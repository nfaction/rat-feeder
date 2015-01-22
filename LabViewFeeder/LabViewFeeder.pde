// Debug Flag
const int DEBUG = 1;

// Interface code
const int NBLOOP = 2;
const byte NBLIGHTS = 8;
const byte MIDNBLIGHTS = 4;

const int BLINKNUM = 5;

const byte VERSION = 0;
const byte FLASH = 1;
const byte VALVEOPEN = 2;
const byte VALVECLOSE = 3;
const byte BLINKLIGHT = 4;
const byte PURGEONE = 5;
const byte BLINKFEED = 6;
const byte PURGEALL = 7;
const byte RESET = 8;
const byte RELEASE = 9;
const byte BLINKFEEDDELAY = 10;

const byte LIGHT_0_PIN = 20;
const byte FEEDER_0_PIN = 32;
const float PURGEDELAY = 2.0;
const float PRIMEDELAY = 0.25;
const byte TRAININGFEED = 50;
// Pin connections to board
const int NUMFEEDERS = 8;

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
int blinkSpeed = 10;
int blinkStop = 0;

// Stores serial input one character at a time
char* input = "0";
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

//Commands
byte c = 0;
byte p1 = 0;
byte p2 = 0;
byte p3 = 0;
byte p4 = 0;
int success = 0;

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
}

int getCommand(byte* C, byte* p1, byte* p2, byte* p3, byte* p4){
  *C = Serial.read();
  delay(10);
  
  if(*C != -1){
    *p1 = Serial.read();
    delay(10);
    if(*p1 == -1){
      return 0;
    }
    *p2 = Serial.read();
    delay(10);
    if(*p2 == -1){
      return 0;
    }
    *p3 = Serial.read();
    delay(10);
    if(*p3 == -1){
      return 0;
    }
    *p4 = Serial.read();
    delay(10);
    if(*p4 == -1){
      return 0;
    }
  }
  return 1;
}

void flashAll(){

  int feederNum = 0;
  int blinkerNum = 0;
  
  for(int i = 1; i < NBLOOP; i++){
    if(DEBUG)
      Serial.println("Doing loop");
    delay(10);
	for(int j = 1; j < NBLIGHTS; j++){
      for(int k = 1; k < BLINKNUM; k++){
        blinkerNum = IDtoPin(j, 0);
		feederNum = IDtoPin(j, 1);
		delay(10);
        digitalWrite(blinkerNum, LOW);
		digitalWrite(feederNum, HIGH);
		delay(10);
        digitalWrite(blinkerNum, HIGH);
		digitalWrite(feederNum, LOW);
      }
	  digitalWrite(blinkerNum, LOW);
	  digitalWrite(feederNum, LOW);
    }
  }
  if(DEBUG)
      Serial.println("Flash Done");
}


// Main Program
void loop() {
  byte C = 0;
  byte p1 = 0;
  byte p2 = 0;
  byte p3 = 0;
  byte p4 = 0;
  int success = 0;
  
  int feederNum = 0;
  int blinkerNum = 0;
  
  // Check to see if Arduino serial port is available
  if (Serial.available() > 0) {
    // Get command switch
    do{
      
      success = getCommand(&C, &p1, &p2, &p3, &p4);
      
      if(success){
        if(DEBUG){
          Serial.print("Received: ");
          Serial.println(C);
          Serial.println(p1);
          Serial.println(p2);
          Serial.println(p3);
          Serial.println(p4);
          Serial.println("----------------------");
        }
      }
      int com = char(C);
      
      Serial.println(com);
      Serial.println("got here before switch");
      switch(com-48){
        Serial.println("got here after switch");
        case VERSION:
          Serial.println("got here");
          if(DEBUG){
            Serial.println("Version 1.0");
          }
          break;
        case FLASH:
		  flashAll();
          break;
		case VALVEOPEN:
		  feederNum = IDtoPin(p1, 1);
		  digitalWrite(feederNum, HIGH);
		  printSerial(feederNum, 1, DEBUG);
          break;
		case VALVECLOSE:
		  feederNum = IDtoPin(p1, 1);
		  digitalWrite(feederNum, LOW);
		  printSerial(feederNum, 1, DEBUG);
          break;
		case BLINKLIGHT:
		  blinkerNum = IDtoPin(p1, 0);
		  blinkSpeed = p4;
		  printSerial(blinkerNum, 0, DEBUG);
		  switch(blinkSpeed){
			case 1:
			  blinkDelay = 0.25;
			  break;
			case 2:
			  blinkDelay = 0.1;
			  break;
			case 3:
			  blinkDelay = 0.075;
			  break;
			case 4:
			  blinkDelay = 0.05;
			  break;
		  }
		  do{
			digitalWrite(blinkerNum, HIGH);
			delay(blinkDelay);
			digitalWrite(blinkerNum, LOW);
			delay(blinkDelay);
			blinkStop = getCommand(&C, &p1, &p2, &p3, &p4);
		  }while(!blinkStop);
		  blinkStop = 0;
		  break;
		case PURGEONE:
		  break;
       
     } 
    }while(!EOF);
  }
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

int getCapacitance(int id, int allSensors){
  // Pins to be used for capacitive touch.  ONLY CONNECT TOUCH SENSOR, WILL CAUSE DAMAGE TO ANY OTHER SENSOR
  char capval[8];
  char pinval[8] = {1<<PA0,1<<PA4,1<<PC7,1<<PC3,1<<PD7,1<<PL7,1<<PL3,1<<PB3};
  if(allSensors){
    for(char i = 0; i < NUMFEEDERS; i++){
      // A Channel
      if(i < 2)
        capval[i] = getcapA(pinval[i]);
      // C Channel
      else if(i < 4)
        capval[i] = getcapC(pinval[i]);
      // L Channel
      else if(i == 4)
        capval[i] = getcapD(pinval[i]);
      else if(i < 7)
        capval[i] = getcapL(pinval[i]);
      else
        capval[i] = getcapB(pinval[i]);
    }
  }
  else{
    // A Channel
    if(id < 2)
      capval[id] = getcapA(pinval[id]);
    // C Channel
    else if(id < 4)
      capval[id] = getcapC(pinval[id]);
    // L Channel
    else if(id == 4)
      capval[id] = getcapD(pinval[id]);
    else if(id < 7)
      capval[id] = getcapL(pinval[id]);
    else
      capval[id] = getcapB(pinval[id]);
  }
  return capval[id];
}

// Function to feed, with specified feed duration (ms) and sensitivity of lick sensor
int feed(int id, int duration, int sensitivity){
  int capacitance = 0;
  
  if (Serial.available() > 0) {
    feederNum = IDtoPin(id, 1);
    
    //Open feeder
    if(duration == 0){
      do{
        killfeeder = Serial.read();
        delay(10);
        digitalWrite(feederNum, HIGH);
        printSerial(id, 1, 0);
      }while(killfeeder != id);
    }
    //Wait for lick
    else{
      do{
        killfeeder = Serial.read();
        delay(10);
        
        capacitance = getCapacitance(id, 0);
        
        printSerial(id, 2, capacitance);
        
        if(capacitance > sensitivity){
          digitalWrite(feederNum, HIGH);
          printSerial(id, 1, 0);
          delay(duration);
          digitalWrite(feederNum, LOW);
          printSerial(id, 1, 0);
          delay(duration);
          break;
        }
      }while(killfeeder != id);
    }
    return 0;
  }
  else{
    return 1;
  }
}

// Command to purge all feeders after experiment is finished.
int purgeAll(){
  if (Serial.available() > 0) {
    for(int id = 0; id < NUMFEEDERS; id++){
      openedNum = IDtoPin(id, 1);
      digitalWrite(openedNum, HIGH);
      printSerial(id, 1, 0);
    }
    return 0;
  }
  else{
    return 1;
  }
}

// Command to close all feeders after experiment is finished.
int closeAll(){
  if (Serial.available() > 0) {
    for(int id = 0; id < NUMFEEDERS; id++){
      openedNum = IDtoPin(id, 1);
      digitalWrite(openedNum, LOW);
      printSerial(id, 2, 0);
    }
    return 0;
  }
  else{
    return 1;
  }
}

int printSerial(int id, int option, int value){
  if (Serial.available() > 0) {
		// Choose what to write to serial port
		switch(option){
		  case 1:
			Serial.print(id);
			Serial.println(" Open!");
			break;
		  case 2:
			Serial.print(id);
			Serial.println(" Closed!");
			break;
		  case 3:
			Serial.print("Cap sensor ");
			Serial.print(id);
			Serial.print(": ");
			Serial.println(value, DEC);
			break;
		  case 4:
			Serial.println("Version 1.0");
			break;
		}
		return 0;
	  }
  else{
    return 1;
  }
}
