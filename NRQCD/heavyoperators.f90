! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
!
! heavyoperators.f90
!
! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 module heavyoperators

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
!
! This module create a two-point correlation function for quarkonium.
! The gauge fields and heavy propagators must already exist.
!
! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    use userparameters
    implicit none
    private

! Define access to subroutines.
    public :: Ssource, Smeson

 contains

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 subroutine Ssource(isrc,G)
! Create a source, intended for use as the starting source for
! subsequent computation of a heavy quark propagator.
! INPUT:
!   isrc = ix + nx*(iy-1) + nx*ny*(iz-1) is the spatial site of a point source.
! OUTPUT:
!   G(ic,ip,ixyz,jc,jp,iop) is the collection of sources.
!                      ic   is the color index of the sink.
!                      ip   is the Pauli index of the sink.
!                      ixyz is spatial location of the sink.
!                      jc   is the color index of the source.
!                      jp   is the Pauli index of the source.
!                      iop  is to identify the various source operators.
!   (ic=jc, ip=jp and ixyz=jxyz because no time propagation has occurred yet.)

    integer(kind=KI), intent(in)                          :: isrc
    complex(kind=KC), intent(out), dimension(:,:,:,:,:,:) :: G

    integer(kind=KI) :: ip, ic

    G = (0.0_KR,0.0_KR)
    do ip = 1,np
     do ic = 1,nc
      G(ic,ip,isrc,ic,ip,1) = (1.0_KR,0.0_KR)
     enddo ! ic
    enddo ! ip

 end subroutine Ssource

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 subroutine Smeson(G1,corr)
! Construct a meson correlator at one time step from given propagators.
! INPUT:
!   G1() is the propagator for the quark.
! OUTPUT:
!   corr is the correlation function.

    complex(kind=KC), intent(in),  dimension(:,:,:,:,:,:) :: G1
    complex(kind=KC), intent(out)                         :: corr

    integer(kind=KI) :: ic, ip, ix, iy, iz, ixyz, jc, jp

    corr = (0.0_KR,0.0_KR)
    do jp = 1,np
     do jc = 1,nc
      ixyz = 0
      do iz = 1,nz
       do iy = 1,ny
        do ix = 1,nx
         ixyz = ixyz + 1
         do ip = 1,np
          do ic = 1,nc
           corr = corr + conjg(G1(ic,ip,ixyz,jc,jp,1))*G1(ic,ip,ixyz,jc,jp,1)
          enddo ! ic
         enddo ! ip
        enddo ! ix
       enddo ! iy
      enddo ! iz
     enddo ! jc
    enddo ! jp

 end subroutine Smeson

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 end module heavyoperators

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
