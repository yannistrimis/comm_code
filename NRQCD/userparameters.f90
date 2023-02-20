! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
!
! userparameters.f90, randy.lewis@yorku.ca
!
! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 module userparameters

    implicit none

! Define the integer precision, KI=4 for single and KI=8 for double.
    integer, public, parameter :: KI=4

! Define the real precision, KR=4 for single and KR=8 for double.
    integer, public, parameter :: KR=8

! Define the complex precision, KC=4 for single and KC=8 for double.
    integer, public, parameter :: KC=8

! Define the number of space-time dimensions.
! NOTE: At present the code will only work with ndir=4.
    integer, public, parameter :: ndir=4

! Define the number of colors in the gauge theory.
! NOTE: At present the code will only work with nc=3.
    integer, public, parameter :: nc=3

! Define the number of Pauli indices.
! NOTE: At present the code will only work with np=2.
    integer, public, parameter :: np=2

! Define the number of lattice sites in each spatial direction.
    integer, public, parameter :: nx=16, ny=16, nz=16

! Define the total number of lattice sites in the time direction.
    integer, public, parameter :: largeNt=32

! Define the number of consecutive lattice sites in the time direction that
! will be used for any correlation function.
! NOTE: If nt<largeNt then correlation functions will only have nt-4 time steps
!       because two initial time steps and two final time steps are needed
!       for neighbours during the calculation of color-electric fields.
    integer, public, parameter :: nt=8

! ===============================================
! Abandon all hope, ye who tamper below this line.

    integer, public, parameter :: nxyz=nx*ny*nz, nxyzt=nxyz*nt

 end module userparameters
 
! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
