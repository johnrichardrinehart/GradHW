import PGFPlots
import Plots
Plots.plotly()

superposition_q(B) = (x,y) ->
real((2/pi)*e^(-abs2(B)-x^2-y^2)*cosh((x-im*y)*B)*cosh((x+im*y)*conj(B)))

mixture_q(B) = (x,y) ->
(1/(2*pi))*e^(-abs2(B)-x^2-y^2)*(abs2(e^((x-im*y)*B))+abs2(e^(-(x-im*y)*B)))

x = y = -5:1e-2:5

p =
PGFPlots.Axis(PGFPlots.Plots.Contour(superposition_q(3),(-5,5),(-5,5),labels=false,levels=10),colorbar=true,)
PGFPlots.save("Problem6a.tex",p,include_preamble=false)
q =
PGFPlots.Axis(PGFPlots.Plots.Contour(mixture_q(3),(-5,5),(-5,5),labels=false,levels=10),colorbar=true,)
PGFPlots.save("Problem6b.tex",q,include_preamble=false)
#p = Plots.plot(x,y,superposition_q(3), t=:surface)
#q = Plots.plot(x,y,mixture_q(3), t=:surface)
#display(p)
#display(q)
