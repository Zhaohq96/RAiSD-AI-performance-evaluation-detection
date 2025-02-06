#!/bin/bash

show_help() {
    echo "Usage of scan_dataset_diploshic.sh"
    echo
    echo "bash scan_dataset_diploshic.sh path_inference_file_neutral path_inference_file_sweep path_output path_trained_model window_size length grid_size num_simulation_inference"
    echo
    echo "The results will be stored in the file path_output/Detection_result.txt"
}

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
fi

eval "$(conda shell.bash hook)"

window_size=$5
output=$3
model=$4
length=$6
grid_size=$7
num_sim=$8

rm -r $output

if [ ! -d $output ]; then
	mkdir -p "$output";
fi

mkdir -p "$output"window_"$window_size"

conda activate diploSHIC
diploSHIC_path=./TOOLS/DIPLOSHIC/diploSHIC
./grid -i $1 -m original -c bp -w $window_size -s 5000 -l $length -r 5 -g $grid_size -o "$output"window_"$window_size"/neut

./grid -i $2 -m original -c bp -w $window_size -s 5000 -l $length -r 5 -g $grid_size -o "$output"window_"$window_size"/sweep

echo 'All the results are in seconds.' > "$output"Detection_result.txt
echo 'Time of processing detection data is:' >> "$output"Detection_result.txt
start=$(date +%s.%N);
for ((i=0; i<$num_sim; i++));
do
	python $diploSHIC_path/mytrain.py fvecSim diploid "$output"window_"$window_size"/neut"$i".ms "$output"neut"$i".fvec
	python $diploSHIC_path/mytrain.py fvecSim diploid "$output"window_"$window_size"/sweep"$i".ms "$output"sweep"$i".fvec
done
end=$(date +%s.%N);
execution_time=$(echo "$end - $start" | bc)
echo "$execution_time" >> "$output"Detection_result.txt

echo 'Time of detection is:' >> "$output"Detection_result.txt
start=$(date +%s.%N);
for ((i=0; i<$num_sim; i++));
do
	python $diploSHIC_path/mytrain.py predict --simData "$model"model.json "$model"model.weights.hdf5 "$output"neut"$i".fvec "$output"neut"$i".out;
	python $diploSHIC_path/mytrain.py predict --simData "$model"model.json "$model"model.weights.hdf5 "$output"sweep"$i".fvec "$output"sweep"$i".out;
done
end=$(date +%s.%N);
execution_time=$(echo "$end - $start" | bc)
echo "$execution_time" >> "$output"Detection_result.txt
conda deactivate

