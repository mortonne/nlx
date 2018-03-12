function t = nlx_ts_csc(filename)
%NLX_TS_CSC   Load time stamps for a CSC file.
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

t = Nlx2MatCSCX(filename, [1 0 0 0 0], 0, 1, 1);
