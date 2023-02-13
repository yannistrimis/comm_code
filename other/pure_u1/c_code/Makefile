FILES.c = control.c utils.c action.c
FILES.h = lattice.h utils.h action.h
FILES.o = ${FILES.c:.c=.o}

pure_u1 : $(FILES.o)
	gcc -o pure_u1 $(FILES.o) -lm

$(FILES.o) : $(FILES.h)
 
.PHONY : clean
clean :
	rm -r pure_u1 $(FILES.o)