program lunar_analyzer
    implicit none

    integer :: battery
    integer :: motor_temp
    integer :: wheel_slip
    integer :: signal
    integer :: ios

    real :: terrain_slope
    real :: speed
    real :: traction_score
    real :: power_margin

    character(len=100) :: line

    battery = 0
    motor_temp = 0
    wheel_slip = 0
    signal = 0
    terrain_slope = 0.0
    speed = 0.0

    open(unit=10, file="lunar_telemetry.txt", &
         status="old", action="read", iostat=ios)

    if (ios /= 0) then
        print *, "ERROR: LUNAR TELEMETRY NOT FOUND"
        stop 1
    end if

    do
        read(10, '(A)', iostat=ios) line

        if (ios /= 0) exit

        if (index(line, "BATTERY=") == 1) then
            read(line(9:), *) battery

        else if (index(line, "MOTOR_TEMP=") == 1) then
            read(line(12:), *) motor_temp

        else if (index(line, "WHEEL_SLIP=") == 1) then
            read(line(12:), *) wheel_slip

        else if (index(line, "TERRAIN_SLOPE=") == 1) then
            read(line(15:), *) terrain_slope

        else if (index(line, "SIGNAL=") == 1) then
            read(line(8:), *) signal

        else if (index(line, "SPEED=") == 1) then
            read(line(7:), *) speed
        end if
    end do

    close(10)

    traction_score = 100.0 - real(wheel_slip)
    power_margin = real(battery)

    open(unit=20, file="lunar_result.txt", &
         status="replace", action="write")

    write(20,'(A,F6.1)') "TRACTION_SCORE=", traction_score
    write(20,'(A,F6.1)') "POWER_MARGIN=", power_margin
    write(20,'(A,F6.1)') "TERRAIN_SLOPE=", terrain_slope
    write(20,'(A,I0)')   "MOTOR_TEMP=", motor_temp
    write(20,'(A,I0)')   "SIGNAL=", signal
    write(20,'(A,F6.2)') "SPEED=", speed

    if (wheel_slip >= 40 .or. battery <= 20 .or. &
        signal <= 25 .or. terrain_slope >= 30.0 .or. &
        motor_temp >= 80) then

        write(20,'(A)') "ANALYSIS_STATE=UNDER_STRESS"

    else if (wheel_slip >= 25 .or. battery <= 40 .or. &
             signal <= 50 .or. terrain_slope >= 20.0 .or. &
             motor_temp >= 65) then

        write(20,'(A)') "ANALYSIS_STATE=DEGRADED"

    else
        write(20,'(A)') "ANALYSIS_STATE=CALM"
    end if

    close(20)

    print *, "LUNAR ENGINEERING ANALYSIS COMPLETE"
    print *, "COBOL TELEMETRY INPUT PROCESSED"

end program lunar_analyzer
