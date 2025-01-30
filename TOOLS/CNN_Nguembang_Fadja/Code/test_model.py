import tensorflow as tf
import tensorflow.keras
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras import backend as K
import itertools, os, sys, random, time, math
import numpy as np
from plot_confusion_matrix import plot_confusion_matrix
from tensorflow.keras.models import load_model


from sklearn.metrics import confusion_matrix
from sklearn.metrics import accuracy_score
from sklearn.metrics import precision_score
from sklearn.metrics import recall_score
from sklearn.metrics import roc_auc_score

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

dataset='501010'
batch_size=50
model_string='501010_cats_dogs_18_04_03_02_07_2019_50_0.001.h5'
TESTDIR = '/home/arnaud/datasets/' + dataset + '/TRAIN_IMG'

test_batches = ImageDataGenerator().flow_from_directory(
    TESTDIR, 
    target_size=(1000,48),
    color_mode='grayscale', 
    class_mode='binary',
#    classes=['SELECTION', 'NEUTRAL'], 
    batch_size=int(batch_size))

model = load_model('/home/arnaud/coka_exp_01/models/' + model_string)

evaluations = model.evaluate_generator(
    test_batches, 
    steps=len(test_batches),
    workers=1, 
    use_multiprocessing=False, 
    verbose=0)

test_batches.reset() #Necessary to force it to start from beginning
predictions = model.predict_generator(
    test_batches, 
    steps=len(test_batches), 
    verbose=0)
# seleziona la classe che ha la maggior probabilità -> [0,1] selection, [1,0] neutral

test_files_n = os.listdir(TESTDIR+'/NEUTRAL')
test_files_s = os.listdir(TESTDIR+'/SELECTION')
test_set_size = len(test_files_n) + len(test_files_s)

classes = test_batches.classes[test_batches.index_array]

y_pred = [int(float(np.round(x))) for x in predictions]
#rounded_pred=np.argmax(predictions,axis=-1)
#y_pred=[]
#for i in range(0, len(rounded_pred)):
#    y_pred.append(int(rounded_pred[i]))
#y_pred=np.array(y_pred)

log1 = "/home/arnaud/coka_exp_01/test_logs/" + dataset+  "{}_{}_{}.txt".format(model_string,time.strftime("%H_%M_%S"), time.strftime("%d_%m_%Y"))

f=open(log1, "w")
for i in range (0, len(model.layers)):
    f.write("Layer " + str(i) + ": " + str(model.layers[i].get_config()) + "\n")
f.write("\n")
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

log = "/home/arnaud/coka_exp_01/test_logs/" + dataset + "_{}_{}_{}_cm.jpg".format(model_string,time.strftime("%H_%M_%S"), time.strftime("%d_%m_%Y"))
plot_confusion_matrix(classes, y_pred, classes=['NEUTRAL', 'SELECTION'], title='Confusion matrix', log=log)
