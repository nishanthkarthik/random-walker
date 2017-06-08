
module construct
    implicit none
    include 'mpif.h'

    public :: MPI_WALKER_TYPE, walkunit, create_walker_type

    integer :: MPI_WALKER_TYPE    
    type :: walkunit
        integer(8) :: index
        integer(8) :: position
        integer(4) :: maxstep
    end type walkunit

contains
    
    subroutine create_walker_type()
        implicit none
        include 'mpif.h'
        integer :: lblock(3) = (/ 1, 1, 1 /)
        integer :: types(3) = (/ MPI_INTEGER8, MPI_INTEGER8, MPI_INTEGER4 /)
        integer :: offsets(3), int8offset, lowerbound
        integer :: ierr
        
        call MPI_Type_Get_Extent(MPI_INTEGER8, lowerbound, int8offset)
        offsets(1) = 0
        offsets(2) = int8offset
        offsets(3) = 2 * int8offset

        call MPI_Type_Create_Struct(3, lblock, offsets, types, MPI_WALKER_TYPE, ierr)
        call MPI_Type_Commit(MPI_WALKER_TYPE, ierr)
        print *, MPI_WALKER_TYPE
    end subroutine create_walker_type

end module construct
