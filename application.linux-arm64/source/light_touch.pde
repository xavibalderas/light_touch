import lord_of_galaxy.timing_utils.*;

import processing.serial.*;

import dmxP512.*;

import themidibus.*; //Import the library

DmxP512 dmxOutput;
int universeSize=128;
Stopwatch s;
Stopwatch a;
boolean DMXPRO=true;
String DMXPRO_PORT="/dev/ttyUSB0";//case matters ! on windows port must be upper cased.
int DMXPRO_BAUDRATE=115000;
int colorSelected=0;
int[] colors = new int[6];
color[] backs = new color[6];
int waitTime = 3000;
int autoTime = 5000;
boolean autoMode = false;
String[] attached;

MidiBus myBus; // The MidiBus

void setup() {
  size(400, 400);
  background(0);
  dmxOutput=new DmxP512(this,universeSize,false);
  dmxOutput.setupDmxPro(DMXPRO_PORT,DMXPRO_BAUDRATE);
  
  s = new Stopwatch(this);
  a = new Stopwatch(this);
  s.start();
  colors[0] = 12;
  colors[1] = 23;
  colors[2] = 42;
  colors[3] = 68;
  colors[4] = 98;
  colors[5] = 133;

  backs[0] = #FF0000;
  backs[1] = #FF7900;
  backs[2] = #FFEC00;
  backs[3] = #41DB16;
  backs[4] = #0FEEF4;
  backs[5] = #DE0FF4;

  
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, "BLOCK [hw:1,0,0]", "BLOCK [hw:1,0,0]"); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.
  attached = myBus.attachedInputs();
  dmxOutput.set(1,255);
  dmxOutput.set(2,255);
  dmxOutput.set(3,255);
  dmxOutput.set(4,0);
  dmxOutput.set(5,0);
  dmxOutput.set(6,0);
  dmxOutput.set(7,0);
  dmxOutput.set(8,12);
  dmxOutput.set(9,62);
  
  dmxOutput.set(11,255);
  dmxOutput.set(12,255);
  dmxOutput.set(13,255);
  dmxOutput.set(14,0);
  dmxOutput.set(15,0);
  dmxOutput.set(16,0);
  dmxOutput.set(17,0);
  dmxOutput.set(18,12);
  dmxOutput.set(19,62);

    dmxOutput.set(21,255);
  dmxOutput.set(22,255);
  dmxOutput.set(23,255);
  dmxOutput.set(24,0);
  dmxOutput.set(25,0);
  dmxOutput.set(26,0);
  dmxOutput.set(27,0);
  dmxOutput.set(28,12);
  dmxOutput.set(29,62);
  
    dmxOutput.set(31,255);
  dmxOutput.set(32,255);
  dmxOutput.set(33,255);
  dmxOutput.set(34,0);
  dmxOutput.set(35,0);
  dmxOutput.set(36,0);
  dmxOutput.set(37,0);
  dmxOutput.set(38,12);
  dmxOutput.set(39,62);
  
    dmxOutput.set(41,255);
  dmxOutput.set(42,255);
  dmxOutput.set(43,255);
  dmxOutput.set(44,0);
  dmxOutput.set(45,0);
  dmxOutput.set(46,0);
  dmxOutput.set(47,0);
  dmxOutput.set(48,12);
  dmxOutput.set(49,62);
  
  
}

void draw() {

  dmxOutput.set(8,colors[colorSelected]);
    dmxOutput.set(18,colors[colorSelected]);
    dmxOutput.set(28,colors[colorSelected]);
    dmxOutput.set(38,colors[colorSelected]);
    dmxOutput.set(48,colors[colorSelected]);
    
    if (attached.length==0){
          MidiBus.findMidiDevices();
          myBus = new MidiBus(this, "BLOCK [hw:1,0,0]", "BLOCK [hw:1,0,0]"); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.
    }
    
    if (autoMode){
      myBus.sendControllerChange(1, 0, colorSelected+1); // Send a controllerChange
    }

  background(backs[colorSelected]);
  if (s.time()>=waitTime){
    autoMode = true;
    a.start();
    println();
    println("Auto mode on");
    s.reset();
  }
  if(autoMode){
    if (a.time()>=autoTime){
      colorSelected = int(random(0,5));
      a.restart();
      println();
      println("Auto change");
    }
  }

  //delay(500);
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
  colorSelected = value-1;
  s.restart();
  autoMode = false;
     println();
    println("Auto mode off");
}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}
