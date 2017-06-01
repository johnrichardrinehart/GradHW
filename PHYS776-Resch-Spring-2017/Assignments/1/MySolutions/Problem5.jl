import Plots
Plots.pgfplots()

# r - squeezing parameter magnitude
# n - number of terms to sum
#term(r,n) = tanh(r)^(2*n)/cosh(r)^2
#function squeezed_state_entropy(r; n=10^4)
   #res = 0.0
   #for i = 0:n
      #res -=  term(r,n) * log2(term(r,n))
   #end
   #return res
#end

f(r) = -log2(tanh(r)^2)sinh(r)^2 + log2(cosh(r)^2)

rs = 1e-3:1e-2:1.5
Plots.plot(rs, f.(big(rs)),
           label="Two-Mode Squeezed State",
           yaxis=("Entropy of Entanglement", (0,f(maximum(rs)))),
           xaxis=("Squeezing Parameter Magnitude",(0,maximum(rs))),
         )
p = Plots.plot!(rs, ones(size(rs)),label="Bell Pair", legend=:topleft)
Plots.prepare_output(p)
Plots.savefig(p, "Problem5_plot.tex")
