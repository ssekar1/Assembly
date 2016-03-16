#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

int mystrlen(char *s)
{
    int count = 0;
    while ((s++)!=='\0')
	count++;
    return(count);
}

/*----------------------------------------------------------------------------------------*/
bool sameString(char *s1, char * s2)
{
  bool result = true;

	if(mystrlen(s1) != mystrlen(s2))
	{
		result = false;
	}
	else
	{
		/*check the contents of the two string that have the same length*/
		int i;
		for(i = 0; i < mystrlen(s1); i++)
		{
			if(*(s1+i) != *(s2+i))
			{
				result = false;
			}
		}
	}

	return result;
}


}
/*----------------------------------------------------------------------------------------*/
char* makeCopy(char* s){

    char* buff = (char*) malloc(mystrlen(s) + 1);
	int i;
	for(i=0; i<=mystrlen(s);i++){
	*(buff+i)=*(s+i);
}
       return buff;
}

/*----------------------------------------------------------------------------------------*/
void mySort(char * s)
{

int i,j,temp,size;
for(i=0;i<size-1;i++)
{
for(j=0;j<size-i-1;j++)
{
if(*(s+j)>*(s+j+1))
{
temp=*(s+j);
*(s+j)=*(s+j+1);
*(s+j+1)=temp;
}
}
}

for(i=0;i<size;i++)
{ pritf("%d",*(s+i));
}
} 


}

/*----------------------------------------------------------------------------------------*/
double * makeArray(int x, int size)
{
	double *p1 = (double*)malloc (size * 8);
	int i;
	for (i=0; i<size, i++){
	
	x=x/2;
	*(p1 +i)=x
	}
	return p1;
}

/*----------------------------------------------------------------------------------------*/
void showArray(double * ptr, int size)
{
	int count;
  for (count=0; count<size;count++)

printf("%f ",  *(somearray + count));
}

/*----------------------------------------------------------------------------------------*/
void swapHex(int x, int byte1, int byte2)
{
  unsigned char *b1, *b2, tmpc;
  printf("%d in hex is %x\n", x, x);
  printf("swapping byte %d with byte %d\n", byte1, byte2);

  //int n = 0xABCD; ///expected output 0xADCB
  b1 = (unsigned char *)&x;;   b1 += byte1;               //first error here
  b2 = (unsigned char *)&x;;   b2 += byte2;               //second error here

  //swap the values;
  tmpc = *b1;
  *b1 = *b2;
  *b2 = tmpc;

  printf("%d in hex is %x\n", x, x);
}

/*----------------------------------------------------------------------------------------*/
int main(int argc, char * argv[])
{

  char * copyOfArg1;
  char * copyOfArg2;
  double * myArr[2];

  printf("myStrlen Function\n");
  printf("The number of characters in %s is %d\n", argv[1], myStrlen(argv[1]));
  printf("The number of characters in %s is %d\n", argv[2], myStrlen(argv[2]));
  printf("--------------------------\n");
  printf("sameString Function\n");
  if (sameString(argv[1], argv[2]))
    printf("%s and %s are the same string\n", argv[1], argv[2]);
  else
    printf("%s and %s are not the same string\n", argv[1], argv[2]);
  printf("--------------------------\n");
  printf("makeCopy Function\n");
  copyOfArg1 = makeCopy(argv[1]);
  printf("argv[1] is %s and copy is %s\n", argv[1], copyOfArg1);
  copyOfArg2 = makeCopy(argv[2]);
  printf("argv[2] is %s and copy is %s\n", argv[2], copyOfArg2);
  printf("--------------------------\n");
  printf("mySort Function--Based on ASCII Codes\n");
  mySort(copyOfArg1);
  printf("argv[1] is %s and copy is %s\n", argv[1], copyOfArg1);
  mySort(copyOfArg2);
  printf("argv[2] is %s and copy is %s\n", argv[2], copyOfArg2);
  printf("--------------------------\n");
  printf("swapHex Function\n");
  swapHex(atoi(argv[3]),0,1);
  swapHex(atoi(argv[3]),0,2);
  swapHex(atoi(argv[3]),0,3);
  swapHex(atoi(argv[3]),1,2);
  swapHex(atoi(argv[3]),1,3);
  swapHex(atoi(argv[3]),2,3);
  printf("--------------------------\n");
  printf("makeArray Function\n");
  myArr[0] = makeArray(atoi(argv[3]), myStrlen(argv[1]));
  myArr[1] = makeArray(atoi(argv[3]), myStrlen(argv[2]));
  printf("--------------------------\n");
  printf("showArray Function for argv[1]\n");
  showArray(myArr[0], myStrlen(argv[1]));
  printf("--------------------------\n");
  printf("showArray Function for argv[2]\n");
  showArray(myArr[1], myStrlen(argv[2]));
  printf("--------------------------\n");
  printf("End of Demo\n");
  free(copyOfArg1);
  free(copyOfArg2);
  free(myArr[0]);
  free(myArr[1]);

  return 0;
}