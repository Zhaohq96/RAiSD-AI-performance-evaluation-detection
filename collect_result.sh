#!/bin/bash

if [ ! -d $2 ]; then
	mkdir -p "$2";
fi

output_file="$2""Collection.csv"

echo -e "Tool\tCalculation_training_summary_statistics_time (sec)\tTraing_image_generation_time (sec)\tTraining_time (sec)\tValidation_acc\tCalculation_testing_summary_statistics_time (sec)\tTesting_image_generation_time (sec)\tTesting_time (sec)\tTesting_acc" > "$output_file"

# Collect diploSHIC results
input_file1="$1""diploSHIC/train/model/Training_result.txt"
input_file2="$1""diploSHIC/test/result/Testing_result.txt"
Training_data_processing_time=$(echo "scale=2; (($(sed -n "4p" "$input_file1" | cut -d' ' -f"1") + $(sed -n "6p" "$input_file1" | cut -d' ' -f"1")) *100) /100 " | bc)

Testing_data_processing_time=$(echo "scale=2; (($(sed -n "4p" "$input_file2" | cut -d' ' -f"1") + $(sed -n "2p" "$input_file2" | cut -d' ' -f"1")) *100) /100 " | bc)

Training_time=$(echo "scale=2; (($(tail -n 2 "$input_file1" | head -n 1 | awk '{print $7}')) *100) /100 " | bc)

Val_acc=$(echo "$(tail -n 4 "$input_file1" | head -n 1 | awk '{print $8}')")

Testing_time=$(echo "scale=2; (($(sed -n "6p" "$input_file2" | cut -d' ' -f"1") + $(sed -n "8p" "$input_file2" | cut -d' ' -f"1")) *100) /100 " | bc)

True=$(echo "$(sed -n "11p" "$input_file2" | cut -d' ' -f"1") + $(sed -n "19p" "$input_file2" | cut -d' ' -f"1")" | bc)
All=$(echo "$(sed -n "11p" "$input_file2" | cut -d' ' -f"1") + $(sed -n "19p" "$input_file2" | cut -d' ' -f"1") + $(sed -n "13p" "$input_file2" | cut -d' ' -f"1") + $(sed -n "17p" "$input_file2" | cut -d' ' -f"1")" | bc)
Testing_Acc=$(echo "$True / $All" | bc -l)
#echo "$Testing_Acc $True $All"
result=$(echo "$Testing_Acc == 1" | bc -l)
if [ "$result" -eq 1 ]; then
	Testing_acc="0""$Testing_Acc"
else
	Testing_acc="$Testing_Acc"
fi
echo -e ""diploSHIC"\t$Training_data_processing_time\t0\t$Training_time\t$Val_acc\t$Testing_data_processing_time\t0\t$Testing_time\t$Testing_acc" >> "$output_file"

# Collect SURFDAWave results
input_file1="$1""SURFDAWave/train/model/Training_result.txt"
input_file2="$1""SURFDAWave/test/result/Testing_result.txt"
Training_data_processing_time=$(echo "scale=2; (($(sed -n "4p" "$input_file1" | cut -d' ' -f"1") + $(sed -n "6p" "$input_file1" | cut -d' ' -f"1")) *100) /100 " | bc)

Testing_data_processing_time=$(echo "scale=2; (($(sed -n "4p" "$input_file2" | cut -d' ' -f"1") + $(sed -n "2p" "$input_file2" | cut -d' ' -f"1")) *100) /100 " | bc)

Training_time=$(echo "scale=2; (($(sed -n "7p" "$input_file1" | cut -d' ' -f"5")) *100) /100 " | bc)

Testing_time=$(echo "scale=2; (($(sed -n "6p" "$input_file2" | cut -d' ' -f"1") + $(sed -n "8p" "$input_file2" | cut -d' ' -f"1")) *100) /100 " | bc)

True=$(echo "$(sed -n "11p" "$input_file2" | cut -d' ' -f"1") + $(sed -n "19p" "$input_file2" | cut -d' ' -f"1")" | bc)
All=$(echo "$(sed -n "11p" "$input_file2" | cut -d' ' -f"1") + $(sed -n "19p" "$input_file2" | cut -d' ' -f"1") + $(sed -n "13p" "$input_file2" | cut -d' ' -f"1") + $(sed -n "17p" "$input_file2" | cut -d' ' -f"1")" | bc)
Testing_Acc=$(echo "$True / $All" | bc -l)
#echo "$Testing_Acc $True $All"
result=$(echo "$Testing_Acc == 1" | bc -l)
if [ "$result" -eq 1 ]; then
	Testing_acc="0""$Testing_Acc"
else
	Testing_acc="$Testing_Acc"
fi
echo -e ""SURFDAWave"\t$Training_data_processing_time\t0\t$Training_time\t0\t$Testing_data_processing_time\t0\t$Testing_time\t$Testing_acc" >> "$output_file"

# Collect T-REx results
input_file="$1""T-REx/Results/Results.txt"
Training_data_processing_time=$(echo "scale=2; (($(sed -n "2p" "$input_file" | cut -d' ' -f"1") + $(sed -n "5p" "$input_file" | cut -d' ' -f"7") + $(sed -n "7p" "$input_file" | cut -d' ' -f"8") + $(sed -n "9p" "$input_file" | cut -d' ' -f"5")) *100) /100 " | bc)

Testing_data_processing_time=$(echo "scale=2; (($(sed -n "4p" "$input_file" | cut -d' ' -f"1") + $(sed -n "6p" "$input_file" | cut -d' ' -f"7") + $(sed -n "8p" "$input_file" | cut -d' ' -f"8")) *100) /100 " | bc)

Training_time=$(echo "scale=2; (($(sed -n "10p" "$input_file" | cut -d' ' -f"5")) *100) /100 " | bc)

Testing_time=$(echo "scale=2; (($(sed -n "11p" "$input_file" | cut -d' ' -f"5")) *100) /100 " | bc)

Testing_Acc=0
for value in $(echo "$(sed -n "13p" "$input_file" | cut -d' ' -f"2")" | bc) $(echo "$(sed -n "15p" "$input_file" | cut -d' ' -f"2")" | bc) $(echo "$(sed -n "17p" "$input_file" | cut -d' ' -f"2")" | bc); 
do
	if (( $(echo "$value > $Testing_Acc" | bc -l) )); then
		Testing_Acc=$value
	fi
done
#echo $Testing_Acc
result=$(echo "$Testing_Acc == 1" | bc)
if [ "$result" -eq 1 ]; then
	Testing_acc="0""$Testing_Acc"
else
	Testing_acc="$Testing_Acc"
fi
echo -e ""T\-REx"\t$Training_data_processing_time\t0\t$Training_time\t0\t$Testing_data_processing_time\t0\t$Testing_time\t$Testing_acc" >> "$output_file"

# Collect Net-2 results
input_dir="${1%/}/CNN_Nguembang_Fadja/results/log/"
Input_file1=$(ls "$1""CNN_Nguembang_Fadja/results/log/" | grep "^RAiSD_Info.CNN_Nguembang_Fadja" | grep "TrainingData2DSNP.neutralTR" | head -n 1)
Input_file2=$(ls "$1""CNN_Nguembang_Fadja/results/log/" | grep "^RAiSD_Info.CNN_Nguembang_Fadja" | grep "TrainingData2DSNP.sweepTR" | head -n 1)
input_file1=$input_dir$Input_file1
input_file2=$input_dir$Input_file2

Training_image_processing_time=$(echo "scale=2; (($(tail -n 3 "$input_file1" | head -n 1 | awk '{print $4}') + $(tail -n 3 "$input_file2" | head -n 1 | awk '{print $4}')) * 100) / 100" | bc)


Input_file1=$(ls "$1""CNN_Nguembang_Fadja/results/log/" | grep "^RAiSD_Info.CNN_Nguembang_Fadja" | grep "TestingData2DSNP.neutralTE" | head -n 1)
Input_file2=$(ls "$1""CNN_Nguembang_Fadja/results/log/" | grep "^RAiSD_Info.CNN_Nguembang_Fadja" | grep "TestingData2DSNP.sweepTE" | head -n 1)
input_file1="$input_dir$Input_file1"
input_file2="$input_dir$Input_file2"

Testing_image_processing_time=$(echo "scale=2; (($(tail -n 3 "$input_file1" | head -n 1 | awk '{print $4}') + $(tail -n 3 "$input_file2" | head -n 1 | awk '{print $4}')) * 100) / 100" | bc)


Input_file=$(ls "$1""CNN_Nguembang_Fadja/results/log/" | grep "^create_model" | grep ".txt" | head -n 1)
input_file=$input_dir$Input_file
Training_time=$(echo "scale=2; (($(sed -n "19p" "$input_file" | cut -d' ' -f"3")) *100) /100 " | bc)
Testing_time=$(echo "scale=2; (($(sed -n "20p" "$input_file" | cut -d' ' -f"3")) *100) /100 " | bc)
Val_acc=$(echo $(sed -n "22p" "$input_file" | cut -d' ' -f"6"))
Testing_acc=$(echo $(sed -n "27p" "$input_file" | cut -d' ' -f"2"))
echo -e ""CNN_Nguembang_Fadja"\t0\t$Training_image_processing_time\t$Training_time\t$Val_acc\t0\t$Testing_image_processing_time\t$Testing_time\t$Testing_acc" >> "$output_file"

# Collect SweepNet results
input_dir="${1%/}/SweepNet/"
Input_file1=$(ls "$1""SweepNet/" | grep "^RAiSD_Info.SweepNet" | grep "TrainingData2DSNP.neutralTR" | head -n 1)
Input_file2=$(ls "$1""SweepNet/" | grep "^RAiSD_Info.SweepNet" | grep "TrainingData2DSNP.sweepTR" | head -n 1)
input_file1=$input_dir$Input_file1
input_file2=$input_dir$Input_file2

Training_image_processing_time=$(echo "scale=2; (($(tail -n 3 "$input_file1" | head -n 1 | awk '{print $4}') + $(tail -n 3 "$input_file2" | head -n 1 | awk '{print $4}')) * 100) / 100" | bc)


Input_file1=$(ls "$1""SweepNet/" | grep "^RAiSD_Info.SweepNet" | grep "TestingData2DSNP.neutralTE" | head -n 1)
Input_file2=$(ls "$1""SweepNet/" | grep "^RAiSD_Info.SweepNet" | grep "TestingData2DSNP.sweepTE" | head -n 1)
input_file1="$input_dir$Input_file1"
input_file2="$input_dir$Input_file2"

Testing_image_processing_time=$(echo "scale=2; (($(tail -n 3 "$input_file1" | head -n 1 | awk '{print $4}') + $(tail -n 3 "$input_file2" | head -n 1 | awk '{print $4}')) * 100) / 100" | bc)


Input_file=$(ls "$1""SweepNet/" | grep "^RAiSD_Info.SweepNet" | grep "Model" | head -n 1)
input_file=$input_dir$Input_file
Training_time=$(echo "scale=2; (($(tail -n 3 "$input_file" | head -n 1 | awk '{print $4}')) *100) /100 " | bc)
Val_acc=$(grep "\[SAVING BEST MODEL, ACCURACY:" "$input_file" | tail -n 1 | awk -F'ACCURACY: ' '{gsub(/\]/, "", $2); print $2}')

Input_file=$(ls "$1""SweepNet/" | grep "^RAiSD_Info.SweepNet" | grep "ModelTest" | head -n 1)
input_file=$input_dir$Input_file


Testing_time=$(echo "scale=2; (($(tail -n 3 "$input_file" | head -n 1 | awk '{print $4}')) *100) /100 " | bc)
Testing_acc=$(echo "scale=8; (($(tail -n 5 "$input_file" | head -n 1 | awk '{print $3}') / 100) *100) /100 " | bc)
echo -e ""SweepNet"\t0\t$Training_image_processing_time\t$Training_time\t$Val_acc\t0\t$Testing_image_processing_time\t$Testing_time\t$Testing_acc" >> "$output_file"

# Collect FAST-NN results
input_dir="${1%/}/FAST-NN/"
Input_file1=$(ls "$1""FAST-NN/" | grep "^RAiSD_Info.FAST-NN" | grep "TrainingData2DSNP.neutralTR" | head -n 1)
Input_file2=$(ls "$1""FAST-NN/" | grep "^RAiSD_Info.FAST-NN" | grep "TrainingData2DSNP.sweepTR" | head -n 1)
input_file1=$input_dir$Input_file1
input_file2=$input_dir$Input_file2

Training_image_processing_time=$(echo "scale=2; (($(tail -n 3 "$input_file1" | head -n 1 | awk '{print $4}') + $(tail -n 3 "$input_file2" | head -n 1 | awk '{print $4}')) * 100) / 100" | bc)


Input_file1=$(ls "$1""FAST-NN/" | grep "^RAiSD_Info.FAST-NN" | grep "TestingData2DSNP.neutralTE" | head -n 1)
Input_file2=$(ls "$1""FAST-NN/" | grep "^RAiSD_Info.FAST-NN" | grep "TestingData2DSNP.sweepTE" | head -n 1)
input_file1="$input_dir$Input_file1"
input_file2="$input_dir$Input_file2"

Testing_image_processing_time=$(echo "scale=2; (($(tail -n 3 "$input_file1" | head -n 1 | awk '{print $4}') + $(tail -n 3 "$input_file2" | head -n 1 | awk '{print $4}')) * 100) / 100" | bc)


Input_file=$(ls "$1""FAST-NN/" | grep "^RAiSD_Info.FAST-NN" | grep "Model" | head -n 1)
input_file=$input_dir$Input_file
Training_time=$(echo "scale=2; (($(tail -n 3 "$input_file" | head -n 1 | awk '{print $4}')) *100) /100 " | bc)
Val_acc=$(grep "\[SAVING BEST MODEL, ACCURACY:" "$input_file" | tail -n 1 | awk -F'ACCURACY: ' '{gsub(/\]/, "", $2); print $2}')

Input_file=$(ls "$1""FAST-NN/" | grep "^RAiSD_Info.FAST-NN" | grep "ModelTest" | head -n 1)
input_file=$input_dir$Input_file


Testing_time=$(echo "scale=2; (($(tail -n 3 "$input_file" | head -n 1 | awk '{print $4}')) *100) /100 " | bc)
Testing_acc=$(echo "scale=8; (($(tail -n 5 "$input_file" | head -n 1 | awk '{print $3}') / 100) *100) /100 " | bc)
echo -e ""FAST-NN"\t0\t$Training_image_processing_time\t$Training_time\t$Val_acc\t0\t$Testing_image_processing_time\t$Testing_time\t$Testing_acc" >> "$output_file"

# Collect FASTER-NN results
input_dir="${1%/}/FASTER-NN/"
Input_file1=$(ls "$1""FASTER-NN/" | grep "^RAiSD_Info.FASTER-NN" | grep "TrainingData2DSNP.neutralTR" | head -n 1)
Input_file2=$(ls "$1""FASTER-NN/" | grep "^RAiSD_Info.FASTER-NN" | grep "TrainingData2DSNP.sweepTR" | head -n 1)
input_file1=$input_dir$Input_file1
input_file2=$input_dir$Input_file2

Training_image_processing_time=$(echo "scale=2; (($(tail -n 3 "$input_file1" | head -n 1 | awk '{print $4}') + $(tail -n 3 "$input_file2" | head -n 1 | awk '{print $4}')) * 100) / 100" | bc)


Input_file1=$(ls "$1""FASTER-NN/" | grep "^RAiSD_Info.FASTER-NN" | grep "TestingData2DSNP.neutralTE" | head -n 1)
Input_file2=$(ls "$1""FASTER-NN/" | grep "^RAiSD_Info.FASTER-NN" | grep "TestingData2DSNP.sweepTE" | head -n 1)
input_file1="$input_dir$Input_file1"
input_file2="$input_dir$Input_file2"

Testing_image_processing_time=$(echo "scale=2; (($(tail -n 3 "$input_file1" | head -n 1 | awk '{print $4}') + $(tail -n 3 "$input_file2" | head -n 1 | awk '{print $4}')) * 100) / 100" | bc)


Input_file=$(ls "$1""FASTER-NN/" | grep "^RAiSD_Info.FASTER-NN" | grep "Model" | head -n 1)
input_file=$input_dir$Input_file
Training_time=$(echo "scale=2; (($(tail -n 3 "$input_file" | head -n 1 | awk '{print $4}')) *100) /100 " | bc)
Val_acc=$(grep "\[SAVING BEST MODEL, ACCURACY:" "$input_file" | tail -n 1 | awk -F'ACCURACY: ' '{gsub(/\]/, "", $2); print $2}')

Input_file=$(ls "$1""FASTER-NN/" | grep "^RAiSD_Info.FASTER-NN" | grep "ModelTest" | head -n 1)
input_file=$input_dir$Input_file


Testing_time=$(echo "scale=2; (($(tail -n 3 "$input_file" | head -n 1 | awk '{print $4}')) *100) /100 " | bc)
Testing_acc=$(echo "scale=8; (($(tail -n 5 "$input_file" | head -n 1 | awk '{print $3}') / 100) *100) /100 " | bc)
echo -e ""FASTER-NN"\t0\t$Training_image_processing_time\t$Training_time\t$Val_acc\t0\t$Testing_image_processing_time\t$Testing_time\t$Testing_acc" >> "$output_file"

# Collect FASTER-NN-G8 results
input_dir="${1%/}/FASTER-NN-G8/"
Input_file1=$(ls "$1""FASTER-NN-G8/" | grep "^RAiSD_Info.FASTER-NN-G8" | grep "TrainingData2DSNP.neutralTR" | head -n 1)
Input_file2=$(ls "$1""FASTER-NN-G8/" | grep "^RAiSD_Info.FASTER-NN-G8" | grep "TrainingData2DSNP.sweepTR" | head -n 1)

input_file1=$input_dir$Input_file1
input_file2=$input_dir$Input_file2


Training_image_processing_time=$(echo "scale=2; (($(tail -n 3 "$input_file1" | head -n 1 | awk '{print $4}') + $(tail -n 3 "$input_file2" | head -n 1 | awk '{print $4}')) * 100) / 100" | bc)


Input_file1=$(ls "$1""FASTER-NN-G8/" | grep "^RAiSD_Info.FASTER-NN-G8" | grep "TestingData2DSNP.neutralTE" | head -n 1)
Input_file2=$(ls "$1""FASTER-NN-G8/" | grep "^RAiSD_Info.FASTER-NN-G8" | grep "TestingData2DSNP.sweepTE" | head -n 1)

input_file1="$input_dir$Input_file1"
input_file2="$input_dir$Input_file2"


Testing_image_processing_time=$(echo "scale=2; (($(tail -n 3 "$input_file1" | head -n 1 | awk '{print $4}') + $(tail -n 3 "$input_file2" | head -n 1 | awk '{print $4}')) * 100) / 100" | bc)


Input_file=$(ls "$1""FASTER-NN-G8/" | grep "^RAiSD_Info.FASTER-NN-G8" | grep "Model" | head -n 1)
input_file=$input_dir$Input_file
Training_time=$(echo "scale=2; (($(tail -n 3 "$input_file" | head -n 1 | awk '{print $4}')) *100) /100 " | bc)
Val_acc=$(grep "\[SAVING BEST MODEL, ACCURACY:" "$input_file" | tail -n 1 | awk -F'ACCURACY: ' '{gsub(/\]/, "", $2); print $2}')

Input_file=$(ls "$1""FASTER-NN-G8/" | grep "^RAiSD_Info.FASTER-NN-G8" | grep "ModelTest" | head -n 1)
input_file=$input_dir$Input_file


Testing_time=$(echo "scale=2; (($(tail -n 3 "$input_file" | head -n 1 | awk '{print $4}')) *100) /100 " | bc)
Testing_acc=$(echo "scale=8; (($(tail -n 5 "$input_file" | head -n 1 | awk '{print $3}') / 100) *100) /100 " | bc)
echo -e ""FASTER-NN-G8"\t0\t$Training_image_processing_time\t$Training_time\t$Val_acc\t0\t$Testing_image_processing_time\t$Testing_time\t$Testing_acc" >> "$output_file"

# Collect FASTER-NN-G128 results
input_dir="${1%/}/FASTER-NN-G128/"
Input_file1=$(ls "$1""FASTER-NN-G128/" | grep "^RAiSD_Info.FASTER-NN-G128" | grep "TrainingData2DSNP.neutralTR" | head -n 1)
Input_file2=$(ls "$1""FASTER-NN-G128/" | grep "^RAiSD_Info.FASTER-NN-G128" | grep "TrainingData2DSNP.sweepTR" | head -n 1)

input_file1=$input_dir$Input_file1
input_file2=$input_dir$Input_file2


Training_image_processing_time=$(echo "scale=2; (($(tail -n 3 "$input_file1" | head -n 1 | awk '{print $4}') + $(tail -n 3 "$input_file2" | head -n 1 | awk '{print $4}')) * 100) / 100" | bc)


Input_file1=$(ls "$1""FASTER-NN-G128/" | grep "^RAiSD_Info.FASTER-NN-G128" | grep "TestingData2DSNP.neutralTE" | head -n 1)
Input_file2=$(ls "$1""FASTER-NN-G128/" | grep "^RAiSD_Info.FASTER-NN-G128" | grep "TestingData2DSNP.sweepTE" | head -n 1)

input_file1="$input_dir$Input_file1"
input_file2="$input_dir$Input_file2"


Testing_image_processing_time=$(echo "scale=2; (($(tail -n 3 "$input_file1" | head -n 1 | awk '{print $4}') + $(tail -n 3 "$input_file2" | head -n 1 | awk '{print $4}')) * 100) / 100" | bc)


Input_file=$(ls "$1""FASTER-NN-G128/" | grep "^RAiSD_Info.FASTER-NN-G128" | grep "Model" | head -n 1)
input_file=$input_dir$Input_file
Training_time=$(echo "scale=2; (($(tail -n 3 "$input_file" | head -n 1 | awk '{print $4}')) *100) /100 " | bc)
Val_acc=$(grep "\[SAVING BEST MODEL, ACCURACY:" "$input_file" | tail -n 1 | awk -F'ACCURACY: ' '{gsub(/\]/, "", $2); print $2}')

Input_file=$(ls "$1""FASTER-NN-G128/" | grep "^RAiSD_Info.FASTER-NN-G128" | grep "ModelTest" | head -n 1)
input_file=$input_dir$Input_file


Testing_time=$(echo "scale=2; (($(tail -n 3 "$input_file" | head -n 1 | awk '{print $4}')) *100) /100 " | bc)
Testing_acc=$(echo "scale=8; (($(tail -n 5 "$input_file" | head -n 1 | awk '{print $3}') / 100) *100) /100 " | bc)
echo -e ""FASTER-NN-G128"\t0\t$Training_image_processing_time\t$Training_time\t$Val_acc\t0\t$Testing_image_processing_time\t$Testing_time\t$Testing_acc" >> "$output_file"
