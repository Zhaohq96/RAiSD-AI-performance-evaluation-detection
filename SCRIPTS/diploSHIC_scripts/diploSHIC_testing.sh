#!/bin/bash

diploSHIC_path=./TOOLS/DIPLOSHIC/diploSHIC

if [ ! -d $4 ]; then
	mkdir -p $4
else
	echo 'file exists'
fi

rm $1.*;
rm $2.*;

echo 'calculate summary statistics of inference files'

echo 'Time of calculating summary statistics of neutral inference set is:' > $4/Testing_result.txt
python $diploSHIC_path/mytrain.py fvecSim diploid $1 $1.fvec >> $4/Testing_result.txt

echo 'Time of calculating summary statistics of selection inference set is:' >> $4/Testing_result.txt
python $diploSHIC_path/mytrain.py fvecSim diploid $2 $2.fvec >> $4/Testing_result.txt

echo 'calculation finished'

echo 'start predict'

echo 'Time of testing of neutral inference set is:' >> $4/Testing_result.txt
start=$(date +"%Y-%m-%d %H:%M:%S");
python $diploSHIC_path/mytrain.py predict --simData $3/model.json $3/model.weights.hdf5 $1.fvec $4/neutral.out;
end=$(date +"%Y-%m-%d %H:%M:%S");
start_s=$(date -d "$start" +%s);
end_s=$(date -d "$end" +%s);
echo "$((end_s-start_s)) " >> $4/Testing_result.txt

echo 'Time of testing of selection inference set is:' >> $4/Testing_result.txt
start=$(date +"%Y-%m-%d %H:%M:%S");
python $diploSHIC_path/mytrain.py predict --simData $3/model.json $3/model.weights.hdf5 $2.fvec $4/hard.out;
end=$(date +"%Y-%m-%d %H:%M:%S");
start_s=$(date -d "$start" +%s);
end_s=$(date -d "$end" +%s);
echo "$((end_s-start_s)) " >> $4/Testing_result.txt

echo The results of prediction of $1 is: >> $4/Testing_result.txt
echo the number of population inferenced as neutral selection: >> $4/Testing_result.txt
a=$(($(($(grep -c neutral $4/neutral.out)))-1));
echo $a >> $4/Testing_result.txt
echo the number of population inferenced as hard selection: >> $4/Testing_result.txt
b=$(($(($(grep -c hard $4/neutral.out)))-1));
echo $b >> $4/Testing_result.txt
echo '' >> $4/Testing_result.txt

echo The results of prediction of $2 is: >> $4/Testing_result.txt
echo the number of population inferenced as neutral selection: >> $4/Testing_result.txt
c=$(($(($(grep -c neutral $4/hard.out)))-1));
echo $c >> $4/Testing_result.txt
echo the number of population inferenced as hard selection: >> $4/Testing_result.txt
d=$(($(($(grep -c hard $4/hard.out)))-1));
echo $d >> $4/Testing_result.txt

echo 'inference done'
echo $a $b $c $d

