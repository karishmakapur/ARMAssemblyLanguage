#include <stdio.h>
#include <stdlib.h>
#include <time.h>


int main(int argc, char *argv[])
{
    FILE *fp2 = fopen("gamelog.txt", "w"); //file pointer for gamelog
    if(fp2 == NULL)
    {
	printf("Could not open file to write gamelog");
	return 0;
    }
    int ncards = 52; //total number of cards in a deck
    FILE *fp; //file pointer
    int p1cards[13]= {0}; //array of cards p1
    int p2cards[13] = {0}; //array of cards p2
    int winner = 0; //1 = player1, 2 = player2
    int donep1 = 0; //1 = player1 is done
    int donep2 = 0; // 1 = player2 is done
    int p1numOfPairs = 0; //amount of pairs on hand
    int p2numOfPairs = 0; //amount of pairs on hand
    int cardsUsedp1 = 0; //amount of cards on hand
    int cardsUsedp2 = 0; //amount of cards on hand
    int cardsUsedTotal = 0; //total cards used

    if (argc > 1)
    {
        fp = fopen(argv[1], "w");
    }
    else
    {
        fp = fopen("deck", "w");
    }
    shuffle(fp);
    if (argc > 1)
    {
        fp = fopen(argv[1], "r");
    }
    else
    {
        fp = fopen("deck", "r");
    }
    //print to screen
    dealcards(fp, p1cards, p2cards);
    printf("Starting cards:\n");
    printf("         1  2  3  4  5  6  7  8  9 10 11 12 13\n");
    printf("P1start %2d %2d %2d %2d %2d %2d %2d %2d %2d %2d %2d %2d %2d\n", p1cards[0], p1cards[1], p1cards[2], p1cards[3], p1cards[4], p1cards[5], p1cards[6], p1cards[7], p1cards[8], p1cards[9], p1cards[10], p1cards[11], p1cards[12]);

    while(cardsUsedTotal < 52)
    {
//player1 plays
	//print to screen
	askcard_man(fp, p1cards, p2cards, fp2);
	printf("\nHere are your cards:\n");
	printf("         1  2  3  4  5  6  7  8  9 10 11 12 13\n");
	printf("P1Cards %2d %2d %2d %2d %2d %2d %2d %2d %2d %2d %2d %2d %2d\n", p1cards[0], p1cards[1], p1cards[2], p1cards[3], p1cards[4], p1cards[5], p1cards[6], p1cards[7], p1cards[8], p1cards[9], p1cards[10], p1cards[11], p1cards[12]);
	fprintf(fp2, "\n");

	donep1 = gameover(p1cards); //is there a winner yet?
	donep2 = gameover(p2cards);
        if(donep1 == 1 || donep2 == 1)
        {
	  //print to screen and file
       	  printf("\nPairs for player 1\n");
       	  fprintf(fp2, "\nPairs for player 1\n");
	  p1numOfPairs = laydowncards(fp, p1cards, fp2);
          printf("\nplayer 1 number of pairs %d\n", p1numOfPairs);
          fprintf(fp2, "\nplayer 1 number of pairs %d\n", p1numOfPairs);

          //print to screen
          printf("\nPairs for player 2\n");
          fprintf(fp2, "\nPairs for player 2\n");
          p2numOfPairs = laydowncards(fp, p2cards, fp2);
          printf("\nplayer 2 number of pairs %d\n", p2numOfPairs);
          fprintf(fp2, "\nplayer 2 number of pairs %d\n", p2numOfPairs);
          break;
        }

//player2 plays
	//print to screen
	askcards_auto(fp, p1cards, p2cards, fp2);
	printf("\nHere are your cards:\n");
	printf("         1  2  3  4  5  6  7  8  9 10 11 12 13\n");
	printf("P1Cards %2d %2d %2d %2d %2d %2d %2d %2d %2d %2d %2d %2d %2d\n", p1cards[0], p1cards[1], p1cards[2], p1cards[3], p1cards[4], p1cards[5], p1cards[6], p1cards[7], p1cards[8], p1cards[9], p1cards[10], p1cards[11], p1cards[12]);

	donep1 = gameover(p1cards);
	donep2 = gameover(p2cards);
	//print to screen
 	if(donep2 == 1 || donep1 == 1)
        {
	  //print to screen and file
          printf("\nPairs for player 1\n");
          fprintf(fp2, "\nPairs for player 1\n");
          p1numOfPairs = laydowncards(fp, p1cards, fp2);
          printf("\nplayer 1 number of pairs %d\n", p1numOfPairs);
          fprintf(fp2, "\nplayer 1 number of pairs %d\n", p1numOfPairs);

          //print to screen
          printf("\nPairs for player 2\n");
          fprintf(fp2, "\nPairs for player 2\n");
          p2numOfPairs = laydowncards(fp, p2cards, fp2);
          printf("\nplayer 2 number of pairs %d\n", p2numOfPairs);
          fprintf(fp2, "\nplayer 2 number of pairs %d\n", p2numOfPairs);
          break;
        }

//printing the hand to file after a whole turn (both player 1 and player 2)
	//print to file
	fprintf(fp2, "\nCards after hand:\n");
	fprintf(fp2, "         1  2  3  4  5  6  7  8  9 10 11 12 13\n");
	fprintf(fp2, "P1Cards %2d %2d %2d %2d %2d %2d %2d %2d %2d %2d %2d %2d %2d\n", p1cards[0], p1cards[1], p1cards[2], p1cards[3], p1cards[4], p1cards[5], p1cards[6], p1cards[7], p1cards[8], p1cards[9], p1cards[10], p1cards[11], p1cards[12]);
	fprintf(fp2, "P2Cards %2d %2d %2d %2d %2d %2d %2d %2d %2d %2d %2d %2d %2d\n\n", p2cards[0], p2cards[1], p2cards[2], p2cards[3], p2cards[4], p2cards[5], p2cards[6], p2cards[7], p2cards[8], p2cards[9], p2cards[10], p2cards[11], p2cards[12]);

	//print to file
        fprintf(fp2, "Pairs for player 1\n");

	//print to screen
        printf("\nPairs for player 1\n");
        p1numOfPairs = laydowncards(fp, p1cards, fp2);
        printf("\nplayer 1 number of pairs %d\n", p1numOfPairs);

	//print to file
        fprintf(fp2, "\nplayer 1 number of pairs %d\n", p1numOfPairs);
        fprintf(fp2, "\nPairs for player 2\n");

        //print to screen
        printf("\nPairs for player 2\n");
        p2numOfPairs = laydowncards(fp, p2cards, fp2);
        printf("\nplayer 2 number of pairs %d\n", p2numOfPairs);

	//print to file
	fprintf(fp2, "\nplayer 2 number of pairs %d\n", p2numOfPairs);

	//print to screen
	cardsUsedp1 = cardsAmt(p1cards);
	cardsUsedp2 = cardsAmt(p2cards);
	printf("CardsUsed = %d\n", (cardsUsedp1 + cardsUsedp2)); //cardsused printed out
	cardsUsedTotal = cardsUsedp1 + cardsUsedp2; //when there are 0 cards, end game

 	printf("==========================================================\n");

	fprintf(fp2, "==========================================================\n");
    }


    winner = calculateWinner(p1numOfPairs, p2numOfPairs);
    if(winner == 1)
    {
	//print to screen
	printf("Player 1 is the winner\n");

	//print to file "gamelog"
	fprintf(fp2, "Player 1 is the winner\n");
    }
    else if(winner == 2)
    {
	//print to screen
        printf("Player 2 is the winner\n");

        //print to file "gamelog"
        fprintf(fp2,"Player 2 is the winner\n");
    }
    fclose(fp);
    fclose(fp2);
    return 0;
}
