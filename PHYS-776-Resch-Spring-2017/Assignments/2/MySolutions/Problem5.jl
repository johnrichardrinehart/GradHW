#import Plots
#Plots.pgfplots()
import PGFPlots

superposition(B) = (a,b) -> (1/pi)*(2*e^(-2*(a^2+b^2))*cos(4*b*B) +
                                    e^(-2((a+B)^2+b^2))*(1+e^*(8*a*B)))
a1 = PGFPlots.Axis(PGFPlots.Plots.Contour(superposition(3),(-5,5),(-5,5),
                                         number=12,
                                         labels=false,
                                        ),width="15cm",height="10cm",
                  xmin=-4.5,xmax=4.5,ymin=-1.5,ymax=1.5,
                 colorbar=true,
                )
PGFPlots.save("Problem5a.tex",a1,include_preamble=false)

mixture(B) = (a,b) -> (2/pi)*e^(-2*abs2(a+im*b-B)^2) + (2/pi)*e^(-2*abs2(a+im*b+B)^2)
a2 =
PGFPlots.Axis(PGFPlots.Plots.Contour(mixture(3),(-5,5),(-5,5),
                                     number=10,labels=false),
              width="15cm",
              height="10cm",
              xmin=-4.5,
              xmax=4.5,
              ymin=-1.25,
              ymax=1.25,
             colorbar=true)
PGFPlots.save("Problem5b.tex",a2,include_preamble=false)
