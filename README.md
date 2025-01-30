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
wget https://github.com/Zhaohq96/RAiSD-AI-performance-evaluation-detection/archive/refs/heads/master.zip; unzip master.zip; cd RAiSD-AI-performance-evaluation-detection-main/; mv README.md README-RAiSD-AI-performance-evaluation-detection.md; mv * ../; cd ..; rm -r RAiSD-AI-performance-evaluation-detection-main/; rm master.zip; gcc convert.c -o convert -lm; gcc grid.c -o grid -lm; wget -O dataset-example.tar.gz https://figshare.com/ndownloader/files/51400967; tar -xzvf dataset-example.tar.gz; chmod +x ./SCRIPTS/diploSHIC_scripts/diploSHIC_spliting.sh; wget -O dataset-detection.tar.gz https://figshare.com/ndownloader/files/52027712; tar -xzvf dataset-detection.tar.gz;
```

## Run detection with the trained model from RAiSD-AI-performance-evaluation repo
If you have trained models using the process_all_datasets_all_tools.sh and obtained the results and model files in folders like _result-mild-bottleneck-1K_ that contains subfolder of each tool, please copy these folder to this folder path.

The environment for each tool should be already installed.

To run all tools for detection:

bash run_detection_all_tools.sh dataset_name dataset_size grid_size

A quick command:
```
bash run_detection_all_tools.sh mild-bottleneck 1K 100
```

The results will be collected in Collection.csv and stored in the path _result-detection-mild-bottleneck_

Note that the default number of simulations to detect is 100, error is 0.01, the FPR for obtaining TPR is 0.05, if you want to change any parameters, please go to _scan_dataset.sh_ and modify the parameters of interest.

