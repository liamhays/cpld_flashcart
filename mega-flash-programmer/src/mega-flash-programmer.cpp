#include <Arduino.h>
#include <SPI.h>
// note: use the Adafruit SD library, as documented at
// https://learn.adafruit.com/adafruit-data-logger-shield/for-the-mega-and-leonardo
#include <SdFat.h>
#include "SST39SF040.hpp"
// #include <digitalWriteFast.h>
// SD_FAT_TYPE = 0 for SdFat/File as defined in SdFatConfig.h,
// 1 for FAT16/FAT32, 2 for exFAT, 3 for FAT16/FAT32 and exFAT.
#define SD_FAT_TYPE 1

const uint8_t SD_CS_PIN = 10;
// Try to select the best SD card configuration.
#define SD_CONFIG SdSpiConfig(SD_CS_PIN, DEDICATED_SPI)



SdFat32 sd;
File32 file;

SST39SF040 flash;

void setup() {
  pinMode(11, INPUT);
  pinMode(12, INPUT);
  pinMode(13, INPUT);
  Serial.begin(1000000);
  if (!sd.begin(SD_CONFIG)) {
    Serial.println("SD initialization failed!");
    while (true);
  }

  if (!file.open("sonic.sms", FILE_READ)) {
    Serial.println("Opening file failed!");
    while (true);
  }
  
  flash.begin();
  delay(1);
  flash.chip_erase();
  
  
  /* Everything now appears to be working! */
  
  uint32_t address = 0;
  // Serial.println(file.size());
  uint32_t t = millis();
  // This takes 47875 ms with file.available()
  // It takes 47502 with file.size() (so basically no difference)

  // It takes 15655 with the adjustments on RD and WR made with PORT
  // access instead of digitalWrite
  
  // while (file.available()) {
  uint32_t s = file.size();
  for (uint32_t i = 0; i < s; i++) {

    uint8_t b = file.read();
    
    flash.write_byte(0x5555, 0xAA);
    flash.write_byte(0x2aaa, 0x55);
    flash.write_byte(0x5555, 0xa0);
    flash.write_byte(i, b);
    delayMicroseconds(20);
    // address++;
  }

  // Test idea: we read the whole thing back and save it to a file on
  // the card, where we can check the checksum.
  Serial.println(millis() - t);
  // while (true);

  // Currently, with just porte_reset() using PORTE, this is fully
  // functional (check by SHA256)
  
  // Let's enable rd_low() with PORTE. With it this way, the checksums
  // vary.
  flash.data_lines_input();
  delay(1);
  file.close();
  File32 output;
  output.open("flash.out", FILE_WRITE);
  // Serial.println(flash.read_byte(0), HEX);
  for (uint32_t i = 0; i < s; i++) {
    // Serial.print(flash.read_byte(i), HEX);
    // Serial.print((char)flash.read_byte(i));
    output.write((char)flash.read_byte(i));
    delayMicroseconds(2);
  }
  output.close();
  Serial.println("finished writing to file");
}    /* flash.write_byte(0x5555, 0xAA);
  flash.write_byte(0x2aaa, 0x55);
  flash.write_byte(0x5555, 0xa0);
  flash.write_byte(0x30000, 0xAC);
  delayMicroseconds(50);
  
  flash.write_byte(0x5555, 0xAA);
  flash.write_byte(0x2aaa, 0x55);
  flash.write_byte(0x5555, 0xa0);
  flash.write_byte(0x40000, 0x95);
  delayMicroseconds(50);
  
  flash.write_byte(0x5555, 0xAA);
  flash.write_byte(0x2aaa, 0x55);
  flash.write_byte(0x5555, 0xa0);
  flash.write_byte(0x50000, 0xB7);
  delayMicroseconds(50);*/

/* 

  flash.write_byte(0x5555, 0xAA);
  flash.write_byte(0x2aaa, 0x55);
  flash.write_byte(0x5555, 0xa0);
  flash.write_byte(0, 0xAC);
  delayMicroseconds(50);
  
  flash.write_byte(0x5555, 0xAA);
  flash.write_byte(0x2aaa, 0x55);
  flash.write_byte(0x5555, 0xa0);
  flash.write_byte(15, 0x95);
  delayMicroseconds(50);
  
  flash.write_byte(0x5555, 0xAA);
  flash.write_byte(0x2aaa, 0x55);
  flash.write_byte(0x5555, 0xa0);
  flash.write_byte(25, 0xB7);
  delayMicroseconds(50);
*/
void loop() {}
