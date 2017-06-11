
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

    subroutine free_walker_type()
        implicit none
        integer :: ie
        call MPI_Type_free(MPI_WALKER_TYPE, ie)
    end subroutine free_walker_type

    subroutine throw_mpi(ierr)
        implicit none
        integer :: ierr
        if (ierr /= 0) then
            call MPI_Abort(MPI_COMM_WORLD, ierr, ierr)
        endif
    end subroutine throw_mpi

    subroutine setwalker(wk, idx, pos, mxst)
        implicit none
        integer, intent(in) :: idx, pos, mxst
        type(walkunit), intent(out) :: wk
        wk%index = idx
        wk%position = pos
        wk%maxstep = mxst
    end subroutine setwalker

end module construct

module decomposer

    implicit none
    integer :: ngrid = 100

contains
    
    subroutine getbounds(rank, world, l, u)
        integer, intent(in) :: rank, world
        integer, intent(out) :: l, u
        integer :: seglength

        seglength = ngrid / world
        
        if (rank /= (world - 1)) then
            l = rank * seglength + 1
            u = (rank + 1) * seglength
        else
            l = ngrid - (world - 2) * seglength
            u = ngrid
        endif
    end subroutine getbounds
    
    subroutine walk(wk, l, u)
        use construct
        integer, intent(in) :: l, u
        real :: r
        type(walkunit), intent(inout) :: wk
        integer :: i

        if (wk%position < l) then
            call MPI_Abort(MPI_COMM_WORLD, i, i)
        endif

        do while (.TRUE.)
            call RANDOM_NUMBER(r)
            wk%position = wk%position + int(r * wk%maxstep)
            if (wk%position > u) then
                wk%index = wk%index + 1
                if (wk%position > ngrid) then
                    wk%position = ngrid
                endif
                exit
            endif
        enddo
    end subroutine walk

end module decomposer