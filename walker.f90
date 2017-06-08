program walker
    use construct
    implicit none
    integer :: world, rank, ierr, status(MPI_STATUS_SIZE)
    type(walkunit) :: wk
    call MPI_Init()
    call MPI_Comm_Size(MPI_COMM_WORLD, world)
    call MPI_Comm_Rank(MPI_COMM_WORLD, rank)
    
    call create_walker_type()

    if (rank == 0) then
        wk%index = 100
        wk%position = 200
        wk%maxstep = 300
        call MPI_Send(wk, 1, MPI_WALKER_TYPE, 1, 0, MPI_COMM_WORLD, ierr)
    else if (rank == 1) then
        call MPI_Recv(wk, 1, MPI_WALKER_TYPE, 0, 0, MPI_COMM_WORLD, status, ierr)
        print *, wk%index, wk%position, wk%maxstep
    endif
    call MPI_Finalize()
end program walker