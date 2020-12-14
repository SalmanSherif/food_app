

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
String entity_api_token = "6Zy/vPZfFbh01gpudalXhkZk7ort2Lb8DBxBQ2nPY//WLf8itlUBTFPBY0Blzxl3";
long iot_id = 728; //change to user inputs
long entity_id = 847;

// ------------------------------------------------------------------------
// data foundry connection
DataFoundry df = new DataFoundry(host);

// access to two datasets: iotDS and entityDS
DFDataset iotDS = df.dataset(iot_id, iot_api_token);
DFDataset entityDS = df.dataset(entity_id, entity_api_token);
//load in table
Table recipe_table;

// variables
String uname = "d9980f7cb03f346d4";
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
String ingredients_list;

ControlP5 cp5;

int xPosA = 18;
int yPosA = 300;
int ySpacing = 30;
int hour = 0;

PImage food_img1;

boolean [][] ingredientsToSend;
String userName;
String ageSend;
float user_age;
float user_weight;
float user_height;
float calTarget;
int foodPref;
int setGoal;
int setFeeling;
int setActivity;
int fitGoal;
float targetCal;
int energyFeeling;
int mealReasonNum;
int mealHeavyLightNum;
int mealDifficultyNum;
String mealReason;
String mealHeavyLight;
String mealDifficulty;
boolean mealFitsTimeslot;

void setup() {

  loadTable(false); // set true when testing;

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

  cp5.addTextfield("user_name").setPosition(xPosA + 100, yPosA - 175).setSize(100, 35).setFont(font).setFocus(true).setColor(color(200, 200, 200));
  cp5.addTextfield("age").setPosition(xPosA + 325, yPosA - 175).setSize(100, 35).setFont(font).setFocus(true).setColor(color(200, 200, 200));
  cp5.addButton("male").setPosition(xPosA + 120, yPosA - 115)
    .setSize(80, 20);
  cp5.addButton("female").setPosition(xPosA + 220, yPosA - 115)
    .setSize(80, 20);
  cp5.addButton("non-binary").setPosition(xPosA + 320, yPosA - 115)
    .setSize(80, 20);

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

  cp5.addTextfield("user_weight").setPosition(xPosA, yPosA - 36).setSize(100, 35).setFont(font).setFocus(true).setColor(color(200, 200, 200));
  cp5.addTextfield("user_height").setPosition(xPosA + 250, yPosA - 36).setSize(100, 35).setFont(font).setFocus(true).setColor(color(200, 200, 200));
  cp5.addTextfield("cal_target").setPosition(xPosA + 970, buttonPositionY * 2.08).setSize(100, 35).setFont(font).setFocus(true).setColor(color(200, 200, 200));

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

  cp5.addButton("Hard to make")
    .setPosition(buttonPositionX + 0, buttonPositionY * 2.1)
    .setSize(120, 30)
    .setId(9);

  cp5.addButton("Easy to make")
    .setPosition(buttonPositionX + 135, buttonPositionY * 2.1)
    .setSize(120, 30)
    .setId(10);  

  cp5.addButton("Very easy to make")
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
  //fetchData();
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

  if (hour < 11) {
    text("Would you eat this meal for breakfast?", xPosA, yPosA + ySpacing + 100);
  } else if (hour > 11 && hour < 14) {
    text("Would you eat this meal for lunch?", xPosA, yPosA + ySpacing + 100);
  } else {
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

float calculateMaxCal() {

  user_age = float(cp5.get(Textfield.class, "age").getText());
  user_height = float(cp5.get(Textfield.class, "user_height").getText());
  user_weight = float(cp5.get(Textfield.class, "user_weight").getText());
  int user_activity = int(cp5.get(Slider.class, "set_activity_slider").getValue());
  float converted = 0;

  if (user_activity == -2) {
    converted = 1.2;
  } else if (user_activity == -1) {
    converted = 1.375;
  } else if (user_activity == 0) {
    converted = 1.55;
  } else if (user_activity == 1) {
    converted = 1.725;
  } else {
    converted = 1.9;
  }

  float calc1 = 66.5 + 13.8 * user_weight + 5 * user_height - 6.8 * user_age;
  float calc2 = 655.1 + 9.6 * user_weight + 1.9 * user_height - 4.7 * user_age;

  if (gender == 1) {
    println("Calories are: " + calc1);
    return converted * calc1;
  } else if (gender == 2) {
    println("Calories are: " + calc2);
    return converted * calc2;
  } else if (gender == 3) {
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

    if (theEvent.getController().getName()=="High Protein") {  
      mealReasonNum = 1;
    }
    if (theEvent.getController().getName()=="High Carb") {   
      mealReasonNum = 2;
    }
    if (theEvent.getController().getName()=="High Fibre") {   
      mealReasonNum = 3;
    }
    if (theEvent.getController().getName()=="High Fat") {   
      mealReasonNum = 4;
    }

    if (theEvent.getController().getName()=="Heavy and Filling") {  
      mealHeavyLightNum = 1;
    }
    if (theEvent.getController().getName()=="Just Right for Me") {  
      mealHeavyLightNum = 2;
    }
    if (theEvent.getController().getName()=="Light and Not Filling") {  
      mealHeavyLightNum = 3;
    }

    if (theEvent.getController().getName()=="Hard to make") {  
      mealDifficultyNum = 1;
    }
    if (theEvent.getController().getName()=="Easy to make") {  
      mealDifficultyNum = 2;
    }
    if (theEvent.getController().getName()=="Very easy to make") {  
      mealDifficultyNum = 3;
    }
 
  if (theEvent.getController().getName()=="yes") {  
    mealFitsTimeslot = true;
  }
  if (theEvent.getController().getName()=="no") {  
    mealFitsTimeslot = false;
  }



  if (theEvent.getController().getName()=="Skip") {   
    count_done = count_done +1;

    if (count_done > 64) count_done = 0;
  }
  if (theEvent.getController().getName()=="Submit") {

    foodPref = (int) cp5.getController("preference_slider").getValue();
    setGoal = (int) cp5.getController("set_goal_slider").getValue();
    setFeeling = (int) cp5.getController("set_feeling_slider").getValue();
    setActivity = (int) cp5.getController("set_activity_slider").getValue();
    fitGoal = (int) cp5.getController("fit_to_goal_slider").getValue();
    energyFeeling = (int) cp5.getController("energy_feeling_slider").getValue();

    ageSend = cp5.get(Textfield.class, "age").getText();
    userName = cp5.get(Textfield.class, "user_name").getText();
    targetCal = float(cp5.get(Textfield.class, "cal_target").getText());
    user_height = float(cp5.get(Textfield.class, "user_height").getText());
    user_weight = float(cp5.get(Textfield.class, "user_weight").getText());
    logIoTDataV2();

    if (count_done > 64) count_done = 0;
  }
}
}


// to IoT dataset
void logIoTDataV2() {
  // set resource id (refId of device in the project)
  iotDS.device(uname);

  String act = "other";

  // set activity for the log
  if (act.equals("start") || act.equals("stop")) {
    iotDS.activity(act);
  } else {
    iotDS.activity("data_entry");
  }
  if (mealReasonNum == 1) {
    mealReason = "High Protein";
  }
  if (mealReasonNum == 2) {
    mealReason = "High Carb";
  }
  if (mealReasonNum == 3) {
    mealReason = "High Fibre";
  }
  if (mealReasonNum == 4) {
    mealReason = "High Fat";
  }

  if (mealHeavyLightNum == 1) {
    mealHeavyLight = "Heavy and Filling";
  }
  if (mealHeavyLightNum == 2) {
    mealHeavyLight = "Just Right for Me";
  }
  if (mealHeavyLightNum == 3) {
    mealHeavyLight = "Light and Not Filling";
  }
  if (mealDifficultyNum == 1) {
    mealDifficulty = "Hard to Make";
  }
  if (mealDifficultyNum == 2) {
    mealDifficulty = "Easy to Make";
  }
  if (mealDifficultyNum == 3) {
    mealDifficulty = "Very easy to Make";
  }
  // add data, then send off the log
  iotDS.data("Time", 0000).data("meal", count_done).data("Username", userName).data("Age", ageSend).data("Gender", gender).data("Food_Preference", foodPref).data("Target_Cal", targetCal)
    .data("Set_Goal", setGoal).data("Set_Feeling", setFeeling).data("Set_Activity", setActivity).data("Fit_Goal", fitGoal).data("Energy_Feeling", energyFeeling)
    .data("Ingredients", ingredientsToSend)
    .data("User_Height", user_height).data("User_Weight", user_weight).data("Meal_Reason", mealReason).data("Meal_Heavy/Light", mealHeavyLight).data("Meal_Difficulty", mealDifficulty).data("Meal_Fits_Timeslot", mealFitsTimeslot)
    .log();
  //entityDS.data("Username", userName).log();

  //easy_to_make = cheap = focussed = breakfast = lunch = dinner = snack = 0;

  count_done = count_done+1;
}

void loadTable(boolean testing) {

  int recipe_number = 0;
  String recipeName, url, rowNumber= "blank";
  TableRow result;

  text("loading", 50, 50);

  recipe_table = loadTable("Recipe_Dataset_1 - Sheet1.csv", "header");
  numberRecipes = (recipe_table.getRowCount()+1);
  recipe_img = new PImage[numberRecipes];
  ingredientsToSend = new boolean[70][30];


  for (TableRow recipe_row : recipe_table.rows()) {

    recipe_number = recipe_row.getInt("No.");
    recipeName = recipe_row.getString("Recipe_Name [string]");
    url = recipe_row.getString("IMG [url]");
    ingredients_list = recipe_row.getString("Ingredients");
    String[] ingredientsIndividual = split(ingredients_list.toLowerCase(), ',');  
    for (int i = 0; i < ingredientsIndividual.length; i++) {
      //println(ingredientsIndividual[i]);
      if (match(ingredientsIndividual[i], "olive oil") != null) {
        ingredientsToSend[recipe_number][1] = true;
      }
      if (match(ingredientsIndividual[i], "flour") != null) {
        ingredientsToSend[recipe_number][2] = true;
      }
      if (match(ingredientsIndividual[i], "butter") != null) {
        ingredientsToSend[recipe_number][3] = true;
      }
      if (match(ingredientsIndividual[i], "chicken") != null) {
        ingredientsToSend[recipe_number][4] = true;
      }
      if (match(ingredientsIndividual[i], "sugar") != null) {
        ingredientsToSend[recipe_number][5] = true;
      }
      if (match(ingredientsIndividual[i], "salt") != null) {
        ingredientsToSend[recipe_number][6] = true;
      }
      if (match(ingredientsIndividual[i], "egg") != null) {
        ingredientsToSend[recipe_number][7] = true;
      }
      if (match(ingredientsIndividual[i], "rice") != null) {
        ingredientsToSend[recipe_number][8] = true;
      }
      if (match(ingredientsIndividual[i], "vegetable oil") != null) {
        ingredientsToSend[recipe_number][9] = true;
      }
      if (match(ingredientsIndividual[i], "pork") != null) {
        ingredientsToSend[recipe_number][10] = true;
      }
      if (match(ingredientsIndividual[i], "beef") != null) {
        ingredientsToSend[recipe_number][11] = true;
      }
      if (match(ingredientsIndividual[i], "cheese") != null) {
        ingredientsToSend[recipe_number][12] = true;
      }
      if (match(ingredientsIndividual[i], "garlic") != null) {
        ingredientsToSend[recipe_number][13] = true;
      }
      if (match(ingredientsIndividual[i], "orange") != null) {
        ingredientsToSend[recipe_number][14] = true;
      }
      if (match(ingredientsIndividual[i], "turkey") != null) {
        ingredientsToSend[recipe_number][15] = true;
      }
      if (match(ingredientsIndividual[i], "onion") != null) {
        ingredientsToSend[recipe_number][16] = true;
      }
      if (match(ingredientsIndividual[i], "corn") != null) {
        ingredientsToSend[recipe_number][17] = true;
      }
      if (match(ingredientsIndividual[i], "whole milk") != null) {
        ingredientsToSend[recipe_number][18] = true;
      }
      if (match(ingredientsIndividual[i], "mayonnaise") != null) {
        ingredientsToSend[recipe_number][19] = true;
      }
      if (match(ingredientsIndividual[i], "chile") != null) {
        ingredientsToSend[recipe_number][20] = true;
      }
      if (match(ingredientsIndividual[i], "almond") != null) {
        ingredientsToSend[recipe_number][21] = true;
      }
      if (match(ingredientsIndividual[i], "bacon") != null) {
        ingredientsToSend[recipe_number][22] = true;
      }
      if (match(ingredientsIndividual[i], "mushroom") != null) {
        ingredientsToSend[recipe_number][23] = true;
      }
      if (match(ingredientsIndividual[i], "coconut") != null) {
        ingredientsToSend[recipe_number][24] = true;
      }
      if (match(ingredientsIndividual[i], "beets") != null) {
        ingredientsToSend[recipe_number][25] = true;
      }
      if ( match(ingredientsIndividual[i], "strawberries") != null) {
        ingredientsToSend[recipe_number][26] = true;
      }
      if ( match(ingredientsIndividual[i], "fennel") != null) {
        ingredientsToSend[recipe_number][27] = true;
      }
      if ( match(ingredientsIndividual[i], "lamb") != null) {
        ingredientsToSend[recipe_number][28] = true;
      }
      if ( match(ingredientsIndividual[i], "apple") != null) {
        ingredientsToSend[recipe_number][29] = true;
      }
      if ( match(ingredientsIndividual[i], "shrimp") != null) {
        ingredientsToSend[recipe_number][30] = true;
      }
    }
    println(recipe_number + " (" + recipeName + ") has an Url of " + url);

    rowNumber = str(recipe_number);
    result = recipe_table.findRow(rowNumber, "No.");

    recipe_img[recipe_number] = loadImage(url, "jpg");

    if (testing && recipe_number == 5) break; //only for testing or building.
  }
}
