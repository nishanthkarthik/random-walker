program walker
    use construct
    use decomposer
    use extbind
    implicit none
    
    integer :: world, rank, ierr, status(MPI_STATUS_SIZE)
    integer :: l, u, i, nwk = 10
    type(walkunit) :: wk
    type(walkunit), allocatable :: wks(:)

    call MPI_Init()
    call MPI_Comm_Size(MPI_COMM_WORLD, world)
    call MPI_Comm_Rank(MPI_COMM_WORLD, rank)

    call create_walker_type()

    call getbounds(rank, world, l, u)
    print *, rank, 'has bounds', '(', l, u, ')'

    if (rank == 0 .or. rank == (world - 1)) then
        allocate(wks(nwk))
    endif

    if (rank == 0) then
        do i =1, nwk
            call setwalker(wks(i), 0, 1, 20)
            call walk(wks(i), l, u)
            print *, rank, 'walk to', wks(i)%position
            print *, rank, 'send', wks(i)%index, wks(i)%position
            call MPI_Send(wks(i), 1, MPI_WALKER_TYPE, rank+1, 0, MPI_COMM_WORLD, ierr)
            call throw_mpi(ierr)
        enddo
    else if (rank == (world - 1)) then
        do i =1, nwk
            call MPI_Recv(wks(i), 1, MPI_WALKER_TYPE, rank-1, 0, MPI_COMM_WORLD, status, ierr)
            print *, rank, 'recv', wks(i)%index, wks(i)%position
            call throw_mpi(ierr)
            call walk(wks(i), l, u)
            print *, rank, 'walk to', wks(i)%position
        enddo
    else
        do i =1, nwk
            call MPI_Recv(wk, 1, MPI_WALKER_TYPE, rank-1, 0, MPI_COMM_WORLD, status, ierr)
            print *, rank, 'recv', wk%index, wk%position
            call throw_mpi(ierr)

            call walk(wk, l, u)
            print *, rank, 'walk to', wk%position

            print *, rank, 'send', wk%index, wk%position
            call MPI_Send(wk, 1, MPI_WALKER_TYPE, rank+1, 0, MPI_COMM_WORLD, ierr)
            call throw_mpi(ierr)
        enddo
    endif


    if (rank == 0 .or. rank == (world - 1)) then
        if (allocated(wks)) then
            deallocate(wks)
        endif
    endif

    call nop_inline(int(100, 8))

    ! call free_walker_type()
    ! print *, 'hello'
    ! call sleep(1)

    print *, allocated(wks)

    call MPI_Finalize()

end program walker
