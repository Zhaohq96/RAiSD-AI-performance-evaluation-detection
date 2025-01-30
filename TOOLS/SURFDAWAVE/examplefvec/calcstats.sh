#!/bin/bash


echo "Begin calculating"
python calcstats.py train1_N.ms;
python calcstats.py train1_H.ms;
python calcstats.py train36_N.ms;
python calcstats.py train36_H.ms;
echo "Finish calculating"

