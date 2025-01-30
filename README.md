# RAiSD-AI-performance-evaluation-detection

## About
This repository contains supplementary files to reproduce the detection results in the paper "".

## Step by step instructions
### Step 1: RAiSD-AI download and compile
Firstly, to download and compile RAiSD-AI via https://github.com/alachins/raisd-ai. Using quick command:

```
 mkdir RAiSD-AI; cd RAiSD-AI; wget https://github.com/alachins/RAiSD-AI/archive/refs/heads/master.zip; unzip master.zip; cd RAiSD-AI-master; ./compile-RAiSD-AI.sh
```

### Step 2: Toolchain download
To enter the RAiSD-AI folder, if you followed the last command to download and compile RAiSD-AI, you would already be in the RAiSD-AI folder.

To download and move the source files to the RAiSD-AI folder:

```
wget https://github.com/Zhaohq96/RAiSD-AI-performance-evaluation-detection/archive/refs/heads/master.zip; unzip master.zip; cd RAiSD-AI-performance-evaluation-detection-main/; mv README.md README-RAiSD-AI-performance-evaluation-detection.md; mv * ../; cd ..; rm -r RAiSD-AI-performance-evaluation-detection-main/; rm master.zip; gcc convert.c -o convert -lm; gcc grid.c -o grid -lm; wget -O dataset-example.tar.gz https://figshare.com/ndownloader/files/51400967; tar -xzvf dataset-example.tar.gz; chmod +x ./SCRIPTS/diploSHIC_scripts/diploSHIC_spliting.sh;
```

## Download and path modification
To download the repository by the command:

```
wget https://github.com/Zhaohq96/RAiSD-AI-performance-evaluation-detection/archive/refs/heads/master.zip; unzip master.zip;
```

After downloading the repository, please move the folder _T-REx/_ to the path _TOOLS/_ of _RAiSD-AI-performance-evaluation_. Then, move all scripts to the path _RAiSD-AI-performance-evaluation_. NOTE that if you follow the instructions in repository _RAiSD-AI-performance-evaluation_, the files should be moved to the path _RAiSD-AI/RAiSD-AI-master_.

After moving the scripts, to compile grid.c by the command:
```
gcc grid.c -o grid -lm
```

## Quick example
If you follow the instructions to run the example dataset in repository _RAiSD-AI-performance-evaluation_, you should have a folder named _result-example/_ that contains the trained models of all the tools. Then, you can test the following tools on the example dataset with the commands:

### diploshic
```
bash scan_dataset.sh diploshic result-example/diploSHIC/train/model/ dataset-example/test/ result-scan/diploshic/ 9
```
The results will be stored in _result-scan/diploshic/Detection_result.txt_.

### t-rex
```
bash scan_dataset.sh t-rex dataset-example/train/ dataset-example/test/ result-scan/t-rex/ 9 example
```
The results will be stored in _result-scan/t-rex/Results/Results.txt_.

### faster-nn
```
bash scan_dataset.sh faster-nn result-example/FASTER-NN/RAiSD_Model.FASTER-NNexampleModel/ dataset-example/test/ result-scan/faster-nn/ 9 example faster-nn-example
```
The results will be stored in _result-scan/faster-nn/Results.txt_.

### Collect result
```
sh collect_result_detection.sh result-scan/ result-scan/
```
where the first arguement input is the path to input folder that contains the output folders of the tools with the names _diploshic_, _t-rex_ and _faster-nn_, and the second arguement input is the path to output folder. The results will be stored in _result-scan/Collection.csv_.

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

The results will be stored in the file path_output/Results/Results.txt
```

### scan_dataset_faster-nn.sh
```
Usage of scan_dataset_faster-nn.sh

bash scan_dataset_faster-nn path_trained_model path_inference_folder path_output length target grid_size error run_ID

The results will be stored in the file path_output/Detection_result.txt
```
