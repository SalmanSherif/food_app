import java.util.Map;
import controlP5.*;
import nl.tue.id.datafoundry.*;

// ------------------------------------------------------------------------
// settings for DataFoundry library
//
// ... :: CHANGE API TOKENS AND IDS YOURSELF! :: ...
//
String host = "data.id.tue.nl";
String iot_api_token = "opYt87+OhMzH6CXARDVsrMNdMOU6XTqPe891VFAmF/+FIH7uFneJ9rjJmncsnDyq";
long iot_id = 728; //change to user inputs


// ------------------------------------------------------------------------
// data foundry connection
DataFoundry df = new DataFoundry(host);

// access to two datasets: iotDS and entityDS
DFDataset iotDS = df.dataset(iot_id, iot_api_token);

// variables
String uname = "d9980f7cb03f346d4";
long startTime, lastClickTime;
color rColor, bgColor;
int red, green, blue;
int clicks;
boolean isStart;

int light_excercise = 0;
int heavy_excercise = 0;
int long_study_session = 0;
PImage food_img;
int buttonPositionX, buttonPositionY;

ControlP5 cp5;
controlP5.Button goal1, goal2, goal3, submit;
controlP5.Slider sl1;

void setup() {
  // initiate canvas in mobile resolution
  size(800, 1500);
  background(0);
  frameRate(20);
  noStroke();
  
  food_img = loadImage("image_1.jpg");
  
  cp5 = new ControlP5(this);
  
  PFont p = createFont("Verdana",23); 
  ControlFont font = new ControlFont(p);
  
  cp5.setFont(font);
  
  buttonPositionX = 870;
  buttonPositionY = 40;
    
  goal1 = cp5.addButton("Light Excercise")
    .setPosition(buttonPositionY + 0, buttonPositionX)
    .setSize(300, 60)
    .setId(1);
  
  goal2 = cp5.addButton("Heavy Excercise")
    .setPosition(buttonPositionY + 350, buttonPositionX)
    .setSize(300, 60)
    .setId(2);
    
  goal3 = cp5.addButton("Long Study Session")
    .setPosition(buttonPositionY + 0, buttonPositionX + 100)
    .setSize(325, 60)
    .setId(3);
    
  sl1 = cp5.addSlider("preference_slider")
     .setPosition(40,1150)
     .setHeight(60)
     .setWidth(700)
     .setRange(0,5) // values can range from big to small as well
     .setValue(2)
     .setNumberOfTickMarks(5)
     .setSliderMode(Slider.FLEXIBLE)
     ;
  
  submit = cp5.addButton("Submit")
    .setPosition(buttonPositionY + 175, buttonPositionX + 450)
    .setSize(325, 60)
    .setId(4);   

  // set interaction start time
  startTime = millis();
}

void draw() {
  background(255,255,255);
  
  image(food_img, 0, 55, width/1, height/3);
  
  textSize(30);
  text("Food Description", 35, 650);
  fill(0, 102, 153);
  
  textSize(30);
  text("Vegetable Salad with Mayo Dressing \n400 kCal", 35, 720);
  fill(0, 102, 153);
  
  textSize(30);
  text("What activities did you do today?", 35, 830);
  fill(0, 102, 153);
  
  textSize(30);
  text("Do you like this recommendation?", 35, 1100);
  fill(0, 102, 153);
  
  // check every 5 seconds
  if (millis() > 5000 && frameCount % 600 == 0) {
    //fetchData();
  }
}

void controlEvent(ControlEvent theEvent) {
  
  
  if(theEvent.isController()) {
    
    print("control event from : "+theEvent.getController().getName());
    println(", value : "+theEvent.getController().getValue());
    
    // clicking on button1 sets toggle1 value to 0 (false)
    if(theEvent.getController().getName()=="Light Excercise") {   
     //cp5.getController("Light Excercise").setColorValue(#03a9f4);
     light_excercise = 1;
    }
    
    if(theEvent.getController().getName()=="Heavy Excercise") {   
     heavy_excercise = 1;
    }
    
    if(theEvent.getController().getName()=="Long Study Session") {   
     long_study_session = 1;
    }
    
    if(theEvent.getController().getName()=="Submit") {
      int value = (int) cp5.getController("preference_slider").getValue();
      
      logIoTDataV2(value);
    }
    
  }  
}

// to IoT dataset
void logIoTDataV2(int foodPref) {
  // set resource id (refId of device in the project)
  iotDS.device(uname);
  
  String act = "other";
  
  // set activity for the log
  if(act.equals("start") || act.equals("stop")) {
    iotDS.activity(act);
  } else {
    iotDS.activity("data_entry");
  }
  // add data, then send off the log
  iotDS.data("Time", 0000).data("light_excercise", light_excercise)
  .data("heavy_excercise", heavy_excercise)
  .data("long_study_session", long_study_session)
  .data("Food_Preference", foodPref).log();
  
  light_excercise = heavy_excercise = long_study_session = 0;
}
