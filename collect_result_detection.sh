#!/bin/bash

if [ ! -d $2 ]; then
	mkdir -p "$2";
fi

output_file="$2""Collection.csv"

echo -e "Tool\tCalculation_training_summary_statistics_time (sec)\tTraining_time (sec)\tCalculation_inference_summary_statistics_time (sec)\tInference_time (sec)\tSuccess_rate\tSuccess_rate_center\tSuccess_rate_threshold\tTPR" > "$output_file"

# Collect diploshic results
result_file="$1""diploshic/Detection_result.txt"
Inference_data_processing_time=$(sed -n '3p' $result_file)

Inference_time=$(sed -n '5p' "$result_file")

Success_rate=$(echo "$(tail -n 4 "$result_file" | head -n 1 | awk '{print $5}')")

Success_rate_center=$(echo "$(tail -n 3 "$result_file" | head -n 1 | awk '{print $6}')")

Success_rate_threshold=$(echo "$(tail -n 2 "$result_file" | head -n 1 | awk '{print $6}')")

TPR=$(echo "$(tail -n 1 "$result_file" | head -n 1 | awk '{print $4}')")

echo -e ""diploshic"\t0\t0\t$Inference_data_processing_time\t$Inference_time\t$Success_rate\t$Success_rate_center\t$Success_rate_threshold\t$TPR" >> "$output_file"

# Collect t-rex results
input_file="$1""t-rex/Results/Results.txt"
Training_data_processing_time=$(echo "scale=2; (($(sed -n "2p" "$input_file" | cut -d' ' -f"1") + $(sed -n "5p" "$input_file" | cut -d' ' -f"7") + $(sed -n "7p" "$input_file" | cut -d' ' -f"8") + $(sed -n "9p" "$input_file" | cut -d' ' -f"5")) *100) /100 " | bc)

Testing_data_processing_time=$(echo "scale=2; (($(sed -n "4p" "$input_file" | cut -d' ' -f"1") + $(sed -n "6p" "$input_file" | cut -d' ' -f"7") + $(sed -n "8p" "$input_file" | cut -d' ' -f"8")) *100) /100 " | bc)

Training_time=$(echo "scale=2; (($(sed -n "10p" "$input_file" | cut -d' ' -f"5")) *100) /100 " | bc)

Testing_time=$(echo "scale=2; (($(sed -n "11p" "$input_file" | cut -d' ' -f"5")) *100) /100 " | bc)

if [ "$3" = "mild-bottleneck" ] || [ "$3" = "severe-bottleneck" ] || [ "$3" = "recent-migration" ]; then
	Success_rate=$(echo "$(tail -n 12 "$input_file" | head -n 1 | awk '{print $6}')")

	Success_rate_center=$(echo "$(tail -n 9 "$input_file" | head -n 1 | awk '{print $7}')")

	Success_rate_threshold=$(echo "$(tail -n 6 "$input_file" | head -n 1 | awk '{print $7}')")

	TPR=$(echo "$(tail -n 3 "$input_file" | head -n 1 | awk '{print $5'})")

elif [ "$3" = "old-migration" ]; then
	Success_rate=$(echo "$(tail -n 11 "$input_file" | head -n 1 | awk '{print $6}')")

	Success_rate_center=$(echo "$(tail -n 8 "$input_file" | head -n 1 | awk '{print $7}')")

	Success_rate_threshold=$(echo "$(tail -n 5 "$input_file" | head -n 1 | awk '{print $7}')")

	TPR=$(echo "$(tail -n 2 "$input_file" | head -n 1 | awk '{print $5}')")

elif [ "$3" = "low-intensity-recombination-hotspot" ] || [ "$3" = "high-intensity-recombination-hotspot" ]; then
	Success_rate=$(echo "$(tail -n 10 "$input_file" | head -n 1 | awk '{print $6}')")

	Success_rate_center=$(echo "$(tail -n 7 "$input_file" | head -n 1 | awk '{print $7}')")

	Success_rate_threshold=$(echo "$(tail -n 4 "$input_file" | head -n 1 | awk '{print $7}')")

	TPR=$(echo "$(tail -n 1 "$input_file" | head -n 1 | awk '{print $5}')")

fi

echo -e ""t-rex"\t$Training_data_processing_time\t$Training_time\t$Testing_data_processing_time\t$Testing_time\t$Success_rate\t$Success_rate_center\t$Success_rate_threshold\t$TPR" >> "$output_file"

# Collect faster-nn results
result_file="$1""faster-nn/Results.txt"
#Inference_data_processing_time=$(sed -n '3p' $result_file)

Inference_time=$(sed -n '2p' "$result_file")

Success_rate=$(echo "$(tail -n 4 "$result_file" | head -n 1 | awk '{print $5}')")

Success_rate_center=$(echo "$(tail -n 3 "$result_file" | head -n 1 | awk '{print $6}')")

Success_rate_threshold=$(echo "$(tail -n 2 "$result_file" | head -n 1 | awk '{print $6}')")

TPR=$(echo "$(tail -n 1 "$result_file" | head -n 1 | awk '{print $4}')")

echo -e ""faster-nn"\t0\t0\t0\t$Inference_time\t$Success_rate\t$Success_rate_center\t$Success_rate_threshold\t$TPR" >> "$output_file"

# Collect raisd results
result_file="$1""raisd/Results.txt"
#Inference_data_processing_time=$(sed -n '3p' $result_file)

Inference_time=$(sed -n '2p' "$result_file")

Success_rate=$(echo "$(tail -n 3 "$result_file" | head -n 1 | awk '{print $5}')")

#Success_rate_center=$(echo "$(tail -n 3 "$result_file" | head -n 1 | awk '{print $6}')")

Success_rate_threshold=$(echo "$(tail -n 2 "$result_file" | head -n 1 | awk '{print $6}')")

TPR=$(echo "$(tail -n 1 "$result_file" | head -n 1 | awk '{print $4}')")

echo -e ""raisd"\t0\t0\t0\t$Inference_time\t$Success_rate\t0\t$Success_rate_threshold\t$TPR" >> "$output_file"
