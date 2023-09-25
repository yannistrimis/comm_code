FILES.c = control.c utils.c measurements.c
FILES.h = lattice.h utils.h measurements.h
FILES.o = ${FILES.c:.c=.o}

wloop : $(FILES.o)
	gcc -o wloop $(FILES.o) -lm

$(FILES.o) : $(FILES.h)
 
.PHONY : clean
clean :
	rm -r wloop $(FILES.o)