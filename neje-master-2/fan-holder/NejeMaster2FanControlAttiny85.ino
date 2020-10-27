// NejeMaster2FanControlAttiny85
// Arduino IDE 1.6.8, Board: Digispark (Default - 16.5 MHz)
// 4.678 Bytes (77%) Maximum 6.012 Bytes.
// 
// Adjust fan speed by NPN transistor.
// ATtiny85 Digispark
// 
//                          +--N4001-+
//                          +---FAN----(12V)
//                          |
//                         (C)
// (PB1)---[220R]---(B)2N2222
//                         (E)
//                          |
// (PB0)---[BUTTON]---------+----------(GND)
// 
// on/off   push button 
// next     press short > 1500 ms
// save     press long  > 6000 ms
// 

#include "DigiKeyboard.h"
#include <avr/eeprom.h>

#define PIN_BUTTON   0      // PB0
#define PIN_FAN      1      // PB1
#define PIN_LIGHT    2      // PB2 (ADC1)
#define ADC_LIGHT    1      // PB2 (ADC1)

#define EEPROM_DATA_READ    eeprom_read_block((void*)&gFanSpeed, 0, 1)
#define EEPROM_DATA_WRITE   eeprom_write_block(&gFanSpeed, 0, 1)

#define FAN_LIMIT    15     // 0..15
#define FAN_DEFAULT  8      // 50%
#define FAN_SCALE    15     // 255/15
#define BUTTON_SHORT 1500   // short push
#define BUTTON_LONG  6000   // long press
#define KEY_TAB      0x2B   // Keyboard Tab

static uint8_t  gFanState = HIGH;
static uint8_t  gFanSpeed = 0;
static uint8_t  gButtonState = HIGH;
static uint32_t gButtonTime  = 0;
static uint16_t gLightSensor  = 0;
static uint16_t gLightDebug = 4;

void fan();
void light();
void button();

void setup() {
  pinMode(PIN_BUTTON,INPUT_PULLUP);
  pinMode(PIN_FAN,OUTPUT);
  pinMode(PIN_LIGHT,INPUT);
  EEPROM_DATA_READ;
  if (gFanState == 255) {
    gFanState = FAN_DEFAULT;
    EEPROM_DATA_WRITE;
  }  
  fan();
  gLightSensor = analogRead(ADC_LIGHT);
  DigiKeyboard.sendKeyStroke(0);
  for (uint8_t i=0; i<10; i++) {
    digitalWrite(PIN_FAN, HIGH);
    delay(5);
    digitalWrite(PIN_FAN, LOW);
    delay(195);
  }  
  DigiKeyboard.println(F("NejeMaster2FanControl"));
  DigiKeyboard.print(F("FAN"));
  DigiKeyboard.sendKeyStroke(KEY_TAB,0);
  DigiKeyboard.println(F("LIGHT"));
}

void loop() {
  delay(125);
  fan();
  light();
  button();
}

void fan() {
  if (gFanState == LOW) {
    digitalWrite(PIN_FAN, LOW);
  } else {
    if (gFanSpeed > FAN_LIMIT) {
      gFanSpeed = 0;
    }
    switch(gFanSpeed) {
      case 0:
        digitalWrite(PIN_FAN, LOW);
        break;
      case FAN_LIMIT:
        digitalWrite(PIN_FAN, HIGH);
        break;
      default:
        analogWrite(PIN_FAN, gFanSpeed * FAN_SCALE);
        break;
    }
  }
}

void light() {
  gLightSensor *= 4;
  gLightSensor += analogRead(ADC_LIGHT);
  gLightSensor /=5;
  gLightDebug--;
  if (gLightDebug == 0) {
    gLightDebug = 4;
    DigiKeyboard.print((uint16_t) (gFanSpeed * FAN_SCALE));
    DigiKeyboard.sendKeyStroke(KEY_TAB,0);
    DigiKeyboard.println(gLightSensor);
  }
}

void button() {
  // on button change
  if (digitalRead(PIN_BUTTON) != gButtonState) {
    if (gButtonState == HIGH) {
      // button down
      gButtonState = LOW;
      gButtonTime = millis();
    } else {
      // button released
      gButtonState = HIGH;
      gButtonTime = millis() - gButtonTime;
      // short push (on/off)
      if (gButtonTime < BUTTON_SHORT) {
        if (gFanState == HIGH) {
          gFanState = LOW;
        } else {
          gFanState = HIGH;
        }
      }
      // medium push (next)
      else if (gButtonTime < BUTTON_LONG) {
        gFanSpeed++;
        if (gFanSpeed > FAN_LIMIT) {
          gFanSpeed = 0;
        }
        gFanState = HIGH;
      }      
      // long push (save)
      else if (gButtonTime >= BUTTON_LONG) {
        EEPROM_DATA_WRITE;
      }
    }
  }
  // on button down
  if (gButtonState == LOW) {
    if ((millis()-gButtonTime) > BUTTON_SHORT) {
      digitalWrite(PIN_FAN, HIGH);
      delay(5);
      digitalWrite(PIN_FAN, LOW);
      delay(5);
    }
    if ((millis()-gButtonTime) > BUTTON_LONG) {
      digitalWrite(PIN_FAN, HIGH);
      delay(250);
      digitalWrite(PIN_FAN, LOW);
      delay(125);
    }
  }
}
