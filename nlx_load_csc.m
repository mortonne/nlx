function [x, t] = nlx_load_csc(filename, start, finish)
%NLX_LOAD_CSC   Load csc data for a specified time window.
%
%  [x, t] = nlx_load_csc(filename, start, finish)
%
%  INPUTS:
%  filename:  path to .csc file with Neuralynx data. May also specify
%             a cell array of strings with files to load data split
%             over multiple files.
%
%     start:  start time in microseconds.
%
%    finish:  finish time in microseconds.
%
%  OUTPUTS:
%        x:  vector of raw voltage data in uV.
%
%        t:  vector of corresponding times in s.

if ischar(filename)
    filename = {filename};
end

start_time = [];
x_all = cell(1, length(filename));
t_all = cell(1, length(filename));
gain_all = NaN(1, length(filename));
for i = 1:length(filename)
    if ~exist(filename{i}, 'file')
        error('File does not exist: %s', filename{i});
    end
    
    % get data segment size
    [fs, segsize, hdr] = Nlx2MatCSC_v3(filename{i}, [0 0 1 1 0], 1, 2, [0 0]);
    segdur = (segsize / fs) * 10^6;

    % load all records that include the start and finish times (must add
    % an additional segment on each side to ensure all samples are
    % included)
    if isempty(start_time)
        [ts, ds] = Nlx2MatCSC_v3(filename{i}, [1 0 0 0 1], 0, 4, ...
                                 [start-segdur finish+segdur]);
    else
        [ts, ds] = Nlx2MatCSC_v3(filename{i}, [1 0 0 0 1], 0, 4, ...
                                 [start_time-segdur finish+segdur]);
    end
    ds = ds(:);

    step = (1/fs)*10^6;
    times = ts(1):step:(ts(end)+segdur);
    if isempty(start_time)
        % first sample before start time
        tmin_ind = find(times < start, 1, 'last');
        if isempty(tmin_ind)
            error('Recording started after requested start time.')
        end
    else
        % time after the last time from the previous file
        tmin_ind = find(abs(times - start_time) < (step / 2));
        if length(tmin_ind) > 1
            error('Multiple matching start times found.')
        elseif isempty(tmin_ind)
            error('No matching start times found.')
        end
    end
    
    % last sample before finish time
    tmax_ind = find(times < finish, 1, 'last');

    start_time = times(tmax_ind) + step;
    
    % extract requested samples
    x_all{i} = ds(tmin_ind:tmax_ind);
    t_all{i} = times(tmin_ind:tmax_ind)';
    gain_all(i) = nlx_gain(filename{i});
end

% determine gain
if length(unique(gain_all)) > 1
    error('Input files have different gains.')
end
gain = unique(gain_all);

x = cat(1, x_all{:}) * gain * 10^6;
t = cat(1, t_all{:}) / 10^6;

