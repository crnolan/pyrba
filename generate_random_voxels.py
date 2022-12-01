import numpy as np
import pandas as pd

#create voxel noise parameters
noise_list = []
for i in range(0,1000): #hardcoded
    mean =  np.random.normal(0, .08) #voxel noise paramerer - normal distribution
    sd =  abs(np.random.normal(0, .05)) #voxel noise paramerer - uniform distribution or absolute normal distribution
    noise_list.append([mean, sd])

#define function to generate random voxel values
def generate_random_voxels(mean, sd, noise_list, length=1000): #hardcoded
    voxels = []
    for v in range(length):
        mean = mean + noise_list[v][0]
        sd = sd + noise_list[v][1]
        voxels.append(np.random.normal(mean,sd)) #mean 0, std 1
    return voxels

participants = []
conditions = []

#create multi level index matrix
for i in range(30):
    participants.append(i)
    participants.append(i)
    conditions.append(0)
    conditions.append(1)
arrays = [participants, conditions]
tuples = list(zip(*arrays))
multi_index = pd.MultiIndex.from_tuples(tuples, names=["participant", "condition"])

#initiate voxel list
data = np.zeros((60,1000)) #hardcoded
df = pd.DataFrame(data, index = multi_index)

#populate the multi level index matrix
for participant in range(30):
    # unique number for each paritipcant
    random_effect_mean = np.random.normal(0, .1)
    random_effect_sd = abs(np.random.normal(0, .05))
    
    for condition in range(2):
        if condition == 0:
            mean = .5 + random_effect_mean
            sd = .1 + random_effect_sd
            df.loc[participant, condition] = generate_random_voxels(mean,sd,noise_list)
            
        if condition == 1:
            mean = .3 + random_effect_mean
            sd = .1 + random_effect_sd
            df.loc[participant, condition] = generate_random_voxels(mean,sd,noise_list)


#melt to satisfy bambi long form
df = pd.melt(df, ignore_index=False, var_name="voxel_id", value_name = "BOLD")

#write to csv
df.to_csv(r'df2.txt', sep=' ', mode='a')





