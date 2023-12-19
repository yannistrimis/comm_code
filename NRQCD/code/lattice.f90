! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
!
! lattice.f90
!
! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 module lattice

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
!
! This module manages gauge fields.
! The initial fields are read from disk in ILDG format.
! Tadpole factors are computed here.
! Stout link smearing is also available here.
!
! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    use userparameters
    implicit none
    private

! Define access to subroutines.
    public :: nbhd

 contains

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 subroutine nbhd(bwdnbr,fwdnbr)
! Define nearest neighbours of each lattice site.
! OUTPUT:
!   bwdnbr(mu,i) is the neighbour of site i in the -mu direction.
!   fwdnbr(mu,i) is the neighbour of site i in the +mu direction.

    integer(kind=KI), intent(out), dimension(:,:) :: bwdnbr, fwdnbr

    integer(kind=KI) :: ixyzt, ix, iy, iz, it, iybit, izbit, itbit

    ixyzt = 0
    do it = 1,nt
     itbit = nx*ny*nz*(it-1)
     do iz = 1,nz
      izbit = nx*ny*(iz-1)
      do iy = 1,ny
       iybit = nx*(iy-1)
       do ix = 1,nx
        ixyzt = ixyzt + 1
        fwdnbr(1,ixyzt) = modulo(ix,nx) + 1 + iybit + izbit + itbit
        fwdnbr(2,ixyzt) = ix + nx*modulo(iy,ny) + izbit + itbit
        fwdnbr(3,ixyzt) = ix + iybit + nx*ny*modulo(iz,nz) + itbit
        fwdnbr(4,ixyzt) = ix + iybit + izbit + nx*ny*nz*modulo(it,nt)
        if (ix==1) then
         bwdnbr(1,ixyzt) = nx + iybit + izbit + itbit
        else
         bwdnbr(1,ixyzt) = ix - 1 + iybit + izbit + itbit
        endif
        if (iy==1) then
         bwdnbr(2,ixyzt) = ix + nx*(ny-1) + izbit + itbit
        else
         bwdnbr(2,ixyzt) = ix + nx*(iy-2) + izbit + itbit
        endif
        if (iz==1) then
         bwdnbr(3,ixyzt) = ix + iybit + nx*ny*(nz-1) + itbit
        else
         bwdnbr(3,ixyzt) = ix + iybit + nx*ny*(iz-2) + itbit
        endif
        if (it==1) then
         bwdnbr(4,ixyzt) = ix + iybit + izbit + nx*ny*nz*(nt-1)
        else
         bwdnbr(4,ixyzt) = ix + iybit + izbit + nx*ny*nz*(it-2)
        endif
       enddo ! ix
      enddo ! iy
     enddo ! iz
    enddo ! it

 end subroutine nbhd

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 end module lattice

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
