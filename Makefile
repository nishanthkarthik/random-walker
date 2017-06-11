# Compiler
FC = mpifort
CC = gcc
FCFLAGS = -ggdb -fcheck=all -Wall

# Program
PROGRAMS = walker
MODULES = construct.mod extbind.mod
EXTC = ext.c
RUN = ./walker

# MPI
NCORES = 3

OBJ = $(patsubst %.f90, %.o, $(wildcard *.f90))
EXTCOBJ = $(patsubst %.c, %.o, $(EXTC))

all: ext $(MODULES) $(PROGRAMS)

%: %.o $(OBJ)
	$(FC) $(FCFLAGS) -o $@ $^ $(EXTCOBJ)

%.o %.mod: %.f90
	$(FC) $(FCFLAGS) -c $<

ext: 
	$(CC) -c $(EXTC)

.PHONY: clean aclean run

clean:	
	rm -f *.o *.mod

aclean:
	rm -f $(PROGRAMS)

run: $(RUN)
	mpirun -n $(NCORES) $(RUN)

drun: $(RUN)
	mpirun -n $(NCORES) valgrind $(RUN)