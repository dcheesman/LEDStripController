//midi triggers

void noteOn(int channel, int pitch, int velocity) {
  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);

  // simple proof of concept for midi trigger
  CircleBurst circleBurst = new CircleBurst(2000, selectedColor);
  effects.add(circleBurst);
}

void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOff
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
}