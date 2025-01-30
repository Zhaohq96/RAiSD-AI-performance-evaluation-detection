# Script for creating the dataset folders
import os

# S = selection
# N = neutral
# B = both
# path = path corrente

def create_tree(path):
    if os.access(path + 'DATASET', os.F_OK) == True:
        os.system('rm -r ' + path + 'DATASET')
        os.mkdir(path + 'DATASET')
        os.mkdir(path + 'DATASET/TRAIN/')
        os.mkdir(path + 'DATASET/VALID/')
        os.mkdir(path + 'DATASET/TEST/')
        print("DATASET Overwritten\n")
    else:
        os.mkdir(path + 'DATASET') # makedirectory
        os.mkdir(path + 'DATASET/TRAIN/')
        os.mkdir(path + 'DATASET/VALID/')
        os.mkdir(path + 'DATASET/TEST/')
        print('DATASET created \n')
    

    print('NEUTRAL folder created \n')
    os.mkdir(path + 'DATASET/TRAIN/NEUTRAL/')
    os.mkdir(path + 'DATASET/VALID/NEUTRAL/')
    os.mkdir(path + 'DATASET/TEST/NEUTRAL/')
    # copy of the files present in mas2raster
    os.system('cp -a ' + path + '/ms2raster/. ' + 'DATASET/TRAIN/NEUTRAL')
    os.system('cp -a ' + path + '/ms2raster/. ' + 'DATASET/VALID/NEUTRAL')
    os.system('cp -a ' + path + '/ms2raster/. ' + 'DATASET/TEST/NEUTRAL')

    print('SELECTION folder created\n')
    os.mkdir(path + 'DATASET/TRAIN/SELECTION/')
    os.mkdir(path + 'DATASET/VALID/SELECTION/')
    os.mkdir(path + 'DATASET/TEST/SELECTION/')
    # copy of the files present in mas2raster
    os.system('cp -a ' + path + '/ms2raster/. ' + 'DATASET/TRAIN/SELECTION')
    os.system('cp -a ' + path + '/ms2raster/. ' + 'DATASET/VALID/SELECTION')
    os.system('cp -a ' + path + '/ms2raster/. ' + 'DATASET/TEST/SELECTION')



# Once the folders are created i remove the ms2raster files
def clean_tree(path):
    
    path_tmp = path + 'DATASET/TRAIN/NEUTRAL'
    os.system('cd ' + path_tmp + ' ; rm ms')
    os.system('cd ' + path_tmp + ' ; rm lastp0')
    os.system('cd ' + path_tmp + ' ; rm ms2raster.py')
    os.system('cd ' + path_tmp + ' ; rm mssel')
    os.system('cd ' + path_tmp + ' ; rm seedms')
    os.system('cd ' + path_tmp + ' ; rm stepftn')
    os.system('cd ' + path_tmp + ' ; rm tp.out')
    os.system('cd ' + path_tmp + ' ; rm trajfixconst')

    path_tmp = path + 'DATASET/VALID/NEUTRAL'
    os.system('cd ' + path_tmp + ' ; rm ms')
    os.system('cd ' + path_tmp + ' ; rm lastp0')
    os.system('cd ' + path_tmp + ' ; rm ms2raster.py')
    os.system('cd ' + path_tmp + ' ; rm mssel')
    os.system('cd ' + path_tmp + ' ; rm seedms')
    os.system('cd ' + path_tmp + ' ; rm stepftn')
    os.system('cd ' + path_tmp + ' ; rm tp.out')
    os.system('cd ' + path_tmp + ' ; rm trajfixconst')

    path_tmp = path + 'DATASET/TEST/NEUTRAL'
    os.system('cd ' + path_tmp + ' ; rm ms')
    os.system('cd ' + path_tmp + ' ; rm lastp0')
    os.system('cd ' + path_tmp + ' ; rm ms2raster.py')
    os.system('cd ' + path_tmp + ' ; rm mssel')
    os.system('cd ' + path_tmp + ' ; rm seedms')
    os.system('cd ' + path_tmp + ' ; rm stepftn')
    os.system('cd ' + path_tmp + ' ; rm tp.out')
    os.system('cd ' + path_tmp + ' ; rm trajfixconst')
###########################################################################
    path_tmp = path + 'DATASET/TRAIN/SELECTION'
    os.system('cd ' + path_tmp + ' ; rm ms')
    os.system('cd ' + path_tmp + ' ; rm lastp0')
    os.system('cd ' + path_tmp + ' ; rm ms2raster.py')
    os.system('cd ' + path_tmp + ' ; rm mssel')
    os.system('cd ' + path_tmp + ' ; rm seedms')
    os.system('cd ' + path_tmp + ' ; rm stepftn')
    os.system('cd ' + path_tmp + ' ; rm tp.out')
    os.system('cd ' + path_tmp + ' ; rm trajfixconst')
    path_tmp = path + 'DATASET/VALID/SELECTION'
    os.system('cd ' + path_tmp + ' ; rm ms')
    os.system('cd ' + path_tmp + ' ; rm lastp0')
    os.system('cd ' + path_tmp + ' ; rm ms2raster.py')
    os.system('cd ' + path_tmp + ' ; rm mssel')
    os.system('cd ' + path_tmp + ' ; rm seedms')
    os.system('cd ' + path_tmp + ' ; rm stepftn')
    os.system('cd ' + path_tmp + ' ; rm tp.out')
    os.system('cd ' + path_tmp + ' ; rm trajfixconst')

    path_tmp = path + 'DATASET/TEST/SELECTION'
    os.system('cd ' + path_tmp + ' ; rm ms')
    os.system('cd ' + path_tmp + ' ; rm lastp0')
    os.system('cd ' + path_tmp + ' ; rm ms2raster.py')
    os.system('cd ' + path_tmp + ' ; rm mssel')
    os.system('cd ' + path_tmp + ' ; rm seedms')
    os.system('cd ' + path_tmp + ' ; rm stepftn')
    os.system('cd ' + path_tmp + ' ; rm tp.out')
    os.system('cd ' + path_tmp + ' ; rm trajfixconst')
    