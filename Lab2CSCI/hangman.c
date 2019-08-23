/*
Karishma Kapur
2/6/19
hangman.c
program to get a random word from a txt file
and prompt the user to guess a letter
until the random word has been fully spelled
or the word hangman has been filled completely.
*/

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <time.h>
#include <string.h>
#include <wiringPi.h>


////////////////////////////////////////////////////////////////
////////////  Displaying Directions to User  ///////////////////
///////////////////////////////////////////////////////////////
void displayDirections()
{
  printf("Hi, Welcome to HANGMAN.\n");
  printf("In this game, I will generate a random word for you,\n");
  printf("and you will continue to guess letters until either\n");
  printf("you complete the random word, OR HANGMAN");
  printf("is completely spelled out.\n");
  printf("Each time you guess incorrectly, an LED light on the raspberry");
  printf("pi will blink.\n");
  printf("If HANGMAN is completely spelled out before you finish ");
  printf("spelling the word, youlose.\n");

}
////////////////////////////////////////////////////////////////
///////  Printing Amount Of Letters In Word As Dashes  ////////
//////////////////////////////////////////////////////////////
void printWordDashes(char randomWord[], char currentUserGuessWord[])
{
  int i = 0;
  while(i != (strlen(randomWord)))
  {
    strcat(currentUserGuessWord, "-");
    i++;
  }
  printf("Here is your word: %s\n\n", currentUserGuessWord);
}
////////////////////////////////////////////////////////////////
////  Exhanging the \n character from randomWord for \0  ///////
///////////////////////////////////////////////////////////////
void exchangeNullChar(char randomWord[])
{
 //looping through randomWord to get rid of \n and exchange for \0
  for(int i = 0; i < strlen(randomWord); i++)
  {
    if(randomWord[i] == '\n')
    {
      randomWord[i] = '\0';
    }
  }
}
////////////////////////////////////////////////////////////////
////////////  Checking to see if User Guessed right  ///////////
///////////////////////////////////////////////////////////////
void checkCorrectGuess(char randomWord[], char *userGuessLetter, char currentUserGuessWord[])
{
   for(int j = 0; j < strlen(randomWord); j++) //loop to go through word
   {
      //checking to see if user got a correct guess
      if(userGuessLetter[0] == randomWord[j])//if guess is correct
      {
         int pos = j; //position so I know where to add letter in userGuessWord
         currentUserGuessWord[pos] = userGuessLetter[0];//add to the users word
      }//end of if block
   }//end of for loop
}
////////////////////////////////////////////////////////////////
////////////////////// LED Light ///////////////////////////////
////////////////////////////////////////////////////////////////
void turnOnLED()
{
        pinMode(0, OUTPUT); //will send the signal out whenever we want
        digitalWrite(0, LOW);   //led on
        printf("led on\n");
        delay(5000);                         // wait 5 sec
        digitalWrite(0, HIGH);  //led off
        printf("led off\n");
}

////////////////////////////////////////////////////////////////
////////////  Checking to see if user guessed wrong  //////////
///////////////////////////////////////////////////////////////
int checkIfIncorrectGuess(char currentUserGuessWord[], char previousGuessWord[], char hangman[],
			 char hangmanActualWord[], int amountOfIncorrectGuesses)
{
   //if guess is wrong, add a letter from HANGMAN to variable
   if(strcmp(currentUserGuessWord, previousGuessWord) == 0)
   {
      hangman[amountOfIncorrectGuesses] = hangmanActualWord[amountOfIncorrectGuesses];
      amountOfIncorrectGuesses++;
      turnOnLED();
   }//end of if block

   strcpy(previousGuessWord, currentUserGuessWord);
   return amountOfIncorrectGuesses;
}
////////////////////////////////////////////////////////////////
//////////  Printing updated HANGMAN and game word  ///////////
///////////////////////////////////////////////////////////////
void printCurrentGamePosition(char currentUserGuessWord[], char hangman[])
{
   printf("Your hangman string is \"%s\"\n", hangman); //printing to user their "HANGMAN" word
   printf("Here is your current word: %s\n\n", currentUserGuessWord); //showing user their guesses in the word
}
////////////////////////////////////////////////////////////////
////////////  Asking User if they want to play /////////////////
///////////////////////////////////////////////////////////////
char askUserPlay(char playgame)
{
   //asking user if they want to play
   printf("\nPlease enter y/n if you would like to play:\n");
   playgame = getchar();
   tolower(playgame);
   return playgame;
}
////////////////////////////////////////////////////////////////
////////////////////////  Opening file/ ////////////////////////
///////////////////////////////////////////////////////////////
FILE * openFile(FILE *filePtr)
{
  filePtr = fopen("dictionary.txt", "r"); //opening file

  if(filePtr != NULL)
  {
    return filePtr;
  }
  else //cannot open file
  {
    printf("Error opening file");
    exit(1);
  }
}
////////////////////////////////////////////////////////////////
////////////  Checking if user won or lost  ///////////////////
///////////////////////////////////////////////////////////////
void winOrLose(char hangman[], char hangmanActualWord[], char currentUserGuessWord[], char randomWord[])
{
   if(strcmp(hangman, hangmanActualWord) == 0)
   {
     printf("You lost\n");
   }
   else if(strcmp(currentUserGuessWord, randomWord) == 0)
   {
     printf("You won\n");
   }
}
////////////////////////////////////////////////////////////////
///////////////////  Reading from file ////////////////////////
///////////////////////////////////////////////////////////////
void readFile(FILE *filePtr,int randomNumber, char randomWord[], const int MAX_SIZE)
{
  if(filePtr != NULL) //checking to see if the file is not empty
  {
    for(int i = 1; i <= randomNumber; i++)
    {
       fgets(randomWord, MAX_SIZE, filePtr); //reading file
    }
  }
}
////////////////////////////////////////////////////////////////
//////  If user chooses to play game, then play game  /////////
///////////////////////////////////////////////////////////////
void playGame(int randomNumber, FILE *filePtr, char randomWord[], const int MAX_SIZE)
{
    randomNumber = rand() % 10 + 1; //generating random number

    filePtr = openFile(filePtr);

    readFile(filePtr, randomNumber, randomWord, MAX_SIZE);

    fclose(filePtr); //closing file

    exchangeNullChar(randomWord); //calling function to switch \n with \0

    //variables for game
    char hangman[8] = "";
    char hangmanActualWord[8] = "HANGMAN";
    char currentUserGuessWord[50] = "";
    char previousGuessWord[50] = "";
    char userGuessLetter[1];
    int amountOfIncorrectGuesses = 0;

    printWordDashes(randomWord, currentUserGuessWord); //print out the dashes for the word

    strcpy(previousGuessWord, currentUserGuessWord); //copying currentUserGuessWord to previousGuessWord

    //while loop to see if the game is over (meaning HANGMAN is completely
    //spelled out or the user guessed the word. But using AND operator
    //because 1 condition has to be false, and the while loop ends.
    while((strcmp(currentUserGuessWord, randomWord) != 0) & (strcmp(hangman, hangmanActualWord) != 0))
    {
      printf("Please enter a letter: "); //asking user for guess
      scanf("%s", userGuessLetter); //putting user guess into a variable
      tolower(userGuessLetter[0]); //making guess lowercase

      checkCorrectGuess(randomWord, userGuessLetter, currentUserGuessWord);
      amountOfIncorrectGuesses = checkIfIncorrectGuess(currentUserGuessWord, previousGuessWord, hangman, hangmanActualWord, amountOfIncorrectGuesses);
      printCurrentGamePosition(currentUserGuessWord, hangman);
   }//end of while loop
   winOrLose(hangman, hangmanActualWord, currentUserGuessWord, randomWord);
}
////////////////////////////////////////////////////////////////
////////////  If user does not want to play///  ////////////////
///////////////////////////////////////////////////////////////
void noPlayGame()
{
  //user does not want to play
  printf("okay, bye\n");

}

//////////////////////////////////////////////////////////////////////
////////////////////////  MAIN FUNCTION //////////////////////////////
int main()
{
  wiringPiSetup(); //initialize wiringPi for later use when user
		   // enters wrong answer
  displayDirections(); //calling function to display directions
  char playgame = askUserPlay(playgame); //asking user if they want to play game

  //seeding time, so each time I run the program a new random number gets generated
  srand(time(NULL));

  //variables
  int randomNumber = 0;
  FILE *filePtr;
  const int MAX_SIZE = 50;
  char randomWord[MAX_SIZE];

  //if the user wants to play, then enter the if statement
  if(playgame == 'y')
  {
    playGame(randomNumber, filePtr, randomWord, MAX_SIZE);
  }//end of if block that checks if user wants to play
  else //user does not want to play
  {
     noPlayGame();
  }//end of else block where user does not want to play
  return 0;
}//end of main
