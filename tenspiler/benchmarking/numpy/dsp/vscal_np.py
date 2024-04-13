
####### import statements ########
import numpy as np

def vscal_np (arr, v, n):
    return (v) * (arr[:n])

def vscal_np_glued (arr, v, n):
    arr = np.array(arr).astype(np.int32)
    return vscal_np(arr, v, n)

####### more import statements for benchmarking ########
import time
import cv2
import os

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

####### runner. need to manually update for each file ########  
runs = 10
times = []
for _ in range(runs):
    total_time = 0
    for i in range(len(bases)):
        b = bases[i].flatten().astype(np.int32)
        n, = b.shape
        v = rng.integers(low=0, high=np.iinfo(np.int32).max + 1)

        start_time = time.perf_counter()
        vscal_np(b, v, n)

        end_time = time.perf_counter()
        total_time += (end_time - start_time) * 1000

    times.append(total_time)

times = np.array(times)   

print("vscal_np")
print(f"{np.average(times)} {np.std(times)}") 