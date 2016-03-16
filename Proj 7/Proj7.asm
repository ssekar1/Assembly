#include<stdio.h>
#include<stdbool.h>
#include <stdlib.h>
#include <string.h>

typedef struct student
{
  int id;
  double gpa;
} STUDENT;

void printDouble(void * d)
{
  printf("%f",d);

}
void printStudent(void * s)
{
  printf("id = %d , gpa = %f",((STUDENT *)s)->id,((STUDENT *)s)->gpa);
}

void printStudentPtr(void  *s)
{
  printf("id = %d , gpa = %f",((STUDENT *)s)->id,((STUDENT *)s)->gpa);

}


void showValues(void * base, int nElem, int sizeofEachElem, void (*fptr)(void *))
{
 int i = 0;
        for(i = 0 ; i < nElem;i++)
        {//(void *)*
                (*fptr)(((char *)base+(i * sizeofEachElem)));
        }

}

bool cmpDouble (void *v1, void *v2)
{
if(*((double *)v1) == *((double *)v2))
        {
                return true;
        }
        return false;


}


bool cmpStudent (void *v1, void *v2)
{
 if(((STUDENT *)v1)->id == ((STUDENT *)v2)->id)
        {
                return true;
        }
        return false;

}
bool cmpStudentPtr (void *v1, void *v2)
{
 if(((STUDENT *)(STUDENT *)v1)->id == ((STUDENT *)(STUDENT *)v2)->id)
        {
                return true;
        }
        return false;
 

}
void selectionSort(void * base, int nElem, int sizeofEachElem, bool (*cmp)(void *, void *), void (*fptr)(void *))
{
 
int i = 0, current = 0,min = 0;
 
        for(current = 0 ; current < nElem ; current++)
        {
                min = current;
                for(i = current + 1 ; i < nElem ; i++)
                {
                        if( (*cmp)(((char *)base + (i * sizeofEachElem) ) , ((char *)base + (min * sizeofEachElem) )) == true)
                        {
                                min = i;
                        }
                }
                if( (*cmp)(((char *)base + (current * sizeofEachElem) ) , ((char *)base + (min * sizeofEachElem) )) == true)
                {
                        void * temp;
 
                        temp = (char *)base + (current * sizeofEachElem);
                        memcpy(((char *)base + (current * sizeofEachElem)),((char *)base + (min * sizeofEachElem)),sizeofEachElem);
                        memcpy(((char *)base + (min * sizeofEachElem)), ((char *)temp),sizeofEachElem);
                        showValues(base,nElem,sizeofEachElem,fptr);
                }
 
        }


}


void freeHeapMem(STUDENT ** ptr, int size)
{
int i = 0;
        for(i = 0 ; i < size ; i++)
        {
                free(*(ptr + i));
        }
  

}


int main(int argC, char * argV[])
{

  // seed value provided as command-line arg.
  srand(atoi(argV[1]));

  // rand % 8 just evaluates to an int from 0 to 7, gets added to num < 1 to get a "random" double

  double myDouble []={ rand()%8 + .2, rand()%8 +  .3, rand()%8 +  .7, rand()%8 +  .5, rand()%8 +  .6,
                       rand()%8 + .4, rand()%8 +  .1, rand()%8 +  .2, rand()%8 +  .3, rand()%8 +  .4};




  // produce "random" student info
  STUDENT sArray [] ={ {rand()%1000, rand()%4 + .3}, {rand()%1000, rand()%4 + .9}, {rand()%1000, rand()%4 + .5}, {rand()%1000, rand()%4 + .7},
                       {rand()%1000, rand()%4 + .1}, {rand()%1000, rand()%4 + .8}, {rand()%1000, rand()%4 + .5}, {rand()%1000, rand()%4 + .9},
                       {rand()%1000, rand()%4 + .3}, {rand()%1000, rand()%4 + .7}};



 
  STUDENT * ptrArray[10];

  int i;
  for(i =0; i <10; i++)
    {
      ptrArray[i] = (STUDENT *)malloc(sizeof(STUDENT));
      ptrArray[i]-> id = sArray[i].id  + 1;
      ptrArray[i]->gpa = sArray[i].gpa + .1;

    }

  printf("---------------------------------------\n");
  printf("Print index 5 of each array\n");
  printDouble(&myDouble[5]);
  printStudent(&sArray[5]);
  printStudentPtr(&ptrArray[5]);

  printf("\n---------------------------------------\n");
  printf("Print all elements by calling the showValues on myDouble\n");
  showValues(myDouble, 10, sizeof(double), &printDouble);
  printf("\n---------------------------------------\n");
  printf("Print all elements by calling the showValues on printStudent\n");
  showValues(sArray, 10, sizeof(STUDENT), &printStudent);
  printf("\n---------------------------------------\n");
  printf("Print all elements by calling the showValues on printStudentPtr\n");
  showValues(ptrArray, 10, sizeof(STUDENT *), &printStudentPtr);

  printf("\n---------------------------------------\n");
  printf("Selection Sort on myDouble\n");
  selectionSort(myDouble, 10, sizeof(double), &cmpDouble, &printDouble);


  printf("\n---------------------------------------\n");
  printf("Selection Sort on sArray\n");
  selectionSort(sArray, 10, sizeof(STUDENT), &cmpStudent, &printStudent);


  printf("\n---------------------------------------\n");
  printf("Selection Sort on ptrArray\n");
  selectionSort(ptrArray, 10, sizeof(STUDENT *), &cmpStudentPtr, &printStudentPtr);




  freeHeapMem(ptrArray, 10);

  return 0;

}
