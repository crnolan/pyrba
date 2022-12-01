%%% Adapting to use with BIDS events.tsv for brainhack project
% Wed 30 Nov 2022 - MEJC :-)

%%% outputs .mat per sub.ses with 3 variables:
%   durations: {} 3x n trials under each condition
%   names: {'go'; 'stop'; 'stopfail'}; % names of each condition
%   onsets: {} 3x n trials under each condition

%%% input is _events.tsv BIDS file
% with headers: onset	duration	trial_type	stop_signal_delay	response_time	response_accuracy	response_hand	sex


%% clean start
clear

%% files and subjects
%[filename, pathname, filterindex] = uigetfile('*.log', 'select your log file');
dir_base = "/Users/mejc110/BrainHack2022/BayesfMRI/AOMIC-PIOP2";
dir_spm1 = "derivatives/spm/";
taskname = {'_task-stopsignal'};
fname_out = strcat(taskname, '_onsets.mat'); % outfile = strcat(pathname, 'sub-', subjs(ii), fname_out);
subjs = {'0001'};

%% loop things for each subject

for ii = 1:numel(subjs)
    %% preallocate some stuff
    % names, onsets, durations for SPM...
    names={};
    onsets={};
    durations={};
    pmods={};

    %% get the input log file
    fp_subj = strcat(dir_base, filesep, 'sub-', subjs{ii}, filesep, 'func');
    %/Users/mejc110/BrainHack2022/BayesfMRI/AOMIC-PIOP2/sub-0100/func
    fname_in = strcat(fp_subj, filesep, 'sub-' ,subjs{ii}, taskname , '_acq-seq_events.tsv');

    if ~exist(fname_in, "file")
    disp('event.tsv does not exist!!')
    disp(fname_in)
    disp('~~~~~~~~~~~~~~~~~~!!!!!!!!!!~~~~~~~~~~~~~~~~~')

    else % do the things
    
    %get .tsv as a table and extract variables
    events = readtable(fname_in{1}, 'FileType', 'delimitedtext');
    %  =  onset	duration	trial_type	stop_signal_delay	response_time	response_accuracy	response_hand	sex
   
    Ttype = events.trial_type;
    Tonsets = events.onset;
    Tdurations = events.duration;
    Tgo = strcmp(Ttype, 'go');
    Tstop = strcmp(Ttype, 'succesful_stop');
    Tstopfail = strcmp(Ttype, 'unsuccesful_stop');

    
    nT_go = sum(Tgo);
    nT_stop = sum(Tstop);
    nT_stopfail = sum(Tstopfail);
    check_percentfail = (nT_stopfail/nT_stop)*100;
    check_percentstops = (nT_stop + nT_stopfail);
    %%% add thing that checks if these are as expected:
    % 100 trials; stop-signals on ~33% of trials
    % not to many failures to stop

    %% CONDITIONS

    %  Go trials
    names{end+1}= 'go'; %#ok<*SAGROW> 
    onsets{end+1} = Tonsets(Tgo)';
    durations{end+1} = Tdurations(Tgo)';
    %pmods{end+1} = cell2mat(m(1).rt(Tgo)');

    % Stop trials (successful)
    names{end+1}= 'stop';
    onsets{end+1} = Tonsets(Tstop)';
    durations{end+1} = Tdurations(Tstop)';

    % Stop-fail trails 
    names{end+1}= 'stop';
    onsets{end+1} = Tonsets(Tstopfail)';
    durations{end+1} = Tdurations(Tstopfail)';


    % Stop-signal trials (all stop trials,regardless of response = the sound was played)
   

    %% SAVE TO MODEL.MAT FOR SPM
    outfile = strcat(fp_subj, filesep, 'sub-', subjs(ii), fname_out);
    save(outfile, 'names', 'onsets', 'durations');    
    disp(strcat('saved ', outfile))

    fp_subjspm1 = strcat(dir_base, filesep, dir_spm1, 'sub-', subjs{ii}, filesep, 'func');
    %/AOMIC-PIOP2/derivatives/spm/sub-0001/func
    outfile = strcat(fp_subjspm1, filesep, 'sub-', subjs(ii), fname_out);
    save(outfile, 'names', 'onsets', 'durations');    
    disp(strcat('saved copy here too ', outfile))

    end %end if events.tsv exists?

end % for looping through subjects
