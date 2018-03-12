function gain = nlx_gain(eeg_file)
%NLX_GAIN   Get gain from a Neuralynx file.
%
%  gain = nlx_gain(eeg_file)

hdr = Nlx2MatCSC(eeg_file, [0 0 0 0 0], 1, 2, [0 0]);

for i = 1:length(hdr)
    if ~isempty(strfind(hdr{i}, '-ADBitVolts'))
        f = hdr{i};
    end
end
c = regexp(f, ' ', 'split');
gain = str2num(c{2});
