//sender.c source file
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define PORT 8080
#define SA struct sockaddr

typedef struct
{ // typedef structure
    char letter;
    int code[12];
    int size;
} huffcode; // struct used to store huffman code


extern int decoder(int encoded_int, huffcode hcode[], int * current_char, char d_message[]);
extern int read_huffman(FILE * fptr, huffcode hcode[]);

int main(int argc, char *argv[]){
	FILE *fptr; //file pointer
	huffcode hcode[29];
	int current_char = 0;
	char d_message[10000];
	int code;

        int socketFp = socket(AF_INET, SOCK_STREAM, 0);

	if (argc == 1)
	{
		fptr = fopen("huffman.dat", "r");
   	}
   	else
	{ // else open the string file name given as an argument to main
        	fptr = fopen(argv[1], "r");
    	}
    	// read the huffman code from the file and store huffman code into hcode$
    	read_huffman(fptr, hcode);
    	fclose(fptr); //close "huffman.dat"
        sort_hcode(hcode);

        if(socketFp == -1){
                printf("Socket not made..\n");
                exit(0);
        }

        struct sockaddr_in address;

        address.sin_family = AF_INET;
        address.sin_addr.s_addr = INADDR_ANY;
        address.sin_port = htons(PORT);

        if((bind(socketFp, (SA *)&address , sizeof(address))) != 0){
                printf("Binding failed..\n");
                exit(0);
        }

        if((listen(socketFp, 3)) != 0){
                printf("Listen failed..\n");
                exit(0);
        }

        int addrLen = sizeof(address);

        int new_socket = accept(socketFp, (SA *)&address, (socklen_t *)&addrLen);

        if(new_socket < 0){
                        printf("Accept failed..\n");
                        exit(0);
        }

        while(read(new_socket, &code, sizeof(code))) {
        	printf("%u\n", code);
        	decoder(code, hcode, &current_char, d_message);
        }
	

	printf("\nDecoding message\n");

	printf("\nThe decoded message is:\n");


	for(int i = 0; i < 200; i++)
	{
		printf("%c", d_message[i]);
	}

	printf("\n\n");
        close(socketFp);
}
