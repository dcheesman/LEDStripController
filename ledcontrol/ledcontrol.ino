/*
LED map test
Read Serial IN and map values to led positions and color
 */
#include "FastSPI_LED.h"

const int NUM_LEDS = 10;

int id = 0;
int rval = 0;
int gval = 0;
int bval = 0;

// Sometimes chipsets wire in a backwards sort of way
struct CRGB { unsigned char g; unsigned char r; unsigned char b; };
// struct CRGB { unsigned char r; unsigned char g; unsigned char b; };
struct CRGB *leds;

const int DILED = 4;

void setup()
{
    FastSPI_LED.setLeds(NUM_LEDS);
    FastSPI_LED.setChipset(CFastSPI_LED::SPI_WS2811);

    FastSPI_LED.setPin(DILED);

    FastSPI_LED.init();
    FastSPI_LED.start();

    leds = (struct CRGB*)FastSPI_LED.getRGBData(); 
    Serial.begin(9600);
}

void loop() 
{
    while (Serial.available() > 0) {
        id = Serial.parseInt();
        rval = Serial.parseInt();
        gval = Serial.parseInt();
        bval = Serial.parseInt();

        if (Serial.peek() == '\n') {
            leds[id].r = rval;
            leds[id].g = gval;
            leds[id].b = bval;
            FastSPI_LED.show();
        }
    }
    
}
