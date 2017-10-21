
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32A
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32A
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _j=R4
	.DEF _j_msb=R5
	.DEF _index=R6
	.DEF _index_msb=R7
	.DEF _d1=R9
	.DEF _d2=R8
	.DEF _d3=R11
	.DEF _crc=R12
	.DEF _crc_msb=R13
	.DEF _rx_wr_index=R10

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  _usart_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

__base_y_G102:
	.DB  0x80,0xA0,0xC0,0xE0
_tbl10_G103:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G103:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x30,0x30,0x0,0x30
	.DB  0x0,0x0

_0x3:
	.DB  0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30
_0x0:
	.DB  0x74,0x65,0x6D,0x70,0x3A,0x0,0x20,0x64
	.DB  0x75,0x74,0x79,0x3A,0x0,0x25,0x63,0x25
	.DB  0x63,0x25,0x63,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x08
	.DW  _temp_data
	.DW  _0x3*2

	.DW  0x06
	.DW  _0x2E
	.DW  _0x0*2

	.DW  0x07
	.DW  _0x2E+6
	.DW  _0x0*2+6

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 06/25/2017
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega32A
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;#include <mega32a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdlib.h>
;#include <string.h>
;
;// Alphanumeric LCD functions
;#include <alcd_ks0073.h>
;
;// Declare your global variables here
;
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;
;#define KEYPAD_DDR DDRA
;#define KEYPAD_PORT PORTA
;#define KEYPAD_PIN PINA
;// Declare your global variables here
;char tmp[4]={0,0,0,0};
;int j = 0;
;char temp_data[40] = "00000000" ;

	.DSEG
;char data[10];
;char recieve[40];
;int numbers[3];
;int index = 0 ;
;char d1 ='0';
;char d2='0';
;char d3='0';
;char temps[3];
;int crc = 0;
;int a = 0 , b = 0 , temp_index = 0 , d = 0 , e = 0;
;int tempreture = 0, current_dc = 0;
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index=0,rx_rd_index=0;
;#else
;unsigned int rx_wr_index=0,rx_rd_index=0;
;#endif
;
;#if RX_BUFFER_SIZE < 256
;unsigned char rx_counter=0;
;#else
;unsigned int rx_counter=0;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0050 {

	.CSEG
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0051 char status,data;
; 0000 0052 status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0053 data=UDR;
	IN   R16,12
; 0000 0054 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x4
; 0000 0055    {
; 0000 0056    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R10
	INC  R10
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0057 #if RX_BUFFER_SIZE == 256
; 0000 0058    // special case for receiver buffer size=256
; 0000 0059    if (++rx_counter == 0) rx_buffer_overflow=1;
; 0000 005A #else
; 0000 005B    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R10
	BRNE _0x5
	CLR  R10
; 0000 005C    if (++rx_counter == RX_BUFFER_SIZE)
_0x5:
	LDS  R26,_rx_counter
	SUBI R26,-LOW(1)
	STS  _rx_counter,R26
	CPI  R26,LOW(0x8)
	BRNE _0x6
; 0000 005D       {
; 0000 005E       rx_counter=0;
	LDI  R30,LOW(0)
	STS  _rx_counter,R30
; 0000 005F       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 0060       }
; 0000 0061 #endif
; 0000 0062    }
_0x6:
; 0000 0063 }
_0x4:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x32
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 006A {
_getchar:
; .FSTART _getchar
; 0000 006B char data;
; 0000 006C while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x7:
	LDS  R30,_rx_counter
	CPI  R30,0
	BREQ _0x7
; 0000 006D data=rx_buffer[rx_rd_index++];
	LDS  R30,_rx_rd_index
	SUBI R30,-LOW(1)
	STS  _rx_rd_index,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
; 0000 006E #if RX_BUFFER_SIZE != 256
; 0000 006F if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	LDS  R26,_rx_rd_index
	CPI  R26,LOW(0x8)
	BRNE _0xA
	LDI  R30,LOW(0)
	STS  _rx_rd_index,R30
; 0000 0070 #endif
; 0000 0071 #asm("cli")
_0xA:
	cli
; 0000 0072 --rx_counter;
	LDS  R30,_rx_counter
	SUBI R30,LOW(1)
	STS  _rx_counter,R30
; 0000 0073 #asm("sei")
	sei
; 0000 0074 return data;
	MOV  R30,R17
	RJMP _0x20C0003
; 0000 0075 }
; .FEND
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 8
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE <= 256
;unsigned char tx_wr_index=0,tx_rd_index=0;
;#else
;unsigned int tx_wr_index=0,tx_rd_index=0;
;#endif
;
;#if TX_BUFFER_SIZE < 256
;unsigned char tx_counter=0;
;#else
;unsigned int tx_counter=0;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 008B {
_usart_tx_isr:
; .FSTART _usart_tx_isr
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 008C if (tx_counter)
	LDS  R30,_tx_counter
	CPI  R30,0
	BREQ _0xB
; 0000 008D    {
; 0000 008E    --tx_counter;
	SUBI R30,LOW(1)
	STS  _tx_counter,R30
; 0000 008F    UDR=tx_buffer[tx_rd_index++];
	LDS  R30,_tx_rd_index
	SUBI R30,-LOW(1)
	STS  _tx_rd_index,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0000 0090 #if TX_BUFFER_SIZE != 256
; 0000 0091    if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDS  R26,_tx_rd_index
	CPI  R26,LOW(0x8)
	BRNE _0xC
	LDI  R30,LOW(0)
	STS  _tx_rd_index,R30
; 0000 0092 #endif
; 0000 0093    }
_0xC:
; 0000 0094 }
_0xB:
_0x32:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 009B {
_putchar:
; .FSTART _putchar
; 0000 009C while (tx_counter == TX_BUFFER_SIZE);
	ST   -Y,R26
;	c -> Y+0
_0xD:
	LDS  R26,_tx_counter
	CPI  R26,LOW(0x8)
	BREQ _0xD
; 0000 009D #asm("cli")
	cli
; 0000 009E if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	LDS  R30,_tx_counter
	CPI  R30,0
	BRNE _0x11
	SBIC 0xB,5
	RJMP _0x10
_0x11:
; 0000 009F    {
; 0000 00A0    tx_buffer[tx_wr_index++]=c;
	LDS  R30,_tx_wr_index
	SUBI R30,-LOW(1)
	STS  _tx_wr_index,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
; 0000 00A1 #if TX_BUFFER_SIZE != 256
; 0000 00A2    if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDS  R26,_tx_wr_index
	CPI  R26,LOW(0x8)
	BRNE _0x13
	LDI  R30,LOW(0)
	STS  _tx_wr_index,R30
; 0000 00A3 #endif
; 0000 00A4    ++tx_counter;
_0x13:
	LDS  R30,_tx_counter
	SUBI R30,-LOW(1)
	STS  _tx_counter,R30
; 0000 00A5    }
; 0000 00A6 else
	RJMP _0x14
_0x10:
; 0000 00A7    UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00A8 #asm("sei")
_0x14:
	sei
; 0000 00A9 }
	JMP  _0x20C0002
; .FEND
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;
;char input;
;unsigned char scan_keypad(){
; 0000 00B2 unsigned char scan_keypad(){
_scan_keypad:
; .FSTART _scan_keypad
; 0000 00B3 
; 0000 00B4     unsigned char key;
; 0000 00B5 
; 0000 00B6     b = 5;
	ST   -Y,R17
;	key -> R17
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	STS  _b,R30
	STS  _b+1,R31
; 0000 00B7 
; 0000 00B8     KEYPAD_PORT = 0xFE;
	LDI  R30,LOW(254)
	CALL SUBOPT_0x0
; 0000 00B9     delay_ms(b);
; 0000 00BA     key = KEYPAD_PIN & 0xF0;
; 0000 00BB     if(key == 0xE0){
	BRNE _0x15
; 0000 00BC         tmp[j++] = '1';
	CALL SUBOPT_0x1
	LDI  R26,LOW(49)
	STD  Z+0,R26
; 0000 00BD         return '1';
	LDI  R30,LOW(49)
	RJMP _0x20C0003
; 0000 00BE     }
; 0000 00BF 
; 0000 00C0     if(key == 0xD0){
_0x15:
	CPI  R17,208
	BRNE _0x16
; 0000 00C1         tmp[j++] = '4';
	CALL SUBOPT_0x1
	LDI  R26,LOW(52)
	STD  Z+0,R26
; 0000 00C2         return '4';
	LDI  R30,LOW(52)
	RJMP _0x20C0003
; 0000 00C3     }
; 0000 00C4 
; 0000 00C5     if(key == 0xB0){
_0x16:
	CPI  R17,176
	BRNE _0x17
; 0000 00C6         tmp[j++] = '7';
	CALL SUBOPT_0x1
	LDI  R26,LOW(55)
	STD  Z+0,R26
; 0000 00C7         return '7';
	LDI  R30,LOW(55)
	RJMP _0x20C0003
; 0000 00C8     }
; 0000 00C9 
; 0000 00CA     if(key == 0x70){
_0x17:
	CPI  R17,112
	BRNE _0x18
; 0000 00CB         tmp[j++] = 'M';
	CALL SUBOPT_0x1
	LDI  R26,LOW(77)
	STD  Z+0,R26
; 0000 00CC         return 'M';
	LDI  R30,LOW(77)
	RJMP _0x20C0003
; 0000 00CD     }
; 0000 00CE 
; 0000 00CF 
; 0000 00D0 
; 0000 00D1     KEYPAD_PORT = 0xFD;
_0x18:
	LDI  R30,LOW(253)
	CALL SUBOPT_0x0
; 0000 00D2     delay_ms(b);
; 0000 00D3     key = KEYPAD_PIN & 0xF0;
; 0000 00D4     if(key == 0xE0){
	BRNE _0x19
; 0000 00D5         tmp[j++] = '2';
	CALL SUBOPT_0x1
	LDI  R26,LOW(50)
	STD  Z+0,R26
; 0000 00D6         return '2';
	LDI  R30,LOW(50)
	RJMP _0x20C0003
; 0000 00D7     }
; 0000 00D8 
; 0000 00D9     if(key == 0xD0){
_0x19:
	CPI  R17,208
	BRNE _0x1A
; 0000 00DA         tmp[j++] = '5';
	CALL SUBOPT_0x1
	LDI  R26,LOW(53)
	STD  Z+0,R26
; 0000 00DB         return '5';
	LDI  R30,LOW(53)
	RJMP _0x20C0003
; 0000 00DC     }
; 0000 00DD 
; 0000 00DE     if(key == 0xB0){
_0x1A:
	CPI  R17,176
	BRNE _0x1B
; 0000 00DF         tmp[j++] = '8';
	CALL SUBOPT_0x1
	LDI  R26,LOW(56)
	STD  Z+0,R26
; 0000 00E0         return '8';
	LDI  R30,LOW(56)
	RJMP _0x20C0003
; 0000 00E1     }
; 0000 00E2 
; 0000 00E3     if(key == 0x70){
_0x1B:
	CPI  R17,112
	BRNE _0x1C
; 0000 00E4         tmp[j++] = '0';
	CALL SUBOPT_0x1
	LDI  R26,LOW(48)
	STD  Z+0,R26
; 0000 00E5         return '0';
	LDI  R30,LOW(48)
	RJMP _0x20C0003
; 0000 00E6     }
; 0000 00E7 
; 0000 00E8 
; 0000 00E9     KEYPAD_PORT = 0xFB;
_0x1C:
	LDI  R30,LOW(251)
	CALL SUBOPT_0x0
; 0000 00EA     delay_ms(b);
; 0000 00EB     key = KEYPAD_PIN & 0xF0;
; 0000 00EC     if(key == 0xE0){
	BRNE _0x1D
; 0000 00ED         tmp[j++] = '3';
	CALL SUBOPT_0x1
	LDI  R26,LOW(51)
	STD  Z+0,R26
; 0000 00EE         return '3';
	LDI  R30,LOW(51)
	RJMP _0x20C0003
; 0000 00EF     }
; 0000 00F0 
; 0000 00F1     if(key == 0xD0){
_0x1D:
	CPI  R17,208
	BRNE _0x1E
; 0000 00F2         tmp[j++] = '6';
	CALL SUBOPT_0x1
	LDI  R26,LOW(54)
	STD  Z+0,R26
; 0000 00F3         return '6';
	LDI  R30,LOW(54)
	RJMP _0x20C0003
; 0000 00F4     }
; 0000 00F5 
; 0000 00F6     if(key == 0xB0){
_0x1E:
	CPI  R17,176
	BRNE _0x1F
; 0000 00F7         tmp[j++] = '9';
	CALL SUBOPT_0x1
	LDI  R26,LOW(57)
	STD  Z+0,R26
; 0000 00F8         return '9';
	LDI  R30,LOW(57)
	RJMP _0x20C0003
; 0000 00F9     }
; 0000 00FA 
; 0000 00FB     if(key == 0x70){
_0x1F:
	CPI  R17,112
	BRNE _0x20
; 0000 00FC         tmp[j++] = 'S';
	CALL SUBOPT_0x1
	LDI  R26,LOW(83)
	STD  Z+0,R26
; 0000 00FD         return 'S';
	LDI  R30,LOW(83)
	RJMP _0x20C0003
; 0000 00FE     }
; 0000 00FF 
; 0000 0100     return '';
_0x20:
	LDI  R30,LOW(0)
_0x20C0003:
	LD   R17,Y+
	RET
; 0000 0101 
; 0000 0102 }
; .FEND
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0105 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0106 
; 0000 0107     #asm("cli")
	cli
; 0000 0108 
; 0000 0109     input = scan_keypad();
	RCALL _scan_keypad
	STS  _input,R30
; 0000 010A 
; 0000 010B     if (input != '') {
	CPI  R30,0
	BREQ _0x21
; 0000 010C         if(input != 'S'){
	LDS  R26,_input
	CPI  R26,LOW(0x53)
	BREQ _0x22
; 0000 010D             temp_data[temp_index] = input ;
	CALL SUBOPT_0x2
	SUBI R30,LOW(-_temp_data)
	SBCI R31,HIGH(-_temp_data)
	LDS  R26,_input
	STD  Z+0,R26
; 0000 010E             temp_data[temp_index + 1] = 0;
	CALL SUBOPT_0x2
	__ADDW1MN _temp_data,1
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 010F             temp_index = temp_index + 1;
	CALL SUBOPT_0x2
	ADIW R30,1
	STS  _temp_index,R30
	STS  _temp_index+1,R31
; 0000 0110         }
; 0000 0111         else{
	RJMP _0x23
_0x22:
; 0000 0112             strcpy(data,temp_data);
	LDI  R30,LOW(_data)
	LDI  R31,HIGH(_data)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_temp_data)
	LDI  R27,HIGH(_temp_data)
	CALL _strcpy
; 0000 0113             tempreture = atoi(data);
	LDI  R26,LOW(_data)
	LDI  R27,HIGH(_data)
	CALL _atoi
	STS  _tempreture,R30
	STS  _tempreture+1,R31
; 0000 0114             index = temp_index;
	__GETWRMN 6,7,0,_temp_index
; 0000 0115             temp_index = 0;
	LDI  R30,LOW(0)
	STS  _temp_index,R30
	STS  _temp_index+1,R30
; 0000 0116         }
_0x23:
; 0000 0117         delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 0118     }
; 0000 0119 
; 0000 011A     a = 0 ;
_0x21:
	LDI  R30,LOW(0)
	STS  _a,R30
	STS  _a+1,R30
; 0000 011B 
; 0000 011C     #asm("sei")
	sei
; 0000 011D 
; 0000 011E }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;void main(void)
; 0000 0121 {
_main:
; .FSTART _main
; 0000 0122 // Declare your local variables her
; 0000 0123 int i=0;
; 0000 0124 // Input/Output Ports initialization
; 0000 0125 // Port A initialization
; 0000 0126 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0127 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
;	i -> R16,R17
	__GETWRN 16,17,0
	LDI  R30,LOW(15)
	OUT  0x1A,R30
; 0000 0128 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0129 PORTA=(1<<PORTA7) | (1<<PORTA6) | (1<<PORTA5) | (1<<PORTA4) | (1<<PORTA3) | (1<<PORTA2) | (1<<PORTA1) | (1<<PORTA0);
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0000 012A 
; 0000 012B // Port B initialization
; 0000 012C // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 012D DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 012E // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 012F PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 0130 
; 0000 0131 // Port C initialization
; 0000 0132 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0133 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 0134 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0135 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0136 
; 0000 0137 // Port D initialization
; 0000 0138 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0139 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 013A // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 013B PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 013C 
; 0000 013D // Timer/Counter 0 initialization
; 0000 013E // Clock source: System Clock
; 0000 013F // Clock value: 7.813 kHz
; 0000 0140 // Mode: Normal top=0xFF
; 0000 0141 // OC0 output: Disconnected
; 0000 0142 // Timer Period: 32.768 ms
; 0000 0143 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 0144 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0145 OCR0=0x00;
	OUT  0x3C,R30
; 0000 0146 
; 0000 0147 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0148 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 0149 
; 0000 014A // USART initialization
; 0000 014B // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 014C // USART Receiver: On
; 0000 014D // USART Transmitter: On
; 0000 014E // USART Mode: Asynchronous
; 0000 014F // USART Baud Rate: 9600
; 0000 0150 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0151 UCSRB=(1<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 0152 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0153 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0154 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0155 
; 0000 0156 // Alphanumeric LCD initialization
; 0000 0157 // Connections are specified in the
; 0000 0158 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0159 // RS - PORTC Bit 3
; 0000 015A // RD - PORTD Bit 7
; 0000 015B // EN - PORTD Bit 6
; 0000 015C // D4 - PORTB Bit 4
; 0000 015D // D5 - PORTB Bit 5
; 0000 015E // D6 - PORTB Bit 6
; 0000 015F // D7 - PORTB Bit 7
; 0000 0160 // Characters/line: 8
; 0000 0161 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 0162 
; 0000 0163 // Global enable interrupts
; 0000 0164 #asm("sei")
	sei
; 0000 0165 
; 0000 0166 while (1)
_0x24:
; 0000 0167       {
; 0000 0168 
; 0000 0169         int s = 0 ;
; 0000 016A         // Place your code here
; 0000 016B         delay_ms(300);
	SBIW R28,2
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
;	s -> Y+0
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
; 0000 016C        /* d = getchar();
; 0000 016D         if (d == 'r'){
; 0000 016E             putchar('x');
; 0000 016F             putchar('0' + index);
; 0000 0170             for (; s<index ; s++){
; 0000 0171                 putchar(data[s]);
; 0000 0172             }
; 0000 0173             putchar('c');
; 0000 0174             putchar('r');
; 0000 0175             putchar('c');
; 0000 0176             putchar('x');
; 0000 0177         }
; 0000 0178         else if (d == 'w') {
; 0000 0179             d = getchar() - '0';
; 0000 017A             for (b = 0; b < d + 4; b ++) {
; 0000 017B                 recieve[b] = getchar();
; 0000 017C             }
; 0000 017D             e = 0;
; 0000 017E             for (b = 0; b < d; b++) {
; 0000 017F                 if (recieve[b] >= '0' && recieve[b] <= '9') e = e * 10 + (recieve[b] - '0');
; 0000 0180                 else continue;
; 0000 0181             }
; 0000 0182             if (recieve[d] != 'n' || recieve[d + 1] != '3' || recieve[d + 2] != '0' || recieve[d + 3] != 'p') continue;
; 0000 0183             current_dc = e;
; 0000 0184         }else if(d =='h')
; 0000 0185         recieve[0]='h';
; 0000 0186             */
; 0000 0187 
; 0000 0188 
; 0000 0189                d = getchar();
	RCALL _getchar
	LDI  R31,0
	STS  _d,R30
	STS  _d+1,R31
; 0000 018A 
; 0000 018B 
; 0000 018C         if(d == 't')
	LDS  R26,_d
	LDS  R27,_d+1
	CPI  R26,LOW(0x74)
	LDI  R30,HIGH(0x74)
	CPC  R27,R30
	BREQ PC+2
	RJMP _0x27
; 0000 018D            {
; 0000 018E 
; 0000 018F             putchar('h');
	LDI  R26,LOW(104)
	RCALL _putchar
; 0000 0190             if(tempreture<10)
	CALL SUBOPT_0x3
	SBIW R26,10
	BRGE _0x28
; 0000 0191                 {
; 0000 0192                  putchar('0');
	LDI  R26,LOW(48)
	RCALL _putchar
; 0000 0193                  putchar(recieve[0]);
	LDS  R26,_recieve
	RJMP _0x30
; 0000 0194 
; 0000 0195 
; 0000 0196 
; 0000 0197             }else
_0x28:
; 0000 0198             {
; 0000 0199                  putchar(recieve[0]);
	CALL SUBOPT_0x4
; 0000 019A                  putchar(recieve[1]);
_0x30:
	RCALL _putchar
; 0000 019B 
; 0000 019C             }
; 0000 019D 
; 0000 019E             numbers[0] = (tempreture / 10) % 10;
	CALL SUBOPT_0x3
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	STS  _numbers,R30
	STS  _numbers+1,R31
; 0000 019F             numbers[1] = tempreture%10;
	CALL SUBOPT_0x3
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	__PUTW1MN _numbers,2
; 0000 01A0             crc = numbers[0] + numbers[1];
	__GETW1MN _numbers,2
	LDS  R26,_numbers
	LDS  R27,_numbers+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R12,R30
; 0000 01A1             itoa(crc,recieve);
	ST   -Y,R13
	ST   -Y,R12
	LDI  R26,LOW(_recieve)
	LDI  R27,HIGH(_recieve)
	CALL _itoa
; 0000 01A2 
; 0000 01A3             if(crc<10){
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R12,R30
	CPC  R13,R31
	BRGE _0x2A
; 0000 01A4                 putchar('0');
	LDI  R26,LOW(48)
	RCALL _putchar
; 0000 01A5                 putchar(recieve[0]);
	LDS  R26,_recieve
	RJMP _0x31
; 0000 01A6 
; 0000 01A7             }else
_0x2A:
; 0000 01A8              {
; 0000 01A9                 putchar(recieve[0]);
	CALL SUBOPT_0x4
; 0000 01AA                 putchar(recieve[1]);
_0x31:
	RCALL _putchar
; 0000 01AB             }
; 0000 01AC             putchar('f');
	LDI  R26,LOW(102)
	RCALL _putchar
; 0000 01AD            }
; 0000 01AE 
; 0000 01AF 
; 0000 01B0             else if(d == 'h'){
	RJMP _0x2C
_0x27:
	LDS  R26,_d
	LDS  R27,_d+1
	CPI  R26,LOW(0x68)
	LDI  R30,HIGH(0x68)
	CPC  R27,R30
	BRNE _0x2D
; 0000 01B1                  d1 = getchar();
	RCALL _getchar
	MOV  R9,R30
; 0000 01B2                  d2 = getchar();
	RCALL _getchar
	MOV  R8,R30
; 0000 01B3                  d3 = getchar();
	RCALL _getchar
	MOV  R11,R30
; 0000 01B4 
; 0000 01B5             }
; 0000 01B6 
; 0000 01B7 
; 0000 01B8 
; 0000 01B9         lcd_clear();
_0x2D:
_0x2C:
	CALL _lcd_clear
; 0000 01BA         lcd_puts("temp:");
	__POINTW2MN _0x2E,0
	CALL _lcd_puts
; 0000 01BB         itoa(tempreture, recieve);
	LDS  R30,_tempreture
	LDS  R31,_tempreture+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_recieve)
	LDI  R27,HIGH(_recieve)
	CALL _itoa
; 0000 01BC 
; 0000 01BD         lcd_puts(recieve);
	LDI  R26,LOW(_recieve)
	LDI  R27,HIGH(_recieve)
	CALL _lcd_puts
; 0000 01BE 
; 0000 01BF 
; 0000 01C0         lcd_puts(" duty:");
	__POINTW2MN _0x2E,6
	CALL _lcd_puts
; 0000 01C1         sprintf(temps,"%c%c%c",d1,d2,d3) ;
	LDI  R30,LOW(_temps)
	LDI  R31,HIGH(_temps)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,13
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R9
	CALL SUBOPT_0x5
	MOV  R30,R8
	CALL SUBOPT_0x5
	MOV  R30,R11
	CALL SUBOPT_0x5
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 01C2               lcd_puts(temps);
	LDI  R26,LOW(_temps)
	LDI  R27,HIGH(_temps)
	CALL _lcd_puts
; 0000 01C3       }
	ADIW R28,2
	RJMP _0x24
; 0000 01C4 
; 0000 01C5 }
_0x2F:
	RJMP _0x2F
; .FEND

	.DSEG
_0x2E:
	.BYTE 0xD

	.CSEG
_atoi:
; .FSTART _atoi
	ST   -Y,R27
	ST   -Y,R26
   	ldd  r27,y+1
   	ld   r26,y
__atoi0:
   	ld   r30,x
        mov  r24,r26
	MOV  R26,R30
	CALL _isspace
        mov  r26,r24
   	tst  r30
   	breq __atoi1
   	adiw r26,1
   	rjmp __atoi0
__atoi1:
   	clt
   	ld   r30,x
   	cpi  r30,'-'
   	brne __atoi2
   	set
   	rjmp __atoi3
__atoi2:
   	cpi  r30,'+'
   	brne __atoi4
__atoi3:
   	adiw r26,1
__atoi4:
   	clr  r22
   	clr  r23
__atoi5:
   	ld   r30,x
        mov  r24,r26
	MOV  R26,R30
	CALL _isdigit
        mov  r26,r24
   	tst  r30
   	breq __atoi6
   	movw r30,r22
   	lsl  r22
   	rol  r23
   	lsl  r22
   	rol  r23
   	add  r22,r30
   	adc  r23,r31
   	lsl  r22
   	rol  r23
   	ld   r30,x+
   	clr  r31
   	subi r30,'0'
   	add  r22,r30
   	adc  r23,r31
   	rjmp __atoi5
__atoi6:
   	movw r30,r22
   	brtc __atoi7
   	com  r30
   	com  r31
   	adiw r30,1
__atoi7:
   	adiw r28,2
   	ret
; .FEND
_itoa:
; .FSTART _itoa
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret
; .FEND

	.DSEG

	.CSEG

	.CSEG
_strcpy:
; .FSTART _strcpy
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpy0:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcpy0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
__lcd_write_nibble_G102:
; .FSTART __lcd_write_nibble_G102
	ST   -Y,R26
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x18,R30
	__DELAY_USB 5
	SBI  0x12,6
	__DELAY_USB 13
	CBI  0x12,6
	__DELAY_USB 13
	RJMP _0x20C0002
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
	__DELAY_USB 133
	RJMP _0x20C0002
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G102*2)
	SBCI R31,HIGH(-__base_y_G102*2)
	LPM  R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x6
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x6
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2040004
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2040003
_0x2040004:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2040006
	RJMP _0x20C0002
_0x2040006:
_0x2040003:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x15,3
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,3
	RJMP _0x20C0002
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2040007:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2040009
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2040007
_0x2040009:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x17
	ORI  R30,LOW(0xF0)
	OUT  0x17,R30
	SBI  0x11,6
	SBI  0x14,3
	SBI  0x11,7
	CBI  0x12,6
	CBI  0x15,3
	CBI  0x12,7
	LD   R30,Y
	STS  __lcd_maxx,R30
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x7
	CALL SUBOPT_0x7
	CALL SUBOPT_0x7
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G102
	__DELAY_USW 200
	LDI  R26,LOW(36)
	RCALL __lcd_write_data
	LDI  R26,LOW(9)
	RCALL __lcd_write_data
	LDI  R26,LOW(32)
	RCALL __lcd_write_data
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0002:
	ADIW R28,1
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G103:
; .FSTART _put_buff_G103
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2060010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2060012
	__CPWRN 16,17,2
	BRLO _0x2060013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2060012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2060013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2060014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2060014:
	RJMP _0x2060015
_0x2060010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2060015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G103:
; .FSTART __print_G103
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2060016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2060018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x206001C
	CPI  R18,37
	BRNE _0x206001D
	LDI  R17,LOW(1)
	RJMP _0x206001E
_0x206001D:
	CALL SUBOPT_0x8
_0x206001E:
	RJMP _0x206001B
_0x206001C:
	CPI  R30,LOW(0x1)
	BRNE _0x206001F
	CPI  R18,37
	BRNE _0x2060020
	CALL SUBOPT_0x8
	RJMP _0x20600CC
_0x2060020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2060021
	LDI  R16,LOW(1)
	RJMP _0x206001B
_0x2060021:
	CPI  R18,43
	BRNE _0x2060022
	LDI  R20,LOW(43)
	RJMP _0x206001B
_0x2060022:
	CPI  R18,32
	BRNE _0x2060023
	LDI  R20,LOW(32)
	RJMP _0x206001B
_0x2060023:
	RJMP _0x2060024
_0x206001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2060025
_0x2060024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2060026
	ORI  R16,LOW(128)
	RJMP _0x206001B
_0x2060026:
	RJMP _0x2060027
_0x2060025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x206001B
_0x2060027:
	CPI  R18,48
	BRLO _0x206002A
	CPI  R18,58
	BRLO _0x206002B
_0x206002A:
	RJMP _0x2060029
_0x206002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x206001B
_0x2060029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x206002F
	CALL SUBOPT_0x9
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0xA
	RJMP _0x2060030
_0x206002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2060032
	CALL SUBOPT_0x9
	CALL SUBOPT_0xB
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2060033
_0x2060032:
	CPI  R30,LOW(0x70)
	BRNE _0x2060035
	CALL SUBOPT_0x9
	CALL SUBOPT_0xB
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2060033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2060036
_0x2060035:
	CPI  R30,LOW(0x64)
	BREQ _0x2060039
	CPI  R30,LOW(0x69)
	BRNE _0x206003A
_0x2060039:
	ORI  R16,LOW(4)
	RJMP _0x206003B
_0x206003A:
	CPI  R30,LOW(0x75)
	BRNE _0x206003C
_0x206003B:
	LDI  R30,LOW(_tbl10_G103*2)
	LDI  R31,HIGH(_tbl10_G103*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x206003D
_0x206003C:
	CPI  R30,LOW(0x58)
	BRNE _0x206003F
	ORI  R16,LOW(8)
	RJMP _0x2060040
_0x206003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2060071
_0x2060040:
	LDI  R30,LOW(_tbl16_G103*2)
	LDI  R31,HIGH(_tbl16_G103*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x206003D:
	SBRS R16,2
	RJMP _0x2060042
	CALL SUBOPT_0x9
	CALL SUBOPT_0xC
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2060043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2060043:
	CPI  R20,0
	BREQ _0x2060044
	SUBI R17,-LOW(1)
	RJMP _0x2060045
_0x2060044:
	ANDI R16,LOW(251)
_0x2060045:
	RJMP _0x2060046
_0x2060042:
	CALL SUBOPT_0x9
	CALL SUBOPT_0xC
_0x2060046:
_0x2060036:
	SBRC R16,0
	RJMP _0x2060047
_0x2060048:
	CP   R17,R21
	BRSH _0x206004A
	SBRS R16,7
	RJMP _0x206004B
	SBRS R16,2
	RJMP _0x206004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x206004D
_0x206004C:
	LDI  R18,LOW(48)
_0x206004D:
	RJMP _0x206004E
_0x206004B:
	LDI  R18,LOW(32)
_0x206004E:
	CALL SUBOPT_0x8
	SUBI R21,LOW(1)
	RJMP _0x2060048
_0x206004A:
_0x2060047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x206004F
_0x2060050:
	CPI  R19,0
	BREQ _0x2060052
	SBRS R16,3
	RJMP _0x2060053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2060054
_0x2060053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2060054:
	CALL SUBOPT_0x8
	CPI  R21,0
	BREQ _0x2060055
	SUBI R21,LOW(1)
_0x2060055:
	SUBI R19,LOW(1)
	RJMP _0x2060050
_0x2060052:
	RJMP _0x2060056
_0x206004F:
_0x2060058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x206005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x206005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x206005A
_0x206005C:
	CPI  R18,58
	BRLO _0x206005D
	SBRS R16,3
	RJMP _0x206005E
	SUBI R18,-LOW(7)
	RJMP _0x206005F
_0x206005E:
	SUBI R18,-LOW(39)
_0x206005F:
_0x206005D:
	SBRC R16,4
	RJMP _0x2060061
	CPI  R18,49
	BRSH _0x2060063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2060062
_0x2060063:
	RJMP _0x20600CD
_0x2060062:
	CP   R21,R19
	BRLO _0x2060067
	SBRS R16,0
	RJMP _0x2060068
_0x2060067:
	RJMP _0x2060066
_0x2060068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2060069
	LDI  R18,LOW(48)
_0x20600CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x206006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0xA
	CPI  R21,0
	BREQ _0x206006B
	SUBI R21,LOW(1)
_0x206006B:
_0x206006A:
_0x2060069:
_0x2060061:
	CALL SUBOPT_0x8
	CPI  R21,0
	BREQ _0x206006C
	SUBI R21,LOW(1)
_0x206006C:
_0x2060066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2060059
	RJMP _0x2060058
_0x2060059:
_0x2060056:
	SBRS R16,0
	RJMP _0x206006D
_0x206006E:
	CPI  R21,0
	BREQ _0x2060070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0xA
	RJMP _0x206006E
_0x2060070:
_0x206006D:
_0x2060071:
_0x2060030:
_0x20600CC:
	LDI  R17,LOW(0)
_0x206001B:
	RJMP _0x2060016
_0x2060018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0xD
	SBIW R30,0
	BRNE _0x2060072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0001
_0x2060072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0xD
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G103)
	LDI  R31,HIGH(_put_buff_G103)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G103
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
_isdigit:
; .FSTART _isdigit
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,'0'
    brlo isdigit0
    cpi  r31,'9'+1
    brlo isdigit1
isdigit0:
    clr  r30
isdigit1:
    ret
; .FEND
_isspace:
; .FSTART _isspace
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,' '
    breq isspace1
    cpi  r31,9
    brlo isspace0
    cpi  r31,13+1
    brlo isspace1
isspace0:
    clr  r30
isspace1:
    ret
; .FEND

	.CSEG

	.DSEG
_tmp:
	.BYTE 0x4
_temp_data:
	.BYTE 0x28
_data:
	.BYTE 0xA
_recieve:
	.BYTE 0x28
_numbers:
	.BYTE 0x6
_temps:
	.BYTE 0x3
_a:
	.BYTE 0x2
_b:
	.BYTE 0x2
_temp_index:
	.BYTE 0x2
_d:
	.BYTE 0x2
_tempreture:
	.BYTE 0x2
_rx_buffer:
	.BYTE 0x8
_rx_rd_index:
	.BYTE 0x1
_rx_counter:
	.BYTE 0x1
_tx_buffer:
	.BYTE 0x8
_tx_wr_index:
	.BYTE 0x1
_tx_rd_index:
	.BYTE 0x1
_tx_counter:
	.BYTE 0x1
_input:
	.BYTE 0x1
__seed_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x0:
	OUT  0x1B,R30
	LDS  R26,_b
	LDS  R27,_b+1
	CALL _delay_ms
	IN   R30,0x19
	ANDI R30,LOW(0xF0)
	MOV  R17,R30
	CPI  R17,224
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x1:
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	SBIW R30,1
	SUBI R30,LOW(-_tmp)
	SBCI R31,HIGH(-_tmp)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDS  R30,_temp_index
	LDS  R31,_temp_index+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDS  R26,_tempreture
	LDS  R27,_tempreture+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDS  R26,_recieve
	CALL _putchar
	__GETB2MN _recieve,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G102
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x8:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
