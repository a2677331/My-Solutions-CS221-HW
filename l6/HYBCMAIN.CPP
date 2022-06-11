//****************************************************
//
// Programmer:   xxxxxxxxx
// Instructor:   T. Dutta
// Course:       CS 221
// Date:	 Mar. 20th, 2020
// Program:	 Lab Exercise #6
// Program File: HYBMAIN.CPP
// Input Files:  None
// Output Files: None
// Classes Used: iostream, iomanip
// Purpose:	 This program prompts the user for two positive integers
//		 inputs the integers from the user, finds the GCD of the
//		 two integers using the Euclidean Algorithm, and outputs
//		 the result to the user screen.
//		 This program is a hybrid of C++ and assembly language.
//		 The GCD procedure is in assembly language and the GCD
//		 procedure calls a C++ function.
//
//****************************************************

#include <iostream.h>
#include <iomanip.h>

// Function Prototypes:

// Greet prints introductory messages to the user screen
// Greet is an assembly language procedure
extern "C" void Greet();

// GCD computes the greatest common divisor of two integers
// GCD is an assembly language procedure
extern "C" void GCD(int x, int y, int &div);

// PrnIPar prints the value of its parameter
extern "C" void PrnIPar(int x);

void main()
{
  // Variables used:
     int x,y;       // Two integers
     int gcd;       // The greatest common divisor for the two integers

  // Main Program Code Section
     // Call Greet to display introductory messages to the user screen
     Greet();

     // Prompt the user for two integers and store them in variables
     cout << "Enter a positive integer: " ;
     cin >> x;

     cout << "Enter a positive integer: " ;
     cin >> y;

     // Print value of x and y by calling a C++ print function that is
     // also called from the assembly language procedure GCD
     cout << endl;
     cout << "Calling C++ print function from C++ main program" << endl;
     cout << "First integer:  " ;
     PrnIPar(x);
     cout << "Second integer:  " ;
     PrnIPar(y);

     cout << endl;

     // Call the GCD procedure to compute the GCD for x and y
     GCD(x,y,gcd);

     // Display the result returned from the GCD procedure
     cout << endl << "The greatest common divisor for the two integers:  "
	  << gcd << endl;

     return;
  }
