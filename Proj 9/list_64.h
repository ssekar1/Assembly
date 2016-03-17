// list_64.h   simple use of "list" functions  called by "C"   
// function prototypes for functions to be written in assembly language: 
void clear(long int *L);               // initialize list to empty            
void print(long int *L);               // print the strings, one per line     
void push_front(long int *L, char *s); // put string s on front of list       
void push_back(long int *L, char *s);  // put string s on back of list        
void pop_front(long int *L);           // remove string from front of list    
void pop_back(long int *L);            // remove string from back of list     

// a complete package would allow sorting and insertion and
// deletion before and after a string, and preventing duplicates.