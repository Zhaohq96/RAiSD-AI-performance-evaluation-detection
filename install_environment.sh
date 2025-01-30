#!/bin/bash

show_help() {
    echo "Usage of install_environment.sh"
    echo
    echo "sh install_environment.sh tool_name"
    echo
    echo "Supported tool:"
    echo "\traisd-ai"
    echo "\tdiploshic"
    echo "\tsurfdawave"
    echo "\tt-rex"
    echo "\tcnn-nguembang-fadja"
    echo
    echo "NOTE: the tool name should be in lowercase."
    echo
    echo "Quick example:"
    echo "sh install_environment.sh fast-nn"
}


if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
fi

eval "$(conda shell.bash hook)"

if [ "$1" = "diploshic" ]; then
	conda env create -f ENVIRONMENT/environment-diploSHIC.yml
	conda activate diploSHIC
	cd TOOLS/DIPLOSHIC/diploSHIC; python setup.py install; cd ../../..
	conda deactivate

elif [ "$1" = "surfdawave" ]; then
	conda env create -f ENVIRONMENT/environment-SURFDAWave.yml
	conda activate SURFDAWave
	Rscript ENVIRONMENT/environment-SURFDAWave.R
	conda deactivate
	
elif [ "$1" = "t-rex" ]; then
	conda env create -f ENVIRONMENT/environment-T-REx.yml
	conda activate T-REx
	Rscript ENVIRONMENT/environment-T-REx.R
	pip3 install pandas numpy==1.24 scipy==1.10 argparse seaborn
	pip3 install -U scikit-image
	conda deactivate
	
elif [ "$1" = "raisd-ai" ]; then
	conda env create -f ENVIRONMENT/environment-raisd-ai.yml
	conda activate raisd-ai
	pip3 install tensorflow==2.8
	conda deactivate
	
elif [ "$1" = "cnn-nguembang-fadja" ]; then
	conda env create -f ENVIRONMENT/environment-CNN-Nguembang-Fadja.yml
	conda activate CNN-Nguembang-Fadja
	pip3 install tensorflow==2.8
	conda deactivate
		
fi

