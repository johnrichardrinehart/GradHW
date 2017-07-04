format long;
V = zeros(25,3);
i = 0;
temp = zeros(25,3);
for n = 1:2:10
    for m = 1:2:10
        i = i + 1;
        theta_a = sqrt((n^2*pi^2)+(m^2*pi^2));
        exp(theta_a);
        V(i,1) = (16/(n*m*pi^2*(1+exp(theta_a))))*sin(n*pi/2)*sin(m*pi/2)*(2*exp(theta_a/2));
        V(i,2) = m;
        V(i,3) = n;
    end
end
[partialsums,order] = sortrows(abs(V),-1);
for i = 1:size(partialsums,1)
    temp(i,:) = V(order(i,1),:);
end
table = [cumsum(temp(:,1)) temp];

scrsz = get(groot,'ScreenSize');
f = figure('Position',[0 0 scrsz(3)/2 scrsz(4)/2]);
cnames = {'Cumulative Sum','Term''s Contribution','n','m'};
t = uitable('Parent',f,'Data',table,'ColumnNames',cnames,'Position',[5 5 200 200]);