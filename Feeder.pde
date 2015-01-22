#include <stdbool.h>
// Pin connections to board

// Feeder/Blinker 1
const int Feeder1 = 23;
const int Blinker1 = 25;
// Feeder/Blinker 2
const int Feeder2 = 27;
const int Blinker2 = 29;
// Feeder/Blinker 3
const int Feeder3 = 31;
const int Blinker3 = 33;
// Feeder/Blinker 4
const int Feeder4 = 35;
const int Blinker4 = 37;
// Feeder/Blinker 5
const int Feeder5 = 39;
const int Blinker5 = 41;
// Feeder/Blinker 6
const int Feeder6 = 43;
const int Blinker6 = 45;
// Feeder/Blinker 7
const int Feeder7 = 47;
const int Blinker7 = 49;
// Feeder/Blinker 8
const int Feeder8 = 51;
const int Blinker8 = 53;

// Default sugar water burst in milliseconds
int feedDelay = 130;
// Delay for LED flash in milliseconds
int blinkDelay = 250;

// Stores serial input one character at a time
byte input = 0;
// Serial input to store time in milliseconds one character at a time
char* timechar = "0";
// Serial input for which feeder is selected (in hexidecimal)
char* feederchar = "0";
int feederNum = 0;
int feederID = 0;
// Serial input for which blinker is selected (in hexidecimal)
char* blinkerchar = "0";
int blinkerNum = 0;
int blinkerID = 0;
// Serial input to kill the blinker
byte killblinker = 0;

// Serial input to kill the feeder
byte killfeeder = 0;
// Serial input for which feeder is to be opened (in hexidecimal)
byte opened = 0;
char* openedchar = "0";
int openedNum = 0;
int openedID = 0;

void setup() {
    // Baud rate
    Serial.begin(9600);
    // Set outputs to be used for LEDs and Feeder solenoids
    pinMode(Feeder1, OUTPUT);
    pinMode(Blinker1, OUTPUT);
    
    pinMode(Feeder2, OUTPUT);
    pinMode(Blinker2, OUTPUT);
    
    pinMode(Feeder3, OUTPUT);
    pinMode(Blinker3, OUTPUT);
    
    pinMode(Feeder4, OUTPUT);
    pinMode(Blinker4, OUTPUT);
    
    pinMode(Feeder5, OUTPUT);
    pinMode(Blinker5, OUTPUT);
    
    pinMode(Feeder6, OUTPUT);
    pinMode(Blinker6, OUTPUT);

    pinMode(Feeder7, OUTPUT);
    pinMode(Blinker7, OUTPUT);
    
    pinMode(Feeder8, OUTPUT);
    pinMode(Blinker8, OUTPUT);
    
    Serial.print("Board Initialized and Reset.");
}

void getCommand(){//byte C, byte p1, byte p2, byte p3, byte p4, byte success){
  byte p1;
  byte p2;
  byte p3;
  byte p4;
  byte success;
  bool paramt1 = false;
  bool paramt2 = false;
  bool paramt3 = false;
  bool paramt4 = false;
  bool paramt5 = false;
  
  byte com = 0;
  
  com = Serial.read();
  
  Serial.print("Received: ");
  Serial.println(com);
  
  if(int(com) != 152){
    Serial.println(com);
  }
}

// Main Program
void loop() {
  // Pins to be used for capacitive touch.  ONLY CONNECT TOUCH SENSOR, WILL CAUSE DAMAGE TO ANY OTHER SENSOR
  char capval[8];
  char pinval[8] = {1<<PA0,1<<PA4,1<<PC7,1<<PC3,1<<PD7,1<<PL7,1<<PL3,1<<PB3};
  // Check to see if Arduino serial port is available
  if (Serial.available() > 0) {
    getCommand();
    
//    // Get command switch
//    do{
//      input = Serial.read();
//      delay(10);
//      // Set feeder delay.  e.g. "D(250)" will set delay to 250ms
//      if(input == 'D'){
//        feedDelay = 0;
//        timechar[0] = Serial.read();
//        delay(10);
//        if(timechar[0] == '('){
//          timechar[0] = Serial.read();
//          delay(10);
//          while(timechar[0] != ')'){
//            feedDelay = feedDelay * 10;
//            feedDelay += atoi(timechar);
//            timechar[0] = Serial.read();
//            delay(10);
//          }
//          Serial.print("Time changed to: ");
//          Serial.print(feedDelay);
//          Serial.println(" ms.");
//        }
//      }
//      // Pulse feeder solenoid for chosen delay.  e.g. "FA" to pulse feeder 10, where the A is 10
//      //  in hex, or "F1" will pulse feeder 1
//      else if(input == 'F'){
//        //feeder = Serial.read();
//        //feederNum = hex2dec(feeder);
//        feederchar[0] = Serial.read();
//        delay(10);
//        feederID = atoi(&feederchar[0]);
//        feederNum = IDtoPin(feederID, 1);
//        Serial.print("Feeder: ");
//        Serial.println(feederID);
//        
//        char i = 0;
//        do{
//          killfeeder = Serial.read();
//          delay(10);
//          //Wait for lick
//          
//          for(char i = 0; i < 8; i++){
//            // A Channel
//            if(i < 2)
//              capval[i] = getcapA(pinval[i]);
//            // C Channel
//            else if(i < 4)
//              capval[i] = getcapC(pinval[i]);
//            // L Channel
//            else if(i == 4)
//              capval[i] = getcapD(pinval[i]);
//            else if(i < 7)
//              capval[i] = getcapL(pinval[i]);
//            else
//              capval[i] = getcapB(pinval[i]);
//          }
//          
//          Serial.print("Cap sensor ");
//          Serial.print(feederID);
//          Serial.print(": ");
//          Serial.println(capval[feederID-1], DEC);
//          
//          if(capval[feederID-1] >= 2){
//            digitalWrite(feederNum, HIGH);
//            Serial.print(" Open! ");
//            delay(feedDelay);
//            digitalWrite(feederNum, LOW);
//            Serial.println(" Closed!");
//            delay(feedDelay);
//            break;
//          }
//        }while(killfeeder != 'K');
//      }
//      //Blink LED until kill command.  e.g. "B1" to run, "K" to kill flasher
//      else if(input == 'B'){
////        blinkerTens = Serial.read();
////        blinkerNum = hex2dec(blinker);
//        blinkerchar[0] = Serial.read();
//        blinkerID = atoi(&blinkerchar[0]);
//        blinkerNum = IDtoPin(blinkerID, 0);
//        delay(10);
//        Serial.print("Blinker ");
//        Serial.print(blinkerID);
//        Serial.println(" flashing...");
//        do{
//          killblinker = Serial.read();
//          digitalWrite(blinkerNum, HIGH);
//          delay(blinkDelay);
//          digitalWrite(blinkerNum, LOW);
//          delay(blinkDelay);
//        }while(killblinker != 'K' || !EOF);
//      }
//      // Open solenoid to prime feeder
//      else if(input == 'O'){
//        //opened = Serial.read();
//        //openedNum = hex2dec(opened);
//        openedchar[0] = Serial.read();
//        openedID = atoi(&openedchar[0]);
//        openedNum = IDtoPin(openedID, 1);
//        digitalWrite(openedNum, HIGH);
//        Serial.print(openedID);
//        Serial.println(" Open!");
//      }
//      // Close solenoid to finish priming
//      else if(input == 'C'){
//        digitalWrite(openedNum, LOW);
//        Serial.print(openedID);
//        Serial.println(" Closed!");
//      } 
//    }while(!EOF);
  }
}


// Function to convert from two bytes to decimal
int toDec(byte ten, byte one) {
  int numTen = ten - '0';
  int numOne = one - '0';
  
  return numTen*10 + numOne;
}

// Function to convert from two bytes to decimal
int toDecChar(char* num) {
  int outNum = 0;
  int i = 0;
  while(num[i] != '\0'){
    outNum += num[i] - '0';
    i++;
  }
  return outNum;
}

// Function to convert from feeder/blinker ID to pin number
int IDtoPin(int num, int type){
  int output = 0;
  // Feeder is selected
  if(type){
    switch(num){
      case 1:
        output = Feeder1;
        break;
      case 2:
        output = Feeder2;
        break;
      case 3:
        output = Feeder3;
        break;
      case 4:
        output = Feeder4;
        break;
      case 5:
        output = Feeder5;
        break;
      case 6:
        output = Feeder6;
        break;
      case 7:
        output = Feeder7;
        break;
      case 8:
        output = Feeder8;
        break;
      default:
        // Extra feeder
        break;
    }
  }
  // Binker is selected
  else{
    switch(num){
      case 1:
        output = Blinker1;
        break;
      case 2:
        output = Blinker2;
        break;
      case 3:
        output = Blinker3;
        break;
      case 4:
        output = Blinker4;
        break;
      case 5:
        output = Blinker5;
        break;
      case 6:
        output = Blinker6;
        break;
      case 7:
        output = Blinker7;
        break;
      case 8:
        output = Blinker8;
        break;
      default:
        // Extra feeder
        break;
    }
  }
  return output;
}

// Function to set delay of feeder
int setFeederDelay(int ms){
  if(ms > 0){
    feedDelay = ms;
    return 1;
  }
  return 0;
}

// returns capacity on one input pin
// pin must be the bitmask for the pin e.g. (1<<PB0)
char getcapA(char pin)
{
  char i = 0;
  DDRA &= ~pin;          // input
  PORTA |= pin;          // pullup on
  for(i = 0; i < 16; i++)
    if( (PINA & pin) ) break;
  PORTA &= ~pin;         // low level
  DDRA |= pin;           // discharge
  return i;
}

// returns capacity on one input pin
// pin must be the bitmask for the pin e.g. (1<<PB0)
char getcapC(char pin)
{
  char i = 0;
  DDRC &= ~pin;          // input
  PORTC |= pin;          // pullup on
  for(i = 0; i < 16; i++)
    if( (PINC & pin) ) break;
  PORTC &= ~pin;         // low level
  DDRC |= pin;           // discharge
  return i;
}

// returns capacity on one input pin
// pin must be the bitmask for the pin e.g. (1<<PB0)
char getcapD(char pin)
{
  char i = 0;
  DDRD &= ~pin;          // input
  PORTD |= pin;          // pullup on
  for(i = 0; i < 16; i++)
    if( (PIND & pin) ) break;
  PORTD &= ~pin;         // low level
  DDRD |= pin;           // discharge
  return i;
}

// returns capacity on one input pin
// pin must be the bitmask for the pin e.g. (1<<PB0)
char getcapL(char pin)
{
  char i = 0;
  DDRL &= ~pin;          // input
  PORTL |= pin;          // pullup on
  for(i = 0; i < 16; i++)
    if( (PINL & pin) ) break;
  PORTL &= ~pin;         // low level
  DDRL |= pin;           // discharge
  return i;
}

// returns capacity on one input pin
// pin must be the bitmask for the pin e.g. (1<<PB0)
char getcapB(char pin)
{
  char i = 0;
  DDRB &= ~pin;          // input
  PORTB |= pin;          // pullup on
  for(i = 0; i < 16; i++)
    if( (PINB & pin) ) break;
  PORTB &= ~pin;         // low level
  DDRB |= pin;           // discharge
  return i;
}

