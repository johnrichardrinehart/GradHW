import Plots
Plots.plotly()

function f(B)
    return function (a,b)
        (2/pi)*(
                2*e^(-2*(a^2+b^2))*cos(4*b*B)
                +
                e^(-2*((a+B)^2+b^2))*(1+e^(8*a*B))
               )
    end
end

function g(B)
    return function (a,b)
        (4/pi)*e^(-2*(a^2+b^2))*
        (
         cos(4*B*b)+e^(-2*B^2)*cos(4*B*a)
        )
    end
end

x = y = -7:1e-1:7
w = h = 800
a = Plots.surface(x,y,f(5), size=(w,h),)
