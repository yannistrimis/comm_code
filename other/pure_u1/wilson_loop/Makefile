FILES.c = control.c utils.c action.c
FILES.h = lattice.h utils.h action.h
FILES.o = ${FILES.c:.c=.o}

wloop : $(FILES.o)
	gcc -o wloop $(FILES.o) -lm

$(FILES.o) : $(FILES.h)
 
.PHONY : clean
clean :
	rm -r wloop $(FILES.o)