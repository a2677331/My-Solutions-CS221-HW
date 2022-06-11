//****************************************************
//
// Programmer:   
// Instructor:   T.Dutta
// Course:       CS 221
// Date:	 October 18,2019
// Program:	 Lab Exercise #5
// Program File: TEMPERATURE.CPP
// Input Files:  None
// Output Files: None
// Classes Used: iostream, iomanip
// Purpose:	 This program prompts the user for a fahrenheit
//		 temperature (integer), inputs the integer from the
//		 user, converts it to celsius, and outputs the
//		 celsius temperature.
//
//****************************************************

#include <iostream.h>
#include <iomanip.h>

void main()
{ // Function Prototypes:
     // Greet prints introductory messages to the user screen
     void Greet();
     // ComputeCelsius converts the fahrenheit temp to celsius
     void ComputeCelsius(int fahrenheit, int &celsius);

  // Variables used:
     int fahrenheit;       // Fahrenheit temperature
     int celsius;          // Celsius temperature

  // Main Program Code Section

     Greet();

     cout << "Enter an integer for the fahrenheit temperature: " ;
     cin >> fahrenheit;

     cout << endl << "The entered fahrentheit temperature is:  "
	  << fahrenheit << endl;

     ComputeCelsius(fahrenheit,celsius);

     cout << endl << "The equivalent celsius temperature is:  "
	  << celsius << endl;

     return;
  }

//****************************************************
//
// Function Name:  Greet
// Purpose:	This function prints introductory messages to
//		the user screen
// Parameters:  None
// Return Value:  None
// Non-Local Variables Used:  None
// Functions Called:  Stream insertion operator from iostream class.
//
//****************************************************
void Greet()
{
   cout << endl;
   cout << "This program converts a Fahrenheit temperature to Celsius" << endl;
   cout << "Programmer:  Your Name " << endl;
   cout << "Oct 18, 2019" << endl << endl;
   return;
}

//****************************************************
//
// Function Name:  ComputeCelsius
// Purpose:   This function converts the fahrenheit temperature to
//	      celsius, and returns the celsius temp via second parameter
// Parameters:
// 	Input Parameter: int fahr, the fahrenheit temp to be converted
//	Output Parameter: int &cels, the equivalent celsius temp
// Return Value:  None
// Non-Local Variables Used:  None
// Functions Called:  None
//
//****************************************************
void ComputeCelsius(int fahr, int &cels)
{
   cels = 5*(fahr-32)/9;
   return;
}
