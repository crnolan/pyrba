## script to get the stop signal data motion regressors
## dataset: https://nilab-uva.github.io/AOMIC.github.io/
# K. Garner 2022

# %%
import os
import json
import pandas as pd

# %%
# define functions
def list_files(data_dir, subject_number, session_number, runs, task):
    """create a list of regressor filenames for given subject
    Dependencies: assumes data is in BIDS format

    Args:
        data_dir (str): full file path to the data (typically ending in derivatives/fmriprep/)
        subject_number (string): subject number - either '0x', 'xx', or 'xxx'
        session_number (string): session number - either '0x' or 'xx' and so on
        runs (panda series/string): runs for that participant, size(1, nruns)
        task (string): name of task as it appears in the filename
    
    Returns:
        regressor_files (list of strings): a cell/list of len(run) containing the regressor filenames for that participant
    """
    tmplt = ''.join([data_dir, 'sub-{0}/ses-{1}/func/sub-{0}_ses-{1}_task-{2}_run-{3}_acq-seq_desc-confounds_regressors.tsv'])
    return [tmplt.format(sub, sess, t, run) for sub in subject_number for sess in session_number for t in task for run in runs]


def print_new_json(fname, data): # function to print json file, given fname (str) and data = {}
    """print json file to fname, containing data

    Args:
       fname (str): full_file_path/file_name.json for json file
       data {}: json data in {}
    
    Returns:
        prints json file, does not return a value
    """
    with open(fname, 'w') as outfile:
        json.dump(data, outfile)

def print_motion_regressors_for_spm(confounds_fname): 
    """print movement regressors to a text file and print corresponding json file
    Dependencies: assumes data is in BIDS format

    Args:
        confounds_fname (str): 1 filepath/filename taken from the list output by list_files

    Returns:
        regressor_file_name (string): name of the motion regressor file that was printed by the function
        also prints a json sidecar file for each regressor txt file, not listed in return
    """
    data = pd.read_csv(confounds_fname, sep='\t', usecols=['trans_x', 'trans_x_derivative1',
                                                 'trans_y', 'trans_y_derivative1',
                                                 'trans_z', 'trans_z_derivative1',
                                                 'rot_x', 'rot_x_derivative1',
                                                 'rot_y', 'rot_y_derivative1',
                                                 'rot_z', 'rot_z_derivative1'])
    data = data.fillna(value=0) # for SPM
    
    savefname = confounds_fname.replace('confounds', 'motion')
    savefname = savefname.replace('tsv', 'txt')
    data.to_csv(savefname, sep=' ', index=False, header=False)
    # write json file to accompany
    motionfname_json = savefname.replace('txt', 'json')
    motion_json_data = {"tsvType":"spm motion", 
                        "params":['trans_x', 'trans_x_derivative1',
                                  'trans_y', 'trans_y_derivative1',
                                  'trans_z', 'trans_z_derivative1',
                                  'rot_x', 'rot_x_derivative1',
                                  'rot_y', 'rot_y_derivative1',
                                  'rot_z', 'rot_z_derivative1'],
                        "source":savefname}
    print_new_json(motionfname_json, motion_json_data)
    return savefname


# %%
# first define settings for list files
data_dir = '../data/test-subject/derivatives/fmriprep/' 
subs = ['0001']
task = ['stopsignal']
sess = ['01']

# %%
# get files and rename them
fstr = ''.join([data_dir, 
               'sub-{0}/func/sub-{0}_task-{1}_acq-seq_desc-confounds_regressors.tsv'])

# %%
# expand to get the filelist for subjet numbers
fns = [fstr.format(subnum, t) for subnum in subs for t in task]

# %%
# first make the folder that you expect to exist
dir_names = ''.join(['../data/test-subject/derivatives/fmriprep/', 
                     'sub-{0}/ses-01/func'])
dir_str =  [dir_names.format(subnum) for subnum in subs]
os.system('mkdir -p ' + dir_str[0])

# %%
# move old data to new location
nu = ''.join([data_dir,
              'sub-{0}/ses-{1}/func/sub-{0}_ses-{1}_task-{2}_run-1_acq-seq_desc-confounds_regressors.tsv'])
nufs = [nu.format(subnum, s, t)  for subnum in subs for s in sess for t in task]  
os.system('rsync ' + fns[0] + ' ' + nufs[0])          

# %%
subject_number = ['0001']
session_number = ['01'] # this assumes data is in BIDS
runs = [1]
task = ['stopsignal']

fnms = list_files(data_dir, subject_number, session_number, runs, task)

# %%
# now print out the movement regressor columns into a txt file ready for use in spm
out_fnms = [print_motion_regressors_for_spm(x) for x in fnms]

# %%
