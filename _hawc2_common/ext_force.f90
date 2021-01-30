module ext_force_mod
   implicit none
   integer, parameter :: mk = kind(1.0d0)
   real(MK), allocatable, dimension(:) :: vtime
   real(MK), allocatable, dimension(:,:) :: loads
   integer :: iPrev 
   real(MK) :: tRamp
   integer nStep, nChannel
contains
!**************************************************************************************************
subroutine initialize(array1, array2) bind(c, name='initialize')
   !DEC$ IF .NOT. DEFINED(__LINUX__)
   !DEC$ ATTRIBUTES DLLEXPORT :: initialize
   !DEC$ END IF
   real(mk), dimension(9), intent(inout) :: array1
   real(mk), dimension(1), intent(inout) :: array2
   ! Local vars
   integer i,j
   integer iUnit
   integer iExt
   integer iConstant
   character(len=100) :: filename
   character(len=1024) :: sDummy
   real(mk) :: F6 !< Loads
   real(mk) dt
   write(6, *) '--------------------------------------------------'
   write(6, *) 'Initialization of force_ext.dll, written by E.Branlard'
   iExt      = int(array1(1))
   tRamp     = array1(2)
   iConstant = int(array1(3))
   if (iConstant==1) then
      ! we will apply constant loads throughout (after tRamp)
      nStep    = 1
      nChannel = 6
      allocate(loads(nStep, nChannel)); loads=0.0_MK
      allocate(vtime(nStep)); 
      vtime      = 0.0_MK
      loads(1,:) = array1(4:9)
      print*,'A constant load will be returned.'
      print '(A,6(ES13.4E2))',' Load    : ',loads(1,:)
   else
      ! we open the input file time series
      print*,'Loads obtained from time series.'
      write(filename,'(A,I0)') 'ext_force.0',iExt
      print*,'filename: ',trim(filename)
      iUnit=212
      open(unit=iUnit, file=trim(filename))
      read(iUnit,*) sDummy
      print*,'Header  : ',trim(sDummy)
      read(iUnit,*) nStep, dt, nChannel
      print*,'nStep   : ',nStep
      print*,'dt      : ',dt
      print*,'nChannel: ',nChannel
      allocate(loads(nStep, nChannel)); loads=0.0_MK
      allocate(vtime(nStep)); vtime=0.0_MK
      do i=1,nStep
         read(iUnit,*) loads(i,:)
         vtime(i)=i*dt
      enddo
   endif
   print*,'tRamp   : ',tRamp
   iPrev=1
   close(iUnit)
   array2 = 0.0_mk
   write(6, *) '--------------------------------------------------'
   return
end subroutine initialize

subroutine findtimestep(time, iSel, fact)
   real(mk), intent(in) :: time
   real(mk), intent(out) :: fact
   integer,  intent(out) :: iSel
   integer :: i

   if (time<=tRamp .and. tRamp>0.0_MK) then
      fact = (time)/tRamp
      fact = min(fact, 1.0_MK)
      fact = max(fact, 0.0_MK)
   else
      fact = 1.0_MK
   endif

   if (vtime(iPrev)> time) then 
      iSel=iPrev
   elseif (iPrev == size(vtime)) then 
      iSel=iPrev
   else
      ! Look for index
      do i=iPrev,nStep
         if (vtime(i)<=time) then
            iPrev=i
         else
            exit
         endif
      enddo
      iSel=iPrev
   endif
end subroutine findtimestep

subroutine update(array1, array2) bind(c,name='update')
   !
   ! Controller interface.
   !  - sets DLL inputs/outputs.
   !  - sets controller timers.
   !  - calls the safety system monitor (higher level).
   !
   !DEC$ IF .NOT. DEFINED(__LINUX__)
   !DEC$ ATTRIBUTES DLLEXPORT :: update
   !DEC$ END IF
   real(mk), dimension(1000), intent(inout) :: array1
   real(mk), dimension(1000), intent(inout) :: array2
   ! Local variables
   real(mk) time, fact
   integer :: j, iSel
   ! Time
   time = array1(1)
   call findtimestep(time, iSel, fact)
   ! Output array
   array2 = 0.0_MK
   do j = 1, nChannel
      array2(j) =  fact*loads(iSel,j)
   enddo
   return
end subroutine update
!**************************************************************************************************
end module ext_force_mod
