% Build GLM first-level design and run as matlabbatches
% Use parfor to estimate contrasts for each subj.
% SPM12.7771 on MatlabR2021a

%%% if running SPM on macOS11 and getting errors for SPM, see bottom NOTES for help.

%%TODO:
% gunzip the files from derivatives/fmriprep .nii.gz into derivatives/spm .nii
% read imaging acq parameters from the relevant .json? TR, nslice, fmri_t01
%%%%% clean start & start spm
clc;clear;
spm('defaults', 'FMRI');

%%%%%%%%%%%%%
% choose what to do:
buildbatches = 1; %build matlabbatches and save them?
runbatches_parallel = 0; % run these jobs in parfor.
%%%%%%%%%%%%

%% get dirs and files
dir_base = "/Users/mejc110/BrainHack2022/BayesfMRI/AOMIC-PIOP2";
taskname = {'_task-stopsignal'};
dname_out = 'glm1st';   %  % make a dir in subj dir to output spm.mat and con/beta/spmT images.

subjs = {'0001'};
%other params ->>>> TOD0 be clever later and read this from the relevant .json?
scaninfo.TR = 2;
scaninfo.Nslices = 36; %see slicetiming.mat pulled from .json
scaninfo.fmri_t0 =1; %% reference slice....? this dataset didn't have slice timing applied so no ref slice? just use spm default

% NB this dataset has no runs or sessions - removed all -ses -run file naming bits

% get data in and set  dir_out within subj-dir in the dir_spm
dir_spm = strcat(dir_base, filesep, 'derivatives', filesep, 'spm'); %<<< save spm-glm 1st level here per subj
%/Users/mejc110/BrainHack2022/BayesfMRI/AOMIC-PIOP2/derivatives/spm/sub-0001/func

%  log, func and mask filesfile per subject
fname_log = strcat(taskname, '_onsets.mat');
fname_func = string(strcat(taskname,'_acq-seq_space-MNI152NLin2009cAsym_desc-preproc_bold.nii'));
fname_mask = string(strcat(taskname,'_acq-seq_space-MNI152NLin2009cAsym_desc-brain_mask.nii'));
fname_regs = '_task-stopsignal_run-1_acq-seq_desc-motion_regressors.txt'; %% Kelly did a python thing to get these out from fmriprep regs: sub-0001_task-stopsignal_acq-seq_desc-confounds_regressors.tsv

% code and batchfiles here:
dir_code =  strcat(dir_base, filesep, 'code');
dir_batch = strcat(dir_code, filesep, 'SPM_GLM', filesep, 'matlabbatchfiles');
if ~isfolder(dir_batch)
    mkdir(dir_batch)
else
    disp('batchfolder already exists')
end


if buildbatches ==1
    disp('~~~~~~~~~~~~~~~~~~ build batch files~~~~~~~~~~~~~')
    for i = 1:numel(subjs)
        subj = subjs{i};

        % get files and directories for this subject
        dir_subj = strcat(dir_spm, filesep, 'sub-', subj); % 1 dir per sub with all sess in there together
        %    f_anat = strcat(dir_subj, filesep, 'sub-', subj, fname_anat); % 1 anat file per subject
        dir_spm1 = strcat(dir_subj, filesep, dname_out); % make a dir to output spm.mat and con/beta/spmT images.
        if ~isfolder(dir_spm1)
            mkdir(dir_spm1)
        elseif isfolder(dir_spm1)
            disp('1st level spm directory already exists?!')
        end

        f_func = strcat(dir_subj, filesep, 'func', filesep,'sub-', subj,fname_func);
        f_mask = strcat(dir_subj, filesep, 'func', filesep, 'sub-', subj,fname_mask);
        f_log = strcat(dir_subj, filesep,'func', filesep, 'sub-', subj, fname_log);
        f_regs = strcat(dir_subj, filesep,'func', filesep, 'sub-', subj, '_ses-01' ,fname_regs);
        %sub-0001_ses-01_task-stopsignal_run-1_acq-seq_desc-motion_regressors.txt

        if ~exist(f_func, 'file')
            disp('missing functional file!')
        else

        load(f_log) %conditions names for contrast labels

        glm_build_batch_jobs;  % do the thing and save it to batch directory then run in parallel below
        end
%%% to check things spm_jobman('interactive', matlabbatch)
    end % subjects

end % if building matlab batches


if runbatches_parallel ==1

    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    disp('~~~~~~~~~~~~~~~~~~~~~ run batches in parallel ~~~~~~~~~~~~~~~~~~~~~~~')
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')


    cd(dir_batch); % dir to save batches for model estimates
    allbatches = dir('*_1stlevel_batch.mat'); % saves list of all the batch files in the dir_save/Data directory %%% code copied and adpatped from JMcF's

    jobs{length(allbatches)} = [];
    for j = 1:length(allbatches)

        jobs{j} = load(strcat(dir_batch, '/', allbatches(j).name));

    end

    % Run estimation in parallel
    disp('... starting subject-level SPM batches');
    tic;
    disp(datetime)
    disp('... ***************************************************** ....');

    parfor jj = 1:length(jobs) %

        disp(['... running job ' num2str(jj) ' of ' num2str(length(jobs))]);
        spm('Defaults','fMRI');
        spm_jobman('initcfg');
        spm_jobman('run',jobs{jj}.matlabbatch);

    end
    stoppf=toc;
    disp('... ***************************************************** ....');

    disp(datetime)
    timepastpf = (stoppf/60);
    disp([num2str(timepastpf), ' mins elapsed'])
    disp('... ***************************************************** ....');

end %if runbatches_parallel




%%%%%%%%% NOTES %%%%%%%%

%%% if running SPM on macOS11 + for the first time need to tell mac spm is
%%% safe (or it keeps stopping code to get confirmation to allow spm mex to run)
% in terminal do this: https://en.wikibooks.org/wiki/SPM/Installation_on_64bit_Mac_OS_(Intel)#macOS_Big_Sur
% sudo xattr -r -d com.apple.quarantine SPM_PATH
% sudo find SPM_PATH -name "*.mexmaci64" -exec spctl --add {} \;

%sudo xattr -r -d com.apple.quarantine /Users/Shared/Shared_Toolboxes/spm12
%sudo find /Users/Shared/Shared_Toolboxes/spm12 -name "*.mexmaci64" -exec spctl --add {} \;
