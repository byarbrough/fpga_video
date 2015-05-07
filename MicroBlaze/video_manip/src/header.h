/*
 * header.h
 *
 *  Created on: May 6, 2015
 *      Author: C16Brian.Yarbrough
 */

#include <xuartlite_l.h>
#include <xparameters.h>

#ifndef HEADER_H_
#define HEADER_H_

#define uartReg		0x84000000

#define colorIn		0x83000003 	//slv_reg0
#define rIn			0x83000003 	//slv_reg0(31 downto 24)
#define gIn			0x83000002 	//slv_reg0(23 downto 16)
#define bIn			0x83000001	//slv_reg0(15 downto 8)
#define rOut		0x83000007 	//slv_reg1
#define gOut		0x8300000B 	//slv_reg2
#define bOut		0x8300000F 	//slv_reg3

#endif /* HEADER_H_ */
