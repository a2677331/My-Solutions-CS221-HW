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
//		 This function is called by the GCD procedure
//		 in assembly language file HYBGCD.ASM
//		 and by C++ main program in file HYBCLAB.CPP
//
//******************************************************

#include <iostream.h>
// #include <iomanip.h>

// Function Prototypes: function to print the value of its integer parameter
extern "C" void PrnIPar(int v); // 记得要加extern “C”, 用于main链接到这个PrnIPar function。
// extern “C”强制该函数具有外部链接。

// Definition
extern "C"
void PrnIPar(int v)
{   cout << v << endl;
    return;
  }
