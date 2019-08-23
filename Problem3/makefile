CC = gcc
CFLAGS = -g -Wall


problem3: main.o checkPrimeNumber.o
	$(CC) $(CFLAGS) -o problem3 main.o checkPrimeNumber.o

main.o: main.s
	$(CC) $(CFLAGS) -c -o main.o main.s

checkPrimeNumber.o: checkPrimeNumber.s
	$(CC) $(CFLAGS) -c -o checkPrimeNumber.o checkPrimeNumber.s

clean:
	rm -f *.o 
