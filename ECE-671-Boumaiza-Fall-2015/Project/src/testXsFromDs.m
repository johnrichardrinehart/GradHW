function testXsFromDs(impedance_func, break_freqs, sweep_freqs)
realX = imag(impedance_func(sweep_freqs));
Ds = DsFromRs(real(impedance_func(break_freqs)));
computedXs = XsFromDs(break_freqs, sweep_freqs, Ds);
plot(sweep_freqs,realX,'k',sweep_freqs,computedXs);
end

function D = DsFromRs(R)
D = zeros(length(R)-1,1);
for i = 1:length(D)
    D(i) = R(i+1)-R(i);
end
end