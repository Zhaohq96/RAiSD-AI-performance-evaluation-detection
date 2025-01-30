import matplotlib
matplotlib.use("Agg")

import numpy as np
import tensorflow as tf
import tensorflow.keras
from tensorflow.keras import backend as K 
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.optimizers import Adam, SGD
from sklearn.metrics import confusion_matrix
import itertools
import os, sys, random
import time
import math
import argparse
from cnn_model import create_model
from plot_confusion_matrix import plot_confusion_matrix
#from tensorflow.keras.utils import multi_gpu_model

#matplotlib.rcParams['backend.qt5']='PySide2'
from matplotlib import pyplot as plt

from sklearn.metrics import accuracy_score
from sklearn.metrics import precision_score
from sklearn.metrics import recall_score
from sklearn.metrics import roc_auc_score

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
os.environ["CUDA_VISIBLE_DEVICES"] = "0"
#G=4

parser = argparse.ArgumentParser(description= 'Net-2')
parser.add_argument('input_folder',type=str, help= 'Input folder path')
parser.add_argument('output_folder',type=str, help= 'Output folder path')
parser.add_argument('epoch',type=int, help= 'Number of epochs')

args = parser.parse_args()
input_folder = args.input_folder
output_folder = args.output_folder
epoch = args.epoch

start_time = time.time()

NAME = "8-layers"

# some hyper-parameters
lr = 0.001
loss= 'binary_crossentropy'
metrics = 'accuracy'
epochs = epoch
#dataset='dataset1'
batch_size=50


TRAINDIR = input_folder + 'images/train'
VALIDDIR = input_folder + 'images/valid'
TESTDIR = input_folder + 'images/test'


train_batches = ImageDataGenerator().flow_from_directory(
    TRAINDIR, 
    target_size=(1000,48),
    color_mode='grayscale', 
   #classes=['SELECTION', 'NEUTRAL'],
    class_mode='binary', 
    batch_size=int(batch_size))
valid_batches = ImageDataGenerator().flow_from_directory(
    VALIDDIR, 
    target_size=(1000,48),
    color_mode='grayscale',
    class_mode='binary',
#    classes=['SELECTION', 'NEUTRAL'], 
    batch_size=int(batch_size))
test_batches = ImageDataGenerator().flow_from_directory(
    TESTDIR, 
    target_size=(1000,48),
    color_mode='grayscale', 
    class_mode='binary',
#    classes=['SELECTION', 'NEUTRAL'], 
    batch_size=int(batch_size))
    
   
K.clear_session()
# we'll store a copy of the model on *every* GPU and then combine
# the results from the gradient updates on the CPU
#with tf.device("/cpu:0"):
model = create_model()
#model.summary()

#model = multi_gpu_model(model, gpus=G)
model.compile(SGD(lr=0.001, momentum=0.9), loss=loss, metrics=['accuracy'])
#model.compile(Adam(lr=lr), loss=loss, metrics=[metrics])

#namefile = sys.argv[0]
#namelog = namefile + dataset
#csv_logger = CSVLogger('/home/arnaud/coka_exp_01/logs/' + namelog+'_{}'.format(int(time.time())))

epoch_steps = len(train_batches)
valid_steps = len(valid_batches)



history = model.fit(
    train_batches, 
    steps_per_epoch=epoch_steps, 
    validation_data=valid_batches,
    validation_steps=valid_steps, 
    epochs=epochs,
    verbose=0,
   # workers=4,
   # use_multiprocessing=True
    #callbacks=[TQDMCallback()]
    #callbacks=[tbCallback1, csv_logger]
    #callbacks=[tbCallback, csv_logger]
    #callbacks=callback
    #callbacks=[csv_logger]
    )

elapsed_time = time.time() - start_time

start_time = time.time()    
evaluations = model.evaluate(
    test_batches, 
   steps=len(test_batches),
    workers=1, 
    use_multiprocessing=False, 
    verbose=0)

test_batches.reset() #Necessary to force it to start from beginning
predictions = model.predict(
    test_batches, 
    steps=len(test_batches), 
    verbose=0)
# seleziona la classe che ha la maggior probabilità -> [0,1] selection, [1,0] neutral

test_files_n = os.listdir(TESTDIR+'/neutral')
test_files_s = os.listdir(TESTDIR+'/selection')
test_set_size = len(test_files_n) + len(test_files_s)

classes = test_batches.classes[test_batches.index_array]

#rounded_pred=np.argmax(predictions,axis=-1)
#y_pred=[]
#for i in range(0, len(rounded_pred)):
#    y_pred.append(int(rounded_pred[i]))
#y_pred=np.array(y_pred)

y_pred = [int(float(np.round(x))) for x in predictions]

test_time = time.time() - start_time

log1 = output_folder + "log/{}_{}_{}_{}_{}.txt".format(create_model.__name__,time.strftime("%H_%M_%S"), time.strftime("%d_%m_%Y"), str(batch_size),str(lr),str(epochs))
log = output_folder + "model/{}_{}_{}_{}_{}.h5".format(create_model.__name__,time.strftime("%H_%M_%S"), time.strftime("%d_%m_%Y"), str(batch_size),str(lr),str(epochs))
model.save(log)

f=open(log1, "w")
for i in range (0, len(model.layers)):
	f.write("Layer " + str(i) + ": " + str(model.layers[i].get_config()) + "\n")
f.write("\n")
f.write("Batch size: " + str(batch_size) + ", lr: " + str(lr) + ", loss: " + loss + ", metrics: " + metrics + ", epochs: "+ str(epochs) +"\n\n")
f.write(time.strftime("%H:%M:%S") + " " + time.strftime("%d/%m/%Y") + "\n\n")
f.write("Model accuracy " + str(history.history['accuracy'])+ "\n")
f.write("Validation accuracy " + str(history.history['val_accuracy'])+ "\n")
f.write("Model loss " + str(history.history['loss'])+ "\n")
f.write("Validation loss " + str(history.history['val_loss'])+ "\n\n")
f.write("Training time: " + str(elapsed_time))
f.write("\nTesting time: " + str(test_time))
f.write('\n\nTest loss: ' + str(evaluations[0]) + ', test acc: ' + str(evaluations[1]))
f.write('\n' + str(sum(y_pred==classes)/test_set_size))
f.write('\n\n')
f.write(str(confusion_matrix(classes,y_pred)))
accuracy = accuracy_score(classes, y_pred)
f.write('\nAccuracy: '+ str( accuracy))
# precision tp / (tp + fp)
precision = precision_score(classes, y_pred)
f.write('\nPrecision: '+str(precision))
# recall: tp / (tp + fn)
recall = recall_score(classes, y_pred)
f.write('\nRecall: '+ str(recall))
f.close()
'''
log2 = "/home/arnaud/coka_exp_01/imgs/" + dataset + "_{}_{}_{}_{}_{}_acc.jpg".format(create_model.__name__,time.strftime("%H_%M_%S"), time.strftime("%d_%m_%Y"), str(batch_size),str(lr),str(epochs))
# summarize history for accuracy
plt.plot(history.history['acc'])
plt.plot(history.history['val_acc'])
plt.title('Model accuracy')
plt.ylabel('accuracy')
plt.xlabel('epoch')
plt.legend(['train', 'validation'], loc='upper left')
plt.savefig(log2)
plt.close()

log3 = "/home/arnaud/coka_exp_01/imgs/" + dataset + "_{}_{}_{}_{}_{}_loss.jpg".format(create_model.__name__,time.strftime("%H_%M_%S"), time.strftime("%d_%m_%Y"), str(batch_size),str(lr),str(epochs))
#summarize history for loss
plt.plot(history.history['loss'])
plt.plot(history.history['val_loss'])
plt.title('Model loss')
plt.ylabel('loss')
plt.xlabel('epoch')
plt.legend(['train', 'validation'], loc='upper left')
plt.savefig(log3)
plt.close()

# PLOT CONFUSION MATRIX
log5 = "/home/arnaud/coka_exp_01/imgs/" + dataset + "_{}_{}_{}_{}_{}_cm.jpg".format(create_model.__name__,time.strftime("%H_%M_%S"), time.strftime("%d_%m_%Y"), str(batch_size),str(lr),str(epochs))
np.set_printoptions(precision=2)

# Plot non-normalized confusion matrix
plot_confusion_matrix(classes, y_pred, classes=['NEUTRAL', 'SELECTION'], title='Confusion matrix', log=log5)
'''
