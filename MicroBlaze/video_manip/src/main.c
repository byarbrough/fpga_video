/*
 * main.c
 *
 *  Created on: May 6, 2015
 *      Author: C16Brian.Yarbrough
 *
 *      v1.0 Does HDMI throughput
 *      errors in generating timing in platform studio
 *
 *      "wave" effect is because microprocessor is too slow
 *      	Might be able to configure with clock speed
 */
#include <xuartlite_l.h>
#include <xparameters.h>
#include <xil_io.h>
#include "header.h"

int main(void)
{
xil_printf("begin/r/n");
 while (1)
 {

  //throughput
  Xil_Out8(rOut, Xil_In8(rIn));
  Xil_Out8(gOut, Xil_In8(gIn));
  Xil_Out8(bOut, Xil_In8(bIn));

 }
 return 0;
}

