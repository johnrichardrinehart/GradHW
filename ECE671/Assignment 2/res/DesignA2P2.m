clear;
w = 2 * pi * 2e9;
%%% Input side
% Resistor
Rin = 111.2e-3;
% Capacitor
Cin = 995.864e-15;
YCin = 1i*w*Cin;
ZCin = 1/YCin;
% Transmission line
Zc1 = 150;
l1=10;
YTLin = -1i*Zc1^-1*cotd(l1);

%%% Output side
% Resistor
Rs=50.5949;
% Capacitor
Cout = 499.355e-12;
%   Cout=10^6;
YCout = 1i*w*Cout;
% Transmission line
Zc2=5.46274;
l2=10;
YTLout = -1i*Zc2^-1*cotd(l2);

%%% Za,Zb Calculations
Za = Rin + ZCin;
Zb = 1/YCout;

%%% 2PN Transformation
S11 = .731702*exp(1i*-146.389*pi/180);
S12 = .062647*exp(1i*60.507*pi/180);
S21 = 5.70075*exp(1i*85.4898*pi/180);
S22 = .334965*exp(1i*147.6985*pi/180);
S2p = [S11 S12; S21 S22];
Y2p = s2y(S2p,50);
Y2p(2,2) = Y2p(2,2)+YTLout + 1/Rs;
Y2p(1,1) = Y2p(1,1)+YTLin;
Z2int = y2z(Y2p);
Z2int(1,1) = Z2int(1,1)+Za;
Z2int(2,2) = Z2int(2,2) + Zb;
S = z2s(Z2int,50);
S