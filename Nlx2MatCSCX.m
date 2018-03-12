function varargout = Nlx2MatCSCX(filename, include, loadhdr, mode, mode_array)
%Nlx2MatCSCX   Cross-platform function to load data from a NeuraLynx CSC file.
%
%  [...] = Nlx2MatCSCX(filename, include, loadhdr, mode, mode_array)
%
%  INPUTS
%  filename - char
%      Path to a CSC file. The tilde (~) character is not
%      interpreted, so cannot use ~/ to indicate home directory
%      (must give full path).
%
%  include - [1 x 5] boolean array
%      Indicates fields to load.
%          include(1) - timestamps
%          include(2) - ?
%          include(3) - sample frequency
%          include(4) - ?
%          include(5) - data samples
%
%  loadhdr - boolean
%      If true, the header will be loaded.
%
%  mode - numeric
%      Indicates how to specify data to load.
%          2 - extract using specified record index range
%          4 - extract timestamps range
%
%  mode_array - [1 x 2] numeric array
%      Start and finish indices for loading data.
%
%  OUTPUTS
%  Separate variables are output for each of the outputs requested.

if ~exist(filename, 'file')
    error('File does not exist: %s', filename);
end

varargout = cell(1, nnz(include) + loadhdr);

if ispc
    [varargout{:}] = Nlx2MatCSC(filename, include, loadhdr, mode, mode_array);
else
    [varargout{:}] = Nlx2MatCSC_v3(filename, include, loadhdr, ...
                                   mode, mode_array);
end
