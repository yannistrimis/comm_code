FILES.c = control.c utils.c
FILES.h = lattice.h utils.h
FILES.o = ${FILES.c:.c=.o}

scalar : $(FILES.o)
	gcc -o scalar $(FILES.o) -lm

$(FILES.o) : $(FILES.h)
 
.PHONY : clean
clean :
	rm -r scalar $(FILES.o)
