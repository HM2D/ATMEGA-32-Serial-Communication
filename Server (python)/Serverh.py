import serial  
from time import sleep
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from  threading import *


fig = plt.figure()
ax1 = fig.add_subplot(1,1,1)

# The serial port that the AVR is connected to.
TTY_PORT = 'COM1'

# The baud rate which must match the BAUD defined in main.c
BAUD = 9600

# Command to send to AVR
COMMAND_HELLO = 0x01

s = serial.Serial(TTY_PORT, BAUD, timeout=1)
mutex = Lock()






def main():
    
    print "start"
    mythread = Thread(target=getTemp)
    mythread.daemon=True
    mythread.start()
    mysecondthread = Thread(target=sendDuty)
    mysecondthread.daemon=True
    mysecondthread.start()

    print "gettemp"
    anim = animation.FuncAnimation(fig, chart, interval=1)
    plt.show()
    while True:
        sleep(1)




def sendDuty():
    pullData = open("text2.txt","r").read()
    dataArray = pullData.split('\n')

    for eachLine in dataArray:
        sleep(5.1)   
        if len(eachLine)>1:
            
            mutex.acquire()
            s.write('h')
            s.write(eachLine[0])
            s.write(eachLine[1])
            s.write(eachLine[2])
            print "sent duty"
            print eachLine
            mutex.release()
    
                

def getTemp():


    now=1
    with open("text.txt", "w") as myfile:
                myfile.write("")
    while True:
            mutex.acquire()
            sleep(1)
            Temps=[]
            System_req=0
            s.write('t')
            response =s.read(8)
            
            print response
            
            if len(response)<1:
                mutex.release()
                pass
            h = response[0]
            mytemp = response[1:2]
            crc = response[3] + response[4]
            f = response[5]
            print crc
            data_size=int(response[1])
            num1 = int(response[1])
            num2 = int(response[2])
            numcrc = int(crc)

            if(numcrc != num1 + num2 ):
                print "crc invalid"
                mutex.release()
                pass
            
            i=0
            T= mytemp
            now+=1
            APPEND=str(now)+','+T+'\n'
            with open("text.txt", "a") as myfile:
                myfile.write(APPEND)
            Temps.append(int(T))
            
            print( "the response: " + response)
            mutex.release()

    
def chart(i):

    pullData = open("text.txt","r").read()
    dataArray = pullData.split('\n')
    xar = []
    yar = []
    for eachLine in dataArray:
        if len(eachLine)>1:
            x,y = eachLine.split(',')
            xar.append(int(x))
            yar.append(int(y))
    ax1.clear()
    ax1.plot(xar,yar)




main()    
