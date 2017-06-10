program walker
    use construct
    use decomposer
    implicit none
    
    integer :: world, rank, ierr, status(MPI_STATUS_SIZE)
    integer :: l, u, nwk = 1, i
    type(walkunit) :: wk
    
    call MPI_Init()
    call MPI_Comm_Size(MPI_COMM_WORLD, world)
    call MPI_Comm_Rank(MPI_COMM_WORLD, rank)

    call create_walker_type()

    call getbounds(rank, world, l, u)
    print *, rank, 'has bounds', '(', l, u, ')'

    if (rank == 0) then
        call setwalker(wk, 0, 1, 10)
    endif

    do i = 1, nwk
        if (rank > 0) then
            call MPI_Recv(wk, 1, MPI_WALKER_TYPE, rank-1, 0, MPI_COMM_WORLD, status, ierr)
            print *, rank, 'recv', wk%index, wk%position
            call throw_mpi(ierr)
        endif

        call walk(wk, l, u)
        print *, rank, 'walk to', wk%position
        
        if ((rank+1) < world) then
            print *, rank, 'send', wk%index, wk%position
            call MPI_Send(wk, 1, MPI_WALKER_TYPE, rank+1, 0, MPI_COMM_WORLD, ierr)
            call throw_mpi(ierr)
        endif

    enddo

    ! if (rank == 0) then
    !     wk%index = 100
    !     wk%position = 200
    !     wk%maxstep = 300
    !     call MPI_Send(wk, 1, MPI_WALKER_TYPE, 1, 0, MPI_COMM_WORLD, ierr)
    ! else if (rank == 1) then
    !     call MPI_Recv(wk, 1, MPI_WALKER_TYPE, 0, 0, MPI_COMM_WORLD, status, ierr)
    !     print *, wk%index, wk%position, wk%maxstep
    ! endif

    call MPI_Finalize()

end program walker
