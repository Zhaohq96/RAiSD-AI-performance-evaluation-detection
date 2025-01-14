#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <getopt.h>

int Find_Max_index (double *p, int samples) // function for pccs-based strategies to find the index of row or column has maximum 1s
{
	int i;
	int Maxid=0;
	for(i=0;i<samples;i++)
	{
		if(p[Maxid]<p[i])Maxid=i;
	}
	return Maxid;
}

char ** Row (char **p, int samples, int sites) // function of rowed frequency-based sorting 
{
	int m,n;
	int *count = (int*)malloc(sizeof(int)*samples);
	
	for(m=0;m<samples;m++)
	{
		count[m] = 0;
		for(n=0;n<sites;n++)
		{
			if(p[m][n] == 49)count[m]++;
		}
	}
	
	int temple;
	char *temp;
	
	for(m=0;m<samples;m++)
	{
		for(n=m+1;n<samples;n++)
		{
			if(count[m] < count[n])
			{
				temp = p[m];
				p[m] = p[n];
				p[n] = temp;
	
				temple = count[m];
				count[m] = count[n];
				count[n] = temple;
			}
		}
	}
	
	for(m=0;m<samples;m++)
	{
		printf("%d\n", count[m]);
	}
	
	free(count);
	
	return p;
}

char ** Column (char **p, int samples, int sites) // function of columned frequency-based sorting
{
	int k,m,n;
	int *count = (int*)malloc(sizeof(int)*sites);
		
	for(m=0;m<sites;m++)
	{
		count[m] = 0;
		for(n=0;n<samples;n++)
		{
			if(p[n][m] == 49)count[m]++;
		}
	}
	

		
	int temple;
	char temp;
		
	for(m=0;m<sites;m++)
	{
		for(n=m+1;n<sites;n++)
		{
			if(count[m] < count[n])
			{
				for(k=0;k<samples;k++)
				{
					temp = p[k][m];
					p[k][m] = p[k][n];
					p[k][n] = temp;
				}
					
				temple = count[m];
				count[m] = count[n];
				count[n] = temple;
			}
		}
	}
	
	for(k=0;k<sites;k++)
	{
		printf("%d\n", count[k]);
	}
	
	free(count);
	
	return p;
}

char ** Pccrow (char **p, int samples, int sites) // function of rowed pccs-based sorting
{
	int *P_A = (int*)calloc(samples, sizeof(int));
	int *P_a = (int*)calloc(samples, sizeof(int));
	int i,k,m,n;
		
	for(i=0;i<samples;i++)
	{
		for(k=0;k<sites;k++)
		{
			if(p[i][k] == 49)P_A[i]++;
		}
		P_a[i] = sites - P_A[i];
//		printf("%d %d\n", P_A[i], P_a[i]);
	}
		
	// create the matrices to store PCC between two rows and the sum of PCC of each row
	double **PCC_matrix = (double**)malloc(sizeof(double*)*samples);
	double *sum = (double*)calloc(samples, sizeof(double));

		
	for(i=0;i<samples;i++)
	{
		PCC_matrix[i] = (double*)malloc(sizeof(double)*(samples));
	}
		
	for(i=0;i<samples;i++)
	{
		PCC_matrix[i][i] = 1.000001;
		for(k=i+1;k<samples;k++)
		{
			int P_AB=0;
			for(m=0;m<sites;m++)
			{
				if(p[i][m] == 49 && p[k][m] == 49)P_AB++;
			}
			PCC_matrix[i][k] = (double)((double)P_AB/(double)sites-(double)P_A[i]/(double)sites*(double)P_A[k]/(double)sites)*((double)P_AB/(double)sites-(double)P_A[i]/(double)sites*(double)P_A[k]/(double)sites)/(double)(P_A[i]/(double)sites*(double)(1-(double)P_A[i]/(double)sites)*(double)P_A[k]/(double)sites*(double)(1-(double)P_A[k]/(double)sites));
			if(P_A[i] == 0 || P_A[k] == 0)PCC_matrix[i][k]=0;
			//PCC_matrix[k][i] = PCC_matrix[i][k];
			PCC_matrix[k][i] = PCC_matrix[i][k];
//			printf("%d %d %d %d %d %d ", P_AB, sites, P_A[i], P_A[k], P_a[i], P_a[k]);
//			printf("%f\n", PCC_matrix[i][k]);
		}
	}
		
	for(i=0;i<samples;i++)
	{
		for(k=0;k<samples;k++)
		{
			sum[i]+=PCC_matrix[i][k];
//			printf("%lf ", PCC_matrix[i][k]);
		}
//		printf("%lf\n", sum[i]);
	}
		
	int Maxid=0;
		
	// find the max index and sort with row
	Maxid = Find_Max_index(sum, samples);
//	printf("%d %lf\n", Maxid, sum[Maxid]);
		
	double temple1;
	char *temp1;
		
	for(m=0;m<samples;m++)
	{
		for(n=m+1;n<samples;n++)
		{
			if(PCC_matrix[Maxid][m] < PCC_matrix[Maxid][n])
			{
				temp1 = p[m];
				p[m] = p[n];
				p[n] = temp1;
					
				temple1 = PCC_matrix[Maxid][m];
				PCC_matrix[Maxid][m] = PCC_matrix[Maxid][n];
				PCC_matrix[Maxid][n] = temple1;
			}
		}
	}
	
	free(P_A);
	free(P_a);
	free(sum);
	for(i=0;i<samples;i++)
	{
		free(PCC_matrix[i]);
	}
	free(PCC_matrix);
	
	return p;
}

char ** Pcccolumn (char **p, int samples, int sites) // function of columned pccs-based sorting
{
	int *P_A = (int*)calloc(sites, sizeof(int));
	int *P_a = (int*)calloc(sites, sizeof(int));
	int i,k,m,n;
		
	for(i=0;i<sites;i++)
	{
		for(k=0;k<samples;k++)
		{
			if(p[k][i] == 49)P_A[i]++;
		}
		P_a[i] = samples - P_A[i];
//		printf("%d %d\n", P_A[i], P_a[i]);
	}
		
	double **PCC_matrix = (double**)malloc(sizeof(double*)*sites);
	double *sum = (double*)calloc(sites, sizeof(double));

		
	for(i=0;i<sites;i++)
	{
		PCC_matrix[i] = (double*)malloc(sizeof(double)*(sites));
	}
		
	for(i=0;i<sites;i++)
	{
		PCC_matrix[i][i] = 1.000001;
		for(k=i+1;k<sites;k++)
		{
			int P_AB=0;
			for(m=0;m<samples;m++)
			{
				if(p[m][i] == 49 && p[m][k] == 49)P_AB++;
			}
			PCC_matrix[i][k] = (double)((double)P_AB/(double)samples-(double)P_A[i]/(double)samples*(double)P_A[k]/(double)samples)*((double)P_AB/(double)samples-(double)P_A[i]/(double)samples*(double)P_A[k]/(double)samples)/(double)(P_A[i]/(double)samples*(double)(1-(double)P_A[i]/(double)samples)*(double)P_A[k]/(double)samples*(double)(1-(double)P_A[k]/(double)samples));
			if(P_A[i] == 0 || P_A[k] == 0)PCC_matrix[i][k]=0;
			PCC_matrix[k][i] = PCC_matrix[i][k];
//			printf("%d %d %d %d %d %d ", P_AB, samples, P_A[i], P_A[k], P_a[i], P_a[k]);
//			printf("%f\n", PCC_matrix[i][k]);
		}
	}
		
	for(i=0;i<sites;i++)
	{
		for(k=0;k<sites;k++)
		{
			sum[i]+=PCC_matrix[i][k];
//			printf("%lf ", PCC_matrix[i][k]);
		}
//		printf("%lf\n", sum[i]);
	}
		
	int Maxid=0;

	Maxid = Find_Max_index(sum, sites);
//	printf("%d %lf\n", Maxid, sum[Maxid]);
		
	double temple;
	char temp;
		
	for(m=0;m<sites;m++)
	{
		for(n=m+1;n<sites;n++)
		{
			if(PCC_matrix[Maxid][m] < PCC_matrix[Maxid][n])
			{
				for(k=0;k<samples;k++)
				{
					temp = p[k][m];
					p[k][m] = p[k][n];
					p[k][n] = temp;
				}
					
				temple = PCC_matrix[Maxid][m];
				PCC_matrix[Maxid][m] = PCC_matrix[Maxid][n];
				PCC_matrix[Maxid][n] = temple;
			}
		}
	}
	
	free(P_A);
	free(P_a);
	free(sum);
	for(i=0;i<sites;i++)
	{
		free(PCC_matrix[i]);
	}
	free(PCC_matrix);
	
	return p;
}


int main (int argc, char ** argv)
{
	int opt;
	const char *optstring = "i:m:c:w:s:l:r:g:o:";
	int  win_snp=0, win_site=0, length=0, min_snp=1, grid_size=1;
	char *mode, *outname;
	char *center;
	char *file_name;
	mode = "noopt";
	center = "noopt";
	
	while (-1 != (opt = getopt(argc, argv, optstring))) // get opts
	{
		switch (opt) {
			case 'i': ;
				file_name = optarg;
				break;
			case 'm': ;
				mode = optarg;
				break;
			case 'c': ;
				center = optarg;
				break;
			case 'w':
				win_snp = atoi(optarg);
				break;
			case 's':
				win_site = atoi(optarg);
				break;
			case 'l':
				length = atoi(optarg);
				break;
			case 'r':
				min_snp = atoi(optarg);
				break;
			case 'g':
				grid_size = atoi(optarg);
				break;
			case 'o': ;
				outname = optarg;
				break;
			default:
				printf("No option is detected");
				break;
		}
	}
	
	FILE *fp = fopen(file_name, "r");	
	//FILE *fout = NULL;
	char tstring [100000];
	char sstring [1000];
	char filename [50];
	char new_name [1000];
	char flag [100];
	//sprintf(filename, "%s", outname);
	//fout = fopen(filename, "w");
	int samples, populations;
	int skip;
	
	fscanf(fp, "%s", flag);
	
	if(strcmp(flag, "command:") == 0)
	{
		fscanf(fp, "%s", tstring);
		//fprintf(fout, "./ms ");
		fscanf(fp, "%s", tstring);
		//fprintf(fout, "%s ", tstring);
		samples = atoi(tstring);
		printf("number of samples: %d\n", samples);
		for(skip=0;skip<10;skip++)fscanf(fp, "%s", tstring);
		populations = atoi(tstring);
		//populations = 10000;
		//fprintf(fout, "%d ", populations);
		printf("number of populations: %d\n", populations);
	}
	else
	{
		//fprintf(fout, "%s ", flag);
		fscanf(fp, "%s", tstring);
		//fprintf(fout, "%s ", tstring);			
		// get the number of samples
		samples = atoi(tstring);
		printf("number of samples: %d\n", samples);
		
		fscanf(fp, "%s", tstring);
		//fprintf(fout, "%s ", tstring);
		
		//get the number of populations
		populations = atoi(tstring);
		printf("number of populations: %d\n", populations);
	}
	
	if(win_site>length)win_site=length;
	fgets(sstring, 1000, fp);
	//fprintf(fout, "%s\n", sstring);
	int j;
	
	FILE *fout_pos = NULL;
	char filename_pos [50];
	sprintf(filename_pos, "%s_positions.ms", outname);
	fout_pos = fopen(filename_pos, "w");
	
	// scan each population
	for(j=0;j<populations;j++)
	{
		FILE *fout = NULL;
		sprintf(filename, "%s%d.ms", outname, j);
		fout = fopen(filename, "w");
		fprintf(fout, "./ms ");
		fprintf(fout, "%d ", samples);
		
		if(strcmp(flag, "command:") == 0)
		{
			while(strcmp(tstring, "d"))
			{
				fscanf(fp, "%s", tstring);
				//fprintf(fout, "%s", tstring);
			}
			fgets(sstring, 1000, fp);
			//fprintf(fout, "\n");
			while(strcmp(tstring, "segsites:"))
			{
				fscanf(fp, "%s", tstring);
				//fprintf(fout, "%s", tstring);
			}
		}
		
		while(strcmp(tstring, "segsites:"))
		{
			fscanf(fp, "%s", tstring);
			//fprintf(fout, "\n%s", tstring);
		}
		
		//printf("New population start!\n");
		
		// get the sites information of this population		
		fscanf(fp, "%s", tstring);
		int sites = atoi(tstring);
		if(strcmp(flag, "command:") == 0)sites = sites - 1;
		printf("site of the population %d is: %d\n", j+1, sites);
		//if(win_snp <= sites)//fprintf(fout, " %d\n", win_snp);
		//if(win_snp > sites)//fprintf(fout, " %d\n", sites);

		fscanf(fp, "%s", tstring);
		//fprintf(fout, "%s ", tstring);
		int i,k,index_center;
		int *positions = (int*)calloc(sites, sizeof(int));
		float *position = (float*)malloc(sizeof(float)*sites);
		int position_state = 0;
		if(strcmp(flag, "command:") == 0)
		{
			for(i=0;i<sites;i++)
			{
				if (fscanf(fp, "%s", tstring) != 1) 
				{
					position_state = 1;
					free(position);
					free(positions);
					break;
				}
				//fscanf(fp, "%s", tstring);
				positions[i] = atoi(tstring);
				//printf("%d ", positions[i]);
			}
		}
		else
		{	
			for(i=0;i<sites;i++)
			{
				if (fscanf(fp, "%s", tstring) != 1) 
				{
					position_state = 1;
					free(position);
					free(positions);
					break;
				}
				position[i] = atof(tstring);
				//printf("%f ", position[i]);
			}
//			int *positions = (int*)malloc(sizeof(int)*(sites+1));
			for(i=0;i<sites;i++)
			{
				positions[i] = position[i] * length;
				//printf("%d ", positions[i]);
			}
		}
		if (position_state == 1)
		{
			break;
		}
		//printf("\n");
		
		// create the matrix to store the data and write it to the txt file
		char **matrix = (char**)malloc(sizeof(char*)*samples);
		for(i=0;i<samples;i++)
		{
			matrix[i] = (char*)malloc(sizeof(char)*(sites+1));
			fscanf(fp, "%s", matrix[i]);
		}
		
		if((strcmp(center, "snp") == 0 || strcmp(center, "bp") == 0) && win_snp>=sites)
		{
			fprintf(fout, "1\n");
			fprintf(fout, "//\n");
			fprintf(fout, "segsites: ");
			fprintf(fout, "%d\n", sites);
			fprintf(fout, "positions: ");
			if(strcmp(flag, "command:") == 0)
			{
				for(i=0;i<sites;i++)
				{
					fprintf(fout, "%f ", (float)((float)positions[i]/(float)length));
				}
			}
			else
			{
				for(i=0;i<sites;i++)
				{
					fprintf(fout, "%f ", position[i]);
				}
			}
			fprintf(fout, "\n");
			for(i=0;i<samples;i++)
			{
				fprintf(fout, "%s\n", matrix[i]);
			}
//			fprintf(fout, "\\");
			free(position);
			free(positions);
			for(i=0;i<samples;i++)
			{
				free(matrix[i]);
			}
			free(matrix);
			fclose(fout);
			printf("The window size is larger than total number of sites of this population, so do not count!\n");
			continue;
		}
		//fprintf(fout, "%d\n", grid_size);
		
		
//		for(i=0;i<sites-1;i++)
//		{
//			if(positions[i]<=length/2 && positions[i+1]>length/2)index_center=i;
//		}
		
		
			
		// proccess the data by specified sorting strategy
		if ((strcmp(mode, "original") == 0 || strcmp(mode, "row-frequency") == 0 || strcmp(mode, "column-frequency") == 0 || strcmp(mode, "both-frequency") == 0 || strcmp(mode, "row-pccs") == 0 || strcmp(mode, "column-pccs") == 0 || strcmp(mode, "both-pccs") == 0) && strcmp(center, "noopt") == 0)
		{	
			// create the txt file
			sprintf(filename, "%d.txt", j);
			fout = fopen(filename, "w");
			
			if (strcmp(mode, "row-frequency") == 0)
			{
				matrix = Row(matrix, samples, sites);
			}
			
			if (strcmp(mode, "column-frequency") == 0)
			{
				matrix = Column(matrix, samples, sites);
			}
			
			if (strcmp(mode, "both-frequency") == 0)
			{
				matrix = Row(matrix, samples, sites);
				matrix = Column(matrix, samples, sites);
			}
			
			if (strcmp(mode, "row-pccs") == 0)
			{
				matrix = Pccrow(matrix, samples, sites);
			}
			
			if (strcmp(mode, "column-pccs") == 0)
			{
				matrix = Pcccolumn(matrix, samples, sites);
			}
			
			if (strcmp(mode, "both-pccs") == 0)
			{
				matrix = Pccrow(matrix, samples, sites);
				matrix = Pcccolumn(matrix, samples, sites);
			}
			for(i=0;i<sites;i++)fprintf(fout, "%s ", tstring);
			fprintf(fout, "\n");
			for(i=0;i<samples;i++)
			{
				//printf("%s\n", matrix[i]);
				fprintf(fout, "%s\n", matrix[i]);
			}	
		}
		
		// process the data by specified centering strategy
		if (strcmp(center, "snp") == 0) // snp centering strategy
		{
			int g;
			
			if (win_snp == 0)
			{
				printf("\nThe size of snps window is not specified!\n");
				return -1;
			}
			for(g=1;g<grid_size+1;g++)
			{
				for(i=0;i<sites-1;i++)
				{
					if(positions[i]<=(int)(length*g)/(grid_size+1) && positions[i+1]>(int)(length*g)/(grid_size+1))index_center=i;
				}
				
				//printf("center is:%d\n", index_center);
				//printf("%d %d %s\n", win_snp/2, win_site, mode);
				
				char **snp_matrix = (char**)malloc(sizeof(char*)*samples);
				for(i=0;i<samples;i++)
				{
					snp_matrix[i] = (char*)calloc(win_snp+1, sizeof(char));
				}
				
				if ((index_center-win_snp/2+1)<0)index_center=win_snp/2-1;
				
				for(k=0;k<samples;k++)
				{
					for(i=0;i<win_snp;i++)snp_matrix[k][i]=matrix[k][i+index_center-win_snp/2+1];
				}
				for(i=0;i<win_snp;i++)fprintf(fout, "%f ", (position[i+index_center-win_snp/2+1]-position[index_center-win_snp/2+1]+0.0001)/(position[index_center+win_snp/2+1]-position[index_center-win_snp/2+1]+0.0002));
				fprintf(fout, "\n");
				

				if (strcmp(mode, "row-frequency") == 0)
				{
					snp_matrix = Row(snp_matrix, samples, win_snp);
				}
				
				if (strcmp(mode, "column-frequency") == 0)
				{
					snp_matrix = Column(snp_matrix, samples, win_snp);
				}
				
				if (strcmp(mode, "both-frequency") == 0)
				{
					snp_matrix = Row(snp_matrix, samples, win_snp);
					snp_matrix = Column(snp_matrix, samples, win_snp);
				}
				
				if (strcmp(mode, "row-pccs") == 0)
				{
					snp_matrix = Pccrow(snp_matrix, samples, win_snp);
				}
				
				if (strcmp(mode, "column-pccs") == 0)
				{
					snp_matrix = Pcccolumn(snp_matrix, samples, win_snp);
				}
				
				if (strcmp(mode, "both-pccs") == 0)
				{
					snp_matrix = Pccrow(snp_matrix, samples, win_snp);
					snp_matrix = Pcccolumn(snp_matrix, samples, win_snp);
				}
				
				if (strcmp(mode, "noopt") == 0)
				{
					;
				}
				
				for(i=0;i<samples;i++)
				{
					//printf("%s\n", snp_matrix[i]);
					fprintf(fout, "%s\n", snp_matrix[i]);
				}
				for(i=0;i<samples;i++)
				{
					free(snp_matrix[i]);
				}
				free(snp_matrix);
			}
		}
			
		if (strcmp(center, "bp") == 0) // bp-based window strategy
		{
			
			if (win_snp == 0)
			{
				printf("\nThe size of snps window is not specified!\n");
				return -1;
			}
//			printf("center is:%d\n", index_center);
//			printf("%d %d %s\n", win_snp/2, win_site, mode);
			
			if (win_site == 0 || length ==0)
			{
				printf("\nThe size of bp window and rigion length both need to be specified!\n");
				return -1;
			}
			
			
			if (min_snp > win_snp/2)
			{
				printf("\nThe minimum number of snps is unworkable!\n");
				return -1;
			}
			int g;
			fprintf(fout, "%d\n", grid_size);
			//int out_left_index;
			for(g=1;g<grid_size+1;g++)
			{
				fprintf(fout, "//\n");
				fprintf(fout, "segsites: ");
				fprintf(fout, "%d\n", win_snp);
				fprintf(fout, "positions: ");
				char **snp_matrix = (char**)malloc(sizeof(char*)*samples);
				for(i=0;i<samples;i++)
				{
					snp_matrix[i] = (char*)calloc(win_snp+1, sizeof(char));
				}
				for(i=0;i<sites-1;i++)
				{
					if(positions[i]<=(int)(length*g)/(grid_size+1) && positions[i+1]>(int)(length*g)/(grid_size+1))index_center=i;
				}
				
				//printf("center is:%d\n", index_center);
				fprintf(fout_pos, "%d ", positions[index_center]);
				//printf("%d %d %s\n", win_snp/2, win_site, mode);
				
				int width, left_boundry, right_boundry;
				int left_snp=0, right_snp=0, left_index=0, right_index=0, total;
				width = win_site/2;
				left_boundry = (int)(length*g)/(grid_size+1) - width;
				right_boundry = (int)(length*g)/(grid_size+1) + width;
				//printf("%d %d\n", left_boundry, right_boundry);
				for(i=0;i<sites;i++)
				{
					if (positions[i]>=left_boundry && positions[i]<=(int)(length*g)/(grid_size+1))left_snp++;
					if (positions[i]>(int)(length*g)/(grid_size+1) && positions[i]<=right_boundry)right_snp++;
	//				if (positions[i]<left_boundry && positions[i+1]>=left_boundry)left_index=i+1; // check
	//				if (positions[i]<=right_boundry && positions[i+1]>right_boundry)right_index=i; // check
				}
				for(i=0;i<sites-1;i++)
				{
					if (positions[i]<=(int)(length*g)/(grid_size+1) && positions[i+1]>(int)(length*g)/(grid_size+1))
					{
						left_index = i;
						right_index = i+1;
					}
				}
				//printf("%d %d %d %d\n", left_index, right_index, left_snp, right_snp);
				total = left_snp + right_snp;
				if (left_snp<min_snp || right_snp<min_snp)total=0;
				
				while (total != win_snp)
				{
					if (total>win_snp)
					{
						left_snp = 0;
						right_snp = 0;
						left_boundry = left_boundry + 0.01 * length;
						right_boundry = right_boundry - 0.01 * length;
						if (left_boundry<0)left_boundry = positions[0];
						if (right_boundry>length)right_boundry = positions[sites-1];
						for(i=0;i<sites;i++)
						{
							if (positions[i]>=left_boundry && positions[i]<=(int)(length*g)/(grid_size+1))left_snp++;
							if (positions[i]>(int)(length*g)/(grid_size+1) && positions[i]<=right_boundry)right_snp++;
	//						if (positions[i]<left_boundry && positions[i+1]>=left_boundry)left_index=i+1;
	//						if (positions[i]<=right_boundry && positions[i+1]>right_boundry)right_index=i;
						}
						total = left_snp + right_snp;
						if (total=win_snp)
						{
							for(i=0;i<sites;i++)
							{
								if (positions[i]<=left_boundry && positions[i+1]>left_boundry)left_index=i+1;
								if (positions[i]<=right_boundry && positions[i+1]>right_boundry)right_index=i;
							}
							if ((left_index+win_snp)>=(sites-1))left_index=sites-1-win_snp;
							if ((right_index-win_snp)<=0)left_index=0;
						}
						if (left_snp<min_snp || right_snp<min_snp)total=0;
						//printf("%d %d %d %d %d %d %d %d\n", left_boundry, right_boundry, left_snp, right_snp, left_index, right_index, total, win_snp);
					}
					
					if (total<win_snp)
					{
						if (total==0)
						{
							left_index = index_center - min_snp + 1;
							right_index = index_center + min_snp;
							if (left_index<=0)
							{
								left_index=0;
							}
							if (right_index>=sites-1)
							{
								left_index=sites-1-win_snp;
							}
							total = 2 * min_snp;
							left_snp = min_snp;
							right_snp = min_snp;
							//printf("%d %d %d\n", left_index, right_index, total);
						}
						while (total != win_snp)
						{
							if ((int)(length*g)/(grid_size+1)-positions[left_index-1]>=positions[right_index+1]-(int)(length*g)/(grid_size+1))
							{
								right_index=right_index+1;
	//							printf("%d\n", right_index);
							}					
							else 
							{
								left_index=left_index-1;
	//							printf("%d\n", left_index);
							}
							total = right_index - left_index + 1;
							left_snp = index_center - left_index + 1;
							right_snp = right_index - index_center;
							if (left_index<=0)total=win_snp;
							if (right_index>=sites-1)
							{
								total=win_snp;
								left_index=sites-1-win_snp;
	//							printf("\n%d\n\n", left_index);
							}
							
						}
					}
				}
				if (left_index<0)left_index=0;
				if ((left_index+win_snp+1)>sites)left_index=sites-1-win_snp;
				
				//printf("%d %d %d %d %d %d %d %d\n", left_boundry, right_boundry, left_snp, right_snp, left_index, right_index, total, win_snp);

				for(k=0;k<samples;k++)
				{
					for(i=0;i<win_snp;i++)snp_matrix[k][i]=matrix[k][i+left_index];
				}
				
				
				if (strcmp(mode, "row-frequency") == 0)
				{
					snp_matrix = Row(snp_matrix, samples, win_snp);
				}
				
				if (strcmp(mode, "column-frequency") == 0)
				{
					snp_matrix = Column(snp_matrix, samples, win_snp);
				}
				
				if (strcmp(mode, "both-frequency") == 0)
				{
					snp_matrix = Row(snp_matrix, samples, win_snp);
					snp_matrix = Column(snp_matrix, samples, win_snp);
				}
				
				if (strcmp(mode, "row-pccs") == 0)
				{
					snp_matrix = Pccrow(snp_matrix, samples, win_snp);
				}
				
				if (strcmp(mode, "column-pccs") == 0)
				{
					snp_matrix = Pcccolumn(snp_matrix, samples, win_snp);
				}
				
				if (strcmp(mode, "both-pccs") == 0)
				{
					snp_matrix = Pcccolumn(snp_matrix, samples, win_snp);
					snp_matrix = Pccrow(snp_matrix, samples, win_snp);
				}
				
				if (strcmp(mode, "noopt") == 0)
				{
					;
				}
				for(i=0;i<win_snp;i++)fprintf(fout, "%f ", (float)((((float)positions[i+left_index]-(float)positions[left_index])/((float)positions[left_index+win_snp]-(float)positions[left_index]+0.002))));
				fprintf(fout, "\n");
				
				for(i=0;i<samples;i++)
				{
					//printf("%s\n", snp_matrix[i]);
					fprintf(fout, "%s\n", snp_matrix[i]);
					//printf("%d\n", i);
				}
				for(i=0;i<samples;i++)
				{
					free(snp_matrix[i]);
				}
				free(snp_matrix);
			}
		}
		
		if (strcmp(mode, "noopt") == 0 && strcmp(center, "noopt") == 0)
		{
			printf("\nOne strategy should be specified at least\n");
			return -1;
		}
		fprintf(fout_pos, "\n");
		fclose(fout);
		//double position_center;
		//position_center=(float)((((float)positions[index_center]-(float)positions[left_index])/((float)positions[left_index+win_snp]-(float)positions[left_index]+0.002)));
		//sprintf(new_name, "%s_%f.ms", filename, position_center);
		//rename(filename, new_name);
		free(position);
		free(positions);
		for(i=0;i<samples;i++)
		{
			free(matrix[i]);
		}
		free(matrix);
		//printf("Population ends!\n\n");
	
	}
	fclose(fp);
	fclose(fout_pos);
	

	return 0;
}
