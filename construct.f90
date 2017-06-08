
module construct
    implicit none
    include 'mpif.h'
    type :: unit
        integer(8) :: index
        integer(8) :: position
        integer(4) :: maxstep
    end type unit

contains
    
    subroutine create_walker_type()
        implicit none
        include 'mpif.h'
        integer :: nvars = 3
        integer :: lblock(3) = (/ 1, 1, 1 /)
        integer :: types(3) = (/ MPI_INTEGER8, MPI_INTEGER8, MPI_INTEGER4 /)
        integer :: MPI_WALKER_TYPE
        integer :: offsets(3)
        integer :: int8offset
        integer :: lowerbound
        
        call MPI_Type_Get_Extent(MPI_INTEGER8, lowerbound, int8offset)
        offsets(1) = 0
        offsets(2) = int8offset
        offsets(3) = 2 * int8offset

        call MPI_Type_Create_Struct(3, lblock, offsets, types, MPI_WALKER_TYPE)
        call MPI_Type_Commit(MPI_WALKER_TYPE)  
    end subroutine create_walker_type

end module construct

