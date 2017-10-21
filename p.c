/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 06/25/2017
Author  : 
Company : 
Comments: 


Chip type               : ATmega32A
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega32a.h>
#include <delay.h>
#include <stdlib.h>
#include <string.h>

// Alphanumeric LCD functions
#include <alcd_ks0073.h>

// Declare your global variables here

#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)

#define KEYPAD_DDR DDRA
#define KEYPAD_PORT PORTA
#define KEYPAD_PIN PINA
// Declare your global variables here
char tmp[4]={0,0,0,0};
int j = 0;
char temp_data[40] = "00000000" ;
char data[10];
char recieve[40];
int numbers[3];
int index = 0 ;
char d1 ='0';
char d2='0';
char d3='0';
char temps[3];
int crc = 0;
int a = 0 , b = 0 , temp_index = 0 , d = 0 , e = 0;
int tempreture = 0, current_dc = 0;

// USART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index=0,rx_rd_index=0;
#else
unsigned int rx_wr_index=0,rx_rd_index=0;
#endif

#if RX_BUFFER_SIZE < 256
unsigned char rx_counter=0;
#else
unsigned int rx_counter=0;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index++]=data;
#if RX_BUFFER_SIZE == 256
   // special case for receiver buffer size=256
   if (++rx_counter == 0) rx_buffer_overflow=1;
#else
   if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
      rx_buffer_overflow=1;
      }
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index++];
#if RX_BUFFER_SIZE != 256
if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#endif
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE 8
char tx_buffer[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE <= 256
unsigned char tx_wr_index=0,tx_rd_index=0;
#else
unsigned int tx_wr_index=0,tx_rd_index=0;
#endif

#if TX_BUFFER_SIZE < 256
unsigned char tx_counter=0;
#else
unsigned int tx_counter=0;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter)
   {
   --tx_counter;
   UDR=tx_buffer[tx_rd_index++];
#if TX_BUFFER_SIZE != 256
   if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter == TX_BUFFER_SIZE);
#asm("cli")
if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer[tx_wr_index++]=c;
#if TX_BUFFER_SIZE != 256
   if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
#endif
   ++tx_counter;
   }
else
   UDR=c;
#asm("sei")
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>


char input;
unsigned char scan_keypad(){
    
    unsigned char key;  
    
    b = 5;
    
    KEYPAD_PORT = 0xFE;    
    delay_ms(b);
    key = KEYPAD_PIN & 0xF0;
    if(key == 0xE0){
        tmp[j++] = '1';
        return '1';
    }
    
    if(key == 0xD0){
        tmp[j++] = '4';
        return '4';
    }
    
    if(key == 0xB0){
        tmp[j++] = '7';
        return '7';
    }
    
    if(key == 0x70){
        tmp[j++] = 'M';
        return 'M';
    }
    
    
    
    KEYPAD_PORT = 0xFD;     
    delay_ms(b);
    key = KEYPAD_PIN & 0xF0;
    if(key == 0xE0){
        tmp[j++] = '2';
        return '2';
    }
    
    if(key == 0xD0){
        tmp[j++] = '5';
        return '5';
    }
    
    if(key == 0xB0){
        tmp[j++] = '8';
        return '8';
    }
    
    if(key == 0x70){
        tmp[j++] = '0';
        return '0';
    }
    
    
    KEYPAD_PORT = 0xFB;  
    delay_ms(b);
    key = KEYPAD_PIN & 0xF0;
    if(key == 0xE0){
        tmp[j++] = '3';
        return '3';
    }
    
    if(key == 0xD0){
        tmp[j++] = '6';
        return '6';
    }
    
    if(key == 0xB0){
        tmp[j++] = '9';
        return '9';
    }
    
    if(key == 0x70){
        tmp[j++] = 'S';
        return 'S';
    }
    
    return '';
    
}
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{

    #asm("cli")
      
    input = scan_keypad();
    
    if (input != '') {
        if(input != 'S'){
            temp_data[temp_index] = input ;
            temp_data[temp_index + 1] = 0;
            temp_index = temp_index + 1;
        }
        else{
            strcpy(data,temp_data);
            tempreture = atoi(data);
            index = temp_index;
            temp_index = 0;
        }   
        delay_ms(500);
    } 
    
    a = 0 ;  
       
    #asm("sei")
       
}

void main(void)
{
// Declare your local variables her
int i=0;
// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTA=(1<<PORTA7) | (1<<PORTA6) | (1<<PORTA5) | (1<<PORTA4) | (1<<PORTA3) | (1<<PORTA2) | (1<<PORTA1) | (1<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 7.813 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
// Timer Period: 32.768 ms
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(1<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x33;

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTC Bit 3
// RD - PORTD Bit 7
// EN - PORTD Bit 6
// D4 - PORTB Bit 4
// D5 - PORTB Bit 5
// D6 - PORTB Bit 6
// D7 - PORTB Bit 7
// Characters/line: 8
lcd_init(16);

// Global enable interrupts
#asm("sei")

while (1)
      {           

        int s = 0 ;
        // Place your code here 
        delay_ms(300);
       /* d = getchar();
        if (d == 'r'){
            putchar('x');
            putchar('0' + index);       
            for (; s<index ; s++){
                putchar(data[s]);   
            }
            putchar('c');
            putchar('r');
            putchar('c');
            putchar('x');
        }
        else if (d == 'w') {
            d = getchar() - '0';
            for (b = 0; b < d + 4; b ++) {
                recieve[b] = getchar();
            }
            e = 0;
            for (b = 0; b < d; b++) {
                if (recieve[b] >= '0' && recieve[b] <= '9') e = e * 10 + (recieve[b] - '0');
                else continue;
            }
            if (recieve[d] != 'n' || recieve[d + 1] != '3' || recieve[d + 2] != '0' || recieve[d + 3] != 'p') continue;
            current_dc = e;     
        }else if(d =='h')
        recieve[0]='h'; 
            */
     
        
               d = getchar(); 
               
        
        if(d == 't')
           {  
        
            putchar('h'); 
            if(tempreture<10)
                {                 
                 putchar('0');
                 putchar(recieve[0]);       
            
            
            
            }else
            {
                 putchar(recieve[0]);
                 putchar(recieve[1]);
            
            } 
            
            numbers[0] = (tempreture / 10) % 10;
            numbers[1] = tempreture%10;
            crc = numbers[0] + numbers[1];
            itoa(crc,recieve);
            
            if(crc<10){
                putchar('0');
                putchar(recieve[0]);
            
            }else
             {
                putchar(recieve[0]);
                putchar(recieve[1]);
            }
            putchar('f');
           }
            
            
            else if(d == 'h'){  
            
                 d1 = getchar(); 
                 d2 = getchar();
                 d3 = getchar();
                 
            }
            
            
        
        lcd_clear();
        lcd_puts("temp:"); 
        itoa(tempreture, recieve); 
         
        lcd_puts(recieve);
     
    
        lcd_puts(" duty:");
        sprintf(temps,"%c%c%c",d1,d2,d3) ;
              lcd_puts(temps);     
      }  
      
}
