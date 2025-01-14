import numpy as np
import sys, time, os
import getopt
import argparse


def main(argv):

	target=0.5
	length=100000
	error=0.01
	tpr=0.05	
	
	opts, ars = getopt.getopt(argv, "i:I:d:t:l:e:s:g:o:T:", ["neutinputpos=", "sweepinputpos=", "directory=", "target=", "length=", "error=", "numsim=", "grid=", "output=", "tpr="])
    
	for opt, arg in opts:
		if opt in ("-i", "--neutinputpos"):
			neut_file_pos = arg
		elif opt in ("-I", "--sweepinputpos"):
    			sweep_file_pos = arg
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
		elif opt in ("-o", "--output"):
			output = arg
		elif opt in ("-T", "--tpr"):
			tpr = arg
	
	f_pos_sweep=open(sweep_file_pos, 'r+')
	sweep_out_path=os.path.join(output, "Pos_probs_sweep.txt")
	
	f_pos_neut=open(neut_file_pos, 'r+')
	neut_out_path=os.path.join(output, "Pos_probs_neut.txt")
	#print(file_pos)
	lines_sweep=f_pos_sweep.readlines()
	positions_sweep = [line.split(' ')for line in lines_sweep]
	lines_neut=f_pos_neut.readlines()
	positions_neut = [line.split(' ')for line in lines_neut]
	error_list=[]
	#print(positions)
	position_list_sweep=[]
	probability_list_sweep=[]
	position_list_neut=[]
	probability_list_neut=[]
	prob_sweep_max=[]
	prob_neut_max=[]
	pos_sim_list=[[] for _ in range(int(num_sim))]
	prob_sim_list=[[] for _ in range(int(num_sim))]
	#print()
	for i in range(int(num_sim)):
		pos_list_sweep=[]
		probs_list_sweep=[]
		pos_list_neut=[]
		probs_list_neut=[]
		pro_path_sweep=os.path.join(input_folder, "sweep" + str(i) + ".out")
		f_pro_sweep=open(pro_path_sweep, 'r+')
		pro_path_neut=os.path.join(input_folder, "neut" + str(i) + ".out")
		f_pro_neut=open(pro_path_neut, 'r+')
		lines_pro_sweep=f_pro_sweep.readlines()
		probs_sweep=[line.split('\t')for line in lines_pro_sweep]
		lines_pro_neut=f_pro_neut.readlines()
		probs_neut=[line.split('\t')for line in lines_pro_neut]
		#print(probs)
		for j in range(int(grid)):
			pos_sim_list[i].append(positions_sweep[i][j])
			prob_sim_list[i].append(float(probs_sweep[j+1][5]))
			pos_list_sweep.append(positions_sweep[i][j])
			probs_list_sweep.append(float(probs_sweep[j+1][5]))
			pos_list_neut.append(positions_neut[i][j])
			probs_list_neut.append(float(probs_neut[j+1][5]))
		prob_sweep_max.append(max(probs_list_sweep))
		index_sweep=probs_list_sweep.index(max(probs_list_sweep))
		prob_neut_max.append(max(probs_list_neut))
		index_neut=probs_list_neut.index(max(probs_list_neut))
		position_sweep=pos_list_sweep[index_sweep]
		position_list_sweep.append(position_sweep)
		probability_list_sweep.append(max(probs_list_sweep))
		#print(position)
		err=float((int(position_sweep)-int(float(target)*int(length)))/int(length))
		error_list.append(err)
		f_pro_sweep.close()
		f_pro_neut.close()
	f_pos_sweep.close()
	f_pos_neut.close()
	ans=0
	#print(error_list)
	for i in range(int(num_sim)):
		if abs(error_list[i]) <= float(error):
			ans+=1
	success_rate=float(ans/int(num_sim))
	
	ans=0
	#print(int(float(float(target)-float(error))*int(length)))
	for i in range(int(num_sim)):
		for j in range(int(grid)):
			#print(int(pos_sim_list[i][j]))
			if int(pos_sim_list[i][j]) >= int(float(float(target)-float(error))*int(length)) and int(pos_sim_list[i][j]) <= int(float(float(target)+float(error))*int(length)):
				if float(prob_sim_list[i][j]) > 0.5:
					ans+=1
					break
	#print(pos_sim_list)
	#print(prob_sim_list)
	#print(ans)
	success_rate_center=float(ans/int(num_sim))
	#print(success_rate_center)
	
	prob_neut_max.sort(reverse=1)
	index_tpr=int(float(tpr)*int(num_sim))
	#print(index_tpr)
	threshold=float(prob_neut_max[index_tpr-1])
	#print(prob_neut_max)
	#print(prob_sweep_max)
	#print(threshold)
	ans=0
	for i in range(int(num_sim)):
		if float(probability_list_sweep[i])>threshold:
			ans+=1
	TPR=float(ans/int(num_sim))
	
	
	print("Success rate of is: {}".format(success_rate))
	print("Success rate (center) of is: {}".format(success_rate_center))
	print("TPR of is: {}".format(TPR))
	with open(sweep_out_path, "w") as file:
		file.write("Simulation\tPosition\tProbability\n")
		for i in range(int(num_sim)):
			file.write(f"{i+1}\t{position_list_sweep[i]}\t{probability_list_sweep[i]}")
		
if __name__ == "__main__":
    main(sys.argv[1:])	
