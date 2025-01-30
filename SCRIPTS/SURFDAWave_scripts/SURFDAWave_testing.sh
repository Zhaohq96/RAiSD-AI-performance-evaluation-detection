#!/bin/bash

SURFDAWave_calcpath=./TOOLS/SURFDAWAVE/examplefvec
SURFDAWave_testpath=./TOOLS/SURFDAWAVE/exampledata

if [ ! -d $4 ]; then
	mkdir -p $4
else
	echo 'file exists'
fi

model=$(ls $3/model.*.rds)
echo $model

rm $1.*;
rm $2.*;

echo 'calculate summary statistics of inference files'
echo "Time of calculation of neutral inference set is:" > $4/Testing_result.txt
start=$(date +"%Y-%m-%d %H:%M:%S");
python $SURFDAWave_calcpath/calcstats.py $1;
end=$(date +"%Y-%m-%d %H:%M:%S");
start_s=$(date -d "$start" +%s);
end_s=$(date -d "$end" +%s);
echo "$((end_s-start_s)) " >> $4/Testing_result.txt

echo "Time of calculation of selection inference set is:" >> $4/Testing_result.txt
start=$(date +"%Y-%m-%d %H:%M:%S");
python $SURFDAWave_calcpath/calcstats.py $2;
end=$(date +"%Y-%m-%d %H:%M:%S");
start_s=$(date -d "$start" +%s);
end_s=$(date -d "$end" +%s);
echo "$((end_s-start_s)) " >> $4/Testing_result.txt


echo test file $1
echo "Time of testing of neutral inference set is:" >> $4/Testing_result.txt
start=$(date +"%Y-%m-%d %H:%M:%S");
Rscript $SURFDAWave_testpath/predclass.R $1.stats $model 9;
end=$(date +"%Y-%m-%d %H:%M:%S");
start_s=$(date -d "$start" +%s);
end_s=$(date -d "$end" +%s);
echo "$((end_s-start_s)) " >> $4/Testing_result.txt

echo "Time of testing of selection inference set is:" >> $4/Testing_result.txt
start=$(date +"%Y-%m-%d %H:%M:%S");
Rscript $SURFDAWave_testpath/predclass.R $2.stats $model 9;
end=$(date +"%Y-%m-%d %H:%M:%S");
start_s=$(date -d "$start" +%s);
end_s=$(date -d "$end" +%s);
echo "$((end_s-start_s)) " >> $4/Testing_result.txt

if [ ! -f $1.stats ];then
	echo $1.stats does not exist
else
	echo $1.stats exsit
fi

if [ ! -f $2.stats ];then
	echo $2.stats does not exist
else
	echo $2.stats exsit
fi

echo The results of prediction of $1 is: >> $4/Testing_result.txt
echo the number of population inferenced as neutral selection: >> $4/Testing_result.txt
a=$(($(grep -c ,0, $1.stats.predclass)));
echo $a >> $4/Testing_result.txt
echo the number of population inferenced as hard selection: >> $4/Testing_result.txt
b=$(($(grep -c ,1, $1.stats.predclass)));
echo $b >> $4/Testing_result.txt
echo '' >> $4/Testing_result.txt

echo The results of prediction of $2 is: >> $4/Testing_result.txt
echo the number of population inferenced as neutral selection: >> $4/Testing_result.txt
c=$(($(grep -c ,0, $2.stats.predclass)));
echo $c >> $4/Testing_result.txt
echo the number of population inferenced as hard selection: >> $4/Testing_result.txt
d=$(($(grep -c ,1, $2.stats.predclass)));
echo $d >> $4/Testing_result.txt
echo 'inference done'
echo $a $b $c $d

cp $1.stats.predclass $4;
rm $1.stats.predclass;

cp $2.stats.predclass $4;
rm $2.stats.predclass;


