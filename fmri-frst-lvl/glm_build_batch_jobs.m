%-----------------------------------------------------------------------
% Builds each subj matlabbatch file to then feed back to glm_1stlelve_stopsignal.m to run in parallel
% 
% adapted from glm for gonogo for 2022Brainhack project - Megan 
%-----------------------------------------------------------------------
clear matlabbatch
% this builder gets called by 'glm_1stlevel_gonogo.m' which defines files and directories:
% dir_subj (spm1 dir for this subj), dir_spm1 (where spm.mat will be saved), dir_batch (output batchfiles)
% f_anat, f_func, f_mask, f_log, f_regs (files for this subj/ses)

%scaninfo: timing etc standard across all subjects at this site (HMRI)
%load(f_log); % = 4 variables 'durations', 'names', 'onsets', 'pmods'

funcimages = spm_select('expand', fullfile(f_func)); % get 4D.nii listed as separate 'frames' for SPM

%%% ims = cellstr(ims(4:end,:)) % set so that drops the dummy?

%% design GLM
matlabbatch{1}.spm.stats.fmri_spec.dir = cellstr(dir_spm1); % dir where output SPM goes
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = scaninfo.TR;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = scaninfo.Nslices;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = scaninfo.fmri_t0; % fsl fmriprep uses middle slice and reference slice - Reference timebin - if slicetiming on interleaved acq then match to the parameter used for slice-timing 
matlabbatch{1}.spm.stats.fmri_spec.sess.scans = cellstr(funcimages); %functional files for this sub/ses
matlabbatch{1}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {}); % orth?                                               
matlabbatch{1}.spm.stats.fmri_spec.sess.multi = cellstr(f_log); % onsets loaded here .mat with all these bits 
matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = cellstr(f_regs); 
matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{1}.spm.stats.fmri_spec.mask = cellstr(f_mask); % using explict mask from fmriprep per func sess
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
%% estimate model
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
%matlabbatch{2}.spm.stats.fmri_est.spmmat{1} = strcat(dir_spm1, 'SPM.mat'); % 1stLevel spm.mat saved here from job 1
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
%% estimate contrasts for each condition:
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
%matlabbatch{3}.spm.stats.con.spmmat{1} = strcat(dir_spm1, 'SPM.mat'); % 1stLevel spm.mat saved here from job 1
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = names{1};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 0 0]; %[go, stop, stop-fail]
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = names{2};
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 1 0];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{3}.fcon.name = strcat(names{1}, 'VS', names{2});
matlabbatch{3}.spm.stats.con.consess{3}.fcon.weights = [1 0 0; 0 1 0];
matlabbatch{3}.spm.stats.con.consess{3}.fcon.sessrep = 'none';


% check things: spm_jobman('interactive', matlabbatch)
fname_mat = strcat(dir_batch, filesep, 'sub-', subj, taskname, '_1stlevel_batch.mat');
save(fname_mat, 'matlabbatch')