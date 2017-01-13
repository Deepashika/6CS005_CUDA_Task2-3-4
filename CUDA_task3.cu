// Name: Deepashika Maduwanthi
// Student Id: 1432291
//--------------------------------------------------


/*hese are header files, include <stdio.h> 
-the compiler to include this header file for compilation
stdlib.h header provides variable types,several macros, 
and functions to performe general functions.*/

#include <stdio.h>
#inlude <stdlib.h>

/modify the CUDA_task2 program to generate A and B matrix automatically/

#define N 4

 
/*Global function is also called "kernels".
 It's the functions that you may call from the host side.
 
*/

__global__ void Matri_Add(int A[][N], int B[][N], int C[][N]){
	
	
	 // Thread row and column 
        int i = threadIdx.x;
		int j = threadIdx.y;

		C[i][j] = A [i][j] + B[i][j];

}
 //function type was changed and added new parameter to the function
void randmatfunc(int newmat[N][N]){
  int i, j, k; 
    for(i=0;i<N;i++){
        for(j=0;j<N;j++){
          k = rand() % 100 + 1;;
            printf("%d ", k);
            newmat[i][j] =k;
        }
        printf("\n");
    }
}
/*To generate A and B matrix automatically, code was changes as below(Remove matrix numbers)  */

int main(){

int A[N][N];  
randmatfunc(A);
  
int B[N][N];  
randmatfunc(B);  

int C[N][N];

//calling the poniters
  int (*d_A)[N], (*d_B)[N], (*d_C)[N];

// allocate device copies of A,B, C	
  cudaMalloc((void**)&d_A, (N*N)*sizeof(int));
  cudaMalloc((void**)&d_B, (N*N)*sizeof(int));
  cudaMalloc((void**)&d_C, (N*N)*sizeof(int));

 // CUDA memory copy types(copy input to device from host)
  cudaMemcpy(d_A, A, (N*N)*sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(d_B, B, (N*N)*sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(d_C, C, (N*N)*sizeof(int), cudaMemcpyHostToDevice);

  int numBlocks = 1;
  
  // N threads (kernel invoke N threads)
  dim3 threadsPerBlock(N,N);
  Matri_Add<<<numBlocks,threadsPerBlock>>>(d_A,d_B,d_C);

// copy result of device back to host 
  cudaMemcpy(C, d_C, (N*N)*sizeof(int), cudaMemcpyDeviceToHost);

	int i, j; printf("C = \n"); 
	for(i=0;i<N;i++){
	for(j=0;j<N;j++){ 
	printf("%d ", C[i][j]);
	}
	printf("\n");
	}

//  cleanup 
  cudaFree(d_A); 
  cudaFree(d_B); 
  cudaFree(d_C);

  printf("\n");

  return 0;
}
