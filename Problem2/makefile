CC = gcc
CFLAGS = -g -Wall


problem2: main.o checkPrimeNumber.o
	$(CC) $(CFLAGS) -o problem2 main.o checkPrimeNumber.o

main.o: main.s
	$(CC) $(CFLAGS) -c -o main.o main.s

checkPrimeNumber.o: checkPrimeNumber.c
	$(CC) $(CFLAGS) -c -o checkPrimeNumber.o checkPrimeNumber.c

clean:
	rm -f *.o 
