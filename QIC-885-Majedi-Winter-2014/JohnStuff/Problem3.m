function A = Problem3(E0)

A = [1,0 ; 0,1];
LwCount=0;
LbCount=0;
m = 511*10^3/(2.998*10^8)^2; 
V = 10; 
hb = 6.582*10^-16; 
kp = sqrt(2*m*(E0 - V)/hb^2);
kf = sqrt(2*m*E0/hb^2);
Lw = .4*10^-9 ; 
Lb = .1*10^-9;

for j = 0:23
 if mod(j,2)==0
    Ap=[exp(1i*(LwCount*Lw + LbCount*Lb)*kf),exp(-1i*(LwCount*Lw + LbCount*Lb)*kf); 
        kf*exp(1i*(LwCount*Lw + LbCount*Lb)*kf), -kf*exp(-1i*(LwCount*Lw + LbCount*Lb)*kf)]\...
        ...
        [exp(1i*(LwCount*Lw + LbCount*Lb)*kp),exp(-1i*(LwCount*Lw + LbCount*Lb)*kp);
        kp*exp(1i*(LwCount*Lw + LbCount*Lb)*kp), -kp*exp(-1i*(LwCount*Lw + LbCount*Lb)*kp)];
    A = A*Ap;
    LbCount = LbCount + 1;
 else
     Af=[exp(1i*(LwCount*Lw + LbCount*Lb)*kp),exp(-1i*(LwCount*Lw + LbCount*Lb)*kp);...
            kp*exp(1i*(LwCount*Lw + LbCount*Lb)*kp), -kp*exp(-1i*(LwCount*Lw + LbCount*Lb)*kp)]\...
            ...
            [exp(1i*(LwCount*Lw + LbCount*Lb)*kf),exp(-1i*(LwCount*Lw + LbCount*Lb)*kf);...
             kf*exp(1i*(LwCount*Lw + LbCount*Lb)*kf),-kf*exp(-1i*(LwCount*Lw + LbCount*Lb)*kf)];
     A = A*Af;
      LwCount = LwCount + 1;
 end
end