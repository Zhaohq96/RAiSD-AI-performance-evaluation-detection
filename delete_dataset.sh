#!/bin/bash

show_help() {
    echo "Usage of delete_dataset.sh"
    echo
    echo "sh delete_dataset.sh dataset_name"
    echo
    echo "Quick example:"
    echo "sh delete_dataset.sh mild-bottleneck-1K"
}


if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
fi

rm -r dataset-"$1"
rm dataset-"$1".tar.gz
