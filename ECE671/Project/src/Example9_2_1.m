clear;
% number of breakpoints and fit order below
numbrkpts = 6;
%fitorder = 6; % make sure it's even or things will break
% load description below
zload = @(w)((1+1i*w*1.2).^-1+1i*w*2.3); % g = 1, Yc = 1i*w*1.2, Zl = i*w*2.3
% Frequencies over which to fit the polynomial
optim_freqs = (0:1/100:2)';
% Break frequencies below
omega_max = 1.25;
break_omegas = linspace(0,omega_max,numbrkpts)';
omega_one_idx = find(optim_freqs>1,1);
% Transducer gain below
gaingoal = ones(length(optim_freqs),1);
gaingoal(omega_one_idx:end) = linspace(1,0,length(gaingoal)-omega_one_idx+1)';

R0 = 2.2;
% TODO: Make an initial guess function based on reactive component
% cancellation
Dinit = [-.3; -.4; -.3; -.6; -.6];

objective = @(D)ErrorFunction(optim_freqs,optim_freqs,zload,D,R0,gaingoal);
   [Ds, TG] = lsqnonlin(objective,Dinit); %TODO: Investigate other optimization scheme

R = RsFromDs(break_omegas,optim_freqs,Ds,R0) ;

if (any(R < 0))
    warning(['Your fit didn''t determine no resistance at the highest '...
        'frequency. Check your fit.']);
    for i = 1:length(R)
        if R(i) < 0
            R(i) = 0.1;
        end
    end
end

X = LinearHilbertTransform(break_omegas,Ds)'; % Obtain X to check TG

z = zload(break_omegas);
Z = R + 1i*X;
% figure(1);
plot(break_omegas,R,'k',break_omegas,TransducerGain(Z,z),'b'); % Check TG
title('Transducer Gain (blue) and Resistance (black)');

total_omegas = [-1*flipud(break_omegas(2:end)); break_omegas];
%normalized_R = R / R(1); % Turn the numerator into a "one".
total_R = [flipud(R(2:end)); R]; % Make the double-sided R, assuming even
%total_R = [fliplr(normalized_R(2:end)),normalized_R]; % Make the double-sided R, assuming even
InverseR = 1./total_R; % We assume the denominator of R is a polynomial

% Perform Polynomial Fitting
%[xData, yData] = prepareCurveData( total_omegas, InverseR );
%ft = fittype(sprintf('poly%d',fitorder));\
%[fitresult, gof] = fit( xData, yData, ft );

% Perform Custom Fitting
ft = fittype(['b8*w.^8+b7*w.^7+b6*w.^6+b5*w.^5+b4*w.^4+'...
    'b3*w.^3+b2*w.^2+b1*w.^1+b0'],'independent','w');
[fitresult, gof] = fit(total_omegas, InverseR, ft);
% Below: First term is made highest order, consistent with roots and poly
resistance_den_coeffs = flipud(coeffvalues(fitresult)');

% Below: Check to make sure resistance_den_coeffs are good.
figure(2);plot(break_omegas,R,'b',break_omegas,1./polyval(resistance_den_coeffs,break_omegas),'r');
title('Polynomial fit resistance (red) and Optimized Resistance (blue)');

% Make sure that the polynomial is non-negative
figure(3);plot(-50:.01:50,polyval(resistance_den_coeffs,-50:.01:50));
% December 5: Good up to here.

% coeffs need to be ordered from greatest to least power
[numz, denz] = Gewertz(1, resistance_den_coeffs);
[components,~] = PoleExtractionAtInfinity(numz,denz);

% Print the component values below
for i = 1:length(components)
    fprintf('----------------------------------------------------\n')
    fprintf('|                                                  |\n')
    if i == length(components)
        if mod(i,2) == 0
            fprintf('| Component %d, Inductor Value (Henries):  %f |\n',i,components{i}(1))
            fprintf('| Resistor Value (Ohms):                  %f |\n',components{i}(2))
            fprintf('|                                                  |\n')
            fprintf('-----------------------------------------------------\n')
        else
            fprintf('| Component %d, Capacitor Value (Farads):  %f |\n',i,components{i}(1))
            fprintf('| Resistor Value (Ohms):                  %f |\n', 1/components{i}(2));
            fprintf('|                                                  |\n')
            fprintf('----------------------------------------------------\n')
        end
    elseif mod(i,2) == 0
        fprintf('| Component %d, Inductor Value (Henries):  %f |\n',i,components{i}(1))
        fprintf('|                                                  |\n')
    elseif mod(i,2) ~= 0
        fprintf('| Component %d,  Capacitor Value (Farads): %f |\n',i,components{i}(1));
        fprintf('|                                                  |\n')
    end
end