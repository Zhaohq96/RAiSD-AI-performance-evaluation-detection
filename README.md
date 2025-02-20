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
wget https://github.com/Zhaohq96/RAiSD-AI-performance-evaluation-detection/archive/refs/heads/master.zip; unzip master.zip; cd RAiSD-AI-performance-evaluation-detection-main/; mv README.md README-RAiSD-AI-performance-evaluation-detection.md; mv * ../; cd ..; rm -r RAiSD-AI-performance-evaluation-detection-main/; rm master.zip; gcc convert.c -o convert -lm; gcc grid.c -o grid -lm; wget -O dataset-example.tar.gz https://figshare.com/ndownloader/files/51400967; tar -xzvf dataset-example.tar.gz; chmod +x ./SCRIPTS/diploSHIC_scripts/diploSHIC_spliting.sh; wget -O dataset-detection.tar.gz https://figshare.com/ndownloader/files/52027712; tar -xzvf dataset-detection.tar.gz; wget -O Pretrained_Model.tar.gz https://figshare.com/ndownloader/files/52499765; tar -xzvf Pretrained_Model.tar.gz
```

## Run detection
We provide pretrained models of diploshic, faster-nn and faster-nn-g-8. Those models are trained on the datasets with 5K simulations. For quick test, we use those models as the default.

A quick command to test all tools for selective detection:
```
bash run_all.sh 
```

The results will be collected in Collection.csv and stored in the path _result-detection-mild-bottleneck_

Note that the default number of simulations to detect is 100, error is 0.01, the FPR for obtaining TPR is 0.05, if you want to change any parameters, please go to _scan_dataset.sh_ and modify the parameters of interest.

Users can also specify the path to the model of each tool by using the script _run_detection_all_tools.sh_ with the command:

_bash run_detection_all_tools.sh -d dataset_name -s dataset_size -g grid_size --diploshic-model path_to_diploshic_model --faster-nn-model path_to_fasternn_model --faster-nn-g-8-model path_to_fasternng8_model_

Note that the flag -d, -s and -g are required, and other flags are optional. If the model path is not specified, it will use the pretrained models we provide.



