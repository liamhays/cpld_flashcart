#include "SST39SF040.hpp"
#include <avr/io.h>
// This is inspired by (and the timing portions basically copied from)
// https://mint64.home.blog/2018/07/29/parallel-nor-flash-eeprom-programmer-using-an-arduino-part-1-the-sst39sf040-and-planning/

/* This is currently working. Let's start by using port A. */
SST39SF040::SST39SF040() {}

void SST39SF040::begin() {
  // WR and RD never change mode, and we set them to HIGH to prevent
  // anything from going wrong on initialization
  // DDRE = DDRE | 0b00110000;

  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
  porte_reset();
  address_lines_output();
  
  data_lines_output();
}

void SST39SF040::write_byte(uint32_t address, uint8_t data) {
  porte_reset(); // set both high
  // delayMicroseconds(1);
  set_address(address);
  set_data(data);
  delayMicroseconds(1);
  wr_low();
  delayMicroseconds(1);
  porte_reset();
}

uint8_t SST39SF040::read_byte(uint32_t address) {
  porte_reset();
  set_address(address);
  delayMicroseconds(1);
  rd_low();
  delayMicroseconds(1);
  uint8_t d = get_data();
  porte_reset();
  return d;
}

void SST39SF040::chip_erase() {
  // this is the chip-erase program as documented in the datasheet
  write_byte(0x5555, 0xAA);
  write_byte(0x2aaa, 0x55);
  write_byte(0x5555, 0x80);
  write_byte(0x5555, 0xAA);
  write_byte(0x2aaa, 0x55);
  write_byte(0x5555, 0x10);
  delay(150); // longer than it has to be, but it can't hurt
}

// private

void SST39SF040::address_lines_output() {
  DDRF = 0b11111111;
  DDRK = 0b11111111;
  // DDRH = DDRH | 0b00111000;
  PORTF = 0;
  PORTK = 0;
  // PORTH = PORTH & 0;
  /* for (uint8_t i = A0; i <= A15; i++) {
    pinMode(i, OUTPUT);
    }*/
  pinMode(6, OUTPUT);
  pinMode(7, OUTPUT);
  pinMode(8, OUTPUT);
  digitalWrite(6, LOW);
  digitalWrite(7, LOW);
  digitalWrite(8, LOW);
}

/* Writing to DDRA for output seems to be fully functional, but writing to DDRA for input seems to want a delay (and even then doesn't always work). I suspect every DDRx write needs a short delay to let things sink in. */
void SST39SF040::data_lines_output() {
  DDRA = 0xff;
  /* for (uint8_t i = 22; i <= 29; i++) {
    pinMode(i, OUTPUT);
    }*/
}

void SST39SF040::data_lines_input() {
  DDRA = 0;
  /* for (uint8_t i = 22; i <= 29; i++) {
    pinMode(i, INPUT);
    }*/
}

void SST39SF040::set_address(uint32_t address) {
  // Writing to ports F and K for the address is working.

  PORTF = (uint8_t)(address & 0xff);
  PORTK = (uint8_t)((address >> 8) & 0xff);
  // This is not working. It will work initially, but after the value
  // on the right side of the | changes, that stays that way until it
  // changes again.

  // we don't have to do any bitwise work with the current value
  // because PORT H has nothing special we need to worry about.
  PORTH = (((uint8_t)((address >> 16) & 0b111)) << 3);

  /* Serial.print("address: ");
  Serial.print(address, BIN);
  Serial.print("  PORTF: ");
  Serial.print(PORTF, BIN);
  Serial.print("  PORTK: ");
  Serial.print(PORTK, BIN);
  Serial.print("  PORTH: ");
  Serial.print(PORTH, BIN);
  Serial.print("  PORTH & value: ");
  Serial.println((((uint8_t)((address >> 16) & 0b111)) << 3), BIN);*/

}

/* Setting the data with PORTA= works, however, we seem to need a
   longer µs delay, closer to 50.*/

void SST39SF040::set_data(uint8_t data) {
  PORTA = data;
  /* Serial.print("  PORTA: ");
     Serial.println(PORTA);*/
}

/* Reading the data with PINA seems to be working too. */
uint8_t SST39SF040::get_data() {
  return PINA;
}

/* First 4 bits of PORTE are not used by us, and high 2 bits are the same. */
void SST39SF040::porte_reset() {
  PORTE = PORTE | 0b00110000;
  // Serial.println(PORTE, BIN);
  /* digitalWrite(2, HIGH);
     digitalWrite(3, HIGH);*/
}

void SST39SF040::rd_low() {
  PORTE = bitClear(PORTE, 5);// PORTE & 0b00010000;
  // Serial.println(PORTE, BIN);
  // digitalWrite(3, LOW);
}

void SST39SF040::wr_low() {
  // PORTE = PORTE & 0b00010000;
  PORTE = bitClear(PORTE, 4);
  // 
  // digitalWrite(2, LOW);
}

  
  
