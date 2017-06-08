FC = mpifort

FCFLAGS = -g -fcheck=all -Wall

PROGRAMS = walker
MODULES = construct
RUN = walker

all: $(PROGRAMS)

%: %.o
	$(FC) $(FCFLAGS) -o $@ $^ $(MODULES)

%.o: %.f90
	$(FC) $(FCFLAGS) -c $<



.PHONY: clean aclean run

clean:	
	rm -f *.o *.mod

aclean:
	rm -f $(PROGRAMS)

run: $(RUN)
	mpirun -n 4 $(RUN)