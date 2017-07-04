function [freqpts, loadresistance, loadreactance] = loadpts(load,startfreq,stopfreq,numpts)
% load should be an anonymous function of radial frequency
startomega = 2*pi*startfreq;
stopomega = 2*pi*stopfreq;
freqpts = linspace(startomega,stopomega,numpts);

loadpts = load(freqpts);

loadresistance = real(loadpts);
loadreactance = imag(loadpts);  