import numpy as np
import matplotlib.pyplot as plt
import os
import sys
import argparse

a = eval(sys.argv[1])
b = eval(sys.argv[2])
c = eval(sys.argv[3])
d = eval(sys.argv[4])

path = str(sys.argv[5])
title = str(sys.argv[6])

classes = ['Neutral','Sweep']
confusion_matrix = np.array([(a,b),(c,d)], dtype=np.float64)

plt.imshow(confusion_matrix, interpolation='nearest', cmap=plt.cm.Blues, vmin=0, vmax=100)
plt.title('Dataset' +sys.argv[6], fontsize=20)
plt.colorbar()
tick_marks = np.arange(len(classes))
plt.xticks(tick_marks, classes)
plt.yticks(tick_marks, classes, rotation=90)

thresh = confusion_matrix.max() / 2
iters = np.reshape([[[i,j] for j in range(2)] for i in range(2)], (confusion_matrix.size,2))
for i,j in iters:
	plt.text(j, i, format(confusion_matrix[i,j]), ha="center", va="center", fontsize=20)

plt.savefig('{path}/diploSHIC_Dataset{title}.png'.format(path=path, title=title))	
#plt.show()

#dataset1_matrix=[(100,0),(11,89)]
#dataset23_matrix=[(58,42),(4,96)]
#dataset36_matrix=[(14,86),(0,100)]
#dataset45_matrix=[(53,47),(3,97)]
#dataset60_matrix=[(3,97),(0,100)]

