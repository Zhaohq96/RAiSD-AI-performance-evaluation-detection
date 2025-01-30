#!/bin/bash

show_help() {
    echo "Usage of scan_dataset_raisd.sh"
    echo
    echo "bash scan_dataset_raisd.sh path_inference_folder path_output length target error mbs(1 if the sweep file is ms, else 0) run_ID"
    echo
    echo "The results will be stored in the file path_output/Detection_result.txt"
}

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
fi

eval "$(conda shell.bash hook)"

input_path=$1
output=$2
length=$3
target=$4
error=$5
mbs=$6
run_ID=$7


distance=$(echo "$length * $error" | bc | awk '{print int($1)}')
echo $distance

rm -r $output

if [ ! -d $output ]; then
	mkdir -p "$output";
fi


conda activate raisd-ai
./RAiSD-AI -n "$run_ID"_neut -f -I "$input_path"neutral.ms -L $length -frm -T $target -d $distance -s
if [ "$mbs" = "0" ]; then
	./RAiSD-AI -n "$run_ID"_sweep -f -I "$input_path"selsweep.ms -L $length -frm -T $target -d $distance -s
elif [ "$mbs" = "1" ]; then
	./RAiSD-AI -n "$run_ID"_sweep -f -I "$input_path"selsweep.ms -L $length -frm -T $target -d $distance -s -b
fi

mv RAiSD_Info."$run_ID"_neut $output
mv RAiSD_Info."$run_ID"_sweep $output
mv RAiSD_Report."$run_ID"_neut* $output
mv RAiSD_Report."$run_ID"_sweep* $output
mv RAiSD_Grid."$run_ID"_neut $output
mv RAiSD_Grid."$run_ID"_sweep $output
conda deactivate

