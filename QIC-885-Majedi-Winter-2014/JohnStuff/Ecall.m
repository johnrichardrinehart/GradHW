ElEns = linspace(0,50,10^4);
p11 = zeros(1,length(ElEns));

for i = 1:length(ElEns)
    temp = Problem3(ElEns(i));
    p11(i) = temp(1,1);
end

figure(1),plot(ElEns(1:10000),real(p11(1:10000))),axis([0 15 -2 2])
title('Re(p11) vs. Electron Energy (eV)'),xlabel('Electron Energy (eV)'),ylabel('Re(p11)');

figure(2),plot(ElEns,abs(p11).^-2),
title(' Transmission Probability vs.Electron Energy (eV)'),
xlabel('Electron Energy (eV)'),ylabel('Transmission Probability');
