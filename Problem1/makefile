CC = gcc
CFLAGS = -g -Wall


problem1: main.c checkPrimeNumber.o
	$(CC) $(CFLAGS) -o problem1 main.c checkPrimeNumber.o

checkPrimeNumber.o: checkPrimeNumber.s
	as --gstabs -o checkPrimeNumber.o checkPrimeNumber.s

clean:
	rm -f *.o 
