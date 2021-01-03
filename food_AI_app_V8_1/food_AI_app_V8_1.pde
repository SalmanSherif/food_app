import java.util.Map;
import controlP5.*;
import nl.tue.id.datafoundry.*;

// Settings for DataFoundry library
String host = "data.id.tue.nl";
String iot_api_token = "yDrmySAt5r77uMBLAi/osxqMZnkyF2398uD41fua6uaLamLx7rcmITpfv4fITr6b";
String entity_api_token = "6Zy/vPZfFbh01gpudalXhkZk7ort2Lb8DBxBQ2nPY//WLf8itlUBTFPBY0Blzxl3";
long iot_id = 849; //change to user inputs
long entity_id = 847;

// DataFoundry connection
DataFoundry df = new DataFoundry(host);

// Access to two datasets: iotDS and entityDS
DFDataset iotDS = df.dataset(iot_id, iot_api_token);
DFDataset entityDS = df.dataset(entity_id, entity_api_token);
//load in table
Table recipe_table;

// Variables
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
boolean morning = false;
boolean afternoon = false;
boolean evening = false;
int breakfast=0;
int lunch=0;
int dinner=0;
PFont titleFont;
PFont textFont;
int state=0;
Button bYes, bNo, bSubmit, bVegan, bVegetarian, bNonVegetarian, bIn, bCm, bLb, bKg, bNext, bLoseWeight, bMaintainWeight, bGainWeight, bLowIntensity, bHighIntensity, bMediumIntensity, bNextExercise;
Textfield usernameExisting, usernameTextfield, ageTextfield, heightTextfield, weightTextfield, genderTextfield, durationTextfield;

void setup() {
  loadTable(true); // Set true when testing;
  size(480, 900);
  background(0);
  frameRate(20);
  noStroke();

  cp5 = new ControlP5(this);
  PFont p = createFont("Verdana", 11); 
  ControlFont font = new ControlFont(p);
  cp5.setFont(font);

  buttonPositionY = 435;
  buttonPositionX = 18;
  
  if (state == 0){
    textFont = createFont("Corbel Light", 35);
    bYes = cp5.addButton("yes").setPosition(30, 330).setSize(200, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bNo = cp5.addButton("no").setPosition(250, 330).setSize(200, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    usernameTextfield = cp5.addTextfield("username").setVisible(false).setColorCaptionLabel(color(213, 239, 197)).setColorActive(color(54, 60, 50)).setPosition(30, 410).setSize(419, 50).setFont(textFont).setFocus(true).setColorBackground(color(213, 239, 197)).setColor(color(54, 60, 50)).setColorCursor(color(54, 60, 50));
    bSubmit = cp5.addButton("submit").setVisible(false).setPosition(30, 490).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
} else if (state == 1){
    textFont = createFont("Corbel Light", 35);
    usernameTextfield = cp5.addTextfield("username").setColorCaptionLabel(color(213, 239, 197)).setColorActive(color(54, 60, 50)).setPosition(175, 240).setSize(125, 50).setFont(textFont).setFocus(true).setColorBackground(color(213, 239, 197)).setColor(color(54, 60, 50)).setColorCursor(color(54, 60, 50));
    ageTextfield = cp5.addTextfield("age").setColorCaptionLabel(color(213, 239, 197)).setColorActive(color(54, 60, 50)).setPosition(175, 340).setSize(125, 50).setFont(textFont).setFocus(true).setColorBackground(color(213, 239, 197)).setColor(color(54, 60, 50)).setColorCursor(color(54, 60, 50));
    heightTextfield = cp5.addTextfield("height").setColorCaptionLabel(color(213, 239, 197)).setColorActive(color(54, 60, 50)).setPosition(175, 440).setSize(125, 50).setFont(textFont).setFocus(true).setColorBackground(color(213, 239, 197)).setColor(color(54, 60, 50)).setColorCursor(color(54, 60, 50));
    weightTextfield = cp5.addTextfield("weight").setColorCaptionLabel(color(213, 239, 197)).setColorActive(color(54, 60, 50)).setPosition(175, 540).setSize(125, 50).setFont(textFont).setFocus(true).setColorBackground(color(213, 239, 197)).setColor(color(54, 60, 50)).setColorCursor(color(54, 60, 50));
    genderTextfield = cp5.addTextfield("gender").setColorCaptionLabel(color(213, 239, 197)).setColorActive(color(54, 60, 50)).setPosition(175, 640).setSize(125, 50).setFont(textFont).setFocus(true).setColorBackground(color(213, 239, 197)).setColor(color(54, 60, 50)).setColorCursor(color(54, 60, 50));
    textFont = createFont("Corbel Light", 20);
    bIn = cp5.addButton("in").setPosition(310, 440).setSize(50, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bCm = cp5.addButton("cm").setPosition(370, 440).setSize(50, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bLb = cp5.addButton("lb").setPosition(310, 540).setSize(50, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bKg = cp5.addButton("kg").setPosition(370, 540).setSize(50, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bNext = cp5.addButton("next").setPosition(175, 775).setSize(125, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(54, 60, 50));
  } else if (state == 2){
    textFont = createFont("Corbel Light", 35);
    bVegan = cp5.addButton("vegan").setPosition(30, 320).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bVegetarian = cp5.addButton("vegetarian").setPosition(30, 420).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bNonVegetarian = cp5.addButton("non-vegetarian").setPosition(30, 520).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
  } else if (state == 3){
    textFont = createFont("Corbel Light", 35);
    bLoseWeight = cp5.addButton("lose weight").setPosition(30, 320).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bGainWeight = cp5.addButton("gain weight").setPosition(30, 420).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bMaintainWeight = cp5.addButton("maintain weight").setPosition(30, 520).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
  } else if (state == 4){ 
    textFont = createFont("Corbel Light", 35);
    bLowIntensity = cp5.addButton("low intensity").setPosition(30, 320).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bMediumIntensity = cp5.addButton("medium intensity").setPosition(30, 420).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bHighIntensity = cp5.addButton("high intensity").setPosition(30, 520).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    durationTextfield = cp5.addTextfield("duration").setColorCaptionLabel(color(213, 239, 197)).setColorActive(color(54, 60, 50)).setPosition(185, 620).setSize(100, 50).setFont(textFont).setFocus(true).setColorBackground(color(213, 239, 197)).setColor(color(54, 60, 50)).setColorCursor(color(54, 60, 50));
    bNextExercise = cp5.addButton("next page").setPosition(140, 775).setSize(200, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(54, 60, 50));
  }
  // Set interaction start time
  startTime = millis();
}

void draw() {
  background(213, 239, 197);
  fill(54, 60, 50);
  if (state == 0){
    titleFont = createFont("Bodoni MT Black", 65);
    textFont(titleFont);
    fill(0);
    text("Hello!", 145, 150);
    textFont = createFont("Corbel Light", 30);
    textFont(textFont);
    fill(54, 60, 50);
    text("Do you already have a username?", 45, 300);
  } else if (state == 1){
    titleFont = createFont("Bodoni MT Black", 65);
    textFont(titleFont);
    fill(0);
    text("Hello!", 145, 150);
    textFont = createFont("Corbel Light", 35);
    textFont(textFont);
    fill(54, 60, 50);
    text("Name:", 50, 275);
    text("Age:", 50, 375);
    text("Height:", 50, 475);
    text("Weight:", 50, 575);
    text("Gender:", 50, 675);
  } else if (state == 2){
    titleFont = createFont("Bodoni MT Black", 65);
    textFont(titleFont);
    fill(0);
    text("What food do", CENTER+10, 150);
    text("you like?", CENTER+80, 250);
  } else if (state == 3){
    titleFont = createFont("Bodoni MT Black", 65);
    textFont(titleFont);
    fill(0);
    text("What is", CENTER+100, 150);
    text("your goal?", CENTER+70, 250);
  } else if (state == 4){
    titleFont = createFont("Bodoni MT Black", 65);
    textFont(titleFont);
    fill(0);
    text("What exercise", CENTER+5, 150);
    text("did you do?", CENTER+50, 250);
    textFont = createFont("Corbel Light", 35);
    textFont(textFont);
    fill(54, 60, 50);
    text("Duration:", 40, 655);
    text("minutes", 300, 655);
  }
  
  // Check every 5 seconds
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
    if (theEvent.getController().getName()=="no"){
      state = 1;
      bYes.hide();
      bNo.hide();
      setup();
    } else if (theEvent.getController().getName()=="yes"){
      usernameTextfield.show();
      bSubmit.show();
    }
    if (theEvent.getController().getName()=="submit"){
      state = 4;
      bYes.hide();
      bNo.hide();
      usernameExisting.hide();
      bSubmit.hide();
      setup();
    }
    if (theEvent.getController().getName()=="next"){
      state = 2;
      usernameTextfield.hide();
      ageTextfield.hide();
      weightTextfield.hide();
      heightTextfield.hide();
      genderTextfield.hide();
      bIn.hide();
      bCm.hide();
      bKg.hide();
      bLb.hide();
      bNext.hide();
      setup();
    }
    if (theEvent.getController().getName()=="vegan"){
      state = 3;
      bVegan.hide();
      bVegetarian.hide();
      bNonVegetarian.hide();
      setup();
    } else if (theEvent.getController().getName()=="vegetarian"){
      state = 3;
      bVegan.hide();
      bVegetarian.hide();
      bNonVegetarian.hide();
      setup();
    } else if (theEvent.getController().getName()=="non-vegetarian"){
      state = 3;
      bVegan.hide();
      bVegetarian.hide();
      bNonVegetarian.hide();
      setup();
    }
    if (theEvent.getController().getName()=="lose weight"){
      state = 4;
      bLoseWeight.hide();
      bGainWeight.hide();
      bMaintainWeight.hide();
      setup();
    } else if (theEvent.getController().getName()=="gain weight"){
      state = 4;
      bLoseWeight.hide();
      bGainWeight.hide();
      bMaintainWeight.hide();
      setup();
    } else if (theEvent.getController().getName()=="maintain weight"){
      state = 4;
      bLoseWeight.hide();
      bGainWeight.hide();
      bMaintainWeight.hide();
      setup();
    }
  }
}

// To IoT dataset
void logIoTDataV2() {
  // Set resource id (refId of device in the project)
  iotDS.device(uname);
  String act = "other";
  // Set activity for the log
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
  // Add data, then send off the log
  iotDS.data("Time", 0000).data("meal", count_done).data("Username", userName).data("Age", ageSend).data("Gender", gender).data("Food_Preference", foodPref).data("Target_Cal", targetCal)
    .data("Set_Goal", setGoal).data("Set_Feeling", setFeeling).data("Set_Activity", setActivity).data("Fit_Goal", fitGoal).data("Energy_Feeling", energyFeeling)
    .data("xOlive Oil", ingredientsToSend[count_done][1]).data("xFlour", ingredientsToSend[count_done][2]).data("xbutter", ingredientsToSend[count_done][3]).data("xChicken", ingredientsToSend[count_done][4]).data("xSugar", ingredientsToSend[count_done][5])
    .data("xSalt", ingredientsToSend[count_done][6]).data("xEgg", ingredientsToSend[count_done][7]).data("xRice", ingredientsToSend[count_done][8]).data("xVegetable Oil", ingredientsToSend[count_done][9]).data("xPork", ingredientsToSend[count_done][10])
    .data("xBeef", ingredientsToSend[count_done][12]).data("xCheese", ingredientsToSend[count_done][12]).data("xGarlic", ingredientsToSend[count_done][13]).data("xOrange", ingredientsToSend[count_done][14]).data("xTurkey", ingredientsToSend[count_done][15])
    .data("xOnion", ingredientsToSend[count_done][16]).data("xCorn", ingredientsToSend[count_done][17]).data("xWhole Milk", ingredientsToSend[count_done][18]).data("xMayonnaise", ingredientsToSend[count_done][19]).data("xChiles", ingredientsToSend[count_done][20])
    .data("xAlmonds", ingredientsToSend[count_done][21]).data("xBacon", ingredientsToSend[count_done][22]).data("xMushrooms", ingredientsToSend[count_done][23]).data("xCoconut", ingredientsToSend[count_done][24]).data("xBeets", ingredientsToSend[count_done][25])
    .data("xStrawberries", ingredientsToSend[count_done][26]).data("xFennel", ingredientsToSend[count_done][27]).data("xLamb", ingredientsToSend[count_done][28]).data("xApple", ingredientsToSend[count_done][29]).data("xShrimp", ingredientsToSend[count_done][30])
    .data("User_Height", user_height).data("User_Weight", user_weight).data("Meal_Reason", mealReason).data("Meal_Heavy/Light", mealHeavyLight).data("Meal_Difficulty", mealDifficulty).data("Breakfast", breakfast).data("Lunch", lunch).data("Dinner", dinner)
    .log();
  // EntityDS.data("Username", userName).log();
  // easy_to_make = cheap = focussed = breakfast = lunch = dinner = snack = 0;
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
  ingredientsToSend = new boolean[70][31];
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
