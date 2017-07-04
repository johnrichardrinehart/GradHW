function a = AsFromBreakFreqs(break_freqs,function_freqs)
a = cell(length(break_freqs)-1,1);
for i = 1:length(break_freqs)-1
    a{i,1} = zeros(length(function_freqs),1);
    for j = 1:length(function_freqs)
        w = function_freqs(j);
        wk = break_freqs(i+1);
        wkm1 = break_freqs(i);
        if w >= wk
            a{i,1}(j) = 1;
        elseif w >=wkm1 && w < wk
            a{i,1}(j) = (w - wkm1)/(wk-wkm1);
        else
            a{i,1}(j) = 0;
        end
    end
end
end