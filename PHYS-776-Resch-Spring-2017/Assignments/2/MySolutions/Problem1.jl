import Plots
Plots.pgfplots()

# Don't worry about normalizing coefficients. The plots turned out just fine.
k = 1.38064852e-23
T = 25 + 273.15
m = 6.646477e-27*.85+3.35082e-26*.15 # 85% helium, 15% neon
c = 2.998e8
lambda = 632.8e-9 #m
w0 = 2*pi*c/lambda
sigma_squared = w0^2*k*T/(m*c^2)
I(t) = 1+e^(-.5*t^2*sigma_squared)*cos(w0*t)

# Plot 1a
points_per_cycle = 100
n_cycles = 3
x_short = 0:(2*pi/w0)*(1/points_per_cycle):(2*pi/w0)*n_cycles

q = Plots.plot(xaxis=("\$\\tau\$ (femtoseconds)"),yaxis=((0,2),"\$I(\\textrm{\\tau})\$"))
Plots.plot!(q, x_short*1e15, I.(x_short),legend=false)

# Plot 1b
plus_envelope(t) = 1+e^(-.5*t^2*sigma_squared)
minus_envelope(t) = 1-e^(-.5*t^2*sigma_squared)

n_cycles = 2e5
points_per_cycle=1e-3
x_long = 0:(2*pi/w0)*(1/points_per_cycle):(2*pi/w0)*n_cycles

p = Plots.plot(
               yaxis=((0,2),"\$I(\\textrm{\\tau})\$"),
               xaxis=("\$\\tau\$ (picoseconds)"),
              )
Plots.plot!(p,x_long*1e12,plus_envelope.(x_long),label="\$I_{\\textrm{+env}}(\\tau)\$")
Plots.plot!(p,x_long*1e12,minus_envelope.(x_long),label="\$I_{\\textrm{-env}}(\\tau)\$")
Plots.plot!(p,x_long*1e12,ones(size(x_long)),label="\$\\overline{I}\$")

Plots.savefig(q,"Problem1a.tex")
Plots.savefig(p,"Problem1b.tex")
