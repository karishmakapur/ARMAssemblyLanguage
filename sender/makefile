client.o: client.c read_huffman.o read_message.o search_hcode.o sort_hcode.o encode.o check_space.o
	gcc -g -o client client.c read_huffman.o read_message.o search_hcode.o sort_hcode.o encode.o check_space.o

read_huffman.o: read_huffman.s
	as --gstabs -o read_huffman.o read_huffman.s

read_message.o: read_message.s
	as --gstabs -o read_message.o read_message.s

search_hcode.o: search_hcode.s
	as --gstabs -o search_hcode.o search_hcode.s

sort_hcode.o: sort_hcode.s
	as --gstabs -o sort_hcode.o sort_hcode.s

encode.o: encode.s
	as --gstabs -o encode.o encode.s

check_space.o: check_space.s
	as --gstabs -o check_space.o check_space.s

clean:
	rm -f *.o
