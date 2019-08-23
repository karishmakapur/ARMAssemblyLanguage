server.o: server.c read_huffman.o search_hcode.o sort_hcode.o decoder.o check_space.o led.c
	gcc -g -o server server.c read_huffman.o search_hcode.o sort_hcode.o decoder.o check_space.o led.c -lwiringPi

read_huffman.o: read_huffman.s
	as --gstabs -o read_huffman.o read_huffman.s

search_hcode.o: search_hcode.s
	as --gstabs -o search_hcode.o search_hcode.s

sort_hcode.o: sort_hcode.s
	as --gstabs -o sort_hcode.o sort_hcode.s

decoder.o: decoder.s
	as --gstabs -o decoder.o decoder.s

check_space.o: check_space.s
	as --gstabs -o check_space.o check_space.s

clean:
	rm -f *.o
