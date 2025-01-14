import numpy as np
import sys, time, os
import getopt
import argparse


def main(argv):

	target=0.5
	length=100000
	error=0.01
	tpr=0.05	
	
	opts, ars = getopt.getopt(argv, "i:d:t:l:e:s:g:o:T:", ["inputpos=", "directory=", "target=", "length=", "error=", "numsim=", "grid=", "output=", "tpr="])
    
	for opt, arg in opts:
		if opt in ("-i", "--inputpos"):
			file_pos = arg
		elif opt in ("-d", "--directory"):
    			directory = arg
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
			out_path = arg
		elif opt in ("-T", "--tpr"):
			tpr = arg
	
	f_pos=open(file_pos, 'r+')
	#out_path=os.path.join(output, "Pos_probs.txt")
	#print(file_pos)
	lines=f_pos.readlines()
	positions = [line.split(' ')for line in lines]
	
	file_prob_rf=os.path.join(directory, "Probs_RF.csv")
	f_pro_rf=open(file_prob_rf, 'r+')
	lines_pro_rf=f_pro_rf.readlines()
	probs_rf=[line.strip().split(',')for line in lines_pro_rf]
	
	file_prob_en=os.path.join(directory, "Probs_EN.csv")
	f_pro_en=open(file_prob_en, 'r+')
	lines_pro_en=f_pro_en.readlines()
	probs_en=[line.strip().split(',')for line in lines_pro_en]
	
	file_prob_svm=os.path.join(directory, "Probs_SVM.csv")
	f_pro_svm=open(file_prob_svm, 'r+')
	lines_pro_svm=f_pro_svm.readlines()
	probs_svm=[line.strip().split(',')for line in lines_pro_svm]
	
	#print(probs[1][0])
	error_list_rf=[]
	error_list_en=[]
	error_list_svm=[]
	
	#print(positions)
	position_list_rf=[]
	position_list_en=[]
	position_list_svm=[]
	
	probability_list_rf=[]
	probability_list_en=[]
	probability_list_svm=[]
	
	probability_list_rf_neut=[]
	probability_list_en_neut=[]
	probability_list_svm_neut=[]
	skip=int(num_sim)*int(grid)
	
	pos_sim_list=[[] for _ in range(int(num_sim))]
	prob_sim_list_rf=[[] for _ in range(int(num_sim))]
	prob_sim_list_en=[[] for _ in range(int(num_sim))]
	prob_sim_list_svm=[[] for _ in range(int(num_sim))]
		
	for i in range(int(num_sim)):
		pos_list=[]
		probs_list_rf=[]
		probs_list_en=[]
		probs_list_svm=[]
		
		probs_list_rf_neut=[]
		probs_list_en_neut=[]
		probs_list_svm_neut=[]
		#print(probs)
		#print(i*int(num_sim)+1)
		for j in range(int(grid)):
			pos_sim_list[i].append(positions[i][j])
			prob_sim_list_rf[i].append(float(probs_rf[int(grid)*i+j+1][2]))
			prob_sim_list_en[i].append(float(probs_en[int(grid)*i+j+1][1]))
			prob_sim_list_svm[i].append(float(probs_svm[int(grid)*i+j+1][1]))
			pos_list.append(positions[i][j])
			probs_list_rf.append(float(probs_rf[int(grid)*i+j+1][2]))
			probs_list_en.append(float(probs_en[int(grid)*i+j+1][1]))
			probs_list_svm.append(float(probs_svm[int(grid)*i+j+1][1]))
			
			probs_list_rf_neut.append(float(probs_rf[int(skip)+int(grid)*i+j+1][2]))
			probs_list_en_neut.append(float(probs_en[int(skip)+int(grid)*i+j+1][1]))
			probs_list_svm_neut.append(float(probs_svm[int(skip)+int(grid)*i+j+1][1]))
			
		index=probs_list_rf.index(max(probs_list_rf))
		position=pos_list[index]
		#print(position)
		position_list_rf.append(position)
		probability_list_rf.append(max(probs_list_rf))
		probability_list_rf_neut.append(max(probs_list_rf_neut))
		#print(position)
		err_rf=float((int(position)-int(float(target)*int(length)))/int(length))
		#print(err_rf)
		error_list_rf.append(err_rf)
		f_pro_rf.close()
		
		index=probs_list_en.index(max(probs_list_en))
		position=pos_list[index]
		position_list_en.append(position)
		probability_list_en.append(max(probs_list_en))
		probability_list_en_neut.append(max(probs_list_en_neut))
		#print(position)
		err_en=float((int(position)-int(float(target)*int(length)))/int(length))
		error_list_en.append(err_en)
		f_pro_en.close()
		
		index=probs_list_svm.index(max(probs_list_svm))
		position=pos_list[index]
		position_list_svm.append(position)
		probability_list_svm.append(max(probs_list_svm))
		probability_list_svm_neut.append(max(probs_list_svm_neut))
		#print(position)
		err_svm=float((int(position)-int(float(target)*int(length)))/int(length))
		error_list_svm.append(err_svm)
		f_pro_svm.close()
		#print(int(grid)*i+j+1)
	#print(error_list_rf)
	f_pos.close()
	ans_rf=0
	ans_en=0
	ans_svm=0
	#print(error_list)
	for i in range(int(num_sim)):
		if abs(error_list_rf[i]) <= float(error):
			ans_rf+=1
		if abs(error_list_en[i]) <= float(error):
			ans_en+=1
		if abs(error_list_svm[i]) <= float(error):
			ans_svm+=1
			
	success_rate_rf=float(ans_rf/int(num_sim))
	success_rate_en=float(ans_en/int(num_sim))
	success_rate_svm=float(ans_svm/int(num_sim))
	
	ans_rf=0
	ans_en=0
	ans_svm=0
	#print(prob_sim_list_rf)
	#print(int(float(float(target)-float(error))*int(length)))
	for i in range(int(num_sim)):
		for j in range(int(grid)):
			#print(int(pos_sim_list[i][j]))
			if int(pos_sim_list[i][j]) >= int(float(float(target)-float(error))*int(length)) and int(pos_sim_list[i][j]) <= int(float(float(target)+float(error))*int(length)):
				if float(prob_sim_list_rf[i][j]) > 0.5:
					ans_rf+=1
					break
	for i in range(int(num_sim)):
		for j in range(int(grid)):
			#print(int(pos_sim_list[i][j]))
			if int(pos_sim_list[i][j]) >= int(float(float(target)-float(error))*int(length)) and int(pos_sim_list[i][j]) <= int(float(float(target)+float(error))*int(length)):
				if float(prob_sim_list_en[i][j]) > 0.5:
					ans_en+=1
					break
	for i in range(int(num_sim)):
		for j in range(int(grid)):
			#print(int(pos_sim_list[i][j]))
			if int(pos_sim_list[i][j]) >= int(float(float(target)-float(error))*int(length)) and int(pos_sim_list[i][j]) <= int(float(float(target)+float(error))*int(length)):
				if float(prob_sim_list_svm[i][j]) > 0.5:
					ans_svm+=1
					break
	#print(pos_sim_list)
	#print(prob_sim_list)
	#print(ans_rf)
	#print(ans_en)
	#print(ans_svm)
	success_rate_center_rf=float(ans_rf/int(num_sim))
	success_rate_center_en=float(ans_en/int(num_sim))
	success_rate_center_svm=float(ans_svm/int(num_sim))
	
	
	#print(ans_rf)
	#print(ans_en)
	#print(ans_svm)
	
	probability_list_rf_neut.sort(reverse=1)
	probability_list_en_neut.sort(reverse=1)
	probability_list_svm_neut.sort(reverse=1)
	index_tpr=int(float(tpr)*int(num_sim))
	
	threshold_rf=float(probability_list_rf_neut[index_tpr-1])
	threshold_en=float(probability_list_en_neut[index_tpr-1])
	threshold_svm=float(probability_list_svm_neut[index_tpr-1])
	
	ans_rf=0
	ans_en=0
	ans_svm=0
	for i in range(int(num_sim)):
		if float(probability_list_rf[i])>threshold_rf:
			ans_rf+=1
		if float(probability_list_en[i])>threshold_en:
			ans_en+=1
		if float(probability_list_svm[i])>threshold_svm:
			ans_svm+=1
	TPR_rf=float(ans_rf/int(num_sim))
	TPR_en=float(ans_en/int(num_sim))
	TPR_svm=float(ans_svm/int(num_sim))
	#print(probability_list_rf_neut)
	#print(probability_list_rf)
	#print(probability_list_en_neut)
	#print(probability_list_en)
	#print(probability_list_svm_neut)
	#print(probability_list_svm)
	
	#print(threshold_rf)
	#print(threshold_en)
	#print(threshold_svm)
	
	#print(ans_rf)
	#print(ans_en)
	#print(ans_svm)
	#print(TPR_rf)
	#print(TPR_en)
	#print(TPR_svm)

	print("Success rate of RF is: {}".format(success_rate_rf))
	print("Success rate of EN is: {}".format(success_rate_en))
	print("Success rate of SVM is: {}".format(success_rate_svm))
	
	print("Success rate (center) of RF is: {}".format(success_rate_center_rf))
	print("Success rate (center) of EN is: {}".format(success_rate_center_en))
	print("Success rate (center) of SVM is: {}".format(success_rate_center_svm))
	
	print("TPR of RF is: {}".format(TPR_rf))
	print("TPR of EN is: {}".format(TPR_en))
	print("TPR of SVM is: {}".format(TPR_svm))
	
	
	out_path_rf=os.path.join(out_path, "Pos_probs_rf.txt")
	with open(out_path_rf, "w") as file:
		file.write("Simulation\tPosition\tProbability\n")
		for i in range(int(num_sim)):
			file.write(f"{i+1}\t{position_list_rf[i]}\t{probability_list_rf[i]}\n")
	
	out_path_en=os.path.join(out_path, "Pos_probs_en.txt")
	with open(out_path_en, "w") as file:
		file.write("Simulation\tPosition\tProbability\n")
		for i in range(int(num_sim)):
			file.write(f"{i+1}\t{position_list_en[i]}\t{probability_list_en[i]}\n")
	
	out_path_svm=os.path.join(out_path, "Pos_probs_svm.txt")
	with open(out_path_svm, "w") as file:
		file.write("Simulation\tPosition\tProbability\n")
		for i in range(int(num_sim)):
			file.write(f"{i+1}\t{position_list_svm[i]}\t{probability_list_svm[i]}\n")

if __name__ == "__main__":
    main(sys.argv[1:])	
