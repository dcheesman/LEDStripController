#include <OctoWS2811.h>

int id = 0;
int rval = 0;
int gval = 0;
int bval = 0;

const int ledsPerStrip = 10;

DMAMEM int displayMemory[ledsPerStrip*6];
int drawingMemory[ledsPerStrip*6];

const int config = WS2811_GRB | WS2811_800kHz;

OctoWS2811 leds(ledsPerStrip, displayMemory, drawingMemory, config);

void setup() {
  leds.begin();
  leds.show();
  Serial.begin(9600);
}

void loop() {
  while (Serial.available() > 0) {
        id = Serial.parseInt();
        rval = Serial.parseInt();
        gval = Serial.parseInt();
        bval = Serial.parseInt();

        if (Serial.read() == '\n') {
            leds.setPixel(id, rval, gval, bval);
            leds.show();
        }
    }
}
