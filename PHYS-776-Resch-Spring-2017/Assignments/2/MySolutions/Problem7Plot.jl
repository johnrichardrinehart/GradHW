import Plots
import Cubature
import Interpolations
import Base.Iterators
Plots.plotly()
#Plots.plotlyjs()

function star3(x,y)
    r = (x^2+y^2)^.5
    theta = atan2(y,x)
    return (1/pi^2)*(8*pi/3)*r^2*e^(-2*r^2)*(9 - 18*r^2 + 8*r^4 + 2*sqrt(6)*r*cos(3*theta))
end

@everywhere function characteristic(n)
    # x is a vector of [r,theta] values
    return function f(x)
        e^(-x[1]^2/2)*
        (1
         +
         ((x[1]*e^(im*x[2]))^n+(-x[1]*e^(-im*x[2]))^n)/sqrt(factorial(n))
         +
         sum(j -> (-1)^j*x[1]^(2*j)*binomial(n,j)/factorial(j),0:n)
        )
    end
end

#@everywhere integral_count = RemoteChannel(() -> Channel{Int}(2))
#put!(integral_count, 0)
ch = RemoteChannel(1)
put!(ch,1)
t = RemoteChannel(1) # time
put!(t,now())
dur = RemoteChannel(1)
put!(dur,0)
@everywhere st = now()
# integrand takes a value of alpha and n
@everywhere function integrand(n,x,y,c,s,d)
    cnt = take!(c)
    t = take!(s)
    #if cnt == 1 || try typeof(convert(Int,cnt/ceil(.01*length(xs)*length(ys))))== Int; catch false; end
    if cnt == 1 || (now()-t).value > 60*1000 # milliseconds
        duration = take!(d)
        duration += (now()-t).value/1000
        println("Working on point: (",x,",",y,"). ",round(100*cnt/(length(xs)*length(ys)),1), "%.")
        if duration > 60
            println("On point ",cnt," of ", length(xs)*length(ys), " in time ", round(duration/60,1), " minutes.")
        else
            println("On point ",cnt," of ", length(xs)*length(ys), " in time ", duration, " seconds.")
        end
        put!(s,now())
        put!(d,duration)
    else
        put!(s,t)
    end
    put!(c,cnt+1)
    function f(X)
        p = atan2(y,x)
        a = sqrt(x^2+y^2)
        return real((1/(pi^2))*X[1]*e^(2*im*a*X[1]*sin(p-X[2]))*characteristic(n)(X))
    end
    return f
end

#xs = ys = -5:.05:5
@everywhere xs = ys = -5.5:.1:5.5

grid_idxs = Iterators.product(xs,ys)
grad_vals = zeros(size(grid_idxs))
tic()
@everywhere n = 20
@everywhere integral = l -> Cubature.hcubature(integrand(n,l[1],l[2],ch,t,dur),[0,0],[10,2*pi],abstol=1e-4)[1]
println("Starting the integrals.\n")
grid_vals = pmap(integral, collect(grid_idxs))
toc()

itp = Interpolations.interpolate(grid_vals,
                  Interpolations.BSpline(Interpolations.Cubic(Interpolations.Line())),
                  Interpolations.OnGrid()
                 )
sitp = Interpolations.scale(itp, xs, ys)
w = 1600
h = 800
Plots.plot(linspace(xs[1],xs[end],500),
           linspace(ys[1],ys[end],500),
           (x,y) -> sitp[x,y],
           linetype=:surface,
           size=(w,h),
          )

#Plots.plot(x, y, (xi,yi) -> Cubature.hcubature_v(integrand_v(3,xi,yi),[.1,0],[10,2*pi])[1], linetype=:surface, size=(w,h))
#Plots.plot(x, y, ,[.1,0],[10,2*pi])[1], linetype=:surface, size=(w,h))
