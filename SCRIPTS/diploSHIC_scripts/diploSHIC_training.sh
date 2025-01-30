#!/bin/bash

diploSHIC_path=./TOOLS/DIPLOSHIC/diploSHIC

rm -r $3
mkdir -p $3
#if [ ! -d $3 ]; then
#	mkdir -p $3
#else
#	rm -r $3
#fi
mkdir -p $3/temp;
mkdir -p $3/training;
mkdir -p $3/testing;

echo Neutral training set is: $1 > $3/Training_result.txt
echo Selection training set is: $2 >> $3/Training_result.txt

echo 'calculate the summary statistics of training sets'

echo 'Time of calculating summary statistics of neutral training set is:' >> $3/Training_result.txt
python $diploSHIC_path/mytrain.py fvecSim diploid $1 $3/temp/temp1.txt >> $3/Training_result.txt

echo 'Time of calculating summary statistics of selection training set is:' >> $3/Training_result.txt
python $diploSHIC_path/mytrain.py fvecSim diploid $2 $3/temp/temp2.txt >> $3/Training_result.txt

echo 'calculation finished'

./SCRIPTS/diploSHIC_scripts/diploSHIC_spliting.sh $3;

echo 'train the modele'
echo Time of training is : >> $3/Training_result.txt
python $diploSHIC_path/mytrain.py train $3/training/ $3/testing/ $3/model --epochs $4 >> $3/Training_result.txt;

cp model.* $3;
rm model.*;
rm -r $3/temp/;


echo 'the training is finished'
