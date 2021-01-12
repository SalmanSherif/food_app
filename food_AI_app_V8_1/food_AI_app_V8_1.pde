import java.util.Map;
import controlP5.*;
import nl.tue.id.datafoundry.*;

// Settings for DataFoundry library
String host = "data.id.tue.nl";
String iot_api_token = "yDrmySAt5r77uMBLAi/osxqMZnkyF2398uD41fua6uaLamLx7rcmITpfv4fITr6b";
String entity_api_token = "K42jfbGeoMWVFBptrK12Ic9Bo+vzCpo6ONpHHE61GsMAdHg2R6z6gu4nA2suTuM8";
long iot_id = 849; //change to user inputs8
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
Button bYes, bNo, bSubmit, bVegan, bVegetarian, bNonVegetarian, /*bIn, bCm, bLb, bKg, */ bNext1, bNext2, bLoseWeight, bMaintainWeight, bGainWeight, bNext1Exercise, bInActive, bSlightlyActive, bAveragelyActive, bVeryActive, bExtremelyActive;
Textfield usernameExisting, usernameTextfield, ageTextfield, heightTextfield, weightTextfield, genderTextfield;
PImage background;
PImage backbutton;
Button back1, back2, back3;
Slider weight_slider;
DropdownList gender_list;

// User data
String user_name;
String user_age;
String user_height;
String user_weight;
float user_gender;
String user_vegan;
String user_vegetarian;
String user_nonvegetarian;
float user_weightgoal;
boolean inActive;
boolean slightlyActive;
boolean averagelyActive;
boolean veryActive;
boolean extremelyActive;
float recommendedCalory;

void setup() {
  //loadTable(true); // Set true when testing;
  size(480, 900);
  background(0);
  frameRate(20);
  noStroke();
  background = loadImage("background.jpg");
  backbutton = loadImage("back_button.JPG");

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
    usernameExisting = cp5.addTextfield("username").setVisible(false).setColorCaptionLabel(color(255, 255, 255)).setColorActive(color(54, 60, 50)).setPosition(30, 410).setSize(419, 50).setFont(textFont).setFocus(true).setColorBackground(color(213, 239, 197)).setColor(color(54, 60, 50)).setColorCursor(color(54, 60, 50)).setColorForeground(color(54, 60, 50));
    bSubmit = cp5.addButton("sign in").setVisible(false).setPosition(30, 490).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
} else if (state == 1){
    textFont = createFont("Corbel Light", 35);
    back1 = cp5.addButton("back1").setImage(backbutton).setPosition(25, 50).setSize(50, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(255, 255, 255)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    usernameTextfield = cp5.addTextfield("username").setColorCaptionLabel(color(255, 255, 255)).setColorActive(color(54, 60, 50)).setPosition(250, 270).setSize(125, 50).setFont(textFont).setFocus(true).setColorBackground(color(213, 239, 197)).setColor(color(54, 60, 50)).setColorCursor(color(54, 60, 50)).setColorForeground(color(255, 255, 255));
    ageTextfield = cp5.addTextfield("age").setColorCaptionLabel(color(255, 255, 255)).setColorActive(color(54, 60, 50)).setPosition(250, 370).setSize(125, 50).setFont(textFont).setFocus(true).setColorBackground(color(213, 239, 197)).setColor(color(54, 60, 50)).setColorCursor(color(54, 60, 50)).setColorForeground(color(255, 255, 255));
    heightTextfield = cp5.addTextfield("height").setColorCaptionLabel(color(255, 255, 255)).setColorActive(color(54, 60, 50)).setPosition(250, 470).setSize(125, 50).setFont(textFont).setFocus(true).setColorBackground(color(213, 239, 197)).setColor(color(54, 60, 50)).setColorCursor(color(54, 60, 50)).setColorForeground(color(255, 255, 255));
    weightTextfield = cp5.addTextfield("weight").setColorCaptionLabel(color(255, 255, 255)).setColorActive(color(54, 60, 50)).setPosition(250, 570).setSize(125, 50).setFont(textFont).setFocus(true).setColorBackground(color(213, 239, 197)).setColor(color(54, 60, 50)).setColorCursor(color(54, 60, 50)).setColorForeground(color(255, 255, 255));
    textFont = createFont("Corbel Light", 20);
    bNext1 = cp5.addButton("next").setPosition(175, 775).setSize(125, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(54, 60, 50));
    gender_list = cp5.addDropdownList("gender").setPosition(250, 670).setFont(textFont).setSize(125, 200).setBackgroundColor(color(190)).setBarHeight(50).setItemHeight(50).setValue(1).close().setColorLabel(color(54, 60, 50)).setColorValue(color(54, 60, 50)).addItem("Female",1).addItem("Male",2).addItem("Non-Binary", 3).setColorBackground(color(213, 239, 197)).setColorActive(color(167, 188, 154)).setColorForeground(color(167, 188, 154));
  } else if (state == 2){
    back2 = cp5.addButton("back2").setImage(backbutton).setPosition(25, 50).setSize(50, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    textFont = createFont("Corbel Light", 35);
    bVegan = cp5.addButton("vegan").setPosition(30, 320).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bVegetarian = cp5.addButton("vegetarian").setPosition(30, 420).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bNonVegetarian = cp5.addButton("non-vegetarian").setPosition(30, 520).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
  } else if (state == 3){
    back3 = cp5.addButton("back3").setImage(backbutton).setPosition(25, 50).setSize(50, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    textFont = createFont("Corbel Light", 35);
    weight_slider = cp5.addSlider("weight_goal").setPosition(30, 320).setHeight(50).setWidth(420).setRange(-2.5, 2.5).setValue(0).setNumberOfTickMarks(51).setSliderMode(Slider.FLEXIBLE).setColorBackground(color(167, 188, 154)).setColorValue(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setColorCaptionLabel(color(0, 0, 0)).setColorForeground(color(54, 60, 50)).setLabelVisible(false);
    textFont = createFont("Corbel Light", 20);
    bNext2 = cp5.addButton("next ").setPosition(175, 775).setSize(125, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(54, 60, 50));
  } else if (state == 4){
    textFont = createFont("Corbel Light", 35);
    bInActive = cp5.addButton("inactive").setPosition(30, 320).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bSlightlyActive = cp5.addButton("slightly active").setPosition(30, 390).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bAveragelyActive = cp5.addButton("averagely active").setPosition(30, 460).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bVeryActive = cp5.addButton("very active").setPosition(30, 530).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bExtremelyActive = cp5.addButton("extremely active").setPosition(30, 600).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    textFont = createFont("Corbel Light", 20);
    bNext1Exercise = cp5.addButton("recommend").setPosition(140, 775).setSize(200, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(54, 60, 50));
  }
  // Set interaction start time
  startTime = millis();
}

void draw() {
  background(background);
  fill(54, 60, 50);
  if (state == 0){
    titleFont = createFont("Corbel", 50);
    textFont(titleFont);
    fill(54, 60, 50);
    text("Hello!", 180, 150);
    textFont = createFont("Corbel Light", 30);
    textFont(textFont);
    fill(54, 60, 50);
    text("Do you already have a username?", 45, 300);
  } else if (state == 1){
    titleFont = createFont("Corbel", 50);
    textFont(titleFont);
    fill(54, 60, 50);
    text("Welcome!", 140, 150);
    textFont = createFont("Corbel Light", 35);
    textFont(textFont);
    fill(54, 60, 50);
    text("Name:", 115, 305);
    text("Age:", 115, 405);
    text("Height:", 115, 505);
    text("Weight:", 115, 605);
    text("Gender:", 115, 705);
    textFont = createFont("Corbel Light", 25);
    textFont(textFont);
    fill(54, 60, 50);
    text("cm", 390, 500);
    text("kg", 390, 600);
  } else if (state == 2){
    titleFont = createFont("Corbel", 50);
    textFont(titleFont);
    fill(54, 60, 50);
    text("What food do", CENTER+95, 115);
    text("you like?", CENTER+155, 180);
  } else if (state == 3){
    titleFont = createFont("Corbel", 50);
    textFont(titleFont);
    fill(54, 60, 50);
    text("What is your", CENTER+110, 115);
    text("goal this month?", CENTER+70, 180);
    textFont = createFont("Corbel", 30);
    textFont(textFont);
    fill(54, 60, 50);
    text("|", 37, 400);
    text("|", 137, 400);
    text("|", 237, 400);
    text("|", 337, 400);
    text("|", 437, 400);
    textFont = createFont("Corbel Light", 20);
    textFont(textFont);
    fill(54, 60, 50);
    text("-2.5 kg", 30, 435);
    text("-1.25 kg", 120, 435);
    text("0 kg", 230, 435);
    text("+1.25 kg", 310, 435);
    text("+2.5 kg", 400, 435);
    textFont = createFont("Corbel Light", 16);
    textFont(textFont);
    fill(54, 60, 50);
    text("Please enter whether you want to lose, gain or maintain your weight.", 25, 480);
    text("This information helps us give more suitable recommendations.", 38, 510);
  } else if (state == 4){
    titleFont = createFont("Corbel", 50);
    textFont(titleFont);
    fill(54, 60, 50);
    text("How active were", CENTER+60, 115);
    text("you today?", CENTER+130, 180);
    textFont = createFont("Corbel Light", 16);
    textFont(textFont);
    fill(54, 60, 50);
    text("This information helps us give more suitable recommendations.", 38, 680);
  }
  
  // Check every 5 seconds
  if (millis() > 5000 && frameCount % 600 == 0) {
    //fetchData();
  }
}

// button functionality
void controlEvent(ControlEvent theEvent) {
  if (theEvent.isController()) {
    print("control event from : "+theEvent.getController().getName());
    println(", value : "+theEvent.getController().getValue()); 
    // if no username
    if (theEvent.getController().getName()=="no"){
      state = 1;
      bYes.hide();
      bNo.hide();
      bSubmit.hide();
      usernameExisting.hide();
      setup();
    } else if (theEvent.getController().getName()=="yes"){
      // if existing username
      usernameExisting.show();
      bSubmit.show();
    }
    // if existing username entered
    if (theEvent.getController().getName()=="sign in"){
      // select item with id and token combination
      entityDS.id(uname).token(uname);
      // check whether username exists
      Map<String, Object> result = entityDS.get();
      user_name = usernameExisting.getText();
      if (result.containsValue(user_name)){
        // display welcome message
        javax.swing.JOptionPane.showMessageDialog(null, "Welcome " + user_name + "!");
        // save all user variables locally
        user_name = checkProfileItem(result.get("user_name"), "Null");
        user_age = checkProfileItem(result.get("user_age"), "Null");
        user_height = checkProfileItem(result.get("user_height"), "Null");
        user_weight = checkProfileItem(result.get("user_weight"), "Null");
        user_gender = parseFloat(checkProfileItem(result.get("user_gender"), "Null"));
        user_vegan = checkProfileItem(result.get("user_vegan"), "false");
        user_vegetarian = checkProfileItem(result.get("user_vegetarian"), "false");
        user_nonvegetarian = checkProfileItem(result.get("user_nonvegetarian"), "false");
        user_weightgoal = parseFloat(checkProfileItem(result.get("user_weightgoal"), "Null"));
        javax.swing.JOptionPane.showMessageDialog(null, "user_name: " + user_name + ", user_age:" + user_age + ", user_height: " + user_height + ", user_weight: " + user_weight + ", user_gender: " + user_gender + ", user_vegan: " + user_vegan + ", user_vegetarian: " + user_vegetarian + ", user_nonvegetarian: + " + user_nonvegetarian + ", user_weightgoal: " + user_weightgoal);
        state = 4;
        bYes.hide();
        bNo.hide();
        usernameExisting.hide();
        bSubmit.hide();
        setup();
      } else {
        javax.swing.JOptionPane.showMessageDialog(null, "This username is not yet in the dataset. Please fill in the form to create a new profile.");
        state = 1;
        bYes.hide();
        bNo.hide();
        usernameExisting.hide();
        bSubmit.hide();
        setup();
      }
    }
    // if introductory form filled in
    if (theEvent.getController().getName()=="next"){
      user_name = usernameTextfield.getText();
      user_age = ageTextfield.getText();
      user_height = heightTextfield.getText();
      user_weight = weightTextfield.getText();
      user_gender = gender_list.getValue();
      // select item with id and token combination
      entityDS.id(uname).token(uname);
      // check whether username exists
      Map<String, Object> result = entityDS.get();
      if (state == 1 && result.containsValue(user_name)==true){
              javax.swing.JOptionPane.showMessageDialog(null, "An error has occured! The chosen username is already in the database or not all fields have been filled in...");
      } else if (state == 1 && (user_name == "" || user_age == "" || user_height == "" || user_weight == "")){
              javax.swing.JOptionPane.showMessageDialog(null, "Please fill in all the fields.");
      } else {
      state = 2;
      usernameTextfield.hide();
      ageTextfield.hide();
      weightTextfield.hide();
      heightTextfield.hide();
      gender_list.hide();
      bNext1.hide();
      back1.hide();
      setup();
      }
    }
    if (theEvent.getController().getName()=="vegan"){
      state = 3;
      user_vegan = "true";
      user_vegetarian = "false";
      user_nonvegetarian = "false";
      bVegan.hide();
      bVegetarian.hide();
      bNonVegetarian.hide();
      back2.hide();
      setup();
    } else if (theEvent.getController().getName()=="vegetarian"){
      user_vegan = "false";
      user_vegetarian = "true";
      user_nonvegetarian = "false";
      state = 3;
      bVegan.hide();
      bVegetarian.hide();
      bNonVegetarian.hide();
      back2.hide();
      setup();
    } else if (theEvent.getController().getName()=="non-vegetarian"){
      user_vegan = "false";
      user_vegetarian = "false";
      user_nonvegetarian = "true";
      state = 3;
      bVegan.hide();
      bVegetarian.hide();
      bNonVegetarian.hide();
      back2.hide();
      setup();
    }
    if (theEvent.getController().getName()=="next "){
      user_weightgoal = weight_slider.getValue();
      weight_slider.hide();
      state = 4;
      back3.hide();
      setup();
    }
    // activity button functionality
    if (theEvent.getController().getName()=="inactive"){
      inActive = true;
      slightlyActive = false;
      averagelyActive = false;
      veryActive = false;
      extremelyActive = false;
      javax.swing.JOptionPane.showMessageDialog(null, "So you were inactive today, " + user_name + "? Press recommend to confirm.");
      println("inactive");
    } else if (theEvent.getController().getName()=="slightly active"){
      inActive = false;
      slightlyActive = true;
      averagelyActive = false;
      veryActive = false;
      extremelyActive = false;
      javax.swing.JOptionPane.showMessageDialog(null, "So you were slightly active today, " + user_name + "? Press recommend to confirm.");
      println("slightly active");
    } else if (theEvent.getController().getName()=="averagely active"){
      inActive = false;
      slightlyActive = false;
      averagelyActive = true;
      veryActive = false;
      extremelyActive = false;
      javax.swing.JOptionPane.showMessageDialog(null, "So you were averagely active today, " + user_name + "? Press recommend to confirm.");
      println("averagely active");
    } else if (theEvent.getController().getName()=="very active"){
      inActive = false;
      slightlyActive = false;
      averagelyActive = false;
      veryActive = true;
      extremelyActive = false;
      javax.swing.JOptionPane.showMessageDialog(null, "So you were very active today, " + user_name + "? Press recommend to confirm.");
      println("very active");
    } else if (theEvent.getController().getName()=="extremely active"){
      inActive = false;
      slightlyActive = false;
      averagelyActive = false;
      veryActive = false;
      extremelyActive = true;
      javax.swing.JOptionPane.showMessageDialog(null, "So you were extremely active today, " + user_name + "? Press recommend to confirm.");
      println("extremely active");
    }
    if (theEvent.getController().getName()=="recommend"){
      calculateMaxCal();    
    }
    
    // back button functionality
    if (theEvent.getController().getName()=="back1"){
      state = 0;
      usernameTextfield.hide();
      ageTextfield.hide();
      weightTextfield.hide();
      heightTextfield.hide();
      gender_list.hide();
      bNext1.hide();
      back1.hide();
      setup();
    }
    if (theEvent.getController().getName()=="back2"){
      state = 1;
      bVegan.hide();
      bVegetarian.hide();
      bNonVegetarian.hide();
      back2.hide();
      setup();
    }
    if (theEvent.getController().getName()=="back3"){
      state = 2;
      bLoseWeight.hide();
      bGainWeight.hide();
      bMaintainWeight.hide();
      back3.hide();
    }
    // select item with id and token combination
    entityDS.id(uname).token(uname);
    // check whether username exists
    Map<String, Object> result = entityDS.get();  
    if (state == 4 && result.containsValue(user_name)==false) {
        // select item with id and token combination
        entityDS.id(uname).token(uname);
        // add data to send (=update)
        entityDS.data("user_name", user_name).data("user_age", user_age).data("user_height", user_height).data("user_weight", user_weight)
        .data("user_gender", user_gender).data("user_vegan", user_vegan).data("user_vegetarian", user_vegetarian).data("user_nonvegetarian", user_nonvegetarian)
        .data("user_weightgoal", user_weightgoal).update();
        javax.swing.JOptionPane.showMessageDialog(null, "Welcome " + user_name + "! Your profile has successfully been generated in the database.");
      }
  }
}

void calculateMaxCal() {
  int user_age_int;
  int user_height_int;
  int user_weight_int;
  user_age_int = parseInt(user_age);
  user_height_int = parseInt(user_height);
  user_weight_int = parseInt(user_weight);
  float converted = 0;
  if (inActive) {
    converted = 1.2;
  } else if (slightlyActive) {
    converted = 1.375;
  } else if (averagelyActive) {
    converted = 1.55;
  } else if (veryActive) {
    converted = 1.725;
  } else if (extremelyActive) {
    converted = 1.9;
  }
  float calc1 = 66.5 + 13.8 * user_weight_int + 5 * user_height_int - 6.8 * user_age_int;
  float calc2 = 655.1 + 9.6 * user_weight_int + 1.9 * user_height_int - 4.7 * user_age_int;
  if (user_gender == 1) {
    println("Calories are: " + calc1);
    recommendedCalory = converted * calc1;
  } else if (gender == 2) {
    println("Calories are: " + calc2);
    recommendedCalory = converted * calc2;
  } else if (gender == 3) {
    recommendedCalory = (calc1 + calc2)/2 ;
  }
  println(recommendedCalory);
  javax.swing.JOptionPane.showMessageDialog(null, "Your recommended daily calory intake is " + recommendedCalory + " kCal, " + user_name + "!");
  println(user_age_int, user_height_int, user_weight_int);
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
