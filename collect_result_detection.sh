#!/bin/bash

if [ ! -d $2 ]; then
	mkdir -p "$2";
fi

output_file="$2""Collection.csv"

echo -e "Tool\tCalculation_training_summary_statistics_time (sec)\tTraining_time (sec)\tCalculation_inference_summary_statistics_time (sec)\tInference_time (sec)\tSuccess_rate\tSuccess_rate_center\tTPR" > "$output_file"

# Collect diploshic results
result_file="$1""diplo/Detection_result.txt"
Inference_data_processing_time=$(sed -n '3p' $result_file)

Inference_time=$(sed -n '5p' "$result_file")

Success_rate=$(echo "$(tail -n 3 "$result_file" | head -n 1 | awk '{print $5}')")

Success_rate_center=$(echo "$(tail -n 2 "$result_file" | head -n 1 | awk '{print $6}')")

TPR=$(echo "$(tail -n 1 "$result_file" | head -n 1 | awk '{print $4}')")

echo -e ""diploshic"\t0\t0\t$Inference_data_processing_time\t$Inference_time\t$Success_rate\t$Success_rate_center\t$TPR" >> "$output_file"


# Collect t-rex results
input_file="$1""t-rex/Results/Results.txt"
Training_data_processing_time=$(echo "scale=2; (($(sed -n "2p" "$input_file" | cut -d' ' -f"1") + $(sed -n "5p" "$input_file" | cut -d' ' -f"7") + $(sed -n "7p" "$input_file" | cut -d' ' -f"8") + $(sed -n "9p" "$input_file" | cut -d' ' -f"5")) *100) /100 " | bc)

Testing_data_processing_time=$(echo "scale=2; (($(sed -n "4p" "$input_file" | cut -d' ' -f"1") + $(sed -n "6p" "$input_file" | cut -d' ' -f"7") + $(sed -n "8p" "$input_file" | cut -d' ' -f"8")) *100) /100 " | bc)

Training_time=$(echo "scale=2; (($(sed -n "10p" "$input_file" | cut -d' ' -f"5")) *100) /100 " | bc)

Testing_time=$(echo "scale=2; (($(sed -n "11p" "$input_file" | cut -d' ' -f"5")) *100) /100 " | bc)

#Testing_Acc=0
#for value in $(echo "$(sed -n "13p" "$input_file" | cut -d' ' -f"2")" | bc) $(echo "$(sed -n "15p" "$input_file" | cut -d' ' -f"2")" | bc) $(echo "$(sed -n "17p" "$input_file" | cut -d' ' -f"2")" | bc); 
#do
#	if (( $(echo "$value > $Testing_Acc" | bc -l) )); then
#		Testing_Acc=$value
#	fi
#done
#echo $Testing_Acc
#result=$(echo "$Testing_Acc == 1" | bc)
#if [ "$result" -eq 1 ]; then
#	Testing_acc="0""$Testing_Acc"
#else
#	Testing_acc="$Testing_Acc"
#fi
#echo -e ""T\-REx"\t$Training_data_processing_time\t0\t$Training_time\t0\t$Testing_data_processing_time\t0\t$Testing_time\t$Testing_acc" >> "$output_file"

# Collect faster-nn results
result_file="$1""faster-nn/Results.txt"
#Inference_data_processing_time=$(sed -n '3p' $result_file)

Inference_time=$(sed -n '2p' "$result_file")

Success_rate=$(echo "$(tail -n 3 "$result_file" | head -n 1 | awk '{print $5}')")

Success_rate_center=$(echo "$(tail -n 2 "$result_file" | head -n 1 | awk '{print $6}')")

TPR=$(echo "$(tail -n 1 "$result_file" | head -n 1 | awk '{print $4}')")

echo -e ""faster-nn"\t0\t0\t0\t$Inference_time\t$Success_rate\t$Success_rate_center\t$TPR" >> "$output_file"
