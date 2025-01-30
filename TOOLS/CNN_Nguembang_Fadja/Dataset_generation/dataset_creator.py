# Dataset creation with scripts ms2raster.py, foldertree.py
# TODO


# Dataset organization:
# - DATASET 
#     - TEST
#         - SELECTION
#         - NEUTRAL
#     - TRAIN
#         - SELECTION
#         - NEUTRAL
#     - VALID
#         - SELECTION
#         - NEUTRAL

import os
import random
import datetime
from tqdm import tqdm
from pathlib import Path

import foldertree
import matrix_to_image_fn

create_tree = foldertree.create_tree
clean_tree = foldertree.clean_tree 

converter_fn = matrix_to_image_fn.converter_fn

def ms(bp, s, l, Ne=1000, mu=0.0008, ro=0.0008, selestr=0.005, path='', i=24):
    command = 'cd ' + path + ' ; python3 ms2raster.py -Ne ' + str(Ne) + ' -bp' + str(bp) + ' -s '+ str(s) + ' -mu ' + str(mu) + ' -ro ' + str(ro) + ' -l ' + l.lower() + ' -selstr ' + str(selestr) + ' -p ' + path + '/ -i ' + str(i)
    print('command: ' + command)
    os.system(command)

# def ms(bp, mode, number,selestr=0.005, path='', i=24):
#     command = 'cd ' + path + '; python3 ms2raster.py -bp ' + str(bp) + ' -s ' + str(int(number)) + ' -l '+ mode.lower() + ' -selstr ' + selstr + ' -p ' + path + ' -i '+str(i)
#     print('run command: ' + command)
#     os.system(command)

os.system('clear')

# get current path
path = os.getcwd() + '/'
print('Current path: ' + path)

print('\nGeneric command:\npython3 ms2raster.py -bp 1000 -s 2 -l selection -selstr 0.005 -p ' + path + ' -i 24\n')
print('Parameters:\n')
print('-bp:\t\tmatrix length')
print('-s:\t\tnumber of matrices to generate')
print('-l:\t\tmode: N for neutral, S for selection and B for both')
print("-selestr:\tselection intensity can be controlled with -selstr (when -l is neutral, it is not considered)")
print('-p:\t\tpath of the folder containing the necessary modules')
print('-i:\t\tnumber of individuals considered')

# total number of matrices
# n_mat = input('Enter single matrix sizes (-bp): ')
# bp=int(n_mat)
# # numero matrici training
# n_train = int(input('Enter number of matrices for the training set (-s): '))
# # numero matrici valutazione
# n_valid = int(input('Enter number of matrices for the evaluating set (-s): '))
# # numero matrici test
# n_test = int(input('Enter number of matrices for testing set (-s): '))
# mode = input('Enter the mode: S for selection and B for both and N for neutral: ')
# if mode=='S' or mode=='B':
#     selstr = input('Enter a value for selstr (-selstr): ')
#     modes = ["NEUTRAL","SELECTION"]
# else:
#     modes = ["NEUTRAL"]
#i = int(input('Enter number of individual (-s): '))
# I create directories with ms2raster content inside


datasets = ["TRAIN", "TEST"]
 
create_tree(path=path)

# os.system('clear')

now=datetime.datetime.now()

# LOG file for each command used
log = open(path + 'DATASET/log.txt', 'w')
log = open(path + 'DATASET/log.txt', 'a')
log.write(str(now) + '\n')
log.write('Characteristics of the dataset:\n\n')
log.write('- ' + str(int(n_train)) + ' training matrices\n')
log.write('- ' + str(int(n_test)) + ' test matrices\n')
log.write('- ' + str(int(n_valid)) + ' validation matrices\n')
log.write('-  each matrice has a bp of ' + n_mat + '\n')
log.write("- the intensity of the selection is " + selstr + '\n')
log.write('- the number of individuals taken into consideration is 24\n\n')

####################################################################################################################################### 
# MS2RASTER
for dataset in datasets:
    for l in modes: 
        pathNew= path + 'DATASET/'+dataset+'/'+mode+'/'
        if dataset== "TRAIN":
            s = n_train
        else:
            if dataset== "VALID":
                s = n_valid
            else:
                s = n_test
        ms(bp,s,l,selestr=selstr,path=pathNew, i=i)  

   

####################################################################################################################################### 
# MATRIX_TO_IMAGE_FN
Convert = input('\n Do you want to transform matrices into images? [Y]/[N]: ')
if  Convert== 'Y': 
    os.mkdir(path + 'DATASET/TRAIN_IMG')
    os.mkdir(path + 'DATASET/TEST_IMG')
    os.mkdir(path + 'DATASET/VALID_IMG')

    for dataset in datasets:
        for mode in modes:
            print('\nI am transforming the', dataset, 'dataset for ',mode,' type into images...')
            os.mkdir(path + 'DATASET/'+dataset+'_IMG/'+mode)
            #os.mkdir(path + 'DATASET/'+dataset+'_IMG/'+mode)
            #os.mkdir(path + 'DATASET/'+dataset+'_IMG/'+mode)
            #if dataset =="TRAIN":
            print('Train of ' + str(n_train))
            for i in tqdm(range(1, int(n_train)+1)):
                # NEUTRAL - TRAIN
                path_tmp_ntrain = path + 'DATASET/'+dataset+'/'+mode+'/' + str(i) + '.'+mode.lower()+'.sim'
                file_ntrain = Path(path_tmp_ntrain)
                
                if file_ntrain.is_file():
                    converter_fn(
                                path = path + 'DATASET/'+dataset+'/'+mode+'/' + str(i) + '.'+mode.lower()+'.sim',
                                file_name = path + 'DATASET/'+dataset+'_IMG/'+mode+'/' + str(i) + '.'+mode.lower()+'.png',
                                )
     
else:
    print('I clean the tree with path='+path)
    clean_tree(path=path)

log.close() #I close the log file

if input(' Do you want to compress the newly created dataset?[Y]/[N]: ') == 'Y':
    print(path)
    nome_archivio = input('Enter a name for the compressed file: ')
    os.system('tar zcvf ' + nome_archivio + '.tar.gz DATASET')
else:
    print('\nDataset creation finished. Bye')

