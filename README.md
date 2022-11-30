# pyrba
Python implementation of hierarchical Bayesian modelling of fMRI data

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
