//*****************************************************
//
// Programmer:   Your name
// Instructor:   T.Dutta
// Course:       CS 221
// Date:	 Mar 20th, 2020
// Program File: HYBCFTN.CPP
// Input Files:  None
// Output Files: None
// Classes Used: iostream, iomanip
// Purpose:	 This file contains a C++ function that prints
//		 the value of its integer parameter.
//
//		 This function is called by the GCD procedure
//		 in assembly language file HYBGCD.ASM
//		 and by C++ main program in file HYBCLAB.CPP
//
//******************************************************

#include <iostream.h>
// #include <iomanip.h>

// Function Prototypes:

// Function to print the value of its integer parameter
extern "C" void PrnIPar(int v);

extern "C"
void PrnIPar(int v)
{   cout << v << endl;
    return;
  }
