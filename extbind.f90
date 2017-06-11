module extbind
    
    interface
        subroutine nop_inline(n) bind(c, name="noop")
            use ISO_C_BINDING, only: c_long
            implicit none
            integer (c_long), value :: n
        end subroutine nop_inline
    end interface

end module extbind