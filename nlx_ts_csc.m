function t = nlx_ts_csc(filename)
%NLX_TS_CSC   Load time stamps for a CSC data.
%
%  t = nlx_ts_csc(filename)
%
%  INPUTS
%  filename - char
%      Path to .csc file with NeuraLynx data.
%
%  OUTPUTS
%  t - [1 x times] vector
%      vector of time stamps in microseconds.

if ~exist(filename, 'file')
    error('File does not exist: %s', filename);
end

t = Nlx2MatCSC(filename, [1 0 0 0 0], 0, 1, 1);
