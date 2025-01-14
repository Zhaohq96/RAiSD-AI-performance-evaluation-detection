#!/bin/bash

show_help() {
    echo "Usage of scan_dataset_faster-nn.sh"
    echo
    echo "bash scan_dataset_faster-nn path_trained_model path_inference_folder path_output length target grid_size error run_ID"
    echo
    echo "The results will be stored in the file path_output/Detection_result.txt"
}

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
fi

eval "$(conda shell.bash hook)"

model_path=$1
input_path=$2
output=$3
length=$4
target=$5
grid_size=$6
error=$7
run_ID=$8

distance=$(echo "$length * $error" | bc | awk '{print int($1)}')
echo $distance

rm -r $3

if [ ! -d $3 ]; then
	mkdir -p "$3";
fi


conda activate raisd-ai
./RAiSD-AI -n "$run_ID"_neut -mdl "$model_path" -f -op SWP-SCN -I "$input_path"neutral.ms -L $length -frm -T $target -d $distance -G $grid_size -pci 1 1 -O -s
if [ "$9" = "0" ]; then
	./RAiSD-AI -n "$run_ID"_sweep -mdl "$model_path" -f -op SWP-SCN -I "$input_path"selsweep.ms -L $length -frm -T $target -d $distance -G $grid_size -pci 1 1 -O -s
elif [ "$9" = "1" ]; then
	./RAiSD-AI -n "$run_ID"_sweep -mdl "$model_path" -f -op SWP-SCN -I "$input_path"selsweep.ms -L $length -frm -T $target -d $distance -G $grid_size -pci 1 1 -O -s -b
fi

mv RAiSD_Info."$run_ID"_neut $output
mv RAiSD_Info."$run_ID"_sweep $output
mv RAiSD_Report."$run_ID"_neut* $output
mv RAiSD_Report."$run_ID"_sweep* $output
mv RAiSD_Grid."$run_ID"_neut $output
mv RAiSD_Grid."$run_ID"_sweep $output
conda deactivate

