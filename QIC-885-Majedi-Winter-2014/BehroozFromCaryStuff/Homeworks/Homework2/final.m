% Behrooz Semnani------Multiple Quantum Well-----------
%-----Feb 17th 2013-University of Waterloo-------------
%------------------------------------------------------
clc
clear all
close all
 
N=8;          %Number of QW
level=9;      % number of desired mode
%-----------------------------------------------------
Lw=6.25;  
Lb=3.75;
V0=0.9;
%---constants-----------------------------------------------------------
c=300;                       %light speed
h=0.65;                      % reduced plank constant
Meff=0.07*(0.511* 10^6)/c^2; % electron effective mass

%-----Determination of the Energybands (coarse root searching)------------
DE=V0/10^4;
E=[DE:DE:V0-DE];
kw=sqrt(2*Meff*E/h^2);
kb=sqrt(2*Meff*(V0-E)/h^2);
M11=exp(kb*Lb).*(cos(kw*Lw)-0.5*(kw./kb-kb./kw).*sin(kw*Lw));
M22=exp(-kb*Lb).*(cos(kw*Lw)+0.5*(kw./kb-kb./kw).*sin(kw*Lw));
U=abs(0.5*(M11+M22))>1;
n=length(E);
Eg=[];   % Eg is the vector of the edges of the allowable enrgy bands 
swich=1;
for j=2:n
    if(U(j)==0 && swich==1)
       Eg=[Eg E(j)];
       swich=0;
    end
    if(U(j)==1 && swich==0)
       Eg=[Eg E(j)];
       swich=1;
    end
    
    
end
%----------------------------------------------------------------------
Neb=length(Eg)/2;
Ox=[];
Oy=[];
for u=1:Neb
   Ox=[Ox 0 1 1 0];
   Oy=[Oy Eg(2*u-1) Eg(2*u-1) Eg(2*u) Eg(2*u)];
end
figure
fill(Ox,Oy,'r')
Xlim([0 1]);
Ylim([0 V0]);
Ylabel('E(ev)','fontsize',15) % plots energy bands
%---------Determination of the Energy Eigenvalues-------------------------
dE=DE/10^2;
Z=[];
for n=1:Neb
    El=Eg(2*n-1)-DE;
    Eh=Eg(2*n)+DE;
    n
    R=[];
    c=0;
    EE=[El:dE:Eh];
    for E0=El:dE:Eh
    c=c+1;
k1=sqrt(2*Meff*E0/h^2);
k2=sqrt(2*Meff*(V0-E0)/h^2);
M11=exp(k2*Lb).*(cos(k1*Lw)-0.5*(k1./k2-k2./k1).*sin(k1*Lw));
M22=exp(-k2*Lb).*(cos(k1*Lw)+0.5*(k1./k2-k2./k1).*sin(k1*Lw));
M12=-0.5*exp(k2*Lb).*(k1./k2+k2./k1).*sin(k1*Lw);
M21=0.5*exp(-k2*Lb).*(k1./k2+k2./k1).*sin(k1*Lw);
M=[M11 M12;M21 M22];
Mt=M^N;
R=[R Mt(1,1)];

%-------------------

if(R(end)==0)
    Z=[Z E0];
elseif(c==1)
elseif(R(end)*R(end-1)<0)
    Z=[Z E0-dE/2];
end

%-------------------
    end
figure
plot(EE,R,'linewidth',2.5);
Ylim([-0.5 0.5]);
Xlim([El Eh]);
Xlabel('E(ev)','fontsize',15)
Ylabel('M_{11}','fontsize',15)
end

%---------------- Part C- Wavefunction Determination ------------------
Ed=Z(level);
U2=0;
for E0=Ed-dE:dE/100:Ed+dE 
k1=sqrt(2*Meff*E0/h^2);
k2=sqrt(2*Meff*(V0-E0)/h^2);
M11=exp(k2*Lb).*(cos(k1*Lw)-0.5*(k1./k2-k2./k1).*sin(k1*Lw));
M22=exp(-k2*Lb).*(cos(k1*Lw)+0.5*(k1./k2-k2./k1).*sin(k1*Lw));
M12=-0.5*exp(k2*Lb).*(k1./k2+k2./k1).*sin(k1*Lw);
M21=0.5*exp(-k2*Lb).*(k1./k2+k2./k1).*sin(k1*Lw);
M=[M11 M12;M21 M22];
Mt=M^N;

%-------------------

U1=Mt(1,1);
if(U1==0)
    Ed=E0;
    break
elseif(U1*U2<0)
  Ed=E0-dE/2;
   break
end

U2=U1;
end

%-------------------------------------------

%-----------------Mb---------
Mb=zeros(2);
kw=sqrt(2*Meff*Ed/h^2);
q=sqrt(2*Meff*(V0-Ed)/h^2);
Mb(1,1)=exp(q*Lb);
Mb(2,2)=exp(-q*Lb);
%---------------Mwb-----------
Mwb=zeros(2,2);
Mwb(1,1)=1+1i*q/kw;
Mwb(2,2)=Mwb(1,1);
Mwb(1,2)=1-1i*q/kw;
Mwb(2,1)=Mwb(1,2);
Mwb=0.5*Mwb;
%-------------Mw--------------
Mw=zeros(2);
Mw(1,1)=exp(-1i*kw*Lw);
Mw(2,2)=exp(+1i*kw*Lw);
%------------Mbw-------------
Mbw=zeros(2);
Mbw(1,1)=1-1i*kw/q;
Mbw(1,2)=1+1i*kw/q;
Mbw(2,1)=Mbw(1,2);
Mbw(2,2)=Mbw(1,1);
Mbw=0.5*Mbw;
%----------------------------
V1=[1;0];
delta=0.001;
zb=[delta:delta:Lb];
zw=[delta:delta:Lw];
Fb=[exp(-q*zb);exp(+q*zb)];
Fw=[exp(1i*kw*zw);exp(-1i*kw*zw)];
%-----------------------------
z=[];
Y=[];
for(n=1:N)
    if(n~=1)
V1=Mb*Mbw*V2;
    end
z=[zb z];
Y=[V1.'*Fb Y];
z=[zw z+Lw];
V2=Mw*Mwb*V1;
Y=[V2.'*Fw Y];
z=z+Lb;
end
V1=Mb*Mbw*V2;
z=[zb z];
Y=[V1.'*Fb Y];
L=max(z);
x=z-L/2;
figure
Nor=sqrt(trapz(x,abs(Y.^2)));
Max=max(abs(Y)/Nor);

y1=0;
y2=1.2*Max;
Oy=[];
Ox=[];
x1=x(1);
for(m=1:N+1)
    Ox=[Ox x1 x1 x1+Lb x1+Lb];
    Oy=[Oy y1 y2 y2 y1];
    x1=x1+Lb+Lw;
end
fill(Ox,Oy,'g')
Xlim([x(1) x(end)]);
Ylim([0 1.2*Max]);
hold on
plot(x,abs(Y)/Nor,'linewidth',2.5)
Xlabel('x(nm)','fontsize',15)
Ylabel('|\Psi|','fontsize',15)