
####### import statements ########
import tensorflow as tf

def voffset_tf(arr, v, n):
    return (v) + (arr[:n])

def voffset_tf_glued(arr, v, n):
    arr = tf.convert_to_tensor(arr, dtype=tf.int32)
    return voffset_tf(arr, v, n)

####### more import statements for benchmarking ########
import time
import cv2
import os
import numpy as np

####### setup for benchmarking ########
rng = np.random.default_rng(1)

folder = "./data/"

img_files = [os.path.join(folder, f) for f in os.listdir(folder) if os.path.isfile(os.path.join(folder, f))]

bases = []
actives = []

for _file in img_files:
    img = cv2.imread(_file, cv2.IMREAD_GRAYSCALE).astype(np.uint8)
    rnd = (rng.random(img.shape, dtype = np.float32) * 255).astype(np.uint8)
    bases.append(img)
    actives.append(rnd)

print("voffset_tf_kernel")
print(f"{np.average(times)} {np.std(times)}") 
