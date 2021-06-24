#ifndef SST39SF040_H
#define SST39SF040_H

#include <Arduino.h>

class SST39SF040 {
public:
  SST39SF040( /* uint8_t pinA0, uint8_t pinA18,
	     uint8_t pinD0, uint8_t pinD7,
	     uint8_t pinWR, uint8_t pinRD*/);

  void begin();
  void write_byte(uint32_t address, uint8_t data);
  uint8_t read_byte(uint32_t address);
  void chip_erase();
  void data_lines_output();
  void data_lines_input();

  // Chip ID, sector erase, etc.

private:
  // uint8_t A0, A18, D0, D7, WR, RD;
  void address_lines_output();

  void porte_reset();
  void rd_low();
  void wr_low();
  void set_address(uint32_t address);
  void set_data(uint8_t data);
  uint8_t get_data();
};


#endif
