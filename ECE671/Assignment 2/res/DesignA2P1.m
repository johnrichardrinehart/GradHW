clear;
w = 2 * pi * 3e9;
%%Input side
% Resistor
Rin = 190.24e-3;
%Rin=0;
% Capacitor
Cin = 20.4359e-12;
YCin = 1i*w*Cin;
ZCin = 1/YCin;
% Transmission line
Zc1 = 150;
l1=90;
YTLin = -1i*Zc1^-1*cotd(l1);
%YTLin = 0;
%% Output side
% Capacitor
Cout = 117.4e-12;
%   Cout=10^6;
YCout = 1i*w*Cout;
% Transmission line
Zc2=35.7967;
l2=90;
YTLout = -1i*Zc2^-1*cotd(l2);
%Za,Zb Calculations
Za = Rin + ZCin;
Zb = 1/YCout;

% 2PN Transformation
S11 = .908980*exp(1i*-169.9931*pi/180);
S12 = .115639*exp(1i*64.090976*pi/180);
S21 = .8433*exp(1i*67.536394*pi/180);
S22 = .830629*exp(1i*126.625718*pi/180);
S2p = [S11 S12; S21 S22];
%Z2p = s2z(S2p,50);
Y2p = s2y(S2p,50);
Y2p(2,2) = Y2p(2,2)+YTLout;
Y2p(1,1) = Y2p(1,1)+YTLin;
Z2int = y2z(Y2p);
Z2int(1,1) = Z2int(1,1)+Za;
Z2int(2,2) = Z2int(2,2) + Zb;
S = z2s(Z2int,50);
S