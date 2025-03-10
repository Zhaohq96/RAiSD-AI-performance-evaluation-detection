import os
import numpy as np
import random
import math
from skimage import data
from skimage.transform import resize
import argparse
import pandas as pd
from scipy import stats


parser = argparse.ArgumentParser(description= 'Preprocess .ms files')
parser.add_argument('number', type=int, help= 'Number of .ms files of the chosen class')
parser.add_argument('input_folder',type=str, help= 'Input folder path')
args = parser.parse_args()
num_ = args.number
input_folder = args.input_folder


def addIndividuals(np_array):

    indexes = range(np_array.shape[0])
    list_array_added = []

    for j in indexes:
        if ((j % 2) != 0):
            array_temp = np_array[j,:] + np_array[j-1,:]
            list_array_added.append(array_temp)

    

    np_array_added = np.array(list_array_added)

    return np_array_added



def saveToCSV(i):
    filename_ms = os.path.join(input_folder, f"test_{i+1}.ms")
    filename_csv = os.path.join(input_folder, f"output_{i+1}.csv")

    file = open(filename_ms, 'r')
    Lines = file.readlines()
    count = 0
    genetic = False

    list_info = []

    # Strips the newline character
    for line in Lines:
        if ('positions:' in line):
            genetic = True

        elif ('//' in line):
            genetic = False

        elif (genetic == True):
            info = list(line[:-1])
            if (info != []):
                info_np = np.array(info, dtype=int)
                list_info.append(info_np)

    np_array = np.array(list_info)
    np.savetxt(filename_csv, np_array, delimiter=",")


def main():
    


    for i in range(10000000):
        print('Saving CSV Iteration: ', i)
        saveToCSV(i)


if __name__ == "__main__":
    main()

