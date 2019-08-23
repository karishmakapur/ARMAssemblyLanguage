//client.c source file
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <netinet/in.h>
//#include <signal.h>

#define PORT 8080
#define SA struct sockaddr

typedef struct
{ // typedef structure
    char letter;
    int code[12];
    int size;
} huffcode; // struct used to store huffman code

extern int read_huffman(FILE * fptr, huffcode hcode[]);
extern int read_message(FILE * fptr, char message[]);
extern int encode(char message[], huffcode hcode[], int socketFp);
extern int sort_hcode(huffcode hcode[]); //FOR DEBUGGING
extern int decoder(int encoded_int, huffcode hcode[], int * current_char, char d_message[]); // FOR DEBUGGING


int main(int argc, char *argv[]){
	FILE *fptr; //file pointer
	huffcode hcode[29]; //array used to store huffman code
	char message[10000];
	int messageLength = 0;

	//signal(SIGPIPE, SIG_IGN);  // ignore SIGPIPE error

	//create socket
	int socketFp = socket(AF_INET, SOCK_STREAM, 0);
        struct sockaddr_in address, serverAddress;

        serverAddress.sin_family = AF_INET;
        serverAddress.sin_port = htons(PORT);
        serverAddress.sin_addr.s_addr = inet_addr("127.0.0.1");

	//trying to connect to the other port
        if(connect(socketFp, (SA *)&serverAddress, sizeof(serverAddress)) != 0)
	{
                printf("connection failed..\n");
                exit(0);
        }



	//open huffman.dat file
	if (argc == 1)
	{
		fptr = fopen("huffman.dat", "r");
	}
	else
	{
		fptr = fopen(argv[1], "r");
	}

	//read huffman code from file and store into hcode array of structs
	read_huffman(fptr, hcode);

	//close huffman.dat file
	fclose(fptr);

	//open the message to be encoded
	fptr = fopen("message.txt", "r");

	//read message and store message into message array
	messageLength = read_message(fptr, message);

	//close message.txt file
	fclose(fptr);

	//printing the original message
	printf("\nOriginal message:\n");
	for(int i = 0; i < messageLength; ++i)
	{
		printf("%c", message[i]);
	}

	//encoding and sending the message
	printf("\n\nInt packets are being sent\n");
	encode(message, hcode, socketFp);

        close(socketFp);
}
