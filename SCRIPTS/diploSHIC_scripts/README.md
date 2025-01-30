#Usage of diploSHIC script sets

Before using, activate the environment first,
'conda activate diploSHIC'

Example of usage:
./diploSHIC_Full.sh /home/sweepcnn/ASDEC_EVAL/DATASETS/TRAIN/train1_N.ms /home/sweepcnn/ASDEC_EVAL/DATASETS/TRAIN/train1_H.ms /home/sweepcnn/ASDEC_EVAL/FINALRESULTS/diploSHIC/MODEL1 /home/sweepcnn/ASDEC_EVAL/DATASETS/TEST/dataset1_neutral.ms /home/sweepcnn/ASDEC_EVAL/DATASETS/TEST/dataset1_hard.ms /home/sweepcnn/ASDEC_EVAL/FINALRESULTS/diploSHIC/INFERENCE1 1

##diploSHIC_training.sh
This script needs 3 arguments, the commond line is:
'./diploSHIC_training.sh $1 $2 $3'
$1: the path to neutral training set file
$2: the path to selected (hard) training set file
$3: path to a folder where training model and training results will be stored

##diploSHIC_testing.sh
This script needs 4 arguments, the commond line is:
'./diploSHIC_testing.sh $1 $2 $3 $4'
$1: the path to neutral inference set file
$2: the path to selected (hard) inference set file
$3: path to a folder where training model is
$4: path to a folder where testing results will be stored

##diploSHIC_Full.sh
This script calls above scripts and needs 7 arguments, the commond line is:
'./diploSHIC_Full.sh $1 $2 $3 $4 $5 $6 $7'
$1: the path to neutral training set file
$2: the path to selected (hard) training set file
$3: path to a folder where training model and training results will be stored (only absolute path!!)
$4: the path to neutral inference set file
$5: the path to selected (hard) inference set file
$6: path to a folder where testing results will be stored
$7: specify the name of confusion matrix .png stored (the format is Dataset_$7)


Attention: 
1. Modify the path of tool in the script 
2. Just state the name of the folder, please do not add '/'
3. Use the absolute path if possible!! (path to file, path to folder, all!!!)
