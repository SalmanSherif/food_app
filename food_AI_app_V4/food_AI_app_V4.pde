

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
//load in table
Table table;



// variables
String uname = "d9aa70f6a06b64d9e";
long startTime, lastClickTime;
color rColor, bgColor;
int red, green, blue;
int clicks;

boolean isStart;

int healthy = 0;
int easy_to_make = 0;
int cheap = 0;
int focussed = 0;
int breakfast = 0;
int lunch = 0;
int dinner = 0;
int snack = 0;
int state = 1;
String title;
String calCount;
PImage img[];
int numberRecipes;

int buttonPositionX, buttonPositionY;
int Number=0;
String recipeName;
String url;
String row;
String imageUrl;
ControlP5 cp5;
controlP5.Button description1, description2, description3, description4, description5, description6, description7, description8, submit, skip;
controlP5.Slider sl1;

void setup() {
  // load in table
  text("loading", 50, 50);
  table = loadTable("Recipe_Dataset_1 - Sheet1.csv", "header");
  numberRecipes = (table.getRowCount()+1);
  img = new PImage[numberRecipes];
  for (TableRow row : table.rows()) {

    int Number = row.getInt("No.");
    String recipeName = row.getString("Recipe_Name [string]");
    String url = row.getString("IMG [url]");

    println(Number + " (" + recipeName + ") has an Url of " + url);

    // row = str(state);
    //TableRow result = table.findRow(row, "No.");
    //imageUrl = result.getString("IMG [url]");
    String rowNumber = str(Number);
    TableRow result = table.findRow(rowNumber, "No.");
    imageUrl = result.getString("IMG [url]");
    img[Number] = loadImage(imageUrl, "jpg");
    delay(10);
  }

  size(400, 750);
  background(0);
  frameRate(20);
  noStroke();
  //loads however many images we have
  //food_img1 = loadImage("https://i2.wp.com/www.eatthis.com/wp-content/uploads/2019/07/red-green-breakfast-salad.jpg?resize=640%2C360&ssl=1", "jpg");
  //food_img2 = loadImage("image_2.jpg");
  //food_img3 = loadImage("image_3.jpg");
  cp5 = new ControlP5(this);

  PFont p = createFont("Verdana", 11); 
  ControlFont font = new ControlFont(p);

  cp5.setFont(font);

  buttonPositionX = 435;
  buttonPositionY = 20;

  description1 = cp5.addButton("healthy")
    .setPosition(buttonPositionY + 0, buttonPositionX)
    .setSize(80, 30)
    .setId(1);

  description2 = cp5.addButton("easy")
    .setPosition(buttonPositionY + 135, buttonPositionX)
    .setSize(80, 30)
    .setId(2);

  description3 = cp5.addButton("cheap")
    .setPosition(buttonPositionY + 275, buttonPositionX)
    .setSize(80, 30)
    .setId(3);

  description4 = cp5.addButton("breakfast")
    .setPosition(buttonPositionY + 0, buttonPositionX+50)
    .setSize(80, 30)
    .setId(9);

  description5 = cp5.addButton("lunch")
    .setPosition(buttonPositionY + 135, buttonPositionX+50)
    .setSize(80, 30)
    .setId(5);

  description6 = cp5.addButton("dinner")
    .setPosition(buttonPositionY + 275, buttonPositionX+50)
    .setSize(80, 30)
    .setId(6);

  description4 = cp5.addButton("focussed")
    .setPosition(buttonPositionY + 0, buttonPositionX+100)
    .setSize(80, 30)
    .setId(7);

  description5 = cp5.addButton("snack")
    .setPosition(buttonPositionY + 135, buttonPositionX+100)
    .setSize(80, 30)
    .setId(8);

  sl1 = cp5.addSlider("preference_slider")
    .setPosition(20, 600)
    .setHeight(30)
    .setWidth(350)
    .setRange(0, 5) // values can range from big to small as well
    .setValue(2)
    .setNumberOfTickMarks(5)
    .setSliderMode(Slider.FLEXIBLE)
    ;

  submit = cp5.addButton("Submit")
    .setPosition(buttonPositionY + 88, buttonPositionX + 225)
    .setSize(163, 30)
    .setId(4);   

  submit = cp5.addButton("Skip")
    .setPosition(buttonPositionY + 88, buttonPositionX + 275)
    .setSize(163, 30)
    .setId(10);   

  // set interaction start time
  startTime = millis();
}

void draw() {
  if (state>64) {
    state =1;
  }
  background(255, 255, 255);
  if (img[state] != null) {
    image(img[state], 0, 28, width/1, height/3);
  } else println("error");
  title = table.getString(state-1, "Recipe_Name [string]");
  calCount = table.getString(state-1, "Kcal [int]");

  textSize(15);
  text("Food Description", 18, 325);
  fill(0, 102, 153);

  textSize(15);
  text(title, 18, 360);
  text("\n" + calCount + " kCal", 18, 360);
  fill(0, 102, 153);

  textSize(15);
  text("How would you describe this meal?", 18, 415);
  fill(0, 102, 153);

  textSize(15);
  text("How much do you like this meal?", 18, 585);
  fill(0, 102, 153);

  // check every 5 seconds
  if (millis() > 5000 && frameCount % 600 == 0) {
    //fetchData();
  }
}

void controlEvent(ControlEvent theEvent) {


  if (theEvent.isController()) {

    print("control event from : "+theEvent.getController().getName());
    println(", value : "+theEvent.getController().getValue());

    // clicking on button1 sets toggle1 value to 0 (false)
    if (theEvent.getController().getName()=="healthy") {   
      //cp5.getController("healthy").setColorValue(#03a9f4);
      healthy = 1;
    }

    if (theEvent.getController().getName()=="easy") {   
      easy_to_make = 1;
    }

    if (theEvent.getController().getName()=="cheap") {   
      cheap = 1;
    }

    if (theEvent.getController().getName()=="breakfast") {   
      //cp5.getController("Light Excercise").setColorValue(#03a9f4);
      breakfast = 1;
    }

    if (theEvent.getController().getName()=="lunch") {   
      lunch = 1;
    }

    if (theEvent.getController().getName()=="dinner") {   
      dinner = 1;
    }

    if (theEvent.getController().getName()=="focussed") {   
      lunch = 1;
    }

    if (theEvent.getController().getName()=="snack") {   
      dinner = 1;
    }
    if (theEvent.getController().getName()=="Skip") {   
      state = state +1;
    }
    if (theEvent.getController().getName()=="Submit") {
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
  if (act.equals("start") || act.equals("stop")) {
    iotDS.activity(act);
  } else {
    iotDS.activity("data_entry");
  }
  // add data, then send off the log
  iotDS.data("Time", 0000).data("meal", state)
    .data("healthy", healthy)
    .data("easy_to_make", easy_to_make)
    .data("cheap", cheap)
    .data("focussed", focussed)
    .data("breakfast", breakfast)
    .data("lunch", lunch)
    .data("dinner", dinner)
    .data("snack", snack).data("Food_Preference", foodPref).log();

  easy_to_make = cheap = focussed = breakfast = lunch = dinner = snack = 0;
  state = state+1;
}
