#!/bin/bash

# This script should be run from a directory contining a Neurosynth (or other) activation z-value image. Make sure it's executable (e.g., with chmod +x)
mkdir -p masktmp

# After querying Neurosynth for "stop signal", threshold the z-value output image as desired (here threshold: z-value>=5)
fslmaths stop_signal_association-test_z_FDR_0.01.nii.gz -thr 5 -bin masktmp/ROI_thresh_5.nii

# Get each hemisphere
fslmaths masktmp/ROI_thresh_5.nii.gz -roi 46 91 0 -1 0 -1 0 -1 l_ss.nii
fslmaths masktmp/ROI_thresh_5.nii.gz -roi 0 45 0 -1 0 -1 0 -1 r_ss.nii

# Create output directory 
mkdir -p masks

# Get binary ROI masks for each hemisphere based on arbitrary probability threshold (here 2%)
for hemi in r l; do
	# Get names of ROIs
	rois="$(atlasquery -a "Harvard-Oxford Cortical Structural Atlas" -m ${hemi}_ss.nii.gz | awk -F ' |:' '$NF>2 {$NF = ""; gsub(/ /,"_"); print substr($0, 1, length($0)-1)}')"
	# Get ROI indices from the atlas .xml file and use it to create binary masks 
	for i in ${rois}; do
		roi=$(echo $i | tr '_' ' ');
		index=$(xmlstarlet sel --template --match '//atlas/data' --copy-of '.' --nl $FSLDIR/data/atlases/HarvardOxford-Cortical.xml | awk -v r="$roi" -F '>|<|"' '$11==r {print $3}');
		(( index++ ));
		fslmaths $FSLDIR/data/atlases/HarvardOxford/HarvardOxford-cort-maxprob-thr0-2mm.nii.gz -thr $index -uthr $index -bin masks/"${hemi}"_"${roi}".nii.gz
	done
done

rm -r masktmp
