#!/bin/bash

DATASET=$1 # mild-bottleneck-1K

FLAG=$2 # mild-bottleneck, note that without '-1K' or other suffix, only the dataset name

diploshic_model=result-"$DATASET"/diploSHIC/train/model/

faster_nn_model=result-"$DATASET"/FASTER-NN/RAiSD_Model.FASTER-NNdataset-"$DATASET"Model/

# Install environment
#bash install_environment.sh diploshic

# Download dataset
#bash download_dataset.sh $DATASET

# Process dataset
eval "$(conda shell.bash hook)"

# Run raisd
#bash scan_dataset.sh raisd result-"$DATASET"/FASTER-NN/RAiSD_Model.FASTER-NNdataset-"$DATASET"Model/ dataset-"$DATASET"/test/ result-scan-"$DATASET"/raisd/ 100 "$DATASET" "$DATASET"

# Run faster-nn
#bash scan_dataset.sh faster-nn $faster_nn_model dataset-"$DATASET"/test/ result-scan-"$DATASET"/faster-nn/ 100 "$DATASET" "$DATASET"

# Run t-rex
bash scan_dataset.sh t-rex dataset-"$DATASET"/train/ dataset-"$DATASET"/test/ "$FLAG"/result-scan-"$DATASET"/t-rex/ 100 "$DATASET"

# Run diploshic
#bash scan_dataset.sh diploshic $diploshic_model dataset-"$DATASET"/test/ result-scan-"$DATASET"/diploshic/ 100

# Collect results
#bash collect_result_detection.sh result-scan-"$DATASET"/ result-scan-"$DATASET"/ $FLAG

# Delete dataset
#bash delete_dataset.sh $DATASET

# Remove environment
#bash remove_environment.sh fast-nn
