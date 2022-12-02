# pyrba
Python implementation of hierarchical Bayesian modelling of fMRI data

# Authors & Contributors
This project would be nothing without:  
Gang Chen  
Kelly Garner  
Christopher Nolan  
Lea Waller  
Darin Erat Sleiter  
Megan EJ Campbell  
Steffen Bollmann  
Adam Manoogian  
Isabella Orlando  
Preethom Pal  
Judy Zhu  
Arshiyan Sangchooli  
Daniel Borek  


## Installation

Installation on linux:

1. Install [Anaconda](https://docs.anaconda.com/anaconda/install/index.html) / [Miniconda](https://docs.conda.io/en/latest/miniconda.html)
1. create a new virtual environment with required dependencies:
    ```bash
    $ conda env create -n pyrba --file environment.yml
    ```
1. activate the new environment:
    ```bash
    $ conda activate pyrba
    ```

Installation on MacOS has not been tested, and is not supported for Windows (because [Jax is not directly supported on Windows](https://www.pymc.io/projects/docs/en/latest/installation.html)).

**Notes:**
* the conda environment uses pymc v4.3.0. The newest version is v4.4.0, but conda was having difficulty resolving dependency versions for all dependencies with v4.4.0 of pymc. Using v4.3.0 seemed to solve this issue.
* when training a bambi model in jupyterlab, you might see "Error displaying widget: model not found". This does not prevent training, it just means that the notebook is unable to display the progress bar. This could possibly be resolved by testing out different versions of ipywidgets, but hasn't been tested yet.


### Installation on an Oracle Cloud Notebook Session

After creating a new [notebook session](https://docs.oracle.com/en-us/iaas/data-science/using/manage-notebook-sessions.htm#create-notebooks):

1. clone this repository in the session:
    1. click on the git icon on the left sidebar
    1. clone a repository, and copy in the repository url: `https://github.com/crnolan/pyrba.git`
1. create a new conda environment:
    1. from the launcher, open a new terminal
    2. cd pyrba/
    1. create a conda environment from the `environment.yml` file:
        ```bash
        $ conda env create -n pyrba --file environment.yml
        ```
1. create a new notebook or open an existing one, and select the kernel labeled: `[conda env:.conda-pyrba]`
    1. you might need to give the instance a moment to recognize the new kernel after the previous environment creation step

### Notes on contents of this repo added during Brainhack 2022 Sydney:

* Python notebooks (xx.ipynb) = examples of fitting hierarchical Bayesian modelling of fMRI (and fMRI-like) data.

* generate_random_voxels.py - build a quick simulation to test of your compute but generating some random data for a set of 'voxels' in small scale before going on to real fMRI data.

* neurosyth_masks.sh - this script will pull down custom ROI masks based on neurosynth.org/ meta-analysis of interest.

* scrape_data.sh - script to pull down open source dataset to play with from the Amsterdam Open MRI Collection https://openneuro.org/datasets/ds002790/versions/2.0.0  please see preprint for details of this data https://www.biorxiv.org/content/10.1101/2020.06.16.155317v1

* fmri-frst-lvl/ - simple first-level GLM of the AOMRIC data pulled down by scrape_data.sh
    ** GLM batch scripted in SPM12 Matlab - sorry not sorry ;) 
## to use this pipeline for the AOMRIC data:
1. scrape_data.sh, then
2. fmri-frst-level/get_stopsignal_motion_regressors.py - simplified regressor extraction
3. fmri-frst-level/eventreader_onsets.m
4. fmri-frst-level/glm_1stlevel_stopsignal.m (this calls glm_build_batch_jobs.m)

