# pyrba
Python implementation of hierarchical Baysian modelling of fMRI data
This is a fork. Original can be found at https://github.com/cmolan/pyrba
## Installation

Install Anaconda / Miniconda and create a new conda environment with:

```bash
conda create -n pyrba -c conda-forge ipywidgets jupyter matplotlib seaborn pymc numpyro ipykernel arviz formulae python-graphviz
conda activate pyrba
pip install --no-deps git+https://github.com/bambinos/bambi.git@425b7b88f01f093ed131433d8559bcc6e6d23bf8
```

The specific bambi version is currently required for a bugfix when using numpyro.
