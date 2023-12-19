! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
!
! gaugefields.f90
!
! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 module gaugefields

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
    public  :: configreadshift, tadfield, fatfield, aveplaq
    private :: stout, expon

 contains

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 subroutine configreadshift(userfilename,istep,Uraw)
! Read a selected time window from one ILDG configuration.
! ***Assumed input from an external module:
!     largeNt = number of time steps on the full ILDG lattice.
!     nt = number of time steps to be read in by the present subroutine.
! In particular, if the original ILDG time steps are labelled as
! 1, 2, 3, 4, ..., largeNt, then the present subroutine will read time steps
! istep-1, istep, istep+1, istep+2, istep+3, ..., istep+nt-2.
! The intention is that physics be done within the range (istep+1,istep+nt-4)
! and the remaining two time steps on each end are for neighbours that can
! be required for computing electric fields at the boundaries (for example).
! The range (istep+1,istep+nt-4) is stored as U(:,:,:,1:nt-4) and the
! boundaries fill in the remaining locations, U(:,:,:,nt-3:nt), in the
! natural fashion so that bwdnbr() and fwdnbr() work properly.
! ***The user's filename is ignored if a file named readtemp already exists!***
! INPUT:
!   userfilename is the user's filename.
!   istep is the number of time steps between the desired source position and
!         the earliest ("leftmost") time step on the original ILDG lattice.
! OUTPUT:
!   Uraw() contains the gauge fields that were read from the file.

    character(*),     intent(in)                      :: userfilename
    integer(kind=KI), intent(in)                      :: istep
    complex(kind=KC), intent(out), dimension(:,:,:,:) :: Uraw

    logical          :: isfile
    integer(kind=KI) :: ixyz, ixyzt, idir, ic, jc, it, jt, iread
    complex(kind=KC) :: junk1, junk2, junk3

! Open the extracted configuration file for reading.
    open(unit=10,file=trim(userfilename),status="old",form="unformatted", &
         access="stream")

! Read some of the requested time steps.
     iread = 0
     do it = 1,istep+nt-2-largeNt
      iread = iread + 1
      jt = largeNt-istep+it
      do ixyz = 1,nxyz
       ixyzt = ixyz + (jt-1)*nxyz
       do idir = 1,ndir
        do ic = 1,nc
         read(unit=10) (Uraw(ic,jc,idir,ixyzt),jc=1,3)
        enddo ! ic
       enddo ! idir
      enddo ! ixyz
     enddo ! it

! Omit unrequested time steps.
     do it = min(abs(istep-1),iread+1),istep-2
      do ixyz = 1,nxyz
       do idir = 1,ndir
        do ic = 1,nc
         read(unit=10) junk1, junk2, junk3
        enddo ! ic
       enddo ! idir
      enddo ! ixyz
     enddo ! it

! Read some of the requested time steps.
     do it = max(istep-1,1),istep
      jt = nt-istep+it
      do ixyz = 1,nxyz
       ixyzt = ixyz + (jt-1)*nxyz
       do idir = 1,ndir
        do ic = 1,nc
         read(unit=10) (Uraw(ic,jc,idir,ixyzt),jc=1,3)
        enddo ! ic
       enddo ! idir
      enddo ! ixyz
     enddo ! it

! Read some of the requested time steps.
     do it = istep+1,min(istep+nt-2,largeNt)
      jt = it - istep
      do ixyz = 1,nxyz
       ixyzt = ixyz + (jt-1)*nxyz
       do idir = 1,ndir
        do ic = 1,nc
         read(unit=10) (Uraw(ic,jc,idir,ixyzt),jc=1,3)
        enddo ! ic
       enddo ! idir
      enddo ! ixyz
     enddo ! it

! Omit unrequested time steps.
     do it = istep+nt-1,min(largeNt,largeNt-2+istep)
      do ixyz = 1,nxyz
       do idir = 1,ndir
        do ic = 1,nc
         read(unit=10) junk1, junk2, junk3
        enddo ! ic
       enddo ! idir
      enddo ! ixyz
     enddo ! it

! Read some of the requested time steps.
     do it = largeNt-1+istep,largeNt
      jt = it-largeNt+nt
      do ixyz = 1,nxyz
       ixyzt = ixyz + (jt-1)*nxyz
       do idir = 1,ndir
        do ic = 1,nc
         read(unit=10) (Uraw(ic,jc,idir,ixyzt),jc=1,3)
        enddo ! ic
       enddo ! idir
      enddo ! ixyz
     enddo ! it

! Close the extracted configuration file.
    close(unit=10,status="keep")

 end subroutine configreadshift

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 subroutine tadfield(Utad,uzeros,uzerot)
! Define link variables to be rescaled by the tadpole factors.

    complex(kind=KC), intent(inout), dimension(:,:,:,:) :: Utad
    real(kind=KR),    intent(in)                        :: uzeros, uzerot

    integer(kind=KI) :: ixyzt

    do ixyzt = 1,nxyzt
     Utad(:,:,1,ixyzt) = Utad(:,:,1,ixyzt)/uzeros
     Utad(:,:,2,ixyzt) = Utad(:,:,2,ixyzt)/uzeros
     Utad(:,:,3,ixyzt) = Utad(:,:,3,ixyzt)/uzeros
     Utad(:,:,4,ixyzt) = Utad(:,:,4,ixyzt)/uzerot
    enddo ! ixyzt

 end subroutine tadfield

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 subroutine fatfield(Utad,uzeros,it,nstout,astout,bwdnbr,fwdnbr,Ufat)
! Construct stout links (spatial not temporal) at the specified time step, it.
! INPUT:
!   Utad() contains the original link variables rescaled by tadpole factors.
!   uzeros is the tadpole factor in the spatial directions.
!   it is the time step where spatial links are to be stoutened.
!   nstout is the number of stouting iterations (zero is fine).
!   astout is the coefficient for stouting (ignored if nstout=0).
!   bwdnbr(mu,i) is the neighbour of site i in the -mu direction.
!   fwdnbr(mu,i) is the neighbour of site i in the +mu direction.
! OUTPUT:
!   Ufat() contains the stoutened spatial link variables at a single time step.

    complex(kind=KC), intent(in),  dimension(:,:,:,:) :: Utad
    real(kind=KR),    intent(in)                      :: uzeros, astout
    integer(kind=KI), intent(in)                      :: it, nstout
    integer(kind=KI), intent(in),  dimension(:,:)     :: bwdnbr, fwdnbr
    complex(kind=KC), intent(out), dimension(:,:,:,:) :: Ufat

    integer(kind=KI) :: ixyz, ixyzt

! Remove tadpole factors.
    do ixyz = 1,nxyz
     ixyzt = ixyz + (it-1)*nxyz
     Ufat(:,:,1,ixyz) = Utad(:,:,1,ixyzt)*uzeros
     Ufat(:,:,2,ixyz) = Utad(:,:,2,ixyzt)*uzeros
     Ufat(:,:,3,ixyz) = Utad(:,:,3,ixyzt)*uzeros
    enddo ! ixyz

! Apply stouting.
    call stout(Ufat,nstout,astout,bwdnbr,fwdnbr)

 end subroutine fatfield

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 subroutine stout(Ufat,nstout,astout,bwdnbr,fwdnbr)
! Apply stout smearing to spatial links.
! Morningstar and Peardon, Phys. Rev. D 69, 054501 (2004).
! INPUT:
!   Ufat() contains the spatial link variables at a single time step.
!   nstout is the number of stouting iterations (zero is fine).
!   astout is the coefficient for stouting (ignored if nstout=0).
!   bwdnbr(mu,i) is the neighbour of site i in the -mu direction.
!   fwdnbr(mu,i) is the neighbour of site i in the +mu direction.
! OUTPUT:
!   Ufat() contains the stoutened spatial link variables at a single time step.

    complex(kind=KC), intent(inout), dimension(:,:,:,:) :: Ufat
    integer(kind=KI), intent(in)                        :: nstout
    real(kind=KR),    intent(in)                        :: astout
    integer(kind=KI), intent(in),    dimension(:,:)     :: bwdnbr, fwdnbr

    complex(kind=KC), dimension(nc,nc,ndir-1,nxyz) :: Utmp
    complex(kind=KC), dimension(nc,nc)             :: Usum, mat1, mat2
    complex(kind=KC)                               :: avetrace
    real(kind=KR)                                  :: diff
    integer(kind=KI)                               :: istout, ixyz, jxyz, ic, &
                                                      inbr, jnbr, mu, nu, &
                                                      ipm, jc

    if (nstout>0) then
     do istout = 1,nstout
      do ixyz = 1,nxyz
       do mu = 1,ndir-1
        jxyz = fwdnbr(mu,ixyz)

! Construct the sum of 4 spatial staples for the link at ixyz in direction mu.
        Usum = 0.0_KR
        do nu = 1,ndir-1
         if (nu/=mu) then
          do ipm = 1,2
           if (ipm==1) then
            inbr = bwdnbr(nu,ixyz)
            jnbr = bwdnbr(nu,jxyz) 
            mat1 = matmul(conjg(transpose(Ufat(:,:,nu,inbr))),Ufat(:,:,mu,inbr))
            mat2 = matmul(mat1,Ufat(:,:,nu,jnbr))
           else
            inbr = fwdnbr(nu,ixyz)
            mat1 = matmul(Ufat(:,:,nu,ixyz),Ufat(:,:,mu,inbr))
            mat2 = matmul(mat1,conjg(transpose(Ufat(:,:,nu,jxyz))))
           endif
           Usum = Usum + astout*mat2
          enddo ! ipm
         endif
        enddo ! nu

! Calculate Omega_mu(ixyz) of Morningstar and Peardon.
        mat2 = matmul(Usum,conjg(transpose(Ufat(:,:,mu,ixyz))))

! Calculate Q_mu(ixyz) of Morningstar and Peardon.
        mat1 = conjg(transpose(mat2)) - mat2
        avetrace = (mat1(1,1)+mat1(2,2)+mat1(3,3))/real(nc,KR)
        do ic = 1,3
         mat1(ic,ic) = mat1(ic,ic) - avetrace
        enddo ! ic
        mat1 = (0.0_KR,0.5_KR)*mat1

! Multiply by exp[I*Q_mu(ixyz)] of Morningstar and Peardon unless Q_mu(ixyz)=0.
        diff = 0.0_KR
        do ic = 1,3
         do jc = 1,3
          diff = diff + real(mat1(ic,jc),KR)**2 + aimag(mat1(ic,jc))**2
         enddo ! jc
        enddo ! ic
        if (diff==0.0_KR) then
         Utmp(:,:,mu,ixyz) = Ufat(:,:,mu,ixyz)
        else
         call expon(mat1)
         Utmp(:,:,mu,ixyz) = matmul(mat1,Ufat(:,:,mu,ixyz))
        endif

       enddo ! mu
      enddo ! ixyz
      Ufat = Utmp
     enddo ! istout
    endif
 
 end subroutine stout

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
 subroutine expon(Q)
! Exponentiate the hermitian matrix I*Q, where I=sqrt(-1).
! Morningstar and Peardon, Phys. Rev. D 69, 054501 (2004).

    complex(kind=KC), intent(inout), dimension(:,:) :: Q

    complex(kind=KC), dimension(nc,nc) :: Qsq
    complex(kind=KC)                   :: detQ, h0, h1, h2, f0, f1, f2
    real(kind=KR)                      :: c0, c1, c0max, theta, u, usq, w, &
                                          wsq, xi0
    integer(kind=KI)                   :: ic
    logical                            :: dosign

! Calculate c_0 and c_1 of Morningstar and Peardon equations 14 and 15.
    dosign = .false.
    Qsq = matmul(Q,Q)
    detQ = Q(1,1)*(Q(2,2)*Q(3,3)-Q(3,2)*Q(2,3)) &
         + Q(1,2)*(Q(3,1)*Q(2,3)-Q(2,1)*Q(3,3)) &
         + Q(1,3)*(Q(2,1)*Q(3,2)-Q(3,1)*Q(2,2))
    c0 = real(detQ,KR)
    if (c0<0.0_KR) then
     dosign = .true.
     c0 = -c0
    endif
    c1 = 0.5_KR*real(Qsq(1,1)+Qsq(2,2)+Qsq(3,3),KR)

! Calculate u, w and theta of Morningstar and Peardon equations 23, 24 and 25.
    c0max = 2.0_KR*(c1/3.0_KR)**1.5_KR
    theta = acos(c0/c0max)
    u = sqrt(c1/3.0_KR) * cos(theta/3.0_KR)
    usq = u*u
    w = sqrt(c1) * sin(theta/3.0_KR)
    wsq = w*w

! Calculate xi_0 of Morningstar and Peardon equation 33 and context.
    if (abs(w)>0.05_KR) then
     xi0 = sin(w)/w
    else
     xi0 = 1.0_KR - wsq*(1.0_KR-wsq*(1.0_KR-wsq/42.0_KR)/20.0_KR)/6.0_KR
    endif
    
! Calculate the h_j of Morningstar and Peardon equations 30, 31, 32.
    h0 = (usq-wsq)*cmplx(cos(2.0_KR*u),sin(2.0_KR*u),KC) &
         + cmplx(cos(u),-sin(u),KC)*(8.0_KR*usq*cos(w)+(0.0_KR,2.0_KR)*u &
         *(3.0_KR*usq+wsq)*xi0)
    h1 = 2.0_KR*u*cmplx(cos(2.0_KR*u),sin(2.0_KR*u),KC) &
         - cmplx(cos(u),-sin(u),KC)*(2.0_KR*u*cos(w)-(0.0_KR,1.0_KR)*(3.0_KR &
         *usq-wsq)*xi0)
    h2 = cmplx(cos(2.0_KR*u),sin(2.0_KR*u),KC) - cmplx(cos(u),-sin(u),KC)* &
         (cos(w)+(0.0_KR,3.0_KR)*u*xi0)
    if (dosign) then
     h0 = conjg(h0)
     h1 = -conjg(h1)
     h2 = conjg(h2)
    endif

! Calculate the f_j of Morningstar and Peardon equation 29.
    f0 = h0/(9.0_KR*usq-wsq)
    f1 = h1/(9.0_KR*usq-wsq)
    f2 = h2/(9.0_KR*usq-wsq)

! Construct the exponential matrix of Morningstar and Peardon equation 27.
    Q = f1*Q + f2*Qsq
    do ic = 1,nc
     Q(ic,ic) = f0 + Q(ic,ic)
    enddo ! ic
 
 end subroutine expon

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 subroutine aveplaq(U,cutboundaries,bwdnbr,fwdnbr,plaq)
! Calculate the average plaquette for a given configuration.
! INPUT:
!   U() contains the link variables.
!   cutboundaries=.true. means time steps nt-3, nt-2, nt-1 and nt are omitted.
!   bwdnbr(mu,i) is the neighbour of site i in the -mu direction.
!   fwdnbr(mu,i) is the neighbour of site i in the +mu direction.
! OUTPUT:
!   plaq is the average plaquette, normalized to be (1/3)*Tr(U*U*U*U).

    complex(kind=KC), intent(in), dimension(:,:,:,:) :: U
    logical,          intent(in)                     :: cutboundaries
    integer(kind=KI), intent(in), dimension(:,:)     :: bwdnbr, fwdnbr
    real(kind=KR),    intent(out)                    :: plaq

    integer(kind=KI)                 :: nsites, ixyzt, idir, jdir
    complex(kind=KC), dimension(3,3) :: Utmp1, Utmp2

! Initialize.
    plaq = 0.0_KR
    if (cutboundaries) then
     nsites = nxyzt - 4*nxyz
    else
     nsites = nxyzt
    endif

! Sum.
    do ixyzt = 1,nsites
     do idir = 1,ndir-1
      do jdir = idir+1,ndir
       Utmp1 = matmul(U(:,:,idir,ixyzt),U(:,:,jdir,fwdnbr(idir,ixyzt)))
       Utmp2 = matmul(Utmp1,conjg(transpose(U(:,:,idir,fwdnbr(jdir,ixyzt)))))
       Utmp1 = matmul(Utmp2,conjg(transpose(U(:,:,jdir,ixyzt))))
       plaq = plaq + real(Utmp1(1,1)+Utmp1(2,2)+Utmp1(3,3),KR)
      enddo ! jdir
     enddo ! idir
    enddo ! ixyzt

! Average.
    plaq = plaq/real(18*nsites,KR)

 end subroutine aveplaq

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 end module gaugefields

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
