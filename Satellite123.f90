program satellite_software
    implicit none

    ! Constants
    real(8), parameter :: G = 6.67430e-11 ! Gravitational constant, (m^3/kg/s^2)
    real(8), parameter :: M_earth = 5.972e24 ! Mass of the Earth (kg)
    real(8), parameter :: R_earth = 6371000.0 ! Radius of the Earth (m)

    ! Variables
    real(8) :: altitude, inclination, period, velocity, semi_major_axis
    real(8) :: x, y, z, t, dt
    integer :: num_steps, i
    character(len=10) :: mode

    ! input
    print *, "Welcome to MySatellite3D!"
    print *, "Choose mode: 'real' for real-time or 'sim' for simulation."
    read(*, '(A)') mode

    if (trim(mode) == 'sim') then
        ! simulation
        call simulate_orbit()
    else if (trim(mode) == 'real') then
        ! Real-time updates
        call real_time_orbit()
    else
        print *, "Invalid mode selected. Please choose from 'real' and 'sim'."
    end if

contains

    ! Subroutine for sim
    subroutine simulate_orbit()
        print *, "Enter satellite altitude above Earth's surface (in meters):"
        read(*, *) altitude
        print *, "Enter orbital inclination (in degrees):"
        read(*, *) inclination

        ! Calculate orbitals
        semi_major_axis = R_earth + altitude
        velocity = sqrt(G * M_earth / semi_major_axis) ! Orbital velocity (m/s)
        period = 2.0 * 3.14159 * semi_major_axis / velocity ! Orbital period (s)

        ! Sim settings
        dt = period / 360.0 ! Time step for simulation
        num_steps = 360

        ! Output results
        print *, "Simulating orbit..."
        open(unit=10, file="orbit_simulation.csv", status="replace")
        write(10, '(A)') "time,x,y,z"

        do i = 0, num_steps - 1
            t = i * dt
            call compute_position(semi_major_axis, inclination, t, x, y, z)
            write(10, '(F8.2, 1x, F8.2, 1x, F8.2, 1x, F8.2)') t, x, y, z
        end do

        close(10)
        print *, "Simulation data written to 'orbit_simulation.csv'."
    end subroutine simulate_orbit

    ! Subroutine for real
    subroutine real_time_orbit()
        print *, "Enter satellite altitude above Earth's surface (in meters):"
        read(*, *) altitude

        ! Calculate orbitals
        semi_major_axis = R_earth + altitude
        velocity = sqrt(G * M_earth / semi_major_axis) ! Orbital velocity (m/s)
        period = 2.0 * 3.14159 * semi_major_axis / velocity ! Orbital period (s)

        print *, "Real-time orbit tracking started."
        print *, "Press Ctrl+C to stop the simulation."

        ! Open output file
        open(unit=20, file="real_time_data.csv", status="replace")
        write(20, '(A)') "time,x,y,z"

        t = 0.0
        dt = period / 360.0

        do
            call compute_position(semi_major_axis, 0.0_8, t, x, y, z) ! Assume equatorial orbit
            write(20, '(F8.2, 1x, F8.2, 1x, F8.2, 1x, F8.2)') t, x, y, z
            print *, "Time:", t, "Position: (", x, y, z, ")"
            t = t + dt
            call sleep(1) ! real-time delay (needs OS support, to be updated)
        end do

        close(20)
    end subroutine real_time_orbit

    ! Subroutine to compute orbital position
    subroutine compute_position(semi_major_axis, inclination, t, x, y, z)
        real(8), intent(in) :: semi_major_axis, inclination, t
        real(8), intent(out) :: x, y, z
        real(8) :: theta, inclination_rad

        inclination_rad = inclination * 3.14159 / 180.0
        theta = mod(t / semi_major_axis, 2.0 * 3.14159) ! Angular position

        x = semi_major_axis * cos(theta)
        y = semi_major_axis * sin(theta)
        z = semi_major_axis * sin(inclination_rad)
    end subroutine compute_position

    ! Subroutine for sleep (OS-dependent... To be updated)
    subroutine sleep(seconds)
        integer, intent(in) :: seconds
        call system("sleep " // trim(adjustl(itoa(seconds))))
    end subroutine sleep

    ! Integer to string
    function itoa(num) result(str)
        integer, intent(in) :: num
        character(len=10) :: str
        write(str, '(I0)') num
    end function itoa

end program satellite_software