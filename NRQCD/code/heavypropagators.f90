! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
!
! heavypropagators.f90
!
! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 module heavypropagators

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
!
! This module computes the heavy quark Green's function corresponding to 
! heavy quark propagation on a lattice of gauge fields.
!
! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    use userparameters
    implicit none
    private

! Define access to subroutines.
    public  :: heavyprop
    private :: hamilt, h2, h3, h4, h7, h8, h9E, h9EB, h10E, h10EB, delimp, &
               delmu, Eclov, Bclov

 contains

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 subroutine heavyprop(Gt,Utad,nprop,backward,bareM,itnbr,mode,cset,csetmin, &
                      imp,aspect,unitaritycf,iform,bwdnbr,fwdnbr, &
                      newgaugefield,uzeros,uzerot)
! Evaluate heavy quark propagation by one time step, either forward or
! backward, starting at itbnr.
! INPUT:
!   Gt() is the heavy quark Green function at timeslice inbnr.
!   Utad() contains the gauge fields divided by the appropriate tadpole factor.
!   nprop is the number of different propagators to be computed.
!   backward=.true. for backward time propagation.
!   bareM is the bare heavy quark mass.
!   itbnr is the temporal position.
!   mode>0 is a constant factor affecting the c6 and c11 terms.
!   cset(1,1:14) contains the set of coefficients for H, i.e. respectively
!                c0,c1,c2,c3,c4,c5,c6,c7,c8,c9E,c9EB,c10E,c10EB,c11.
!   cset(2,1:14) contains the set of coefficients for deltaH, i.e. respectively
!                c0,c1,c2,c3,c4,c5,c6,c7,c8,c9E,c9EB,c10E,c10EB,c11.
!   csetmin is the smallest magnitude of cset(i,j) that is not set to zero.
!   imp=.true. if the derivative Delta is to be improved in terms c2,c3,c7,c8
!              but not in terms c0,c1,c5,c6,c11.
!   aspect is the ratio of spatial to temporal lattice spacings, a_s/a_t.
!   unitaritycf is for correcting fourth order derivatives.
!   iform=1 : G_(t+1) = (1-H/(2n))^n*Udag*(1-H/(2n))^n*G_t
!   iform=2 : G_(t+1) = (1-Hbit/2)*(1-H/(2n))^n*Udag*(1-H/(2n))^n*(1-Hbit/2)*G_t
!   iform=3 : G_(t+1) = (1-H/(2n))^n*Udag*(1-H/(2n))^n*(1-Hbit)*G_t
!   bwdnbr(mu,i) is the neighbour of site i in the -mu direction.
!   fwdnbr(mu,i) is the neighbour of site i in the +mu direction.
!   newgaugefield=.true. if new color electric&magnetic fields must be computed.
!                        (Use .false. if this call to heavyprop was preceded
!                        by a previous call using the same gauge fields but a
!                        value of itnbr that was smaller by exactly 1.)
!   uzeros is the spatial tadpole factor.
!   uzerot is the temporal tadpole factor.
! OUTPUT:
!   Gt() is the heavy quark Green function at timeslice
!        itbnr+1 (backward=.false.) or at timeslice itbnr-1 (backward=.true.).

    complex(kind=KC), intent(inout), dimension(:,:,:,:,:,:) :: Gt
    complex(kind=KC), intent(in),    dimension(:,:,:,:)     :: Utad
    integer(kind=KI), intent(in)                            :: nprop, itnbr, &
                                                               mode, iform
    logical,          intent(in)                            :: backward, imp, &
                                                               newgaugefield
    real(kind=KR),    intent(in)                            :: bareM, csetmin, &
                                                               aspect, &
                                                               unitaritycf, &
                                                               uzeros, uzerot
    real(kind=KR),    intent(in),    dimension(:,:)         :: cset
    integer(kind=KI), intent(in),    dimension(:,:)         :: bwdnbr, fwdnbr

    complex(kind=KC), dimension(nc,nc,ndir-1,nxyzt), save :: colE
    complex(kind=KC), dimension(nc,nc,ndir-1,nxyz),  save :: colB
    complex(kind=KC), dimension(nc,np,nxyz)               :: Gtot, G1
    complex(kind=KC), dimension(nc,nc)                    :: amat
    real(kind=KR)                                         :: factor
    integer(kind=KI)                                      :: it, iprop, jp, &
                                                             jc, iset, imode, &
                                                             ixyz, ixyzt, ip

    factor = 1.0_KR/(2.0_KR*real(mode,KR))
    if (backward) then
     it = itnbr - 1
    else
     it = itnbr + 1
    endif
    if (newgaugefield) then
     call Eclov(Utad,imp,uzeros,uzerot,aspect,bwdnbr,fwdnbr,colE)
     call Bclov(Utad,itnbr,imp,uzeros,bwdnbr,fwdnbr,colB)
    endif

! STEP 1: Multiply by some Hamiltonian pieces and the temporal link.
    do iprop = 1,nprop
     do jp = 1,np
      do jc = 1,nc
       Gtot = Gt(:,:,:,jc,jp,iprop)

! --- first factor of ( 1 - "deltaH"/2. ) or ( 1 - "deltaH" ).
       select case (iform)
        case(1) ! no factor required if iform=1
        case(2)
         iset = 2
         call hamilt(Gtot,Utad,bareM,itnbr,mode,cset,iset,csetmin,imp,aspect, &
                     unitaritycf,bwdnbr,fwdnbr,colE,colB,G1)
         Gtot = Gtot - 0.5_KR*G1
        case(3)
         iset = 2
         call hamilt(Gtot,Utad,bareM,itnbr,mode,cset,iset,csetmin,imp,aspect, &
                     unitaritycf,bwdnbr,fwdnbr,colE,colB,G1)
         Gtot = Gtot - G1
        case default ! never get here
         write(*,*) "heavyprop: invalid case"
         stop
       end select

! --- first exponential of Hamiltonian.
       iset = 1
       do imode = 1,mode
        call hamilt(Gtot,Utad,bareM,itnbr,mode,cset,iset,csetmin,imp,aspect, &
                    unitaritycf,bwdnbr,fwdnbr,colE,colB,G1)
        Gtot = Gtot - factor*G1
       enddo ! imode

! --- the temporal link.
       do ixyz = 1,nxyz
        if (backward) then
         ixyzt = ixyz + nxyz*(it-1)
         amat = Utad(:,:,4,ixyzt)
        else
         ixyzt = ixyz + nxyz*(itnbr-1)
         amat = conjg(transpose(Utad(:,:,4,ixyzt)))
        endif
        do ip = 1,np
         Gtot(:,ip,ixyz) = matmul(amat,Gtot(:,ip,ixyz))
        enddo ! np
       enddo ! ixyz

       Gt(:,:,:,jc,jp,iprop) = Gtot
      enddo ! jc
     enddo ! jp
    enddo ! iprop

! STEP 2: Update the color magnetic field.
    call Bclov(Utad,it,imp,uzeros,bwdnbr,fwdnbr,colB)

! STEP 3: Multiply by the remaining Hamiltonian pieces.
    do iprop = 1,nprop
     do jp = 1,np
      do jc = 1,nc
       Gtot = Gt(:,:,:,jc,jp,iprop)
    
! --- second exponential of Hamiltonian.
       iset = 1
       do imode = 1,mode
        call hamilt(Gtot,Utad,bareM,it,mode,cset,iset,csetmin,imp,aspect, &
                    unitaritycf,bwdnbr,fwdnbr,colE,colB,G1)
        Gtot = Gtot - factor*G1 
       enddo ! imode

! --- second factor of ( 1 - "deltaH"/2. ).
       if (iform==2) then
        iset = 2          
        call hamilt(Gtot,Utad,bareM,it,mode,cset,iset,csetmin,imp,aspect, &
                    unitaritycf,bwdnbr,fwdnbr,colE,colB,G1)
        Gtot = Gtot - 0.5_KR*G1
       endif

       Gt(:,:,:,jc,jp,iprop) = Gtot
      enddo ! jc
     enddo ! jp
    enddo ! iprop

 end subroutine heavyprop

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 subroutine hamilt(Gin,Utad,bareM,it,mode,cset,iset,csetmin,imp,aspect, &
                   unitaritycf,bwdnbr,fwdnbr,colE,colB,Gout)
! Construct a Hamiltonian from the NRQCD terms specified in cset(iset,...),
! and multiply this Hamiltonian into the vector Gin at timeslice it.  
! INPUT:
!   Gin() is the initial vector.
!   Utad() contains the gauge fields divided by the appropriate tadpole factor.
!   bareM is the bare heavy quark mass.
!   it is the time step where the Hamiltonian is to be applied.
!   mode is a constant factor affecting the c6 and c11 terms.
!   cset(iset,1:14) contains c0,c1,c2,c3,c4,c5,c6,c7,c8,c9E,c9EB,c10E,c10EB,c11
!                   used in the present subroutine.
!   iset is an integer between 0 and 9 inclusive.  (It differentiates between
!        multiple sets of c_i coefficients which may exist.)
!   csetmin is the smallest magnitude of cset(i,j) that is not set to zero.
!   imp=.true. means that the E,B gauge fields will be improved
!              and the derivative Delta will be improved in terms c2,c3,c7,c8
!              but not in terms c0,c1,c5,c6,c11.
!   aspect is the ratio of spatial to temporal lattice spacings, a_s/a_t.
!   unitaritycf is for correcting fourth order derivatives.
!   bwdnbr(mu,i) is the neighbour of site i in the -mu direction.
!   fwdnbr(mu,i) is the neighbour of site i in the +mu direction.
!   colE() is the colour electric field with the tadpole factors built in.
!   colB() is the colour magnetic field with the tadpole factors built in.
! OUTPUT:
!   Gout() is Hamiltonian*Gin().

    complex(kind=KC), intent(in),  dimension(:,:,:)   :: Gin
    complex(kind=KC), intent(in),  dimension(:,:,:,:) :: Utad, colE, colB
    real(kind=KR),    intent(in)                      :: bareM, csetmin, &
                                                         aspect, unitaritycf
    integer(kind=KI), intent(in)                      :: it, mode, iset
    real(kind=KR),    intent(in),  dimension(:,:)     :: cset
    logical,          intent(in)                      :: imp
    integer(kind=KI), intent(in),  dimension(:,:)     :: bwdnbr, fwdnbr
    complex(kind=KC), intent(out), dimension(:,:,:)   :: Gout

    complex(kind=KC), dimension(nc,np,nxyz) :: G1, G2, G3
    real(kind=KR)                           :: twoM, factor
    integer(kind=KI)                        :: iorder, mu

! Initialize.
    Gout = (0.0_KR,0.0_KR)
    iorder = 2
    twoM = 2.0_KR*bareM

! c0.
    if (abs(cset(iset,1))>=csetmin) then
     factor = cset(iset,1)/twoM
     do mu = 1,3
      call delmu(Utad,mu,Gin,it,iorder,bwdnbr,fwdnbr,G1)
      Gout = Gout - factor*G1
     enddo ! mu
    endif

! c1 and c6.
    if (abs(cset(iset,2))>=csetmin .or. abs(cset(iset,7))>=csetmin) then
     factor = cset(iset,2)/twoM**3 &
            + cset(iset,7)/(4.0_KR*float(mode)*twoM**2)/aspect
     G2 = (0.0_KR,0.0_KR)
     do mu = 1,3
      call delmu(Utad,mu,Gin,it,iorder,bwdnbr,fwdnbr,G1)
      G2 = G2 + G1
     enddo ! mu
     do mu = 1,3
      call delmu(Utad,mu,G2,it,iorder,bwdnbr,fwdnbr,G1)
      Gout = Gout - factor*G1
     enddo ! mu
     Gout = Gout - factor*unitaritycf*Gin
    endif

! c2.
    if (abs(cset(iset,3))>=csetmin) then
     call h2(Utad,colE,it,imp,Gin,bwdnbr,fwdnbr,G1)
     Gout = Gout + cset(iset,3)*G1/(2.0_KR*twoM**2)
    endif

! c3.
    if (abs(cset(iset,4))>=csetmin) then
     call h3(Utad,colE,it,imp,Gin,bwdnbr,fwdnbr,G1)
     Gout = Gout - cset(iset,4)*G1/(2.0_KR*twoM**2)
    endif

! c4.
    if (abs(cset(iset,5))>=csetmin) then
     call h4(colB,it,Gin,G1)
     Gout = Gout - cset(iset,5)*G1/twoM
    endif

! c5.
    if (abs(cset(iset,6))>=csetmin) then
     factor = cset(iset,6)/(12.0_KR*twoM)
     do mu = 1,3
      call delmu(Utad,mu,Gin,it,iorder,bwdnbr,fwdnbr,G1)
      call delmu(Utad,mu,G1,it,iorder,bwdnbr,fwdnbr,G2)
      Gout = Gout + factor*G2
     enddo ! mu
     Gout = Gout + factor*unitaritycf*Gin
    endif

! c7.
    if (abs(cset(iset,8))>=csetmin) then
     call h7(Utad,colB,it,imp,Gin,bwdnbr,fwdnbr,G1)
     Gout = Gout - cset(iset,8)*G1/twoM**3
    endif

! c8.
    if (abs(cset(iset,9))>=csetmin) then
     call h8(Utad,colE,it,imp,Gin,bwdnbr,fwdnbr,G1)
     Gout = Gout - 3.0_KR*cset(iset,9)*G1/(4.0_KR*twoM**4)
    endif

! c9E.
    if (abs(cset(iset,10))>=csetmin) then
     call h9E(colE,it,Gin,G1)
     Gout = Gout - cset(iset,10)*G1/twoM**3
    endif

! c9EB.
    if (abs(cset(iset,11))>=csetmin) then
     call h9EB(colE,colB,it,Gin,G1)
     Gout = Gout - cset(iset,11)*G1/twoM**3
    endif

! c10E.
    if (abs(cset(iset,12))>=csetmin) then
     call h10E(colE,it,Gin,G1)
     Gout = Gout - cset(iset,12)*G1/twoM**3
    endif
     
! c10EB.
    if (abs(cset(iset,13))>=csetmin) then
     call h10EB(colE,colB,it,Gin,G1)
     Gout = Gout - cset(iset,13)*G1/twoM**3
    endif

! c11.
    if (abs(cset(iset,14))>=csetmin) then
     factor = cset(iset,14)/(24.0_KR*float(mode**2)*twoM**3)/aspect**2
     G2 = (0.0_KR,0.0_KR)
     G3 = (0.0_KR,0.0_KR)
     do mu = 1,3
      call delmu(Utad,mu,Gin,it,iorder,bwdnbr,fwdnbr,G1)
      G2 = G2 + G1
     enddo ! mu
     do mu = 1,3
      call delmu(Utad,mu,G2,it,iorder,bwdnbr,fwdnbr,G1)
      G3 = G3 + G1
     enddo ! mu
     do mu = 1,3
      call delmu(Utad,mu,G3,it,iorder,bwdnbr,fwdnbr,G1)
      Gout = Gout - factor*G1
     enddo ! mu
    endif

! Divide by the ratio of spatial to temporal lattice spacings (aspect=a_s/a_t).
    Gout = Gout/aspect

 end subroutine hamilt

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 subroutine h2(Utad,colE,it,imp,Gin,bwdnbr,fwdnbr,Gout)
! Multiply i*(Delta.E - E.Delta) into the vector Gin at timeslice it.  
! NOTE: This the c2 term in the NRQCD Hamiltonian, UP TO A CONSTANT FACTOR.
! INPUT:
!   Utad() contains the gauge fields divided by the appropriate tadpole factor.
!   colE() is the colour electric field with the tadpole factors built in.
!   it is the time step where the operator is to be applied.
!   imp is .true. if the derivative Delta is to be improved.
!   Gin() is the initial vector.
!   bwdnbr(mu,i) is the neighbour of site i in the -mu direction.
!   fwdnbr(mu,i) is the neighbour of site i in the +mu direction.
! OUTPUT:
!   Gout is i*(Delta.E - E.Delta)*Gin.

    complex(kind=KC), intent(in),  dimension(:,:,:,:) :: Utad, colE
    integer(kind=KI), intent(in)                      :: it
    logical,          intent(in)                      :: imp
    complex(kind=KC), intent(in),  dimension(:,:,:)   :: Gin
    integer(kind=KI), intent(in),  dimension(:,:)     :: bwdnbr, fwdnbr
    complex(kind=KC), intent(out), dimension(:,:,:)   :: Gout

    complex(kind=KC), dimension(nc,np,nxyz) :: Gmul, Gmul2
    complex(kind=KC), dimension(nc,nc)      :: amat
    integer(kind=KI)                        :: ixyz, ixyzt, mu, ip

    Gout = (0.0_KR,0.0_KR)

! The i*Delta.E term.
    do mu = 1,3
     do ixyz = 1,nxyz
      ixyzt = ixyz + nxyz*(it-1)
      amat = colE(:,:,mu,ixyzt)
      do ip = 1,np
       Gmul(:,ip,ixyz) = matmul(amat,Gin(:,ip,ixyz))
      enddo ! ip
     enddo ! ixyz
     call delimp(Utad,mu,Gmul,it,imp,bwdnbr,fwdnbr,Gmul2)
     Gout = Gout + (0.0_KR,1.0_KR)*Gmul2
    enddo ! mu

! The -i*E.Delta term.
    do mu = 1,3
     call delimp(Utad,mu,Gin,it,imp,bwdnbr,fwdnbr,Gmul)
     do ixyz = 1,nxyz
      ixyzt = ixyz + nxyz*(it-1)
      amat = colE(:,:,mu,ixyzt)
      do ip = 1,np
       Gout(:,ip,ixyz) = Gout(:,ip,ixyz) &
                       - (0.0_KR,1.0_KR)*matmul(amat,Gmul(:,ip,ixyz))
      enddo ! ip
     enddo ! ixyz
    enddo ! mu

 end subroutine h2

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 subroutine h3(Utad,colE,it,imp,Gin,bwdnbr,fwdnbr,Gout)
! Multiply sigma*(Delta x E - E x Delta) into the vector Gin at timeslice it.
! NOTE: This the c3 term in the NRQCD Hamiltonian, UP TO A CONSTANT FACTOR.
! INPUT:
!   Utad() contains the gauge fields divided by the appropriate tadpole factor.
!   colE() is the colour electric field with the tadpole factors built in.
!   it is the time step where the operator is to be applied.
!   imp is .true. if the derivative Delta is to be improved.
!   Gin() is the initial vector.
!   bwdnbr(mu,i) is the neighbour of site i in the -mu direction.
!   fwdnbr(mu,i) is the neighbour of site i in the +mu direction.
! OUTPUT:
!   Gout is sigma*(Delta x E - E x Delta) * Gin.

    complex(kind=KC), intent(in),  dimension(:,:,:,:) :: Utad, colE
    integer(kind=KI), intent(in)                      :: it
    logical,          intent(in)                      :: imp
    complex(kind=KC), intent(in),  dimension(:,:,:)   :: Gin
    integer(kind=KI), intent(in),  dimension(:,:)     :: bwdnbr, fwdnbr
    complex(kind=KC), intent(out), dimension(:,:,:)   :: Gout

    complex(kind=KC), dimension(nc,nc)      :: amat, bmat
    complex(kind=KC), dimension(nc)         :: avec, bvec, cvec
    complex(kind=KC), dimension(nc,np,nxyz) :: Gsum, Gmu, Gnu, G2
    integer(kind=KI), dimension(3)          :: muvec, nuvec
    integer(kind=KI)                        :: idir, ixyz, ixyzt, mu, nu, ip

    muvec = (/ 2, 3, 1 /)
    nuvec = (/ 3, 1, 2 /)
    Gout = (0.0_KR,0.0_KR)
    do idir = 1,3
     mu = muvec(idir)
     nu = nuvec(idir)
     Gsum = (0.0_KR,0.0_KR)

! The (Delta x E) term.
     do ixyz = 1,nxyz
      ixyzt = ixyz + nxyz*(it-1)
      amat = colE(:,:,mu,ixyzt)
      bmat = colE(:,:,nu,ixyzt)
      do ip = 1,np
       avec = Gin(:,ip,ixyz)
       Gmu(:,ip,ixyz) = matmul(amat,avec)
       Gnu(:,ip,ixyz) = matmul(bmat,avec)
      enddo ! ip
     enddo ! ixyz
     call delimp(Utad,mu,Gnu,it,imp,bwdnbr,fwdnbr,G2)
     Gsum = Gsum + G2
     call delimp(Utad,nu,Gmu,it,imp,bwdnbr,fwdnbr,G2)
     Gsum = Gsum - G2

! The (-E x Delta) term.
     call delimp(Utad,mu,Gin,it,imp,bwdnbr,fwdnbr,Gmu)
     call delimp(Utad,nu,Gin,it,imp,bwdnbr,fwdnbr,Gnu)
     do ixyz = 1,nxyz
      ixyzt = ixyz + nxyz*(it-1)
      amat = colE(:,:,mu,ixyzt)
      bmat = colE(:,:,nu,ixyzt)
      do ip = 1,np
       avec = Gnu(:,ip,ixyz)
       bvec = matmul(amat,avec)
       avec = Gmu(:,ip,ixyz)
       cvec = matmul(bmat,avec)
       G2(:,ip,ixyz) = bvec - cvec
      enddo ! ip
     enddo ! ixyz
     Gsum = Gsum - G2

! Take dot product with (sigma_x,sigma_y,sigma_z).
     select case (idir)
     case(1) ! sigma_x
      Gout(:,1,:) = Gout(:,1,:) + Gsum(:,2,:)
      Gout(:,2,:) = Gout(:,2,:) + Gsum(:,1,:)
! Take dot product: sigma_y
     case(2) ! sigma_y
      Gout(:,1,:) = Gout(:,1,:) - (0.0_KR,1.0_KR)*Gsum(:,2,:)
      Gout(:,2,:) = Gout(:,2,:) + (0.0_KR,1.0_KR)*Gsum(:,1,:)
! Take dot product: sigma_z
     case(3) ! sigma_z
      Gout(:,1,:) = Gout(:,1,:) + Gsum(:,1,:)
      Gout(:,2,:) = Gout(:,2,:) - Gsum(:,2,:)
     case default ! never get here
      write(*,*) "h3: invalid case"
      stop
     end select
    enddo ! idir

 end subroutine h3

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 subroutine h4(colB,it,Gin,Gout)
! Multiply sigma.B into the vector Gin at timeslice it.  
! NOTE: This the c4 term in the NRQCD Hamiltonian, UP TO A CONSTANT FACTOR.
! INPUT:
!   colB() is the colour magnetic field with the tadpole factors built in.
!   it is the time step where the operator is to be applied.
!   Gin() is the initial vector.
! OUTPUT:
!   Gout is sigma.B*Gin.

    complex(kind=KC), intent(in),  dimension(:,:,:,:) :: colB
    integer(kind=KI), intent(in)                      :: it
    complex(kind=KC), intent(in),  dimension(:,:,:)   :: Gin
    complex(kind=KC), intent(out), dimension(:,:,:)   :: Gout

    complex(kind=KC), dimension(nc,nc)   :: amat
    complex(kind=KC), dimension(nc,np,3) :: spinor
    integer(kind=KI)                     :: ixyz, ixyzt, mu, ip

    do ixyz = 1,nxyz
     ixyzt = ixyz + nxyz*(it-1)
! Multiply all three components of B into Gin.
     do mu = 1,3
      amat = colB(:,:,mu,ixyz)
      do ip = 1,np
       spinor(:,ip,mu) = matmul(amat,Gin(:,ip,ixyz))
      enddo ! ip
     enddo ! mu
! Take dot product with (sigma_x,sigma_y,sigma_z)
     Gout(:,1,ixyz) = spinor(:,2,1) + spinor(:,1,3) &
                    - (0.0_KR,1.0_KR)*spinor(:,2,2)
     Gout(:,2,ixyz) = spinor(:,1,1) - spinor(:,2,3) &
                    + (0.0_KR,1.0_KR)*spinor(:,1,2)
    enddo ! ixyz

 end subroutine h4

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 subroutine h7(Utad,colB,it,imp,Gin,bwdnbr,fwdnbr,Gout)
! Multiply {Delta(2),sigma.B} into the vector Gin at timeslice it.  
! If imp=.true. then the second-order derivative Delta(2) is improved.
! NOTE: This the c7 term in the NRQCD Hamiltonian, UP TO A CONSTANT FACTOR.
! INPUT:
!   Utad() contains the gauge fields divided by the appropriate tadpole factor.
!   colB() is the colour magnetic field with the tadpole factors built in.
!   it is the time step where the operator is to be applied.
!   imp is .true. if the second-order derivative Delta(2) is to be improved.
!   Gin() is the initial vector.
!   bwdnbr(mu,i) is the neighbour of site i in the -mu direction.
!   fwdnbr(mu,i) is the neighbour of site i in the +mu direction.
! OUTPUT:
!   Gout is {Delta(2),sigma.B}*Gin.

    complex(kind=KC), intent(in),  dimension(:,:,:,:) :: Utad, colB
    integer(kind=KI), intent(in)                      :: it
    logical,          intent(in)                      :: imp
    complex(kind=KC), intent(in),  dimension(:,:,:)   :: Gin
    integer(kind=KI), intent(in),  dimension(:,:)     :: bwdnbr, fwdnbr
    complex(kind=KC), intent(out), dimension(:,:,:)   :: Gout

    complex(kind=KC), dimension(nc,np,nxyz) :: G1, G2, G3
    real(kind=KR)                           :: factor
    integer(kind=KI)                        :: iorder, mu

    iorder = 2

    G2 = (0.0_KR,0.0_KR)
    do mu = 1,3
     call delmu(Utad,mu,Gin,it,iorder,bwdnbr,fwdnbr,G1)
     G2 = G2 + G1
    enddo ! mu
    if (imp) then
     factor = 1.0_KR/12.0_KR
     do mu = 1,3
      call delmu(Utad,mu,Gin,it,iorder,bwdnbr,fwdnbr,G1)
      call delmu(Utad,mu,G1,it,iorder,bwdnbr,fwdnbr,G3)
      G2 = G2 - factor*G3
     enddo ! mu
    endif
    call h4(colB,it,G2,Gout)

    call h4(colB,it,Gin,G1)
    do mu = 1,3
     call delmu(Utad,mu,G1,it,iorder,bwdnbr,fwdnbr,G2)
     Gout = Gout + G2
    enddo ! mu
    if (imp) then
     factor = 1.0_KR/12.0_KR
     do mu = 1,3
      call delmu(Utad,mu,G1,it,iorder,bwdnbr,fwdnbr,G2)
      call delmu(Utad,mu,G2,it,iorder,bwdnbr,fwdnbr,G3)
      Gout = Gout - factor*G3
     enddo ! mu
    endif

 end subroutine h7

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 subroutine h8(Utad,colE,it,imp,Gin,bwdnbr,fwdnbr,Gout)
! Multiply {Delta(2),sigma.(Delta x E - E x Delta)} into the vector Gin at 
! timeslice it.  
! NOTE: This the c8 term in the NRQCD Hamiltonian, UP TO A CONSTANT FACTOR.
! INPUT:
!   Utad() contains the gauge fields divided by the appropriate tadpole factor.
!   colE() is the colour electric field with the tadpole factors built in.
!   it is the time step where the operator is to be applied.
!   imp is .true. if Delta and Delta(2) are to be improved derivatives.
!   Gin() is the initial vector.
!   bwdnbr(mu,i) is the neighbour of site i in the -mu direction.
!   fwdnbr(mu,i) is the neighbour of site i in the +mu direction.
! OUTPUT:
!   Gout is {Delta(2),sigma.(Delta x E - E x Delta)} * Gin.

    complex(kind=KC), intent(in),  dimension(:,:,:,:) :: Utad, colE
    complex(kind=KC), intent(in),  dimension(:,:,:)   :: Gin
    integer(kind=KI), intent(in)                      :: it
    logical,          intent(in)                      :: imp
    integer(kind=KI), intent(in),  dimension(:,:)     :: bwdnbr, fwdnbr
    complex(kind=KC), intent(out), dimension(:,:,:)   :: Gout

    complex(kind=KC), dimension(nc,np,nxyz) :: G1, G2, G3
    real(kind=KR)                           :: factor
    integer(kind=KI)                        :: iorder, mu

    iorder = 2

    G2 = (0.0_KR,0.0_KR)
    do mu = 1,3
     call delmu(Utad,mu,Gin,it,iorder,bwdnbr,fwdnbr,G1)
     G2 = G2 + G1
    enddo ! mu
    if (imp) then
     factor = 1.0_KR/12.0_KR
     do mu = 1,3
      call delmu(Utad,mu,Gin,it,iorder,bwdnbr,fwdnbr,G1)
      call delmu(Utad,mu,G1,it,iorder,bwdnbr,fwdnbr,G3)
      G2 = G2 - factor*G3
     enddo ! mu
    endif
    call h3(Utad,colE,it,imp,G2,bwdnbr,fwdnbr,Gout)

    call h3(Utad,colE,it,imp,Gin,bwdnbr,fwdnbr,G1)
    G2 = (0.0_KR,0.0_KR)
    do mu = 1,3
     call delmu(Utad,mu,G1,it,iorder,bwdnbr,fwdnbr,G2)
     Gout = Gout + G2
    enddo ! mu
    if (imp) then
     factor = 1.0_KR/12.0_KR
     do mu = 1,3
      call delmu(Utad,mu,G1,it,iorder,bwdnbr,fwdnbr,G2)
      call delmu(Utad,mu,G2,it,iorder,bwdnbr,fwdnbr,G3)
      Gout = Gout - factor*G3
     enddo ! mu
    endif

 end subroutine h8

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 subroutine h9E(colE,it,Gin,Gout)
! Multiply i*sigma.(ExE) into the vector Gin at timeslice it.  
! NOTE: This the c9 term in the NRQCD Hamiltonian, UP TO A CONSTANT FACTOR
!       AND NEGLECTING THE COLOUR MAGNETIC FIELD.
! INPUT:
!   colE() is the colour electric field with the tadpole factors built in.
!   it is the time step where the operator is to be applied.
!   Gin() is the initial vector.
! OUTPUT:
!   Gout is i*sigma.(ExE)*Gin.

    complex(kind=KC), intent(in),  dimension(:,:,:,:) :: colE
    integer(kind=KI), intent(in)                      :: it
    complex(kind=KC), intent(in),  dimension(:,:,:)   :: Gin
    complex(kind=KC), intent(out), dimension(:,:,:)   :: Gout

    complex(kind=KC), dimension(nc,nc)   :: amat, bmat
    complex(kind=KC), dimension(nc)      :: avec, bvec, cvec, dvec
    complex(kind=KC), dimension(nc,np,3) :: spinor
    integer(kind=KI), dimension(3)       :: muvec, nuvec
    integer(kind=KI)                     :: ixyz, ixyzt, idir, mu, nu, ip

! Begin main loop over spatial sites.
    muvec = (/ 2, 3, 1 /)
    nuvec = (/ 3, 1, 2 /)
    do ixyz = 1,nxyz
     ixyzt = ixyz + nxyz*(it-1)

! --- ExE
     spinor = (0.0_KR,0.0_KR)
     do idir = 1,3
      mu = muvec(idir)
      nu = nuvec(idir)
      amat = colE(:,:,mu,ixyzt)
      bmat = colE(:,:,nu,ixyzt)
      do ip = 1,np
       avec = Gin(:,ip,ixyz)
       dvec = matmul(bmat,avec)
       bvec = matmul(amat,dvec)
       dvec = matmul(amat,avec)
       cvec = matmul(bmat,dvec)
       spinor(:,ip,idir) = spinor(:,ip,idir) + bvec - cvec
      enddo ! ip
     enddo ! idir

! --- take dot product with (sigma_x,sigma_y,sigma_z) AND multiply by i
     Gout(:,1,ixyz) = (0.0_KR,1.0_KR)*(spinor(:,2,1)+spinor(:,1,3)) &
                    + spinor(:,2,2)
     Gout(:,2,ixyz) = (0.0_KR,1.0_KR)*(spinor(:,1,1)-spinor(:,2,3)) &
                    - spinor(:,1,2)

! End main loop over spatial sites.
    enddo ! ixyz

 end subroutine h9E

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 subroutine h9EB(colE,colB,it,Gin,Gout)
! Multiply i*sigma.(ExE+BxB) into the vector Gin at timeslice it.  
! NOTE: This the c9 term in the NRQCD Hamiltonian, UP TO A CONSTANT FACTOR.
! INPUT:
!   colE() is the colour electric field with the tadpole factors built in.
!   colB() is the colour magnetic field with the tadpole factors built in.
!   it is the time step where the operator is to be applied.
!   Gin() is the initial vector.
! OUTPUT:
!   Gout is i*sigma.(ExE+BxB)*Gin.

    complex(kind=KC), intent(in),  dimension(:,:,:,:) :: colE, colB
    integer(kind=KI), intent(in)                      :: it
    complex(kind=KC), intent(in),  dimension(:,:,:)   :: Gin
    complex(kind=KC), intent(out), dimension(:,:,:)   :: Gout

    complex(kind=KC), dimension(nc,nc)   :: amat, bmat, cmat, dmat
    complex(kind=KC), dimension(nc)      :: avec, bvec, cvec, dvec, evec, fvec
    complex(kind=KC), dimension(nc,np,3) :: spinor
    integer(kind=KI), dimension(3)       :: muvec, nuvec
    integer(kind=KI)                     :: ixyz, ixyzt, idir, mu, nu, ip

! Begin main loop over spatial sites.
    muvec = (/ 2, 3, 1 /)
    nuvec = (/ 3, 1, 2 /)
    do ixyz = 1,nxyz
     ixyzt = ixyz + nxyz*(it-1)

! --- ExE + BxB
     spinor = (0.0_KR,0.0_KR)
     do idir = 1,3
      mu = muvec(idir)
      nu = nuvec(idir)
      amat = colE(:,:,mu,ixyzt)
      bmat = colE(:,:,nu,ixyzt)
      cmat = colB(:,:,mu,ixyz) 
      dmat = colB(:,:,nu,ixyz)
      do ip = 1,np
       avec = Gin(:,ip,ixyz)
       fvec = matmul(bmat,avec)
       bvec = matmul(amat,fvec)
       fvec = matmul(amat,avec)
       cvec = matmul(bmat,fvec)
       fvec = matmul(dmat,avec)
       dvec = matmul(cmat,fvec)
       fvec = matmul(cmat,avec)
       evec = matmul(dmat,fvec)
       spinor(:,ip,idir) = spinor(:,ip,idir) + bvec - cvec + dvec - evec
      enddo ! ip
     enddo ! idir

! --- take dot product with (sigma_x,sigma_y,sigma_z) AND multiply by i
     Gout(:,1,ixyz) = (0.0_KR,1.0_KR)*(spinor(:,2,1)+spinor(:,1,3)) &
                    + spinor(:,2,2)
     Gout(:,2,ixyz) = (0.0_KR,1.0_KR)*(spinor(:,1,1)-spinor(:,2,3)) &
                    - spinor(:,1,2)

! End main loop over spatial sites.
    enddo ! ixyz

 end subroutine h9EB

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 subroutine h10E(colE,it,Gin,Gout)
! Multiply E^2 into the vector Gin at timeslice it.  
! NOTE: This the c10 term in the NRQCD Hamiltonian, UP TO A CONSTANT FACTOR
!       AND NEGLECTING THE COLOUR MAGNETIC FIELD.
! INPUT:
!   colE() is the colour electric field with the tadpole factors built in.
!   it is the time step where the operator is to be applied.
!   Gin() is the initial vector.
! OUTPUT:
!   Gout is E^2 * Gin.

    complex(kind=KC), intent(in),  dimension(:,:,:,:) :: colE
    integer(kind=KI), intent(in)                      :: it
    complex(kind=KC), intent(in),  dimension(:,:,:)   :: Gin
    complex(kind=KC), intent(out), dimension(:,:,:)   :: Gout

    complex(kind=KC), dimension(nc,nc) :: amat
    complex(kind=KC), dimension(nc)    :: avec, bvec
    integer(kind=KI)                   :: ixyz, ixyzt, mu, ip

    Gout = (0.0_KR,0.0_KR)
    do ixyz = 1,nxyz
     ixyzt = ixyz + nxyz*(it-1)
     do mu = 1,3
      amat = colE(:,:,mu,ixyzt)
      do ip = 1,np
       avec = Gin(:,ip,ixyz)
       bvec = matmul(amat,avec)
       avec = matmul(amat,bvec)
       Gout(:,ip,ixyz) = Gout(:,ip,ixyz) + avec
      enddo ! ip
     enddo ! mu
    enddo ! ixyz

 end subroutine h10E

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 subroutine h10EB(colE,colB,it,Gin,Gout)
! Multiply (E^2+B^2) into the vector Gin at timeslice it.  
! NOTE: This the c10 term in the NRQCD Hamiltonian, UP TO A CONSTANT FACTOR.
! INPUT:
!   colE() is the colour electric field with the tadpole factors built in.
!   colB() is the colour magnetic field with the tadpole factors built in.
!   it is the time step where the operator is to be applied.
!   Gin() is the initial vector.
! OUTPUT:
!   Gout is (E^2+B^2)*Gin.

    complex(kind=KC), intent(in),  dimension(:,:,:,:) :: colE, colB
    integer(kind=KI), intent(in)                      :: it
    complex(kind=KC), intent(in),  dimension(:,:,:)   :: Gin
    complex(kind=KC), intent(out), dimension(:,:,:)   :: Gout

    complex(kind=KC), dimension(nc,nc) :: amat, bmat
    complex(kind=KC), dimension(nc)    :: avec, bvec, cvec, dvec
    integer(kind=KI)                   :: ixyz, ixyzt, mu, ip

    Gout = (0.0_KR,0.0_KR)
    do ixyz = 1,nxyz
     ixyzt = ixyz + nxyz*(it-1)
     do mu = 1,3
      amat = colE(:,:,mu,ixyzt)
      bmat = colB(:,:,mu,ixyz)
      do ip = 1,np
       avec = Gin(:,ip,ixyz)
       bvec = Gin(:,ip,ixyz)
       dvec = matmul(amat,avec)
       cvec = matmul(amat,dvec)
       avec = matmul(bmat,bvec)
       dvec = matmul(bmat,avec)
       Gout(:,ip,ixyz) = Gout(:,ip,ixyz) + cvec + dvec
      enddo ! ip
     enddo ! mu
    enddo ! ixyz

 end subroutine h10EB

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 subroutine delimp(Utad,mu,Gin,it,imp,bwdnbr,fwdnbr,Gout)
! Compute the first order improved (imp=.true.) or unimproved (imp=.false.)
! derivative operator in direction mu=1,2,3 (not mu=4) at timeslice it, 
! acting on vector Gin.  The result is assigned to Gout.
! INPUT:
!   Utad() contains the gauge fields divided by the appropriate tadpole factor.
!   mu is the spatial direction for this derivative operator.
!   Gin() is the initial vector.
!   it is the time step where the differentiation is to be applied.
!   imp is .true. if O(a^2) improvement should be applied.
!   bwdnbr(mu,i) is the neighbour of site i in the -mu direction.
!   fwdnbr(mu,i) is the neighbour of site i in the +mu direction.
! OUTPUT:
!   Gout() is the derivative of Gin().

    complex(kind=KC), intent(in),  dimension(:,:,:,:) :: Utad
    integer(kind=KI), intent(in)                      :: mu, it
    complex(kind=KC), intent(in),  dimension(:,:,:)   :: Gin
    logical,          intent(in)                      :: imp
    integer(kind=KI), intent(in),  dimension(:,:)     :: bwdnbr, fwdnbr
    complex(kind=KC), intent(out), dimension(:,:,:)   :: Gout

    complex(kind=KC), dimension(nc,np,nxyz) :: Gmul, Gmul2
    complex(kind=KC), dimension(nc,nc)      :: amat
    complex(kind=KC), dimension(nc)         :: avec, bvec
    integer(kind=KI)                        :: iorder, ixyz, ixyzt, ip

! Begin with the unimproved derivative.
    iorder = 1
    call delmu(Utad,mu,Gin,it,iorder,bwdnbr,fwdnbr,Gout)

! Apply O(a^2) correction if requested.
    if (imp) then
! --- backward derivative on input spinor.
     Gmul = (0.0_KR,0.0_KR)
     do ixyz = 1,nxyz
      ixyzt = ixyz + nxyz*(it-1)
      amat = Utad(:,:,mu,bwdnbr(mu,ixyzt))
      do ip = 1,np
       avec = Gin(:,ip,bwdnbr(mu,ixyz))
       bvec = matmul(conjg(transpose(amat)),avec)
       Gmul(:,ip,ixyz) = Gin(:,ip,ixyz) - bvec
      enddo ! ip
     enddo ! ixyz
! --- unimproved centered derivative.
     call delmu(Utad,mu,Gmul,it,iorder,bwdnbr,fwdnbr,Gmul2)
! --- forward derivative.
     Gmul = (0.0_KR,0.0_KR)
     do ixyz = 1,nxyz
      ixyzt = ixyz + nxyz*(it-1)
      amat = Utad(:,:,mu,ixyzt)
      do ip = 1,np
       avec = Gmul2(:,ip,fwdnbr(mu,ixyz))
       bvec = matmul(amat,avec)
       Gmul(:,ip,ixyz) = bvec - Gmul2(:,ip,ixyz)
      enddo ! ip
     enddo ! ixyz
! --- record O(a^2) correction.
     Gout = Gout - Gmul/6.0_KR
    endif

 end subroutine delimp

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 subroutine delmu(Utad,mu,Gin,it,iorder,bwdnbr,fwdnbr,Gout)
! Compute the first order (iorder=1) or second order (iorder=2) unimproved 
! derivative operator in direction mu=1,2,3 (not mu=4) at timeslice it,
! acting on the vector Gin.  The result is assigned to Gout.
! INPUT:
!   Utad() contains the gauge fields divided by the appropriate tadpole factor.
!   mu is the spatial direction for this derivative operator.
!   Gin() is the initial vector.
!   it is the time step where the differentiation is to be applied.
!   iorder is the order of differentiation (1 or 2).
!   bwdnbr(mu,i) is the neighbour of site i in the -mu direction.
!   fwdnbr(mu,i) is the neighbour of site i in the +mu direction.
! OUTPUT:
!   Gout() is the derivative of Gin().

    complex(kind=KC), intent(in),  dimension(:,:,:,:) :: Utad
    integer(kind=KI), intent(in)                      :: mu, it, iorder
    complex(kind=KC), intent(in),  dimension(:,:,:)   :: Gin
    integer(kind=KI), intent(in),  dimension(:,:)     :: bwdnbr, fwdnbr
    complex(kind=KC), intent(out), dimension(:,:,:)   :: Gout

    complex(kind=KC), dimension(nc,nc) :: amat, bmat
    complex(kind=KC), dimension(nc)    :: avec, bvec, cvec, dvec
    integer(kind=KI)                   :: ixyz, ixyzt, ip

    do ixyz = 1,nxyz
     ixyzt = ixyz + nxyz*(it-1)
     amat = Utad(:,:,mu,ixyzt)
     bmat = Utad(:,:,mu,bwdnbr(mu,ixyzt))
     do ip = 1,np
      avec = Gin(:,ip,fwdnbr(mu,ixyz))
      bvec = Gin(:,ip,bwdnbr(mu,ixyz))
      cvec = matmul(amat,avec)
      dvec = matmul(conjg(transpose(bmat)),bvec)
      if (iorder==1) then
       Gout(:,ip,ixyz) = 0.5_KR*(cvec-dvec)
      else
       Gout(:,ip,ixyz) = cvec + dvec
      endif
     enddo ! ip
    enddo ! ixyz

    if (iorder==2) then
     Gout = Gout - 2.0_KR*Gin
    endif

 end subroutine delmu

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 subroutine Eclov(Utad,imp,uzeros,uzerot,aspect,bwdnbr,fwdnbr,colE)
! Compute clover-leaf colour electric fields from gauge fields.
! INPUT:
!   Utad() contains the gauge fields divided by the appropriate tadpole factor.
!   imp=.true. if O(a^2) correction is to be performed.
!   uzeros is the spatial tadpole factor.
!   uzerot is the temporal tadpole factor.
!   aspect is the ratio of spatial to temporal lattice spacings, a_s/a_t.
!   bwdnbr(mu,i) is the neighbour of site i in the -mu direction.
!   fwdnbr(mu,i) is the neighbour of site i in the +mu direction.
! OUTPUT:
!   colE() is the colour electric field with the tadpole factors built in.

    complex(kind=KC), intent(in),  dimension(:,:,:,:) :: Utad
    logical,          intent(in)                      :: imp
    real(kind=KR),    intent(in)                      :: uzeros, uzerot, aspect
    integer(kind=KI), intent(in),  dimension(:,:)     :: bwdnbr, fwdnbr
    complex(kind=KC), intent(out), dimension(:,:,:,:) :: colE

    complex(kind=KC), dimension(nc,nc,nxyzt) :: field
    complex(kind=KC), dimension(nc,nc)       :: amat, bmat, cmat, dmat, &
                                                abmat, summat
    complex(kind=KC)                         :: TraceImag
    integer(kind=KI), dimension(3)           :: muvec, nuvec
    integer(kind=KI)                         :: mu, nu, ixyzt, iplane, icol
    real(kind=KR)                            :: Ecorfac
    
    muvec = (/ 4, 4, 4 /)
    nuvec = (/ 1, 2, 3 /)

! Include the 5/3 factor plus the correction of Groote and Shigemitsu,
! Phys.Rev.D62,014508(2000).  See also Phys.Rev.D72,094507(2005) eq.2.
    Ecorfac = 5.0_KR/3.0_KR + (1.0_KR/(uzeros*uzerot) - 1.0_KR)/3.0_KR

! Sum over three planes (mu,nu).
    do iplane = 1,3
     mu = muvec(iplane)
     nu = nuvec(iplane)

! Step 1: O(a) fields.
     do ixyzt = 1,nxyzt
! --- first leaf
      amat = Utad(:,:,mu,ixyzt)
      bmat = Utad(:,:,nu,fwdnbr(mu,ixyzt))
      cmat = Utad(:,:,mu,fwdnbr(nu,ixyzt))
      dmat = Utad(:,:,nu,ixyzt)
      abmat = matmul(amat,bmat)
      bmat = matmul(abmat,conjg(transpose(cmat)))
      cmat = matmul(bmat,conjg(transpose(dmat)))
      summat = cmat
! --- second leaf
      amat = Utad(:,:,nu,ixyzt)
      bmat = Utad(:,:,mu,fwdnbr(nu,bwdnbr(mu,ixyzt)))
      cmat = Utad(:,:,nu,bwdnbr(mu,ixyzt))
      dmat = Utad(:,:,mu,bwdnbr(mu,ixyzt))
      abmat = matmul(amat,conjg(transpose(bmat)))
      bmat = matmul(abmat,conjg(transpose(cmat)))
      cmat = matmul(bmat,dmat)
      summat = summat + cmat
! --- third leaf
      amat = Utad(:,:,mu,bwdnbr(mu,ixyzt))
      bmat = Utad(:,:,nu,bwdnbr(nu,bwdnbr(mu,ixyzt)))
      cmat = Utad(:,:,mu,bwdnbr(nu,bwdnbr(mu,ixyzt)))
      dmat = Utad(:,:,nu,bwdnbr(nu,ixyzt))
      abmat = matmul(conjg(transpose(amat)),conjg(transpose(bmat)))
      bmat = matmul(abmat,cmat)
      cmat = matmul(bmat,dmat)
      summat = summat + cmat
! --- fourth leaf
      amat = Utad(:,:,nu,bwdnbr(nu,ixyzt))
      bmat = Utad(:,:,mu,bwdnbr(nu,ixyzt))
      cmat = Utad(:,:,nu,bwdnbr(nu,fwdnbr(mu,ixyzt)))
      dmat = Utad(:,:,mu,ixyzt)
      abmat = matmul(conjg(transpose(amat)),bmat)
      bmat = matmul(abmat,cmat)
      cmat = matmul(bmat,conjg(transpose(dmat)))
      summat = summat + cmat
! --- keep only the traceless part and the antihermitian part
      bmat = conjg(transpose(summat))
      field(:,:,ixyzt) = (0.0_KR,-0.5_KR)*(summat-bmat)
      TraceImag = cmplx(aimag(summat(1,1)+summat(2,2)+summat(3,3))/3.0_KR, &
                  0.0_KR,KC)
      field(1,1,ixyzt) = field(1,1,ixyzt) - TraceImag
      field(2,2,ixyzt) = field(2,2,ixyzt) - TraceImag
      field(3,3,ixyzt) = field(3,3,ixyzt) - TraceImag
     enddo ! ixyzt
! --- usual normalization (counting four clover leaves).
     field = -0.25_KR*field
! Step 2: O(a^2) fields.
     if (imp) then
      do ixyzt = 1,nxyzt
! --- first mu correction term.
       amat = Utad(:,:,mu,ixyzt)
       bmat = field(:,:,fwdnbr(mu,ixyzt))
       abmat = matmul(amat,bmat)
       cmat = matmul(abmat,conjg(transpose(amat)))
       summat = cmat
! --- second mu correction term.
       amat = Utad(:,:,mu,bwdnbr(mu,ixyzt))
       bmat = field(:,:,bwdnbr(mu,ixyzt))
       abmat = matmul(conjg(transpose(amat)),bmat)
       cmat = matmul(abmat,amat)
       summat = summat + cmat
! --- first nu correction term.
       amat = Utad(:,:,nu,ixyzt)
       bmat = field(:,:,fwdnbr(nu,ixyzt))
       abmat = matmul(amat,bmat)
       cmat = matmul(abmat,conjg(transpose(amat)))
       summat = summat + cmat
! --- second nu correction term.
       amat = Utad(:,:,nu,bwdnbr(nu,ixyzt))
       bmat = field(:,:,bwdnbr(nu,ixyzt))
       abmat = matmul(conjg(transpose(amat)),bmat)
       cmat = matmul(abmat,amat)
       summat = summat + cmat
! --- total O(a^2) correction added to O(a) result.
       colE(:,:,iplane,ixyzt) = Ecorfac*field(:,:,ixyzt) - summat/6.0_KR
      enddo ! ixyzt
     else
      colE(:,:,iplane,:) = field
     endif

! End loop over iplane.
    enddo ! iplane

! Most of NRQCD involves the spatial directions except the 
! colour-electric field.  The ratio of spatial to temporal 
! lattice spacings is multiplied into colE.
    colE = aspect*colE

 end subroutine Eclov

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 subroutine Bclov(Utad,it,imp,uzeros,bwdnbr,fwdnbr,colB)
! Compute clover-leaf colour magnetic fields from gauge fields at a single
! lattice time step.
! INPUT:
!   Utad() contains the gauge fields divided by the appropriate tadpole factor.
!   it is the lattice time step where colour magnetic fields will be computed.
!   imp=.true. if O(a^2) correction is to be performed.
!   uzeros is the spatial tadpole factor.
!   bwdnbr(mu,i) is the neighbour of site i in the -mu direction.
!   fwdnbr(mu,i) is the neighbour of site i in the +mu direction.
! OUTPUT:
!   colB() is the colour magnetic field with the tadpole factors built in.

    complex(kind=KC), intent(in),  dimension(:,:,:,:) :: Utad
    integer(kind=KI), intent(in)                      :: it
    logical,          intent(in)                      :: imp
    real(kind=KR),    intent(in)                      :: uzeros
    integer(kind=KI), intent(in),  dimension(:,:)     :: bwdnbr, fwdnbr
    complex(kind=KC), intent(out), dimension(:,:,:,:) :: colB

    complex(kind=KC), dimension(nc,nc,nxyz) :: field
    complex(kind=KC), dimension(nc,nc)      :: amat, bmat, cmat, dmat, &
                                               abmat, summat
    complex(kind=KC)                        :: TraceImag
    integer(kind=KI), dimension(3)          :: muvec, nuvec
    integer(kind=KI)                        :: mu, nu, ixyz, ixyzt, iplane, icol
    real(kind=KR)                           :: Bcorfac
    
    muvec = (/ 2, 3, 1 /)
    nuvec = (/ 3, 1, 2 /)
    Bcorfac = 5.0_KR/3.0_KR + (1.0_KR/uzeros**2 - 1.0_KR)/3.0_KR

! Sum over three planes (mu,nu).
    do iplane = 1,3
     mu = muvec(iplane)
     nu = nuvec(iplane)

! Step 1: O(a) fields.
     do ixyz = 1,nxyz
      ixyzt = ixyz + (it-1)*nxyz
! --- first leaf
      amat = Utad(:,:,mu,ixyzt)
      bmat = Utad(:,:,nu,fwdnbr(mu,ixyzt))
      cmat = Utad(:,:,mu,fwdnbr(nu,ixyzt))
      dmat = Utad(:,:,nu,ixyzt)
      abmat = matmul(amat,bmat)
      bmat = matmul(abmat,conjg(transpose(cmat)))
      cmat = matmul(bmat,conjg(transpose(dmat)))
      summat = cmat
! --- second leaf
      amat = Utad(:,:,nu,ixyzt)
      bmat = Utad(:,:,mu,fwdnbr(nu,bwdnbr(mu,ixyzt)))
      cmat = Utad(:,:,nu,bwdnbr(mu,ixyzt))
      dmat = Utad(:,:,mu,bwdnbr(mu,ixyzt))
      abmat = matmul(amat,conjg(transpose(bmat)))
      bmat = matmul(abmat,conjg(transpose(cmat)))
      cmat = matmul(bmat,dmat)
      summat = summat + cmat
! --- third leaf
      amat = Utad(:,:,mu,bwdnbr(mu,ixyzt))
      bmat = Utad(:,:,nu,bwdnbr(nu,bwdnbr(mu,ixyzt)))
      cmat = Utad(:,:,mu,bwdnbr(nu,bwdnbr(mu,ixyzt)))
      dmat = Utad(:,:,nu,bwdnbr(nu,ixyzt))
      abmat = matmul(conjg(transpose(amat)),conjg(transpose(bmat)))
      bmat = matmul(abmat,cmat)
      cmat = matmul(bmat,dmat)
      summat = summat + cmat
! --- fourth leaf
      amat = Utad(:,:,nu,bwdnbr(nu,ixyzt))
      bmat = Utad(:,:,mu,bwdnbr(nu,ixyzt))
      cmat = Utad(:,:,nu,bwdnbr(nu,fwdnbr(mu,ixyzt)))
      dmat = Utad(:,:,mu,ixyzt)
      abmat = matmul(conjg(transpose(amat)),bmat)
      bmat = matmul(abmat,cmat)
      cmat = matmul(bmat,conjg(transpose(dmat)))
      summat = summat + cmat
! --- keep only the traceless part and the antihermitian part
      bmat = conjg(transpose(summat))
      field(:,:,ixyz) = (0.0_KR,-0.5_KR)*(summat-bmat)
      TraceImag = cmplx(aimag(summat(1,1)+summat(2,2)+summat(3,3))/3.0_KR, &
                  0.0_KR,KC)
      field(1,1,ixyz) = field(1,1,ixyz) - TraceImag
      field(2,2,ixyz) = field(2,2,ixyz) - TraceImag
      field(3,3,ixyz) = field(3,3,ixyz) - TraceImag
     enddo ! ixyzt
! --- usual normalization (counting four clover leaves).
     field = -0.25_KR*field
! Step 2: O(a^2) fields.
     if (imp) then
      do ixyz = 1,nxyz
       ixyzt = ixyz + (it-1)*nxyz
! --- first mu correction term.
       amat = Utad(:,:,mu,ixyzt)
       bmat = field(:,:,fwdnbr(mu,ixyz))
       abmat = matmul(amat,bmat)
       cmat = matmul(abmat,conjg(transpose(amat)))
       summat = cmat
! --- second mu correction term.
       amat = Utad(:,:,mu,bwdnbr(mu,ixyzt))
       bmat = field(:,:,bwdnbr(mu,ixyz))
       abmat = matmul(conjg(transpose(amat)),bmat)
       cmat = matmul(abmat,amat)
       summat = summat + cmat
! --- first nu correction term.
       amat = Utad(:,:,nu,ixyzt)
       bmat = field(:,:,fwdnbr(nu,ixyz))
       abmat = matmul(amat,bmat)
       cmat = matmul(abmat,conjg(transpose(amat)))
       summat = summat + cmat
! --- second nu correction term.
       amat = Utad(:,:,nu,bwdnbr(nu,ixyzt))
       bmat = field(:,:,bwdnbr(nu,ixyz))
       abmat = matmul(conjg(transpose(amat)),bmat)
       cmat = matmul(abmat,amat)
       summat = summat + cmat
! --- total O(a^2) correction added to O(a) result.
       colB(:,:,iplane,ixyz) = Bcorfac*field(:,:,ixyz) - summat(:,:)/6.0_KR
      enddo ! ixyz
     else
      colB(:,:,iplane,:) = field
     endif

! End loop over iplane.
    enddo ! iplane

 end subroutine Bclov

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 end module heavypropagators

! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
