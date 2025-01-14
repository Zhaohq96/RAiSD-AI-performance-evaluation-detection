# RAiSD-AI-performance-evaluation-detection

## About
This repository contains supplementary files to reproduce the detection results in the paper "".

## Download and path modification
To download the repository by the command:

```
wget https://github.com/Zhaohq96/RAiSD-AI-performance-evaluation-detection/archive/refs/heads/master.zip; unzip master.zip;
```

After downloading the repository, please move the folder _T-REx/_ to the path _TOOLS/_ of _RAiSD-AI-performance-evaluation_. Then, move all scripts to the path _RAiSD-AI-performance-evaluation_. NOTE that if you follow the instructions in repository _RAiSD-AI-performance-evaluation_, the files should be moved to the path _RAiSD-AI/RAiSD-AI-master_.

## Usage of each script
### scan_dataset.sh
```
Usage of scan_dataset.sh

bash scan_dataset.sh tool_name path_training_data_folder(model_folder) path_inference_folder path_output grid_size (evaluataion_dataset) (run_ID)
Note that the path_training_data_folder and path_inference_folder should contain two files, 1) neutral.ms and 2) selsweep.ms and please add '/' to the end of the folder path.

Specific tool:
diploshic
bash process_dataset.sh diploshic path_trained_model_folder path_inference_folder path_output grid_size

t-rex
bash process_dataset.sh t-rex path_training_data_folder path_inference_folder path_output grid_size evaluataion_dataset

Note that evaluation_dataset is only available for t-rex to use the optimized rank value for training and testing

faster-nn
bash process_dataset.sh faster-nn path_trained_model_folder path_inference_folder path_output grid_size run_ID

Quick example:
bash scan_dataset.sh t-rex dataset-example/train/ dataset-example/test/ result-scan/t-rex/ 9 example
bash scan_dataset.sh diploshic result-example/diploSHIC/train/model/ dataset-example/test/ result-scan/diploshic/ 9
bash scan_dataset.sh faster-nn result-example/FASTER-NN/RAiSD_Model.FASTER-NNexampleModel/ dataset-example/test/ result-scan/faster-nn/ 9 example faster-nn-example
```

### scan_dataset_diploshic.sh
```
Usage of scan_dataset_diploshic.sh

bash scan_dataset_diploshic.sh path_inference_file_neutral path_inference_file_sweep path_output path_trained_model window_size length grid_size num_simulation_inference

The results will be stored in the file path_output/Detection_result.txt
```

### scan_dataset_t-rex.sh
```
Usage of scan_dataset_t-rex.sh

bash scan_dataset_t-rex.sh -n path_training_file_neutral -s path_training_file_sweep -N path_inference_file_neutral -S path_inference_file_sweep -o path_output -w window_size -l length -t num_simulation_training -T num_simulation_inference -r rank -g grid_size

The results will be stored in the file path_output/Results.txt
```

### scan_dataset_faster-nn.sh
```
Usage of scan_dataset_faster-nn.sh

bash scan_dataset_faster-nn path_trained_model path_inference_folder path_output length target grid_size error run_ID

The results will be stored in the file path_output/Detection_result.txt
```
