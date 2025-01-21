#!/bin/bash

show_help() {
    echo "Usage of scan_dataset.sh"
    echo
    echo "bash scan_dataset.sh tool_name path_training_data_folder(model_folder) path_inference_folder path_output grid_size (evaluataion_dataset) (run_ID)"
    echo "Note that the path_training_data_folder and path_inference_folder should contain two files, 1) neutral.ms and 2) selsweep.ms and please add '/' to the end of the folder path."
    echo
    echo "Specific tool:"
    echo "diploshic"
    echo "bash process_dataset.sh diploshic path_trained_model_folder path_inference_folder path_output grid_size"
    echo
    echo "t-rex"
    echo "bash process_dataset.sh t-rex path_training_data_folder path_inference_folder path_output grid_size evaluataion_dataset"
    echo
    echo "Note that evaluation_dataset is only available for t-rex to use the optimized rank value for training and testing"
    echo
    echo "faster-nn"
    echo "bash process_dataset.sh faster-nn path_trained_model_folder path_inference_folder path_output grid_size run_ID"
    echo
    echo "Quick example:"
    echo "bash scan_dataset.sh t-rex dataset-example/train/ dataset-example/test/ result-scan/t-rex/ 9 example"
    echo "bash scan_dataset.sh diploshic result-example/diploSHIC/train/model/ dataset-example/test/ result-scan/diploshic/ 9"
    echo "bash scan_dataset.sh faster-nn result-example/FASTER-NN/RAiSD_Model.FASTER-NNexampleModel/ dataset-example/test/ result-scan/faster-nn/ 9 example faster-nn-example"
}

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
fi

eval "$(conda shell.bash hook)"

# Default parameters for evaluation, can be modified if needed
diploSHIC_win=128 # window size of extracting snps from raw ms for diploSHIC
T_REx_win=128 # window size of extracting snps from raw ms for T-REx
num_train=50 # number of simulations of each class of training sets, note that the training sets should be balanced
length=100000 # length of genomic sequence
target=0.5 # target of region (in percentage) that will be extracted from the genomic sequences
mbs=0 # Specify if the selective sweep input datasets are generated by mbs (for raisd-ai tools only), 0 indicates that the datasets are not generated by mbs, 1 indicates that the datasets are generated by mbs
num_scan=50 # number of simulations for inference
error=0.01 # error
rank=5 # default rank value for t-rex
tpr=0.05 # threshold of TPR
raisd_target=50000 # target of region (in basepair) that will be extracted from the genomic sequences, only for raisd-ai


if [ "$6" = "high-intensity-recombination-hotspot-1K" ] || [ "$6" = "high-intensity-recombination-hotspot-5K" ] || [ "$6" = "high-intensity-recombination-hotspot-10K" ] || [ "$6" = "low-intensity-recombination-hotspot-1K" ] || [ "$6" = "low-intensity-recombination-hotspot-5K" ] || [ "$6" = "low-intensity-recombination-hotspot-10K" ]; then
	mbs=1
fi

# the rank value for each dataset that t-rex achieves the highest average testing accuracy for 10 runs
if [ "$6" = "severe-bottleneck-1K" ] || [ "$6" = "severe-bottleneck-5K" ] || [ "$6" = "severe-bottleneck-10K" ]; then
	rank=300

elif [ "$6" = "low-intensity-recombination-hotspot-1K" ] || [ "$6" = "low-intensity-recombination-hotspot-5K" ] || [ "$6" = "low-intensity-recombination-hotspot-10K" ]; then
	rank=300

elif [ "$6" = "high-intensity-recombination-hotspot-1K" ] || [ "$6" = "high-intensity-recombination-hotspot-5K" ] || [ "$6" = "high-intensity-recombination-hotspot-10K" ]; then
	rank=100

fi

if [ "$1" = "diploshic" ]; then
# Run diploSHIC
	conda activate diploSHIC
	bash scan_dataset_diploshic.sh "$3"neutral.ms "$3"selsweep.ms $4 $2 $diploSHIC_win $length $5 $num_scan
	python3 diploshic_suc.py -i "$4"window_"$diploSHIC_win"/neut_positions.ms -I "$4"window_"$diploSHIC_win"/sweep_positions.ms -d $4 -g $5 -s $num_scan -e $error -o $4 -T $tpr >> "$4"Detection_result.txt
	conda deactivate

elif [ "$1" = "t-rex" ]; then
# Run T-REx
	conda activate T-REx
	bash scan_dataset_t-rex.sh -n "$2"neutral.ms -s "$2"selsweep.ms -N "$3"neutral.ms -S "$3"selsweep.ms -o $4 -w $T_REx_win -l $length -g $5 -t $num_train -T $num_scan -r $rank
	python3 t-rex_suc.py -i "$4"Results/sim_positions.ms -d "$4"Results/ -e $error -s $num_scan -g $5 -o "$4"Results/ -T $tpr >> "$4"Results/Results.txt
	conda deactivate

elif [ "$1" = "faster-nn" ]; then
# Run FASTER-NN
	conda activate raisd-ai
	bash scan_dataset_faster-nn.sh $2 "$3" $4 $length $raisd_target $5 $error $7 $mbs
	neut="$4"RAiSD_Info."$7"_neut
	sweep="$4"RAiSD_Info."$7"_sweep
	faster_nn_inference_time=$(echo "scale=2; (($(tail -n 3 "$neut" | head -n 1 | awk '{print $4}') + $(tail -n 3 "$sweep" | head -n 1 | awk '{print $4}')) * 100) / 100" | bc)
	echo "Total execution time (sec):" > "$4"Results.txt
	echo $faster_nn_inference_time >> "$4"Results.txt
	python3 faster-nn_suc.py -n "$7" -d $4 -g $5 -s $num_scan -l $length -e $error -T $tpr >> "$4"Results.txt
	conda deactivate
	
elif [ "$1" = "raisd" ]; then
# Run FASTER-NN
	conda activate raisd-ai
	bash scan_dataset_raisd.sh $2 "$3" $4 $length $raisd_target $5 $error $7 $mbs
	neut="$4"RAiSD_Info."$7"_neut
	sweep="$4"RAiSD_Info."$7"_sweep
	echo "Total execution time (sec):" > "$4"Results.txt
	echo $faster_nn_inference_time >> "$4"Results.txt
	neut="$4"RAiSD_Info."$7"_neut
	sweep="$4"RAiSD_Info."$7"_sweep
	raisd_inference_time=$(echo "scale=2; (($(tail -n 3 "$neut" | head -n 1 | awk '{print $4}') + $(tail -n 3 "$sweep" | head -n 1 | awk '{print $4}')) * 100) / 100" | bc)
	echo "Total execution time (sec):" > "$4"Results.txt
	echo $raisd_inference_time >> "$4"Results.txt
	python3 raisd.py -n "$7" -d $4 -g $5 -s $num_scan -l $length -e $error -T $tpr >> "$4"Results.txt
	#conda deactivate
		
fi

