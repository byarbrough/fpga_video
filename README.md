FPGA Video
=====================================
Manipulation of HDMI video with MicroBlaze. Xilinx Spartan 6.
-----------------------------

This project uses the [input](http://hamsterworks.co.nz/mediawiki/index.php/HDMI_Input#Test_setup) and [output](http://hamsterworks.co.nz/mediawiki/index.php/Dvid_test)
 HDMI packages from hampsterworks to make a perpehial for Xilinx Platform Studio.
 
 The perephial is setup so that the decoded bits are sent to to MicroBlaze via slave registers, where they can be processed and returned - again via slave registers.
 Once the manipulated signals are returned, they are displayed on an external monitor.
 
 Currently the system does throughput.
 
 Current problems:
 1. Seems to only work with VGA protocol, not directly from a laptop or other HDMI source
 2. Wavelike ripple across screen because of the delay introduced by the microporcessor
 3. Does not line up the corners of the screen and scrolls
 4. Had to override a timing error when generating the bitstream
 5. UART Does not work
 
 Considering the above issues, the project does not do much more than throughput, but it is a good starting place!

 __For more details, please see report folder__
