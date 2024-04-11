
####### import statements ########
import torch

def matscal_torch (mat, val, m, n):
    return (val) * (mat[:m][:, 0:n])

def matscal_torch_glued (mat, val, m, n):
    mat = torch.tensor(mat, dtype=torch.int32)
    return matscal_torch(mat, val, m, n)

####### more import statements for benchmarking ########
import time
import cv2
import os
import numpy as np

####### setup for benchmarking ########
rng = np.random.default_rng(1)
device = 'cuda' if torch.cuda.is_available() else 'cpu'
cpu = 'cpu'

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

        b = bases[i].astype(np.int32)
        s = rng.integers(low=0, high=np.iinfo(np.int32).max + 1).astype(np.int32)

        b = torch.from_numpy(b).to(dtype=torch.int32).to(cpu)
        

        m, n = b.shape
        

        b = b.to(device)
        
        start_time = time.perf_counter()
        res = matscal_torch(b, s, m, n)
        end_time = time.perf_counter()
        res = res.to(cpu)

        total_time += (end_time - start_time) * 1000

    times.append(total_time)

times = np.array(times)   

print("matscal_torch_kernel")
print(f"{np.average(times)} {np.std(times)}") 
