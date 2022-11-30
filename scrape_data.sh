#!/bin/bash
# this script scrapes stopsignal fMRI task data from 
# https://openneuro.org/datasets/ds002790/versions/2.0.0       

option=$1
if [[ $option == "single" ]] 
then
  aws s3 sync --no-sign-request s3://openneuro.org/ds002790 ./data/test-subject \
  --exclude "*" --include "participants.json" \
  --include "dataset_description.json" \
  --include "task-stopsignal_acq-seq_events.json" \
  --include "task-stopsignal_acq-seq_bold.json" \
  --include "derivatives/fmriprep/sub-0001/func/*stopsignal_acq-seq_space-MNI152NLin2009cAsym*" \
  --include "derivatives/fmriprep/sub-0001/func/*stopsignal_acq-seq_desc-confounds_regressors*" \
  --include "sub-0001/func/*task-stopsignal_acq-seq_events.tsv"
elif [[ $option == "all" ]]
then
  aws s3 sync --no-sign-request s3://openneuro.org/ds002790 ./data \
  --exclude "*" --include "participants.json" \
  --include "dataset_description.json" \
  --include "task-stopsignal_acq-seq_events.json" \
  --include "task-stopsignal_acq-seq_bold.json" \
  --include "derivatives/fmriprep/*/func/*stopsignal_acq-seq_space-MNI152NLin2009cAsym*" \
  --include "derivatives/fmriprep/*/func/*stopsignal_acq-seq_desc-confounds_regressors*" \
  --include "*/func/*task-stopsignal_acq-seq_events.tsv"
else
  echo usage: \'bash scrape_data.sh [single,all]\'
fi