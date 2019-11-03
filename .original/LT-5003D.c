#include <SPI.h>
// Sample program for 10x10 matrix LED (LT-5003D) by MAENOH!
// 2019.10.07
// http://akizukidenshi.com/catalog/g/gI-00040/
// 74HC595 x 3 = 8bit x 3
// [- - D9 D8 D7 D6 D5 D4] [D3 D2 D1 D0 - - X9 X8] [X7 X6 X5 X4 X3 X2 X1 X0]
// SPI: 10(SS=RK)ÅA11(MOSI=open)ÅA(12)(MISO=SI)ÅA13(SCK=SK) 

const unsigned int select[] = { // one-hot selection (don't change)
  0x001, // x=0
  0x002, // x=1
  0x004, // x=2
  0x008, // x=3
  0x010, // x=4
  0x020, // x=5
  0x040, // x=6
  0x080, // x=7
  0x100, // x=8
  0x200, // x=9
};

unsigned int disp_buff[] = {
  0x0001  , // for x=0
  0x0002+1, // for x=1
  0x0004+1, // for x=2
  0x0008+1, // for x=3
  0x0010+1, // for x=4
  0x0020+1, // for x=5
  0x0040+1, // for x=6
  0x0080+1, // for x=7
  0x0100+1, // for x=8
  0x0200+1, // for x=9
};

void show() {
  digitalWrite(SS, HIGH);
  for ( int x = 0; x <=9 ; x++ ) {
    SPI.transfer((disp_buff[x]&0x3F0)>>4);
    SPI.transfer(((disp_buff[x]&0x00F)<<4)+(((select[x]&0x300)>>8)^3));
    SPI.transfer((select[x]&0xff)^0xff);
    digitalWrite(SS, LOW);
    digitalWrite(SS, HIGH);
    delay(1);
    //delay(1000); //for debug
  } 
}

void setup() {
  //Serial.begin(9600);
  SPI.begin() ;
  SPI.setBitOrder(MSBFIRST);
  SPI.setClockDivider(SPI_CLOCK_DIV4);
  SPI.setDataMode(SPI_MODE0) ;
}

void loop() {
    show();
}
