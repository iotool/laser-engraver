// NejeMaster2FanControlAttiny85
// Arduino IDE 1.6.8, Board: Digispark (Default - 16.5 MHz)
// 5.048 Bytes (83%) Maximum 6.012 Bytes.
// 
// Adjust 12V fan speed by NPN transistor.
// ATtiny85 Digispark
//                          +--N4001-+
//                          +---FAN----(12V)
//                          |
//                         (C)
// (PB1)---[220R]---(B)2N2222
//                         (E)
//                          |
// (PB0)---[BUTTON]---------+----------(GND)
// 
// One button fan control to turn on and off, change and save speed setting.
// Reduce current consumption by reduce cpu frequency.
// 
// debug    press durring setup
// on/off   push button 
// next     press short > 1600 ms
// save     press long  > 6000 ms
// 
// adjust cpu and pwm frequency
// PWM_FREQ_32HZ  + CPU_FREQ_1MHZ   = 32 kHz pwm / 18 mA idle (32 mA)
// PWM_FREQ_32HZ  + CPU_FREQ_500KHZ = 16 kHz pwm / 13 mA idle (29 mA)
// PWM_FREQ_125HZ + CPU_FREQ_125KHZ = 16 kHz pwm /  9 mA idle (25 mA)
// PWM_FREQ_32HZ  + CPU_FREQ_250KHZ =  8 kHz pwm / 10 mA idle (28 mA)
// PWM_FREQ_32HZ  + CPU_FREQ_125KHZ =  4 kHz pwm /  9 mA idle (26 mA)

#include "DigiKeyboard.h"
#include <avr/eeprom.h>

#define PWM_FREQ_32KHZ      TCCR0B = TCCR0B & 0b11111000 | 0b00000001;
#define PWM_FREQ_4KHZ       TCCR0B = TCCR0B & 0b11111000 | 0b00000010;
#define PWM_FREQ_500HZ      TCCR0B = TCCR0B & 0b11111000 | 0b00000011;
#define PWM_FREQ_125HZ      TCCR0B = TCCR0B & 0b11111000 | 0b00000100;
#define PWM_FREQ_32HZ       TCCR0B = TCCR0B & 0b11111000 | 0b00000101;
#define PWM_FREQ            PWM_FREQ_125HZ
#define CPU_FREQ_1MHZ       cli();CLKPR=(1<<CLKPCE);CLKPR=0;sei();
#define CPU_FREQ_500KHZ     cli();CLKPR=(1<<CLKPCE);CLKPR=1;sei();gTime16ms/=2;gTimeShort/=2;gTimeLong/=2;
#define CPU_FREQ_250KHZ     cli();CLKPR=(1<<CLKPCE);CLKPR=2;sei();gTime16ms/=4;gTimeShort/=4;gTimeLong/=4;
#define CPU_FREQ_125KHZ     cli();CLKPR=(1<<CLKPCE);CLKPR=3;sei();gTime16ms/=8;gTimeShort/=8;gTimeLong/=8;
#define CPU_FREQ            CPU_FREQ_125KHZ
#define EEPROM_DATA_READ    eeprom_read_block((void*)&gFanSpeed, 0, 1)
#define EEPROM_DATA_WRITE   eeprom_write_block(&gFanSpeed, 0, 1)

#define PIN_BUTTON   0      // PB0
#define PIN_FAN      1      // PB1
#define PIN_LIGHT    2      // PB2 (ADC1)
#define ADC_LIGHT    1      // PB2 (ADC1)

#define FAN_LIMIT    15     // 0..15
#define FAN_DEFAULT  8      // 50%
#define FAN_SCALE    17     // 255/15
#define FAN_DELAY    7      // 1000/(7*15)=9.5Hz
#define BUTTON_SHORT 1600   // short push
#define BUTTON_LONG  6000   // long press
#define KEY_TAB      0x2B   // Keyboard Tab

static uint8_t  gTime16ms = 16;
static uint16_t gTimeShort = BUTTON_SHORT;
static uint16_t gTimeLong = BUTTON_LONG;
static uint8_t  gFanState = HIGH;
static uint8_t  gFanSpeed = 0;
static uint8_t  gButtonState = HIGH;
static uint32_t gButtonTime  = 0;
static uint16_t gLightSensor  = 0;
static uint16_t gLightDebug = 4;
static uint8_t  gKeyboard = LOW;

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
  PWM_FREQ;
  CPU_FREQ;
  fan();
  gLightSensor = analogRead(ADC_LIGHT);
  if (digitalRead(PIN_BUTTON) == LOW) {
    gKeyboard = HIGH;
    DigiKeyboard.sendKeyStroke(0);
    for (uint8_t i=0; i<10; i++) {
      digitalWrite(PIN_FAN, HIGH);
      delay(gTime16ms);
      digitalWrite(PIN_FAN, LOW);
      delay(12*gTime16ms);
    }  
    DigiKeyboard.println(F("NejeMaster2FanControl"));
    DigiKeyboard.print(F("FAN"));
    DigiKeyboard.sendKeyStroke(KEY_TAB,0);
    DigiKeyboard.println(F("LIGHT"));  
  }
}

void loop() {
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
  delay(8*gTime16ms);
}

void light() {
  gLightSensor *= 4;
  gLightSensor += analogRead(ADC_LIGHT);
  gLightSensor /=5;
  if (gKeyboard == HIGH) {
    gLightDebug--;
    if (gLightDebug == 0) {
      gLightDebug = 4;
      DigiKeyboard.print((uint16_t) (gFanSpeed * FAN_SCALE));
      DigiKeyboard.sendKeyStroke(KEY_TAB,0);
      DigiKeyboard.println(gLightSensor);
    }
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
      if (gButtonTime < gTimeShort) {
        if (gFanState == HIGH) {
          gFanState = LOW;
        } else {
          gFanState = HIGH;
        }
        delay(8*gTime16ms);
      }
      // medium push (next)
      else if (gButtonTime < gTimeLong) {
        gFanSpeed++;
        if (gFanSpeed > FAN_LIMIT) {
          gFanSpeed = 0;
        }
        gFanState = HIGH;
      }      
      // long push (save)
      else if (gButtonTime >= gTimeLong) {
        CPU_FREQ_1MHZ;
        delay(100);
        EEPROM_DATA_WRITE;
        delay(100);
        CPU_FREQ;
      }
    }
  }
  // on button down
  if (gButtonState == LOW) {
    if ((millis()-gButtonTime) > gTimeShort) {
      digitalWrite(PIN_FAN, HIGH);
      delay(gTime16ms);
      digitalWrite(PIN_FAN, LOW);
      delay(gTime16ms);
    }
    if ((millis()-gButtonTime) > gTimeLong) {
      digitalWrite(PIN_FAN, HIGH);
      delay(16*gTime16ms);
      digitalWrite(PIN_FAN, LOW);
      delay(8*gTime16ms);
    }
  }
}
