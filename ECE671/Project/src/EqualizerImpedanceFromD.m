function EqualizerImpedance = EqualizerImpedanceFromD(D, omegas)
ResistanceArray = length(D);
ResistanceArray(1) = D(1);
for i = 2:length(D)
    ResistanceArray(i) = ResistanceArray(i-1)+D(i)
end

ReactanceArray = length(D);
b = length(d);
b(1) = 0;
for i = 2:length(D)
    b(i) = (pi*(