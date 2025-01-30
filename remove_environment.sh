#!/bin/bash

show_help() {
    echo "Usage of remove_environment.sh"
    echo
    echo "sh remove_environment.sh tool_name"
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
    echo "sh remove_environment.sh fast-nn"
}


if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
fi

eval "$(conda shell.bash hook)"

if [ "$1" = "diploshic" ]; then
	conda env remove --name diploSHIC

elif [ "$1" = "surfdawave" ]; then
	conda env remove --name SURFDAWave
	
elif [ "$1" = "t-rex" ]; then
	conda env remove --name T-REx
	
elif [ "$1" = "raisd-ai" ]; then
	conda env remove --name raisd-ai
	
elif [ "$1" = "cnn-nguembang-fadja" ]; then
	conda env remove --name CNN-Nguembang-Fadja
		
fi

