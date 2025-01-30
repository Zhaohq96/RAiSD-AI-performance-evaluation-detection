#!/bin/bash

echo split training sets
split_pointN=$(cat $1/temp/temp1.txt | wc -l);
a=$[($((split_pointN))-1)/5];
echo $a
head -1 $1/temp/temp1.txt >> $1/head1.txt;
sed -i '1d' $1/temp/temp1.txt;
split -l $a $1/temp/temp1.txt -d -a 1 $1/neut_;
cat $1/head1.txt $1/neut_0 $1/neut_1 $1/neut_2 $1/neut_3 >> $1/training/neut.fvec;
cat $1/head1.txt $1/neut_4 >> $1/testing/neut.fvec;

split_pointH=$(cat $1/temp/temp2.txt | wc -l);
b=$[($((split_pointH))-1)/5];
echo $b
head -1 $1/temp/temp2.txt >> $1/head2.txt;
sed -i '1d' $1/temp/temp2.txt;
split -l $b $1/temp/temp2.txt -d -a 1 $1/hard_;
cat $1/head2.txt $1/hard_0 $1/hard_1 $1/hard_2 $1/hard_3 >> $1/training/hard.fvec;
cat $1/head2.txt $1/hard_4 >> $1/testing/hard.fvec;

rm $1/neut_*;
rm $1/head1.txt;
rm $1/hard_*;
rm $1/head2.txt;
echo done
