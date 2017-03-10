# -*- coding: utf-8 -*-
"""
===================================
Demo of DBSCAN clustering algorithm
===================================

Finds core samples of high density and expands clusters from them.

"""
print(__doc__)

import numpy as np

from sklearn.cluster import DBSCAN
from sklearn import metrics
from sklearn.datasets.samples_generator import make_blobs
from sklearn.preprocessing import StandardScaler


##############################################################################
# Generate sample data
fp="./input/chula_vista_pro_uid.csv"

f=open(fp,'r')
coordlist=f.read().split('\n')

coord=[]
for cord in coordlist:
    x_y=cord.split(',')
    xy=[]
    for i in range(len(x_y)):
        if i==1:
            xy.append(x_y[i])
        if i==4 or i==5:
            xy.append(float(x_y[i]))
    coord.append(xy)


X=np.array([coord[0][1],coord[0][2]])
for i in range(1,len(coord)):
    a=np.array([coord[i][1],coord[i][2]])
    X=np.vstack((X,a))

Q,labels_true = make_blobs(n_samples=(X.size/2),cluster_std=0.4,random_state=0)


X = StandardScaler().fit_transform(X)

##############################################################################
# Compute DBSCAN
db = DBSCAN(eps=0.3, min_samples=30).fit(X)
core_samples_mask = np.zeros_like(db.labels_, dtype=bool)
core_samples_mask[db.core_sample_indices_] = True
labels = db.labels_

# Number of clusters in labels, ignoring noise if present.
n_clusters_ = len(set(labels)) - (1 if -1 in labels else 0)

print('Estimated number of clusters: %d' % n_clusters_)
print("Homogeneity: %0.3f" % metrics.homogeneity_score(labels_true, labels))
print("Completeness: %0.3f" % metrics.completeness_score(labels_true, labels))
print("V-measure: %0.3f" % metrics.v_measure_score(labels_true, labels))
print("Adjusted Rand Index: %0.3f"
      % metrics.adjusted_rand_score(labels_true, labels))
print("Adjusted Mutual Information: %0.3f"
      % metrics.adjusted_mutual_info_score(labels_true, labels))
print("Silhouette Coefficient: %0.3f"
      % metrics.silhouette_score(X, labels))

label=list(labels)
coord_label=[]
i=0
for crd in coord:
    crdlst=''
    crdlst+=str(crd[0])
    crdlst+=','
    crdlst+=str(crd[1])
    crdlst+=','
    crdlst+=str(crd[2])
    crdlst+=','
    crdlst+=str(label[i])
    crdlst+='\n'
    coord_label.append(crdlst)
    i+=1

fp2="./output/chula_vista_pro_uid_cluster.csv"
f2=open(fp2,'w')
f2.writelines(coord_label)

##############################################################################
# Plot result
import matplotlib.pyplot as plt

# Black removed and is used for noise instead.
unique_labels = set(labels)
colors = plt.cm.Spectral(np.linspace(0, 1, len(unique_labels)))
for k, col in zip(unique_labels, colors):
    if k == -1:
        # Black used for noise.
        col = 'k'

    class_member_mask = (labels == k)

    xy = X[class_member_mask & core_samples_mask]
    plt.plot(xy[:, 0], xy[:, 1], 'o', markerfacecolor=col,
             markeredgecolor='k', markersize=14)

    xy = X[class_member_mask & ~core_samples_mask]
    plt.plot(xy[:, 0], xy[:, 1], 'o', markerfacecolor=col,
             markeredgecolor='k', markersize=6)

plt.title('Estimated number of clusters: %d' % n_clusters_)
plt.show()
