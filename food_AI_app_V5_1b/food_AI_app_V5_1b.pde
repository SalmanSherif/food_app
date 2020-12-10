

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

int gender = 0;

int count_done = 1;
String title;
String calCount;
String calMaxResult = "Not yet available";
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
  
  size(1185, 980);
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
    .setRange(-2.5, 2.5) // values can range from big to small as well
    .setValue(0)
    .setNumberOfTickMarks(5)
    .setSliderMode(Slider.FLEXIBLE);
    
  cp5.addSlider("set_feeling_slider")
    .setPosition(xPosA + 768, yPosA - 145)
    .setHeight(30)
    .setWidth(350)
    .setRange(-2, 2) // values can range from big to small as well
    .setValue(0)
    .setNumberOfTickMarks(5)
    .setSliderMode(Slider.FLEXIBLE);
    
  cp5.addSlider("set_activity_slider")
    .setPosition(xPosA + 768, yPosA - 34)
    .setHeight(30)
    .setWidth(350)
    .setRange(-2, 2) // values can range from big to small as well
    .setValue(0)
    .setNumberOfTickMarks(5)
    .setSliderMode(Slider.FLEXIBLE);
  
  cp5.addTextfield("user_weight").setPosition(xPosA, yPosA - 36).setSize(100, 35).setFont(font).setFocus(true).setColor(color(200,200,200));
  cp5.addTextfield("user_height").setPosition(xPosA + 250, yPosA - 36).setSize(100, 35).setFont(font).setFocus(true).setColor(color(200,200,200));
  cp5.addTextfield("cal_target").setPosition(xPosA + 970, buttonPositionY * 2.08).setSize(100, 35).setFont(font).setFocus(true).setColor(color(200,200,200));
  
  cp5.addButton("yes")
    .setPosition(buttonPositionX + 0, buttonPositionY * 1.9)
    .setSize(80, 30)
    .setId(1);

  cp5.addButton("no")
    .setPosition(buttonPositionX + 110, buttonPositionY * 1.9)
    .setSize(80, 30)
    .setId(2);
    
  cp5.addButton("High Protein")
    .setPosition(buttonPositionX + 500, buttonPositionY * 1.1)
    .setSize(150, 30)
    .setId(3);
    
  cp5.addButton("High Carb")
    .setPosition(buttonPositionX + 500, buttonPositionY * 1.2)
    .setSize(150, 30)
    .setId(4);
    
  cp5.addButton("High Fibre")
    .setPosition(buttonPositionX + 500, buttonPositionY * 1.3)
    .setSize(150, 30)
    .setId(5);

  cp5.addButton("High Fat")
    .setPosition(buttonPositionX + 500, buttonPositionY * 1.4)
    .setSize(150, 30)
    .setId(5);
    
  cp5.addButton("Heavy and Filling")
    .setPosition(buttonPositionX + 500, buttonPositionY * 1.63)
    .setSize(150, 30)
    .setId(6);
    
  cp5.addButton("Just Right for Me")
    .setPosition(buttonPositionX + 500, buttonPositionY * 1.73)
    .setSize(150, 30)
    .setId(7);
    
  cp5.addButton("Light and Not Filling")
    .setPosition(buttonPositionX + 500, buttonPositionY * 1.83)
    .setSize(150, 30)
    .setId(8);

  cp5.addButton("not easy to make")
    .setPosition(buttonPositionX + 0, buttonPositionY * 2.1)
    .setSize(120, 30)
    .setId(9);
    
  cp5.addButton("easy to make")
    .setPosition(buttonPositionX + 135, buttonPositionY * 2.1)
    .setSize(120, 30)
    .setId(10);  

  cp5.addButton("very easy to make")
    .setPosition(buttonPositionX + 270, buttonPositionY * 2.1)
    .setSize(120, 30)
    .setId(11);
    
  cp5.addSlider("fit_to_goal_slider")
    .setPosition(xPosA + 770, yPosA * 2.05)
    .setHeight(30)
    .setWidth(350)
    .setRange(-2, 2) // values can range from big to small as well
    .setValue(0)
    .setNumberOfTickMarks(5)
    .setSliderMode(Slider.FLEXIBLE);
    
  cp5.addSlider("energy_feeling_slider")
    .setPosition(xPosA + 770, yPosA * 2.4)
    .setHeight(30)
    .setWidth(350)
    .setRange(-2, 2) // values can range from big to small as well
    .setValue(0)
    .setNumberOfTickMarks(5)
    .setSliderMode(Slider.FLEXIBLE);
    
    
  cp5.addSlider("preference_slider")
    .setPosition(xPosA + 770, yPosA * 1.5)
    .setHeight(30)
    .setWidth(350)
    .setRange(-2, 2) // values can range from big to small as well
    .setValue(0)
    .setNumberOfTickMarks(5)
    .setSliderMode(Slider.FLEXIBLE)
    ;
    
  cp5.addButton("Skip")
    .setPosition(buttonPositionX + 500, buttonPositionY * 2)
    .setSize(163, 30)
    .setId(12);
    
  cp5.addButton("Submit")
    .setPosition(buttonPositionX + 500, buttonPositionY * 2.1)
    .setSize(163, 30)
    .setId(13);   

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
    image(recipe_img[count_done], xPosA, 400, width/3, height/3.6);
  } else {
    println("error");
  }
    
  text("Tell Us About Yourself?", xPosA, yPosA - 200);
  text("User Name", xPosA, yPosA - 150);
  text("Select Age", xPosA + 225, yPosA - 150);
  text("Select Gender", xPosA, yPosA - 100);
  text("What is your weight? (in kg)", xPosA, yPosA - 50);
  text("What is your height? (in cms)", xPosA + 250, yPosA - 50);
  
  text("How do you feel today?", xPosA + 768, yPosA - 160);
  text("Very Bad", xPosA + 768, yPosA * 0.7);
  text("Just Ok", xPosA + 916, yPosA * 0.7);
  text("Very Good", xPosA + 1064, yPosA * 0.7);
  
  text("What is your weekly activity level?", xPosA + 768, yPosA - 50);
  text("Inactive", xPosA + 768, yPosA * 1.1);
  text("On\nAverage\nActive", xPosA + 916, yPosA * 1.1);
  text("Extremely\nActive", xPosA + 1064, yPosA * 1.1);
  
  text("How much weight do you want to lose or gain? (in +/- kg)", xPosA, yPosA + 30);
  
  // second part of the app starts here!
  ySpacing = 415;
  
  text("What do you think about this dish?" + "\n" + title + " with\n" + nutri_info + " kCal", xPosA, yPosA + ySpacing);
  
  hour = hour();
  
  if(hour < 11){
    text("Would you eat this meal for breakfast?", xPosA, yPosA + ySpacing + 100);
  }else if(hour > 11 && hour < 14){
    text("Would you eat this meal for lunch?", xPosA, yPosA + ySpacing + 100);
  }else {
    text("Would you eat this meal for dinner?", xPosA, yPosA + ySpacing + 100);
  }
  
  //stroke(0, 102, 153);
  //line(xPosA + 410, yPosA + ySpacing + 160, xPosA + 410, yPosA + ySpacing + 510);

  text("Why would you eat this meal? (Pick One)", xPosA + 422, yPosA + 125);
  
  text("Is this meal,", xPosA + 455, yPosA * 2.3);
  
  text("How would you describe this meal?", xPosA, yPosA + 600);

  text("How well does this meal fit your selected goal?", xPosA + 770, yPosA + 290);
  
  text("Not at all", xPosA + 770, yPosA * 1.7);
  text("Neutral", xPosA + 148 + 770, yPosA * 1.7);
  text("Very Much", xPosA + 296 + 770, yPosA * 1.7);
  
  text("How would this recipe make you feel?", xPosA + 770, yPosA + 400);
  
  text("Not\nVery\nEnergetic", xPosA + 770, yPosA * 2.58);
  text("As\nNormal", xPosA + 148 + 770, yPosA * 2.58);
  text("Very\nEnergetic", xPosA + 296 + 770, yPosA * 2.58);
  
  //stroke(0, 102, 153);
  //line(xPosA + 720, yPosA + ySpacing + 160, xPosA + 720, yPosA + ySpacing + 510);
  
  text("How much do you like this meal?", xPosA + 820, yPosA + 125);
  
  text("Not at all", xPosA + 770, yPosA * 2.23);
  text("Neutral", xPosA + 148 + 770, yPosA * 2.23);
  text("Very Much", xPosA + 296 + 770, yPosA * 2.23);
  
  text(calMaxResult, xPosA + 768, yPosA + ySpacing + 150);
  text("What is your target calory\nfor this meal?", xPosA + 768, yPosA + ySpacing + 200);
  
  // check every 5 seconds
  if (millis() > 5000 && frameCount % 600 == 0) {
    //fetchData();
  }
}

float calculateMaxCal(){
  
  float user_age = float(cp5.get(Textfield.class, "age").getText());
  float user_height = float(cp5.get(Textfield.class, "user_height").getText());
  float user_weight = float(cp5.get(Textfield.class, "user_weight").getText());
  int user_activity = int(cp5.get(Slider.class, "set_activity_slider").getValue());
  float converted = 0;
  
  if(user_activity == -2){
    converted = 1.2;
  } else if (user_activity == -1){
    converted = 1.375;
  } else if(user_activity == 0){
    converted = 1.55;
  } else if(user_activity == 1){
    converted = 1.725;
  } else {
    converted = 1.9;
  }
  
  float calc1 = 66.5 + 13.8 * user_weight + 5 * user_height - 6.8 * user_age;
  float calc2 = 655.1 + 9.6 * user_weight + 1.9 * user_height - 4.7 * user_age;
  
  if(gender == 1){
    println("Calories are: " + calc1);
    return converted * calc1;
    
  }else if(gender == 2){
    println("Calories are: " + calc2);
    return converted * calc2;
    
  }else if(gender == 3){
    return converted * (calc1 + calc2)/2 ;
    
  }
  
  return -1;
}

void controlEvent(ControlEvent theEvent) {


  if (theEvent.isController()) {

    print("control event from : "+theEvent.getController().getName());
    println(", value : "+theEvent.getController().getValue());

    // clicking on button1 sets toggle1 value to 0 (false)
    //cp5.getController("healthy").setColorValue(#03a9f4);
    //cp5.getController("Light Excercise").setColorValue(#03a9f4);
    
    if (theEvent.getController().getName()=="male") {  
      gender = 1;
    }
    if (theEvent.getController().getName()=="female") {   
      gender = 2;
    }
    if (theEvent.getController().getName()=="non-binary") {   
      gender = 3;
    }
    if (theEvent.getController().getName()=="set_activity_slider") { 
      calMaxResult = "This is your required daily calories:" + str(calculateMaxCal());
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
  
  /*
  // add data, then send off the log
  iotDS.data("Time", 0000).data("meal", count_done)
    .data("healthy", healthy)
    .data("easy_to_make", easy_to_make)
    .data("cheap", cheap)
    .data("focussed", focussed)
    .data("breakfast", breakfast)
    .data("lunch", lunch)
    .data("dinner", dinner)
    .data("snack", snack).data("Food_Preference", foodPref).log();*/

  //easy_to_make = cheap = focussed = breakfast = lunch = dinner = snack = 0;
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
