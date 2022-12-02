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

