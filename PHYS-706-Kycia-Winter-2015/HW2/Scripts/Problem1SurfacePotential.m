format long;
i = 0;
temp = zeros(25,3);
x = 0:10^-2:1;
y = 0:10^-2:1;
V = zeros(length(x),length(y));
for n = 1:2:1000
    for m = 1:2:1000
        i = i + 1;
        theta_a = sqrt((n^2*pi^2)+(m^2*pi^2));
        exp(theta_a);
        V = V + (16/(n*m*pi^2)).*sin(n*pi*x)'*sin(m*pi*y);
    end
end

surf(x,y,V)

