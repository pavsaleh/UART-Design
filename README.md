# UART-Design
Designing and building a complete UART in VHDL

A UART is a Universal Asynchronous Receiver-Transmitter, which is used to communicate between two devices. Most computers and microcontrollers include one or more serial data ports utilized to communicate with other serial I/O devices, such as keyboards and serial printers. A UART provides the means to send information using a minimum number of wires. This data is sent bit serially, without a clock signal. The main function of a UART is the conversion of parallel-to-serial when transmitting and serial-to-parallel when receiving. In this project, we will, utilizing the UART theory, implement a UART by realizing the UART components as well as the UART control circuits. Finally, having done all that, we will be connecting up the lot to real sensors and actuators. This UART that will be designed will be incorporated with the traffic light controller, which was realized in a previous project.