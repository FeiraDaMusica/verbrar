

void setup() {
  pinMode(9, OUTPUT);
  Serial.begin(9600);
}

void loop() {
    if(Serial.read() == 'H'){
      tone(9,500,50);
    }
    
  


}
