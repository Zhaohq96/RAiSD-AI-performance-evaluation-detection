import numpy as numpy
import tensorflow as tf
import tensorflow.keras
from tensorflow.keras import backend as K 
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Activation, MaxPooling2D, Conv2D, Reshape
from tensorflow.keras.layers import Dense, Flatten, Dropout
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.layers import BatchNormalization
from tensorflow.keras import regularizers 
def create_model():
    model = Sequential()
    # LAYER 1: CONVOLUTIONAL
    model.add(Conv2D(
        4, #filters
        [10, 10], #kernel size
        #[6, 2], 
        strides=(2,2),
        padding='valid',
        activation='relu',
        input_shape=(1000, 48, 1) #dim img (h,w, channel) 
    ))
    
    # LAYER 2: POOLING
    model.add(MaxPooling2D(
        pool_size=(2, 2),
        strides=2
    ))
    
    # LAYER 3: CONVOLUTIONAL
    model.add(Conv2D(
        64,
        [5, 5],
        padding='same',
        activation='relu'
    ))
  
    # LAYER 4: POOLING
    model.add(MaxPooling2D(
        pool_size=(2, 2),
        strides=2
    ))
    
    model.add(Dropout(
        0.4, #rate, to prevent overfitting
    ))
  
    model.add(Flatten())

    # LAYER 6: DENSE
    model.add(Dense(
        1024, #units
        activation='relu'
    ))
   
    #model.add(BatchNormalization())

    model.add(Dense(
        #2, #units
        1, 
        activation='sigmoid'
    ))
    
    return model
