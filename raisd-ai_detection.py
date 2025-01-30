import numpy as np
import sys, time, os
import getopt
import argparse


def main(argv):

	target=0.5
	length=100000
	error=0.01
	tpr=0.05	
	
	opts, ars = getopt.getopt(argv, "n:d:t:l:e:s:g:T:", ["runID=", "directory=", "target=", "length=", "error=", "numsim=", "grid=", "tpr="])
    
	for opt, arg in opts:
		if opt in ("-n", "--runID"):
    			runID = arg
		elif opt in ("-d", "--directory"):
			input_folder = arg
		elif opt in ("-t", "--target"):
			target = arg
		elif opt in ("-l", "--length"):
			length = arg
		elif opt in ("-e", "--error"):
			error = arg
		elif opt in ("-s", "--numsim"):
			num_sim = arg
		elif opt in ("-g", "--grid"):
			grid = arg
		elif opt in ("-T", "--tpr"):
			tpr = arg
	
	pos_list_sweep=[[] for _ in range(int(num_sim))]
	prob_list_sweep=[[] for _ in range(int(num_sim))]
	prob_list_max_sweep=[]
	prob_list_max_neut=[]
	probability_list_sweep=[]
	position_list_sweep=[]
	error_list=[]
	#print()
	for i in range(int(num_sim)):
		path_sweep=os.path.join(input_folder, "RAiSD_Report." + str(runID) + "_sweep." + str(i))
		f_sweep=open(path_sweep, 'r+')
		path_neut=os.path.join(input_folder, "RAiSD_Report." + str(runID) + "_neut." + str(i))
		f_neut=open(path_neut, 'r+')
		lines_sweep=f_sweep.readlines()
		file_sweep=[line.split('\t')for line in lines_sweep]
		lines_neut=f_neut.readlines()
		file_neut=[line.split('\t')for line in lines_neut]
		#print(probs)
		pro_sweep=[]
		pro_neut=[]
		for j in range(int(grid)):
			pos_list_sweep[i].append(int(file_sweep[j+1][0]))
			prob_list_sweep[i].append(float(file_sweep[j+1][2]))
			pro_sweep.append(float(file_sweep[j+1][2]))
			pro_neut.append(float(file_neut[j+1][2]))
		#print(pos_list_sweep[i])
		#print(i)	
		prob_list_max_sweep.append(max(pro_sweep))
		prob_list_max_neut.append(max(pro_neut))
		max_sweep=max(pro_sweep)
		#print(index_sweep)
		#position_sweep=pos_list_sweep[i][index_sweep]
		position_list_sweep.append([pos_list_sweep[i][index] for index, value in enumerate(pro_sweep) if value == max_sweep])
		probability_list_sweep.append(max(pro_sweep))
		#print(position_sweep)
		#err=float((int(position_sweep)-int(float(target)*int(length)))/int(length))
		#error_list.append(err)
		f_sweep.close()
		f_neut.close()

	#print(position_list_sweep)
	ans=0
	#print(error_list)
	for i in range(int(num_sim)):
		#print(int(float(float(target)-float(error))*int(length)))
		#print(probability_list_sweep[i])
		#print(int(float(float(target)+float(error))*int(length)))
		for pos in position_list_sweep[i]:	
			#print(pos)
			if int(pos) >= int(float(float(target)-float(error))*int(length)) and int(pos) <= int(float(float(target)+float(error))*int(length)):
				ans+=1
				break
	success_rate=float(ans/int(num_sim))
#	print(ans)
	ans=0
	#print(int(float(float(target)-float(error))*int(length)))
	for i in range(int(num_sim)):
		for j in range(int(grid)):
			#print(int(pos_sim_list[i][j]))
			if int(pos_list_sweep[i][j]) >= int(float(float(target)-float(error))*int(length)) and int(pos_list_sweep[i][j]) <= int(float(float(target)+float(error))*int(length)):
				if float(prob_list_sweep[i][j]) > 0.5:
					ans+=1
					break
	#print(pos_sim_list)
	#print(prob_sim_list)
	#print(ans)
	success_rate_center=float(ans/int(num_sim))
	#print(success_rate_center)
	
	prob_list_max_neut.sort(reverse=1)
	index_tpr=int(float(tpr)*int(num_sim))
	#print(index_tpr)
	threshold=float(prob_list_max_neut[index_tpr-1])
	#print(prob_neut_max)
	#print(prob_sweep_max)
	#print(threshold)
	ans=0
	for i in range(int(num_sim)):
		if float(probability_list_sweep[i])>threshold:
			ans+=1
	TPR=float(ans/int(num_sim))
	
	ans=0
	#print(int(float(float(target)-float(error))*int(length)))
	for i in range(int(num_sim)):
		for j in range(int(grid)):
			#print(int(pos_sim_list[i][j]))
			if int(pos_list_sweep[i][j]) >= int(float(float(target)-float(error))*int(length)) and int(pos_list_sweep[i][j]) <= int(float(float(target)+float(error))*int(length)):
				if float(prob_list_sweep[i][j]) > float(threshold):
					ans+=1
					break
	success_rate_threshold=float(ans/int(num_sim))
	
	
	print("Success rate of is: {}".format(success_rate))
	print("Success rate (center) of is: {}".format(success_rate_center))
	print("Success rate (threshold) of is: {}".format(success_rate_threshold))
	print("TPR of is: {}".format(TPR))
#	with open(sweep_out_path, "w") as file:
#		file.write("Simulation\tPosition\tProbability\n")
#		for i in range(int(num_sim)):
#			file.write(f"{i+1}\t{position_list_sweep[i]}\t{probability_list_sweep[i]}")
		
if __name__ == "__main__":
    main(sys.argv[1:])	
