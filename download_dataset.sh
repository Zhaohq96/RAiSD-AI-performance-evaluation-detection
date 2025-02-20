#!/bin/bash

show_help() {
    echo "Usage of download_dataset.sh"
    echo
    echo "sh download_dataset.sh dataset_name-dataset_size"
    echo
    echo "Available datasets:"
    echo "\tmild-bottleneck"
    echo "\tsevere-bottleneck"
    echo "\trecent-migration"
    echo "\told-migration"
    echo "\tlow-intensity-recombination-hotspot"
    echo "\thigh-intensity-recombination-hotspot"
    echo
    echo "Available size of dataset (training set):"
    echo "\t1K"
    echo "\t5K"
    echo "\t10K"
    echo
    echo "The downloaded dataset will be named as dataset-dataset_name, for example, dataset-mild-bottleneck-1K."
    echo "Quick example:"
    echo "sh download_dataset.sh mild-bottleneck-1K"
}


if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
fi

eval "$(conda shell.bash hook)"

# Example dataset with 50 simulations
if [ "$1" = "example" ]; then
	wget -O dataset-"$1".tar.gz https://figshare.com/ndownloader/files/51400967
	tar -xzvf dataset-"$1".tar.gz;


# Datasets with 1K simulations
elif [ "$1" = "mild-bottleneck-1K" ]; then
	wget -O dataset-"$1".tar.gz https://figshare.com/ndownloader/files/51375548
	tar -xzvf dataset-"$1".tar.gz

elif [ "$1" = "severe-bottleneck-1K" ]; then
	wget -O dataset-"$1".tar.gz https://figshare.com/ndownloader/files/51375521
	tar -xzvf dataset-"$1".tar.gz
	
elif [ "$1" = "recent-migration-1K" ]; then
	wget -O dataset-"$1".tar.gz https://figshare.com/ndownloader/files/51375515
	tar -xzvf dataset-"$1".tar.gz
	
elif [ "$1" = "old-migration-1K" ]; then
	wget -O dataset-"$1".tar.gz https://figshare.com/ndownloader/files/51375509
	tar -xzvf dataset-"$1".tar.gz
	
elif [ "$1" = "low-intensity-recombination-hotspot-1K" ]; then
	wget -O dataset-"$1".tar.gz https://figshare.com/ndownloader/files/51375500
	tar -xzvf dataset-"$1".tar.gz
	
elif [ "$1" = "high-intensity-recombination-hotspot-1K" ]; then
	wget -O dataset-"$1".tar.gz https://figshare.com/ndownloader/files/51375416
	tar -xzvf dataset-"$1".tar.gz

elif [ "$1" = "low-intensity-recombination-hotspot-merge-2K" ]; then
        wget -O dataset-"$1".tar.gz https://figshare.com/ndownloader/files/52436963
        tar -xzvf dataset-"$1".tar.gz

elif [ "$1" = "high-intensity-recombination-hotspot-merge-2K" ]; then
        wget -O dataset-"$1".tar.gz https://figshare.com/ndownloader/files/52435505
        tar -xzvf dataset-"$1".tar.gz

elif [ "$1" = "low-intensity-recombination-hotspot-merge-1K" ]; then
        wget -O dataset-"$1".tar.gz https://figshare.com/ndownloader/files/52452488
        tar -xzvf dataset-"$1".tar.gz

elif [ "$1" = "high-intensity-recombination-hotspot-merge-1K" ]; then
        wget -O dataset-"$1".tar.gz https://figshare.com/ndownloader/files/52452272
        tar -xzvf dataset-"$1".tar.gz

# Datasets with 5K simulations
elif [ "$1" = "mild-bottleneck-5K" ]; then
	wget -O dataset-"$1".tar.gz https://figshare.com/ndownloader/files/51375575
	tar -xzvf dataset-"$1".tar.gz

elif [ "$1" = "severe-bottleneck-5K" ]; then
	wget -O dataset-"$1".tar.gz https://figshare.com/ndownloader/files/51375587
	tar -xzvf dataset-"$1".tar.gz
	
elif [ "$1" = "recent-migration-5K" ]; then
	wget -O dataset-"$1".tar.gz https://figshare.com/ndownloader/files/51375602
	tar -xzvf dataset-"$1".tar.gz
	
elif [ "$1" = "old-migration-5K" ]; then
	wget -O dataset-"$1".tar.gz https://figshare.com/ndownloader/files/51394661
	tar -xzvf dataset-"$1".tar.gz
	
elif [ "$1" = "low-intensity-recombination-hotspot-5K" ]; then
	wget -O dataset-"$1".tar.gz https://figshare.com/ndownloader/files/51375635
	tar -xzvf dataset-"$1".tar.gz
	
elif [ "$1" = "high-intensity-recombination-hotspot-5K" ]; then
	wget -O dataset-"$1".tar.gz https://figshare.com/ndownloader/files/51375629
	tar -xzvf dataset-"$1".tar.gz


# Datasets with 10K simulations
elif [ "$1" = "mild-bottleneck-10K" ]; then
	wget -O dataset-"$1".tar.gz https://figshare.com/ndownloader/files/51394664
	tar -xzvf dataset-"$1".tar.gz

elif [ "$1" = "severe-bottleneck-10K" ]; then
	wget -O dataset-"$1".tar.gz https://figshare.com/ndownloader/files/51376070
	tar -xzvf dataset-"$1".tar.gz
	
elif [ "$1" = "recent-migration-10K" ]; then
	wget -O dataset-"$1".tar.gz https://figshare.com/ndownloader/files/51376034
	tar -xzvf dataset-"$1".tar.gz
	
elif [ "$1" = "old-migration-10K" ]; then
	wget -O dataset-"$1".tar.gz https://figshare.com/ndownloader/files/51376010
	tar -xzvf dataset-"$1".tar.gz
	
elif [ "$1" = "low-intensity-recombination-hotspot-10K" ]; then
	wget -O dataset-"$1".tar.gz https://figshare.com/ndownloader/files/51375956
	tar -xzvf dataset-"$1".tar.gz
	
elif [ "$1" = "high-intensity-recombination-hotspot-10K" ]; then
	wget -O dataset-"$1".tar.gz https://figshare.com/ndownloader/files/51375797
	tar -xzvf dataset-"$1".tar.gz
		
fi

