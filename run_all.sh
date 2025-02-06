#!/bin/bash

#datasets=("example")
#datasets=("mild-bottleneck-1K" "severe-bottleneck-1K" "recent-migration-1K" "old-migration-1K" "low-intensity-recombination-hotspot-1K" "high-intensity-recombination-hotspot-1K") 
#datasets=("mild-bottleneck-5K" "severe-bottleneck-5K" "recent-migration-5K" "old-migration-5K" "low-intensity-recombination-hotspot-5K" "high-intensity-recombination-hotspot-5K")
#datasets=("mild-bottleneck" "severe-bottleneck" "recent-migration" "old-migration" "low-intensity-recombination-hotspot" "high-intensity-recombination-hotspot") # "severe-bottleneck-5K") # "low-intensity-recombination-hotspot-1K" "low-intensity-recombination-hotspot-5K") 
datasets=("severe-bottleneck")
grid=3 # grid size
num_detection=3 # number of simulation to be detected (dplishic and t-rex with grid-based scanning)
num_detection_trex=3 # number of simulation to be detected (t-rex with its own scanning script)

get_model_path(){
	local dataset="$1"
	if [ "$dataset" = "mild-bottleneck" ]; then
		DIPLOSHIC_MODEL=Pretrained_Model/result-mild-bottleneck-5K/diploSHIC/train/model/; 
		FASTER_NN_MODEL=Pretrained_Model/result-mild-bottleneck-5K/FASTER-NN/RAiSD_Model.FASTER-NNdataset-mild-bottleneck-5KModel/; 
		FASTER_NN_G_8_MODEL=Pretrained_Model/result-mild-bottleneck-5K/FASTER-NN-G8/RAiSD_Model.FASTER-NN-G8dataset-mild-bottleneck-5KModel/;
		
	elif [ "$dataset" = "severe-bottleneck" ]; then
		DIPLOSHIC_MODEL=Pretrained_Model/result-severe-bottleneck-5K/diploSHIC/train/model/; 
		FASTER_NN_MODEL=Pretrained_Model/result-severe-bottleneck-5K/FASTER-NN/RAiSD_Model.FASTER-NNdataset-severe-bottleneck-5KModel/; 
		FASTER_NN_G_8_MODEL=Pretrained_Model/result-severe-bottleneck-5K/FASTER-NN-G8/RAiSD_Model.FASTER-NN-G8dataset-severe-bottleneck-5KModel/;
		
	elif [ "$dataset" = "recent-migration" ]; then
		DIPLOSHIC_MODEL=Pretrained_Model/result-recent-migration-5K/diploSHIC/train/model/; 
		FASTER_NN_MODEL=Pretrained_Model/result-recent-migration-5K/FASTER-NN/RAiSD_Model.FASTER-NNdataset-recent-migration-5KModel/; 
		FASTER_NN_G_8_MODEL=Pretrained_Model/result-recent-migration-5K/FASTER-NN-G8/RAiSD_Model.FASTER-NN-G8dataset-recent-migration-5KModel/;
		
	elif [ "$dataset" = "old-migration" ]; then
		DIPLOSHIC_MODEL=Pretrained_Model/result-old-migration-5K/diploSHIC/train/model/; 
		FASTER_NN_MODEL=Pretrained_Model/result-old-migration-5K/FASTER-NN/RAiSD_Model.FASTER-NNdataset-old-migration-5KModel/; 
		FASTER_NN_G_8_MODEL=Pretrained_Model/result-old-migration-5K/FASTER-NN-G8/RAiSD_Model.FASTER-NN-G8dataset-old-migration-5KModel/;
		
	elif [ "$dataset" = "low-intensity-recombination-hotspot" ]; then
		DIPLOSHIC_MODEL=Pretrained_Model/result-low-intensity-recombination-hotspot-5K/diploSHIC/train/model/; 
		FASTER_NN_MODEL=Pretrained_Model/result-low-intensity-recombination-hotspot-5K/FASTER-NN/RAiSD_Model.FASTER-NNdataset-low-intensity-recombination-hotspot-5KModel/; 
		FASTER_NN_G_8_MODEL=Pretrained_Model/result-low-intensity-recombination-hotspot-5K/FASTER-NN-G8/RAiSD_Model.FASTER-NN-G8dataset-low-intensity-recombination-hotspot-5KModel/;
		
	elif [ "$dataset" = "high-intensity-recombination-hotspot" ]; then
		DIPLOSHIC_MODEL=Pretrained_Model/result-high-intensity-recombination-hotspot-5K/diploSHIC/train/model/; 
		FASTER_NN_MODEL=Pretrained_Model/result-high-intensity-recombination-hotspot-5K/FASTER-NN/RAiSD_Model.FASTER-NNdataset-high-intensity-recombination-hotspot-5KModel/; 
		FASTER_NN_G_8_MODEL=Pretrained_Model/result-high-intensity-recombination-hotspot-5K/FASTER-NN-G8/RAiSD_Model.FASTER-NN-G8dataset-high-intensity-recombination-hotspot-5KModel/;
	fi
}		

for dataset in "${datasets[@]}"
do
	get_model_path $dataset
	#echo $DIPLOSHIC_MODEL
	bash run_detection_all_tools.sh -d $dataset -g $grid -n $num_detection -N $num_detection_trex --diploshic-model $DIPLOSHIC_MODEL --faster-nn-model $FASTER_NN_MODEL --faster-nn-g-8-model $FASTER_NN_G_8_MODEL
done 


