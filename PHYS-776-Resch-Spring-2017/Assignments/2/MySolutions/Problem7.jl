import PGFPlots
import Plots
import Cubature
import Interpolations
import Base.Iterators
Plots.plotly()

function star3(x,y)
    r = (x^2+y^2)^.5
    theta = atan2(y,x)
    return (1/pi^2)*(8*pi/3)*r^2*e^(-2*r^2)*(9 - 18*r^2 + 8*r^4 + 2*sqrt(6)*r*cos(3*theta))
end

x = y = -5:1e-1:5
p =
PGFPlots.Axis(PGFPlots.Plots.Contour(star3,(-5,5),(-5,5),labels=false,levels=15,),xmin=-2.5,xmax=2.5,ymin=-2.5,ymax=2.5,colorbar=true,)
PGFPlots.save("Problem7a.tex",p,include_preamble=false)

# # characteristic(n) returns the Wigner characteristic function for a star state of
# # the form |0>+|n>
# @everywhere function characteristic(n)
#     # x is a vector of [r,theta] values
#     return function f(x)
#         e^(-x[1]^2/2)*
#         (1
#          +
#          ((x[1]*e^(im*x[2]))^n+(-x[1]*e^(-im*x[2]))^n)/sqrt(factorial(n))
#         +
#         sum(j -> (-1)^j*x[1]^(2*j)*binomial(n,j)/factorial(j),0:n)
#         )
#     end
# end
# 
# ch = RemoteChannel(1) #ch -> # of solved points in the α grid
# put!(ch,1)
# #init = RemoteChannel(1) # t -> a channel that stores the computing time
# @everywhere init = now()
# #put!(t,now())
# #@everywhere st = now()
# 
# # integrand(n,x,y,c,s) takes 5 arguments:
# # n - the n in |0>+|n>
# # x, y - the x,y values of alpha = x+iy
# # c - a channel storing the number of solved points
# @everywhere function integrand(n,x,y,c;print_status=false)
#     if print_status
#         cnt = take!(c)
#         duration = (now()-init).value/1000
#         println("Working on point: (",x,",",y,"). ",
#                 round(100*cnt/(length(xs)*length(ys)),1), "%.")
#         if duration > 60
#             println("On point ",cnt," of ", length(xs)*length(ys),
#                     " in time ", round(duration/60,1), " minutes.")
#         else
#             println("On point ",cnt," of ", length(xs)*length(ys),
#                     " in time ", duration, " seconds.")
#         end
#         put!(c,cnt+1)
#     end
#     function f(X)
#         p = atan2(y,x)
#         a = sqrt(x^2+y^2)
#         return real((1/(pi^2))*X[1]*e^(2*im*a*X[1]*sin(p-X[2]))*characteristic(n)(X))
#     end
#     return f
# end
# 
# # solution grid
# @everywhere xs = ys = -5.5:.2:5.5
# 
# # the cartesian product of all of the xs and ys
# grid_idxs = Iterators.product(xs,ys)
# # the solution grid (where the results go)
# grid_vals = zeros(size(grid_idxs))
# 
# n = 6
# @everywhere integral =
# l -> Cubature.hcubature(integrand(n,l[1],l[2],ch),[0,0],[10,2*pi],abstol=1e-3)[1]
# println("Starting the integrals.\n") # starting the integrals at each \\alpha = x+iy
# grid_vals = pmap(integral, collect(grid_idxs)) # pmap is a parallel map.
# 
# # interpolate the solutions to smooth it out.
# itp = Interpolations.interpolate(grid_vals,
#                   Interpolations.BSpline(Interpolations.Cubic(Interpolations.Line())),
#                   Interpolations.OnGrid()
#                  )
# # scale the interpolation according to the actualy grid
# sitp = Interpolations.scale(itp, xs, ys)
# # plot the interpolated data
# p = Plots.plot(
#                linspace(xs[1],xs[end],500),
#                linspace(ys[1],ys[end],500),
#                (x,y) -> sitp[x,y],
#                t=:surface
#               )
