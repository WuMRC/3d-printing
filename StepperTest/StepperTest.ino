/* 
 This is a test sketch for the Adafruit assembled Motor Shield for Arduino v2
 It won't work with v1.x motor shields! Only for the v2's with built in PWM
 control
 
 For use with the Adafruit Motor Shield v2 
 ---->	http://www.adafruit.com/products/1438
 */


#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_PWMServoDriver.h"

// Create the motor shield object with the default I2C address
Adafruit_MotorShield AFMS = Adafruit_MotorShield(); 
// Or, create it with a different I2C address (say for stacking)
// Adafruit_MotorShield AFMS = Adafruit_MotorShield(0x61); 

// Connect a stepper motor with 200 steps per revolution (1.8 degree)
// to motor port #2 (M3 and M4)
Adafruit_StepperMotor *myMotor = AFMS.getStepper(200, 1);

int stepperMode = 0;


void setup() {
  TWBR = ((F_CPU /400000l) - 16) / 2; // Change the i2c clock to 400KHz
  Serial.begin(38400);           // set up Serial library at 9600 bps
  Serial.println("Stepper test!");

  AFMS.begin();  // create with the default frequency 1.6KHz
  //AFMS.begin(1000);  // OR with a different frequency, say 1KHz

  myMotor->setSpeed(255);  // 10 rpm   
}

void loop() {

  if (Serial.available()) {
    uint8_t ch = Serial.read();
    uint8_t status;

    if (ch == '0') {

    }

    if (ch == '1') {
      Serial.println("Single coil steps");
      myMotor->step(1000, BACKWARD, SINGLE);
    }

    if (ch == '2') {
      Serial.println("Double coil steps");
      myMotor->step(2000, FORWARD, DOUBLE); 
    }

    if (ch == '3') {
      Serial.println("Interleave coil steps");
      myMotor->step(2000, FORWARD, INTERLEAVE); 
    }

    if (ch == '4') {
      Serial.println("Microstep steps");
      myMotor->step(2000, FORWARD, MICROSTEP); 
    }
  }
}

