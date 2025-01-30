#!/bin/bash

SURFDAWave_calcpath=./TOOLS/SURFDAWAVE/examplefvec
SURFDAWave_trainpath=./TOOLS/SURFDAWAVE/exampledata

rm -r $3
mkdir -p $3
#if [ ! -d $3 ]; then
#	mkdir -p $3
#else
#	rm -r $3
#fi

rm $3/Training_result.txt;

echo Neutral training set is: $1 >> $3/Training_result.txt
echo Selection training set is: $2 >> $3/Training_result.txt

echo 'calculate the summary statistics of training sets'

echo 'Time of calculating summary statistics of neutral training set is:' >> $3/Training_result.txt
python $SURFDAWave_calcpath/calcstats.py $1 >> $3/Training_result.txt;
sed -i 's/$/0/' $1.stats;

echo 'Time of calculating summary statistics of selection training set is:' >> $3/Training_result.txt
python $SURFDAWave_calcpath/calcstats.py $2 >> $3/Training_result.txt;
sed -i 's/$/1/' $2.stats;

cat $1.stats $2.stats >> $3/model;
rm $1.stats;
rm $2.stats;
echo 'calculation finished'

echo 'train the model'
start=$(date +"%Y-%m-%d %H:%M:%S");
Rscript $SURFDAWave_trainpath/FDAclass.R $3/model 9;
end=$(date +"%Y-%m-%d %H:%M:%S");

start_s=$(date -d "$start" +%s);
end_s=$(date -d "$end" +%s);
echo Time of training is: $((end_s-start_s)) s >> $3/Training_result.txt
echo 'the training is finished'
