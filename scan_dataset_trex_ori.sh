#!/bin/bash

eval "$(conda shell.bash hook)"

window_size=128
length=100000
grid_size=9
num_train=50
num_sim=2
rank=5

while getopts "hn:s:N:S:o:w:l:t:T:r:g:m:" opt
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
		m) mbs=${OPTARG};;
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

python3 SCRIPTS/T-REx_scripts/split.py -i "$output"extracted_data/neutral_train.ms -o "$output"MS_files_train -f neut
python3 SCRIPTS/T-REx_scripts/split.py -i "$output"extracted_data/selsweep_train.ms -o "$output"MS_files_train -f sweep
python3 SCRIPTS/T-REx_scripts/split.py -i $sweep_scan -o "$output"MS_files_test -f sweep
python3 SCRIPTS/T-REx_scripts/split.py -i $neut_scan -o "$output"MS_files_test -f neut


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
num_detection=$(($num_sim * 88 * 2))
echo 'Time of preprocessing the testing set is:' >> "$output"Results/Results.txt
start=$(date +"%Y-%m-%d %H:%M:%S");
sim_num=0
for ((i=0; i<$num_sim; i++));
do
	I=$i+1
	python3 ms2vcf.py "$output"MS_files_test/sweep_"$((i + 1))".ms "$output"MS_files_test/test_"$i".vcf $mbs 
	python3 ms2vcf.py "$output"MS_files_test/neut_"$((i + 1))".ms "$output"MS_files_test/test_"$((i + num_sim))".vcf 0
	python3 TOOLS/T-REx/VCF_ms.py "$output"MS_files_test/test_"$i".vcf "$output"MS_files_test/ SCRIPTS/T-REx_scripts/miss.txt $i $sim_num
	sim_current=$(wc -l < "$output"MS_files_test/Positions_10000_window_"$i".csv)
	sim_c=$((sim_current - 1))
	echo "$sim_c" >> "$output"Results/Sim_pos.txt
	sim_num=$((sim_num + sim_c))
done

for ((i=0; i<$num_sim; i++));
do
	I=$((i + num_sim))
	python3 TOOLS/T-REx/VCF_ms.py "$output"MS_files_test/test_"$((i + num_sim))".vcf "$output"MS_files_test/ SCRIPTS/T-REx_scripts/miss.txt "$((i + num_sim))" $sim_num
	sim_current=$(wc -l < "$output"MS_files_test/Positions_10000_window_"$I".csv)
	sim_c=$((sim_current - 1))
	echo "$sim_c" >> "$output"Results/Sim_pos.txt
	sim_num=$((sim_num + sim_c))
done


python3 TOOLS/T-REx/test_vcf.py $sim_num "$output"MS_files_test/
python3 TOOLS/T-REx/Parse_vcf.py $sim_num "$output"MS_files_test/ "$output"CVF_files/
end=$(date +"%Y-%m-%d %H:%M:%S");
start_s=$(date -d "$start" +%s);
end_s=$(date -d "$end" +%s);
echo "$((end_s-start_s)) " >> "$output"Results/Results.txt

Rscript TOOLS/T-REx/TD_vcf.R $rank $num_train $num_train $sim_num "$output"CVF_files/ "$output"Results/

cp "$output"MS_files_test/Position* "$output"Results;
conda deactivate

rm -r "$output"MS_files_train;
rm -r "$output"MS_files_test;
rm -r "$output"CVF_files;
rm -r "$output"extracted_data;
rm -r "$output"window_"$window_size"
