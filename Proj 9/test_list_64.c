// test_list_64.c   simple use of "list" functions
// function prototypes for functions to be written in assembly language:
#include "list_64.h"
#include <stdio.h> // for debug

// The assembly language program must be in a single file  list_64.asm    
// The following sequence of commands must run correctly on linux.gl
// nasm -g -f elf64 -l list_64.lst  list_64.asm
// gcc -g3 -m64 -o test_list_64  test_list_64.c  list_64.o
// ./test_list_64  test_list_64.out
// cat test_list_64.out
// partial credit based on how far it executes before segfault or error  

int main()
{
  long int L1[2];        // allocate space for two pointers for list L1 
  long int L2[2];        // allocate space for two pointers for list L2 
  char hello[]="Hello";  // just a string for use later 

  printf("test_list_64.c running, testing list_64.asm \n");
  L1[0] = 5;
  L1[1] = 6;
  clear(L1);             // address of L1, space for two pointers
  printf("clear set L1[0]=%ld, L1[1]=%ld \n", L1[0], L1[1]); 

  print(L1);             // should print blank line 
  push_back(L1,"front");
  printf("did push_back L1[0]=%ld, L1[1]=%ld \n", L1[0], L1[1]); // debug
  print(L1);             // 25% of project credit  
  printf("back from print, front \n"); // debug
  push_back(L1,"middle");
  printf("did 2nd push_back L1[0]=%ld, L1[1]=%ld \n", L1[0], L1[1]); // debug
  print(L1);
  printf("back from print, front,middle \n"); // debug
  push_back(L1,"last");
  printf("did 3rd push_back L1[0]=%ld, L1[1]=%ld \n", L1[0], L1[1]); // debug
  print(L1);             // 50% of project credit 

  clear(L2);             // another list, its own two pointers
  printf("clear L2 L2[0]=%ld, L2[1]=%ld \n", L2[0], L2[1]); 
  push_front(L2, "end");
  printf("did push_front L2[0]=%ld, L2[1]=%ld \n", L2[0], L2[1]); // debug
  print(L2);
  push_front(L2, "center");
  printf("did push_front center L2[0]=%ld, L2[1]=%ld \n", L2[0], L2[1]); // debug
  push_front(L2, "start");
  printf("did push_front start L2[0]=%ld, L2[1]=%ld \n", L2[0], L2[1]); // debug
  print(L2);             // 75% of project credit 
  
  printf("do pop_front(L1) \n");
  pop_front(L1);         // removes first item on list L1 
  printf("did pop_front L1[0]=%ld, L1[1]=%ld \n", L1[0], L1[1]); // debug

  printf("do pop_back(L1) \n");
  pop_back(L1);          // removes last item on list
  printf("did pop_back L1[0]=%ld, L1[1]=%ld \n", L1[0], L1[1]); // debug

  printf("do print(L1) \n"); 
  print(L1);             // 90% of project credit 

  push_front(L1, hello);
  hello[0]='g';
  hello[1]='o';
  hello[2]='o';
  hello[3]='d';
  hello[4]=' ';
  push_back(L2, hello);
  print(L1);
  print(L2);             // 100% of project credit 

  return 0;
}
// Output of this program is:
/*
test_list_64.c running, testing list_64.asm 
clear set L1[0]=0, L1[1]=0 
did push_back L1[0]=1, L1[1]=1 
front

back from print, front 
did 2nd push_back L1[0]=1, L1[1]=4 
front
middle

back from print, front,middle 
did 3rd push_back L1[0]=1, L1[1]=7 
front
middle
last

clear L2 L2[0]=0, L2[1]=0 
did push_front L2[0]=10, L2[1]=10 
end

did push_front center L2[0]=13, L2[1]=10 
did push_front start L2[0]=16, L2[1]=10 
start
center
end

do pop_front(L1) 
did pop_front L1[0]=4, L1[1]=7 
do pop_back(L1) 
did pop_back L1[0]=4, L1[1]=4 
do print(L1) 
middle

Hello
middle

start
center
end
good 
*/