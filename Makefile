# Compiler
FC = mpifort
FCFLAGS = -ggdb -fcheck=all -Wall

# Program
PROGRAMS = walker
MODULES = construct.mod
RUN = walker

# MPI
NCORES = 3

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
	mpirun -n $(NCORES) $(RUN)