function ErrorFunction = ErrorFunction(break_freqs, function_freqs, loadfunc, Ds, Rdc, gaingoal)
if sum(Ds) > Rdc
    ErrorFunction = 1e10;
end
R = RsFromDs(break_freqs, function_freqs, Ds, Rdc);
%X = XsFromDs(break_freqs,Ds);
X = R;
Z = R + 1i*X;
z=loadfunc(function_freqs);
TG = TransducerGain(Z,z);
ErrorFunction = TG - gaingoal;