#!/bin/bash

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -d) DATASET="$2"; shift ;;  # Capture dataset
        -g) GRID="$2"; shift ;;  # Capture generation count
        -s) SIZE="$2"; DIPLOSHIC_MODEL=Pretrained_Model/result-"$DATASET"-"$SIZE"/diploSHIC/train/model/; FASTER_NN_MODEL=Pretrained_Model/result-"$DATASET"-"$SIZE"/FASTER-NN/RAiSD_Model.FASTER-NNdataset-"$DATASET"-"$SIZE"Model/; FASTER_NN_G_8_MODEL=Pretrained_Model/result-"$DATASET"-"$SIZE"/FASTER-NN-G8/RAiSD_Model.FASTER-NN-G8dataset-"$DATASET"-"$SIZE"Model/; shift ;;  # Capture size
        --diploshic-model) DIPLOSHIC_MODEL="$2"; shift ;;  # Capture Diploshic mode path
        --faster-nn-model) FASTER_NN_MODEL="$2"; shift ;;  # Capture FasterNN model path
        --faster-nn-g-8-model) FASTER_NN_G_8_MODEL="$2"; shift ;;  # Capture FasterNN model path
        -h|--help) 
            echo "Usage: $0 -d <dataset> -g <generation> -s <size> --diploshic-moded <path> --faster-nn-model <path> --faster-nn-g-8-model <path>"
            exit 0
            ;;
        *) 
            echo "Unknown parameter: $1"
            exit 1
            ;;
    esac
    shift  # Move to next argument
done

TOOL=diploshic
yes | bash remove_environment.sh $TOOL
bash install_environment.sh $TOOL
bash scan_dataset.sh $TOOL $DIPLOSHIC_MODEL dataset-detection/"$DATASET"/ result-scan-"$DATASET"/diploshic/ $GRID 1> /dev/null
yes | bash remove_environment.sh $TOOL

TOOL=t-rex
yes | bash remove_environment.sh $TOOL
bash install_environment.sh $TOOL
bash scan_dataset.sh $TOOL dataset-"$DATASET"-"$SIZE"/train/ dataset-detection/"$DATASET"/ result-scan-"$DATASET"/t-rex/ $GRID "$DATASET" 1> /dev/null
yes | bash remove_environment.sh $TOOL

#TOOL=t-rex-ori ############ TO BE TEST, DON'T USE THESE COMMAND
#yes | bash remove_environment.sh $TOOL
#bash install_environment.sh $TOOL
#bash scan_dataset.sh $TOOL dataset-"$DATASET"-"$SIZE"/train/ dataset-detection/"$DATASET"/ result-scan-"$DATASET"/t-rex-ori/ "$DATASET" 1> /dev/null
#yes | bash remove_environment.sh $TOOL

TOOL=raisd
bash scan_dataset.sh $TOOL dataset-detection/"$DATASET"/ result-scan-"$DATASET"/raisd/ raisd-"$DATASET" "$DATASET"

TOOL=raisd-ai
yes | bash remove_environment.sh $TOOL
bash install_environment.sh $TOOL

CNN=faster-nn
bash scan_dataset.sh $CNN $FASTER_NN_MODEL dataset-detection/"$DATASET"/ result-scan-"$DATASET"/faster-nn/ $GRID "$DATASET"-"$SIZE" "$DATASET"-"$SIZE" #1> /dev/null

CNN=faster-nn-g-8
bash scan_dataset.sh $CNN  $FASTER_NN_G_8_MODEL dataset-detection/"$DATASET"/ result-scan-"$DATASET"/faster-nn-g-8/ $GRID "$DATASET"-"$SIZE" "$DATASET"-"$SIZE" #1> /dev/null


yes | bash remove_environment.sh $TOOL

#bash delete_dataset.sh $DATASET-$SIZE

bash collect_result_detection.sh result-scan-"$DATASET"/ result-scan-"$DATASET"/ "$DATASET"


# Delete dataset
#sh delete_dataset.sh "$DATASET"-"$SIZE"

# Remove environment
#sh remove_environment.sh fast-nn
