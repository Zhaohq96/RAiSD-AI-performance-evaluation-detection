#!/bin/bash

DATASET=$1 # mild-bottleneck severe-bottleneck recent-migration old-migration low-intensity-recombination-hotspot high-intensity-recombination-hotspot
#bash download_dataset.sh $DATASET
#rm -r result-$DATASET
SIZE=$2 # size of dataset that the tools were trained
GRID=$3 # grid size

TOOL=diploshic
MODEL=result-"$DATASET"-"$SIZE"/diploSHIC/train/model/
#yes | bash remove_environment.sh $TOOL
#bash install_environment.sh $TOOL
bash scan_dataset.sh $TOOL $MODEL dataset-detection/"$DATASET"/ 1-result-scan-"$DATASET"/diploshic/ $GRID 1> /dev/null
#yes | bash remove_environment.sh $TOOL

TOOL=t-rex
#yes | bash remove_environment.sh $TOOL
#bash install_environment.sh $TOOL
bash scan_dataset.sh $TOOL dataset-"$DATASET"-"$SIZE"/train/ dataset-detection/"$DATASET"/ 1-result-scan-"$DATASET"/t-rex/ $GRID "$DATASET" 1> /dev/null
#yes | bash remove_environment.sh $TOOL

TOOL=raisd
bash scan_dataset.sh $TOOL dataset-detection/"$DATASET"/ 1-result-scan-"$DATASET"/raisd/ raisd-"$DATASET"

#TOOL=raisd-ai
#yes | bash remove_environment.sh $TOOL
#bash install_environment.sh $TOOL

CNN=faster-nn
MODEL=result-"$DATASET"-"$SIZE"/FASTER-NN/RAiSD_Model.FASTER-NNdataset-"$DATASET"-"$SIZE"Model/
bash scan_dataset.sh $CNN $MODEL dataset-detection/"$DATASET"/ 1-result-scan-"$DATASET"/faster-nn/ $GRID "$DATASET"-"$SIZE" "$DATASET"-"$SIZE" 1> /dev/null

CNN=faster-nn-g-8
MODEL=result-"$DATASET"-"$SIZE"/FASTER-NN-G8/RAiSD_Model.FASTER-NN-G8dataset-"$DATASET"-"$SIZE"Model/
bash scan_dataset.sh $CNN  $MODEL dataset-detection/"$DATASET"/ 1-result-scan-"$DATASET"/faster-nn-g-8/ $GRID "$DATASET"-"$SIZE" "$DATASET"-"$SIZE" #1> /dev/null


#yes | bash remove_environment.sh $TOOL

#bash delete_dataset.sh $DATASET

bash collect_result_detection.sh 1-result-scan-"$DATASET"/ 1-result-scan-"$DATASET"/ "$DATASET"


# Delete dataset
#sh delete_dataset.sh mild-bottleneck-1K

# Remove environment
#sh remove_environment.sh fast-nn
