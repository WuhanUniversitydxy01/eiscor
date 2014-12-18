#include "eiscor.h"
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
! example_z_unihess_rootsofunity
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
! This routine computes the Nth order roots of unity by solving a
! corresponding unitary eigenvalue problem two different ways.
!
! 1) Form upper hessenberg permutation matrix and compute its 
!    eigenvalues using z_unihess_qr
!
! 2) Construct the factorization directly and compute its 
!    eigenvalues using z_unifact_qr
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
program example_z_unihess_rootsofunity

  implicit none
  
  ! compute variables
  integer, parameter :: N = 16
  integer :: ii, INFO
  real(8) :: WORK(5*N), Q(3*(N-1)), D(2*N)
  complex(8) :: H(N,N), Z
  integer :: ITS(N-1)
  
  ! print banner
  print*,""
  print*,"example_z_unihess_rootsofunity:"
  print*,""
  
  ! initialize H to be an upper hessenberg permutation matrix
  H = cmplx(0d0,0d0,kind=8)
  do ii=1,N-1
    H(ii+1,ii) = cmplx(1d0,0d0,kind=8)
  end do
  H(1,N) = cmplx(1d0,0d0,kind=8)
  
  ! call zuhfqr
  call z_unihess_qr('N',N,H,Z,ITS,WORK,INFO)
  
  ! check INFO
  if (INFO.NE.0) then
    print*,"z_unihess_qr failed."
    print*,"INFO:",INFO
  end if
  
  ! print diag of H
  print*,"Roots computed using z_unihess_qr:"
  do ii=1,N
    print*,dble(H(ii,ii)),aimag(H(ii,ii))
  end do
  print*,""
  
  ! initialize Q and D to be an upper hessenberg permutation matrix
  do ii=1,N-1
    Q(3*ii-2) = 0d0
    Q(3*ii-1) = 0d0
    Q(3*ii) = 1d0
  end do
  do ii=1,N-1
    D(2*ii-1) = 1d0
    D(2*ii) = 0d0
  end do
  D(2*N-1) = (-1d0)**(N-1)
  D(2*N) = 0d0
  
  ! call zuffqr
  call z_unifact_qr('N',N,Q,D,Z,ITS,INFO)
  
  ! check INFO
  if (INFO.NE.0) then
    print*,"z_unifact_qr failed."
    print*,"INFO:",INFO
  end if
  
  ! print D
  print*,"Roots computed using z_unifact_qr:"
  do ii=1,N
    print*,D(2*ii-1),D(2*ii)
  end do
  print*,""

    
end program example_z_unihess_rootsofunity