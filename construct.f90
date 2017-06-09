
module construct
    implicit none
    include 'mpif.h'

    public :: MPI_WALKER_TYPE, walkunit, create_walker_type

    integer :: MPI_WALKER_TYPE    
    type :: walkunit
        integer :: index
        integer :: position
        integer :: maxstep
    end type walkunit

contains

    subroutine create_walker_type()
        implicit none
        integer :: lblock(3) = (/ 1, 1, 1 /)
        integer :: types(3) = (/ MPI_INTEGER, MPI_INTEGER, MPI_INTEGER /)
        integer(kind=MPI_ADDRESS_KIND) :: offsets(3), intoffset, lowerbound
        integer :: ierr
        
        call MPI_Type_Get_Extent(MPI_INTEGER, lowerbound, intoffset)
        offsets(1) = 0
        offsets(2) = intoffset
        offsets(3) = 2 * intoffset
        ! offsets(1) = 0
        ! offsets(2) = sizeof(ierr)
        ! offsets(3) = sizeof(ierr) * 2

        call MPI_Type_Create_Struct(3, lblock, offsets, types, MPI_WALKER_TYPE, ierr)
        call throw_mpi(ierr)
        call MPI_Type_Commit(MPI_WALKER_TYPE, ierr)
        call throw_mpi(ierr)
    end subroutine create_walker_type

    subroutine throw_mpi(ierr)
        implicit none
        integer :: ierr
        if (ierr /= 0) then
            call MPI_Abort(MPI_COMM_WORLD, ierr, ierr)
        endif
    end subroutine throw_mpi

end module construct
