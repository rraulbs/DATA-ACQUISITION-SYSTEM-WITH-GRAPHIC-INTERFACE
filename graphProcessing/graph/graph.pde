  //Processing code for this example

  // Graphing sketch

  // This program takes ASCII-encoded strings from the serial port at 9600 baud
  // and graphs them. It expects values in the range 0 to 1023, followed by a
  // newline, or newline and carriage return

  // created 20 Apr 2005
  // updated 24 Nov 2015
  // by Tom Igoe
  // This example code is in the public domain.

  import processing.serial.*;

  Serial myPort;        // The serial port
  float xPos = 20;         // horizontal position of the graph
  float xPrevPos = 0;
  float yPrevPos = 0;
  float inByte = 0;
  
  PrintWriter output;
  boolean log = false;
  boolean defaultReference = true;
  boolean grid = true;
  
  PImage img;
  
  void setup () {
    // set the window size:
    size(620, 340);
    //img = loadImage("Button_Start_Log.png");
    
    frameRate(240);

    // List all the available serial ports
    // if using Processing 2.1 or later, use Serial.printArray()
    println(Serial.list());

    // I know that the first port in the serial list on my Mac is always my
    // Arduino, so I open Serial.list()[0].
    // Open whatever port is the one you're using.
    myPort = new Serial(this, Serial.list()[0], 9600);

    // don't generate a serialEvent() unless you get a newline character:
    myPort.bufferUntil('\n');

    // set initial background:
    background(0);
   
  }

  void draw () {
    
    fill(0);
    stroke(0, 0, 0);
    strokeWeight(1);
    rect(0, 0, 620, 20);
    rect(0, 0, 20, 340);
    
    if (grid){   
      for(int x=20; x < 421; x = x + 50){
        stroke(255,255,255);
        for (int i = 0; i <60; i = i+1){
          line(x, 20+(5*i), x, 22+(5*i));
        }
      }
      
      textSize(6);
      fill(255);
      int u = 0;
      for (int y=20; y < 421; y = y + 30){
        textAlign(LEFT);
        text(((1023-(1023/10)*u)),3,y);
        u = u+1;
      }
      fill(0);
      
      for (int y=20; y < 421; y = y + 30){
        stroke(0,0,125);
        for (int i = 0; i < 57; i = i + 1){
          line(20+(7*i), y, 25+(7*i),y);
        }
      }
    }
    
    //SQUARE REFERENCE
    stroke(0,255,0);
    rect(440, 280, 160, 40);
    rect(450,270,100,20);
    
    textSize(9);
    fill(255);
    text("ANALOG REFERENCE", 455,282);
    textSize(10);
    fill(255);
    text("DEFAULT",475,309);
    textSize(10);
    fill(255);
    text("AREF PIN",545,309);    
    //
    
    stroke(0, 255, 0);
    noFill();
    rect(20, 20, 400, 300);
    //BUTTON START LOG///////////////////////////
    if (over(440,20,70,40)) {
      fill(0,255,0);
      rect(440, 20, 70, 40);
    }
    else {
      if (!log) fill(0);
      else fill(0,255,0);
      rect(440, 20, 70, 40);
    }
    textSize(11);
    if (over(440,20,70,40) || log) fill(0);
    else fill(255);
    text("START LOG", 445,43);
    ////////////////////////////////////////////
    //BUTTON SERIAL OPTIONS/////////////////////
    if (over(440,120,70,40)) {
      fill(0,255,0);
      rect(440, 120, 70, 40);
    }
    else {
      fill(0);
      rect(440, 120, 70, 40);
    }
    textSize(11);
    if (over(440,120,70,40)) fill(0);
    else fill(255);
    text("SERIAL", 455,135);
    text("OPTIONS", 450,150);
    /////////////////////////////////////
    //BUTTON STOP LOG////////////////////  
    if (over(530,20,70,40)) {
      fill(0,255,0);
      rect(530, 20, 70, 40);
    }
    else {
      fill(0);
      rect(530, 20, 70, 40);
    }
    textSize(11);
    if (over(530,20,70,40)) fill(0);
    else fill(255);
    text("STOP LOG", 540,43);
    /////////////////////////////////////
    //BUTTON LOG OPTIONS/////////////////
    if (over(530,120,70,40)) {
      fill(0,255,0);
      rect(530, 120, 70, 40);
    }
    else {
      fill(0);
      rect(530, 120, 70, 40);
    }
    textSize(11);
    if (over(530,120,70,40)) fill(0);
    else fill(255);
    text("LOG", 550,135);
    text("OPTIONS", 540,150);
    /////////////////////////////////////
    //BUTTON SHOW GRID///////////////////
    if (over(440,180,70,40) || grid == true) fill(0,255,0);
    else fill(0);
    rect(440, 180, 70, 40);
    
    textSize(11);
    if (over(440,180,70,40) || grid == true) fill(0);
    else fill(255);
    text("SHOW", 457,195);
    text("GRID", 460,210);
    /////////////////////////////////////
    //BUTTON ANALOG REFERENCE: DEFAULT///
    if (over(460,300,10,10) || defaultReference == true) fill(0,255,0);
    else fill(0);
    rect(460, 300, 10, 10);
    /////////////////////////////////////
    //BUTTON ANALOG REFERENCE: AREF PIN/
    if (over(530,300,10,10) || defaultReference == false) fill(0,255,0);
    else fill(0);  
    rect(530, 300, 10, 10);
    /////////////////////////////////////


    
    stroke(255, 255, 0);
    strokeWeight(2);
    line(xPrevPos, yPrevPos, xPos, 320 - inByte);

    if (xPos >= 420) {
      xPos = 20;
      background(0);
    } 
    else {
      xPos++;
    }
    xPrevPos = xPos;
    yPrevPos = 320 - inByte;
    
    
    
  
  }

  void serialEvent (Serial myPort) {
    // get the ASCII string:
    String inString = myPort.readStringUntil('\n');

    if (inString != null) {
      // trim off any whitespace:
      inString = trim(inString);
      // convert to an int and map to the screen height:
      inByte = float(inString);
      if(Float.isNaN(inByte)) println(inByte);
      if(log){
        output.print(millis());
        output.print('\t');
        output.println(inByte);
      }
      inByte = map(inByte, 0, 1023, 1, 299);
    }
  }
  
  boolean over(int x, int y, int w, int h)  {
    if (mouseX >= x && mouseX <= x+w && 
      mouseY >= y && mouseY <= y+h) {
      return true;
    } 
    else {
      return false;
    }
  }
  
  void mousePressed() {
    if (over(440,20,70,40)) {
      output = createWriter("log.txt");
      int d = day();    
      int m = month();  
      int y = year();
      output.print("DATA LOG ");
      output.print(d);
      output.print('/');
      output.print(m);
      output.print('/');
      output.print(y);
      output.print(' ');
      int s = second();  
      int min = minute();  
      int h = hour();
      output.print(h);
      output.print(':');
      output.print(min);
      output.print(':');
      output.println(s);
      output.println();
      log = true;
    }
    
    if (over(530,20,70,40)) {
      if(output != null){
        output.flush();
        output.close();
        log = false;
      }
    }
    
    if (over(460,300,10,10)){
      defaultReference = true;
      myPort.write('d');
    }
    
    if (over(530,300,10,10)){
      defaultReference = false;
      myPort.write('r');
    }
    
    if(over(440,180,70,40)){
      grid = !grid;
      xPos = 20;
      xPrevPos = xPos;
      yPrevPos = 320 - inByte;
      background(0);
      stroke(0, 255, 0);
      fill(0);
      rect(20, 20, 400, 300);
    }
    
    
  }