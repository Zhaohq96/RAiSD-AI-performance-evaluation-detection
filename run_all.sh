#!/bin/bash

#datasets=("example")
#datasets=("mild-bottleneck-1K" "severe-bottleneck-1K" "recent-migration-1K" "old-migration-1K" "low-intensity-recombination-hotspot-1K" "high-intensity-recombination-hotspot-1K") 
#datasets=("mild-bottleneck-5K" "severe-bottleneck-5K" "recent-migration-5K" "old-migration-5K" "low-intensity-recombination-hotspot-5K" "high-intensity-recombination-hotspot-5K")
datasets=("mild-bottleneck" "severe-bottleneck" "recent-migration" "old-migration" "low-intensity-recombination-hotspot" "high-intensity-recombination-hotspot") # "severe-bottleneck-5K") # "low-intensity-recombination-hotspot-1K" "low-intensity-recombination-hotspot-5K") 
size=1K # size of the dataset for training the models
grid=100 # grid size

for dataset in "${datasets[@]}"
do
	bash run_detection_all_tools.sh -d $dataset -g $grid -s $size
done 


