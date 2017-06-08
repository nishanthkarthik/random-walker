FC = mpifort

FCFLAGS = -ggdb -fcheck=all -Wall

PROGRAMS = walker
MODULES = construct.mod
RUN = walker

OBJ = $(patsubst %.f90, %.o, $(wildcard *.f90))

all: $(MODULES) $(PROGRAMS)

%: %.o $(OBJ)
	$(FC) $(FCFLAGS) -o $@ $^

%.o %.mod: %.f90
	$(FC) $(FCFLAGS) -c $<

.PHONY: clean aclean run

clean:	
	rm -f *.o *.mod

aclean:
	rm -f $(PROGRAMS)

run: $(RUN)
	mpirun -n 2 $(RUN)