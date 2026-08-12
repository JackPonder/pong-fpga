# FPGA Pong

A hardware implementation of the classic Pong game developed for the Digilent Basys 3 FPGA.

## Features

* Real-time Pong gameplay implemented entirely in FPGA logic
* Collision detection between the ball, paddles, and game boundaries
* Variable ball deflection angle based on where ball hits paddle
* Two-player control using analog joysticks
* SPI interface for reading joystick inputs
* 640×480 @ 60 Hz VGA output
* Synthesizable RTL suitable for implementation on the Basys 3

## Development

### Requirements

* Xilinx Vivado
* Digilent Basys 3 FPGA Board
* VGA monitor supporting 640×480 @ 60 Hz
* Two Pmod JSTK2 joysticks

### Building the Project

1. Clone the repository
```
git clone https://github.com/JackPonder/pong-fpga.git
```

2. Create the Vivado project
```
vivado -mode batch -source scripts/create_project.tcl
```

3. Run Synthesis & Implementation

4. Generate Bitstream

5. Program Device

6. Connect the VGA monitor to the Basys 3 VGA output

7. Connect the two joysticks to the Basys 3 Pmod JA

8. Begin playing!

## Authors

* Jack Ponder [@JackPonder](https://github.com/JackPonder) 
* Zachary Kuo [@Ch3rud1m](https://github.com/ch3rud1m)
