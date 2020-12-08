

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
Table recipe_table;

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
int count_done = 1;
String title;
String calCount;
PImage recipe_img[];
int numberRecipes;

int buttonPositionX, buttonPositionY;
int Number=0;
String recipeName;
String url;
String row;
String imageUrl;

ControlP5 cp5;

int xPosA = 18;
int yPosA = 300;
int ySpacing = 30;
int hour = 0;

PImage food_img1;

void setup() {
  
  loadTable(true); // set true when testing;
  
  size(1200, 1300);
  background(0);
  frameRate(20);
  noStroke();
  
  cp5 = new ControlP5(this);
  PFont p = createFont("Verdana", 11); 
  ControlFont font = new ControlFont(p);
  cp5.setFont(font);

  buttonPositionY = 435;
  buttonPositionX = 18;
  
  cp5.addTextfield("user_name").setPosition(xPosA + 100, yPosA - 175).setSize(100, 35).setFont(font).setFocus(true).setColor(color(200,200,200));
  cp5.addTextfield("age").setPosition(xPosA + 325, yPosA - 175).setSize(100, 35).setFont(font).setFocus(true).setColor(color(200,200,200));
  cp5.addButton("male").setPosition(xPosA + 120, yPosA - 115)
  .setSize(80,20);
  cp5.addButton("female").setPosition(xPosA + 220, yPosA - 115)
  .setSize(80,20);
  cp5.addButton("non-binary").setPosition(xPosA + 320, yPosA - 115)
  .setSize(80,20);
  
  cp5.addSlider("set_goal_slider")
    .setPosition(xPosA, yPosA + 45)
    .setHeight(30)
    .setWidth(350)
    .setRange(-10, 10) // values can range from big to small as well
    .setValue(0)
    .setNumberOfTickMarks(20)
    .setSliderMode(Slider.FLEXIBLE);
  
  cp5.addTextfield("Weight").setPosition(xPosA, yPosA - 36).setSize(100, 35).setFont(font).setFocus(true).setColor(color(200,200,200));
  
  cp5.addButton("yes")
    .setPosition(buttonPositionX + 0, buttonPositionY * 2.05)
    .setSize(80, 30)
    .setId(1);

  cp5.addButton("no")
    .setPosition(buttonPositionX + 110, buttonPositionY * 2.05)
    .setSize(80, 30)
    .setId(2);
    
  cp5.addButton("High Protein/Low Fat")
    .setPosition(buttonPositionX + 500, buttonPositionY * 2.05)
    .setSize(150, 30)
    .setId(3);
    
  cp5.addButton("High Fat/Low Protein")
    .setPosition(buttonPositionX + 500, buttonPositionY * 2.15)
    .setSize(150, 30)
    .setId(4);
    
  cp5.addButton("Low Fat/Low Protein")
    .setPosition(buttonPositionX + 500, buttonPositionY * 2.25)
    .setSize(150, 30)
    .setId(5);
    
  cp5.addButton("Heavy and Filling")
    .setPosition(buttonPositionX + 500, buttonPositionY * 2.50)
    .setSize(150, 30)
    .setId(6);
    
  cp5.addButton("Just Right for Me")
    .setPosition(buttonPositionX + 500, buttonPositionY * 2.60)
    .setSize(150, 30)
    .setId(7);
    
  cp5.addButton("Light and Not Filling")
    .setPosition(buttonPositionX + 500, buttonPositionY * 2.70)
    .setSize(150, 30)
    .setId(8);

  cp5.addButton("not easy to make")
    .setPosition(buttonPositionX + 0, buttonPositionY * 2.23)
    .setSize(120, 30)
    .setId(9);
    
  cp5.addButton("easy to make")
    .setPosition(buttonPositionX + 135, buttonPositionY * 2.23)
    .setSize(120, 30)
    .setId(10);  

  cp5.addButton("very easy to make")
    .setPosition(buttonPositionX + 270, buttonPositionY * 2.23)
    .setSize(120, 30)
    .setId(11);
    
  cp5.addSlider("fit_to_goal_slider")
    .setPosition(xPosA, yPosA * 3.57)
    .setHeight(30)
    .setWidth(350)
    .setRange(-2, 2) // values can range from big to small as well
    .setValue(0)
    .setNumberOfTickMarks(5)
    .setSliderMode(Slider.FLEXIBLE);
    
  cp5.addSlider("energy_feeling_slider")
    .setPosition(xPosA, yPosA * 3.94)
    .setHeight(30)
    .setWidth(350)
    .setRange(-2, 2) // values can range from big to small as well
    .setValue(0)
    .setNumberOfTickMarks(5)
    .setSliderMode(Slider.FLEXIBLE);
    
    
  cp5.addSlider("preference_slider")
    .setPosition(xPosA + 770, yPosA * 3)
    .setHeight(30)
    .setWidth(350)
    .setRange(-2, 2) // values can range from big to small as well
    .setValue(0)
    .setNumberOfTickMarks(5)
    .setSliderMode(Slider.FLEXIBLE)
    ;
    
  cp5.addButton("Skip")
    .setPosition(buttonPositionX + 860, buttonPositionY * 2.4)
    .setSize(163, 30)
    .setId(12);
    
  cp5.addButton("Submit")
    .setPosition(buttonPositionX + 860, buttonPositionY * 2.5)
    .setSize(163, 30)
    .setId(13);   

/*
  cp5.addButton("lunch")
    .setPosition(buttonPositionY + 135, buttonPositionX+50)
    .setSize(80, 30)
    .setId(5);

  cp5.addButton("dinner")
    .setPosition(buttonPositionY + 275, buttonPositionX+50)
    .setSize(80, 30)
    .setId(6);

  cp5.addButton("focussed")
    .setPosition(buttonPositionY + 0, buttonPositionX+100)
    .setSize(80, 30)
    .setId(7);

  cp5.addButton("snack")
    .setPosition(buttonPositionY + 135, buttonPositionX+100)
    .setSize(80, 30)
    .setId(8);*/   

  // set interaction start time
  startTime = millis();
}

void draw() {
  
  background(255, 255, 255);
  
  textSize(15);
  fill(0, 102, 153);
  
  title = recipe_table.getString(count_done-1, "Recipe_Name [string]");
  
  String nutri_info = "kCal: " + recipe_table.getString(count_done-1, "Kcal [int]")
  + ", Proteins: " + recipe_table.getString(count_done-1, "Proteins in g [int]")
  + ", Fats: " + recipe_table.getString(count_done-1, "Fat in g [int]") 
  + ", Carbs: " + recipe_table.getString(count_done-1, "Carbohydrates [int]")
  + ", Fibre: " + recipe_table.getString(count_done-1, "Fibre [int]") + ".";
  
  // set image here
  if (recipe_img[count_done] != null) {
    image(recipe_img[count_done], 200, 400, width/1.5, height/3.6);
  } else {
    println("error");
  }
    
  text("Tell Us About Yourself?", xPosA, yPosA - 200);
  text("User Name", xPosA, yPosA - 150);
  text("Select Age", xPosA + 225, yPosA - 150);
  text("Select Gender", xPosA, yPosA - 100);
  text("What is your weight?", xPosA, yPosA - 50);
  text("How much weight do you want to lose or gain? (in +/- kg)", xPosA, yPosA + 30);
  
  // second part of the app starts here!
  ySpacing = 415;
  
  text("What do you think about this dish?\n", xPosA, yPosA + ySpacing + 80);
  text(title + " with " + nutri_info + " kCal", xPosA, yPosA + ySpacing + 110);
  
  hour = hour();
  
  if(hour < 11){
    text("Would you eat this meal for breakfast?", xPosA, yPosA + ySpacing + 160);
  }else if(hour > 11 && hour < 14){
    text("Would you eat this meal for lunch?", xPosA, yPosA + ySpacing + 160);
  }else {
    text("Would you eat this meal for dinner?", xPosA, yPosA + ySpacing + 160);
  }
  
  stroke(0, 102, 153);
  line(xPosA + 410, yPosA + ySpacing + 160, xPosA + 410, yPosA + ySpacing + 510);

  text("Why would you eat this meal?", xPosA + 455, yPosA + ySpacing + 160);
  
  text("Is this meal,", xPosA + 455, yPosA * 3.54);
  
  text("How would you describe this meal?", xPosA, yPosA + ySpacing + 240);

  text("How well does this meal fit your selected goal?", xPosA, yPosA + ySpacing + 335);
  
  text("Not at all", xPosA, yPosA * 3.75);
  text("Neutral", xPosA + 148, yPosA * 3.75);
  text("Very Much", xPosA + 296, yPosA * 3.75);
  
  text("How would this recipe make you feel?", xPosA, yPosA + ySpacing + 450);
  
  text("Not at all", xPosA, yPosA * 4.12);
  text("Neutral", xPosA + 148, yPosA * 4.12);
  text("Very Much", xPosA + 296, yPosA * 4.12);
  
  stroke(0, 102, 153);
  line(xPosA + 720, yPosA + ySpacing + 160, xPosA + 720, yPosA + ySpacing + 510);
  
  text("How much do you like this meal?", xPosA + 820, yPosA + ySpacing + 160);
  
  text("Not at all", xPosA + 768, yPosA * 3.2);
  text("Neutral", xPosA + 916, yPosA * 3.2);
  text("Very Much", xPosA + 1064, yPosA * 3.2);

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
    //cp5.getController("healthy").setColorValue(#03a9f4);
    //cp5.getController("Light Excercise").setColorValue(#03a9f4);
    
    if (theEvent.getController().getName()=="healthy") {  
      healthy = 1;
    }

    if (theEvent.getController().getName()=="easy") {   
      easy_to_make = 1;
    }

    if (theEvent.getController().getName()=="cheap") {   
      cheap = 1;
    }

    if (theEvent.getController().getName()=="breakfast") {   
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
      count_done = count_done +1;
      
      if (count_done > 64) count_done = 0;
    }
    if (theEvent.getController().getName()=="Submit") {
      
      int value = (int) cp5.getController("preference_slider").getValue();
      logIoTDataV2(value);
      
      if (count_done > 64) count_done = 0;
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
  iotDS.data("Time", 0000).data("meal", count_done)
    .data("healthy", healthy)
    .data("easy_to_make", easy_to_make)
    .data("cheap", cheap)
    .data("focussed", focussed)
    .data("breakfast", breakfast)
    .data("lunch", lunch)
    .data("dinner", dinner)
    .data("snack", snack).data("Food_Preference", foodPref).log();

  easy_to_make = cheap = focussed = breakfast = lunch = dinner = snack = 0;
  count_done = count_done+1;
}

void loadTable(boolean testing){
  
  int recipe_number = 0;
  String recipeName, url, rowNumber= "blank";
  TableRow result;
 
  text("loading", 50, 50);
  
  recipe_table = loadTable("Recipe_Dataset_1 - Sheet1.csv", "header");
  numberRecipes = (recipe_table.getRowCount()+1);
  recipe_img = new PImage[numberRecipes];
  
  for (TableRow recipe_row : recipe_table.rows()) {

    recipe_number = recipe_row.getInt("No.");
    recipeName = recipe_row.getString("Recipe_Name [string]");
    url = recipe_row.getString("IMG [url]");

    println(recipe_number + " (" + recipeName + ") has an Url of " + url);
  
    rowNumber = str(recipe_number);
    result = recipe_table.findRow(rowNumber, "No.");
    
    recipe_img[recipe_number] = loadImage(url, "jpg");
   
    if(testing && recipe_number == 5) break; //only for testing or building.
  }
  
}
