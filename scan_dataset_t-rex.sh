#!/bin/bash

show_help() {
    echo "Usage of scan_dataset_t-rex.sh"
    echo
    echo "bash scan_dataset_t-rex.sh -n path_training_file_neutral -s path_training_file_sweep -N path_inference_file_neutral -S path_inference_file_sweep -o path_output -w window_size -l length -t num_simulation_training -T num_simulation_inference -r rank -g grid_size"
    echo
    echo "The results will be stored in the file path_output/Results.txt"
}

eval "$(conda shell.bash hook)"

window_size=128
length=100000
grid_size=9
num_train=50
num_sim=50
rank=5

while getopts "hn:s:N:S:o:w:l:t:T:r:g:" opt
do
	case "${opt}" in
		h) show_help; exit 0;;
		n) neut_train=${OPTARG};;
		s) sweep_train=${OPTARG};;
		N) neut_scan=${OPTARG};;
		S) sweep_scan=${OPTARG};;
		o) output=${OPTARG};;
		w) window_size=${OPTARG};;
		l) length=${OPTARG};;
		t) num_train=${OPTARG};;
		T) num_sim=${OPTARG};;
		r) rank=${OPTARG};;
		g) grid_size=${OPTARG};;
	esac
done

rm -r $output;
if [ ! -d $output ]; then
	mkdir -p "$output";
fi

mkdir -p "$output"MS_files_train;
mkdir -p "$output"MS_files_test;
mkdir -p "$output"CVF_files;
mkdir -p "$output"Results;
mkdir -p "$output"extracted_data;
mkdir -p "$output"window_"$window_size"

conda activate T-REx
./convert -i $neut_train -m original -c bp -w $window_size -s 5000 -l $length -r 5 -g 1 -o "$output"extracted_data/neutral_train.ms
./convert -i $sweep_train -m original -c bp -w $window_size -s 5000 -l $length -r 5 -g 1 -o "$output"extracted_data/selsweep_train.ms

./grid -i $neut_scan -m original -c bp -w $window_size -s 5000 -l $length -r 5 -g $grid_size -o "$output"window_"$window_size"/neut
./grid -i $sweep_scan -m original -c bp -w $window_size -s 5000 -l $length -r 5 -g $grid_size -o "$output"window_"$window_size"/sweep

cat "$output"window_"$window_size"/sweep_positions.ms "$output"window_"$window_size"/neut_positions.ms > "$output"window_"$window_size"/sim_positions.ms

num_detection=$(($num_sim * $grid_size * 2))
echo "$num_detection"
echo "./ms "$window_size" "$num_detection"" > "$output"extracted_data/test_detection.ms
for ((i=0; i<$num_sim; i++));
do
	tail -n +2 "$output"window_"$window_size"/sweep"$i".ms >> "$output"extracted_data/test_detection.ms;
done 

for ((i=0; i<$num_sim; i++));
do
	tail -n +2 "$output"window_"$window_size"/neut"$i".ms >> "$output"extracted_data/test_detection.ms;
done 

python3 SCRIPTS/T-REx_scripts/split.py -i "$output"extracted_data/neutral_train.ms -o "$output"MS_files_train -f neut
python3 SCRIPTS/T-REx_scripts/split.py -i "$output"extracted_data/selsweep_train.ms -o "$output"MS_files_train -f sweep

python3 SCRIPTS/T-REx_scripts/split.py -i "$output"extracted_data/test_detection.ms -o "$output"MS_files_test -f test

echo 'Time of preprocessing the training set is:' > "$output"Results/Results.txt
start=$(date +"%Y-%m-%d %H:%M:%S");
python3 TOOLS/T-REx/train_ms.py $num_train 1 "$output"MS_files_train/
python3 TOOLS/T-REx/train_ms.py $num_train 0 "$output"MS_files_train/
python3 TOOLS/T-REx/parse_train.py $num_train 1 "$output"MS_files_train/ "$output"CVF_files/
python3 TOOLS/T-REx/parse_train.py $num_train 0 "$output"MS_files_train/ "$output"CVF_files/
end=$(date +"%Y-%m-%d %H:%M:%S");
start_s=$(date -d "$start" +%s);
end_s=$(date -d "$end" +%s);
echo "$((end_s-start_s)) " >> "$output"Results/Results.txt

echo 'Time of preprocessing the testing set is:' >> "$output"Results/Results.txt
start=$(date +"%Y-%m-%d %H:%M:%S");
python3 TOOLS/T-REx/test_vcf.py $num_detection "$output"MS_files_test/
python3 TOOLS/T-REx/Parse_vcf.py $num_detection "$output"MS_files_test/ "$output"CVF_files/
end=$(date +"%Y-%m-%d %H:%M:%S");
start_s=$(date -d "$start" +%s);
end_s=$(date -d "$end" +%s);
echo "$((end_s-start_s)) " >> "$output"Results/Results.txt

Rscript TOOLS/T-REx/TD_vcf.R $rank $num_train $num_train $num_detection "$output"CVF_files/ "$output"Results/

cp "$output"window_"$window_size"/sim_positions.ms "$output"Results;
conda deactivate

rm -r "$output"MS_files_train;
rm -r "$output"MS_files_test;
rm -r "$output"CVF_files;
rm -r "$output"extracted_data;
rm -r "$output"window_"$window_size"

