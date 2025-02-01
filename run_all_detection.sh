#!/bin/bash

# Install environment
#sh install_environment.sh diploshic

# Download dataset
eval "$(conda shell.bash hook)"
# Process dataset

conda activate raisd-ai
for d in mild-bottleneck severe-bottleneck recent-migration old-migration low-intensity-recombination-hotspot high-intensity-recombination-hotspot
do
	bash scan_dataset.sh faster-nn result-"$d"-1K/FASTER-NN/RAiSD_Model.FASTER-NNdataset-"$d"-5KModel/ dataset-"$d"-1K/test/ result-scan-"$d"/faster-nn/ 100 "$d"-1K "$d"-1K
done
conda deactivate

conda activate raisd-ai
for d in mild-bottleneck severe-bottleneck recent-migration old-migration low-intensity-recombination-hotspot high-intensity-recombination-hotspot
do
	bash scan_dataset.sh faster-nn-g8 result-"$d"-1K/FASTER-NN-G8/RAiSD_Model.FASTER-NN-G8dataset-"$d"-5KModel/ dataset-"$d"-1K/test/ result-scan-"$d"/faster-nn-g8/ 100 "$d"-1K "$d"-1K
done
conda deactivate


#conda activate T-REx
#for d in low-intensity-recombination-hotspot-1K high-intensity-recombination-hotspot-1K
#do
#	bash scan_dataset.sh t-rex dataset-"$d"/train/ dataset-"$d"/test/ result-scan-"$d"/t-rex/ 100 "$d"
#done
#conda deactivate

conda activate diploSHIC
for d in mild-bottleneck-1K severe-bottleneck-1K recent-migration-1K old-migration-1K low-intensity-recombination-hotspot-1K high-intensity-recombination-hotspot-1K
do
	bash scan_dataset.sh diploshic result-"$d"/diploSHIC/train/model/ dataset-"$d"/test/ result-scan-"$d"/diploshic/ 100
done
conda deactivate




# Delete dataset
#sh delete_dataset.sh mild-bottleneck-1K

# Remove environment
#sh remove_environment.sh fast-nn
