#!/bin/bash

start=$(date +"%Y-%m-%d %H:%M:%S");
Rscript FDAclass.R ../examplefvec/t60 9;
end=$(date +"%Y-%m-%d %H:%M:%S");

start_s=$(date -d "$start" +%s);
end_s=$(date -d "$end" +%s);
echo "$((end_s-start_s))"
