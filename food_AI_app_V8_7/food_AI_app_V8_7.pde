
import java.util.Map;
import controlP5.*;
import nl.tue.id.datafoundry.*;

import java.io.*;
import java.util.*;

weka.classifiers.trees.J48 j48 = null;
Instances data = null;

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
int gender = 0; //1 = male, 2 = female, 3 = non-binary
int count_done = 1;
String title;
String calCount;
Float calMaxResult;
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
PFont subTitleFont;
PFont mainNumber;
PFont subNumber;
int state=5;                     //change this to start at different screens


//int genderSelect;                
int mealType;                    //1 = light meal, 2 = medium meal, 3 = heavy meal
float currentCal = 700;
float maxCal;
float progressCal;
float progressArcDegrees;
float progressArcRadians;
int Eaten;
int Burned;
float currentCarbs = 111;
float progressCarbs;
float progressCarbsBar;
float maxCarbs = 221;
float currentProtein = 66;
float progressProtein;
float progressProteinBar;
float maxProtein = 88;
float currentFat = 42;
float progressFat;
float progressFatBar;
float maxFat = 58;
float worldTime;
float correctedWorldTime;
float scaledWorldTime;
float mappedWorldTime;

int startUp = 0;
int vegan = 0;  //0 is not vegan, 1= vegan/vegetarian
float addedCal;
float addedCarbs;
float addedProtein;
float addedFat;

float totalCurrentCarbs;
float totalCurrentFat;
float totalCurrentProtein;
float totalCurrentCal;

int imageRecipe1;
int imageRecipe2;
int imageRecipe3;
int predict3;
int titleRecipe1;
int titleRecipe2;
int titleRecipe3;

String stringTitleRecipe1;
String stringTitleRecipe2;
String stringTitleRecipe3;
String stringTitleRecipeHighlight;

int mealHighlight;
String mealTypeSelect = "Just Right for Me";
String mealReasonSelect = "High Protein";

float diffCarbs;
float diffFat;
float diffCal;
float diffProtein;
float largestValue;

int recipeDataSend;
int skipDataSend;
int dislikeDataSend;
Button bYes, bNo, bSubmit, bGenderMale, bGenderFemale, bGenderNonBinary, bVegan, bVegetarian, bNonVegetarian, bIn, bCm, bLb, bKg, bNext, bLoseWeight, bMaintainWeight, bGainWeight, bLowIntensity, bHighIntensity, bMediumIntensity, bNextExercise, bLightMeal, bMediumMeal, bHeavyMeal, bEatHightlight, bEat1, bEat2, bEat3, bDislikeHightlight, bDislike1, bDislike2, bDislike3, bSkipHightlight, bSkip1, bSkip2, bSkip3, bBackHighlight, bRecipe1, bRecipe2, bRecipe3 ;
Textfield usernameExisting, usernameTextfield, ageTextfield, heightTextfield, weightTextfield, genderTextfield, durationTextfield;



void setup() {

  if (startUp ==0) {
    loadTable(false); // Set true when testing;
    predict3 = int(random(0,60));
    startUp = startUp + 1;
  }
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

  if (state == 0) {
    textFont = createFont("Corbel Light", 35);
    bYes = cp5.addButton("yes").setPosition(30, 330).setSize(200, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bNo = cp5.addButton("no").setPosition(250, 330).setSize(200, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    usernameTextfield = cp5.addTextfield("username").setVisible(false).setColorCaptionLabel(color(213, 239, 197)).setColorActive(color(54, 60, 50)).setPosition(30, 410).setSize(419, 50).setFont(textFont).setFocus(true).setColorBackground(color(213, 239, 197)).setColor(color(54, 60, 50)).setColorCursor(color(54, 60, 50));
    bSubmit = cp5.addButton("submit").setVisible(false).setPosition(30, 490).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
  } else if (state == 1) {
    textFont = createFont("Corbel Light", 35);
    usernameTextfield = cp5.addTextfield("username").setColorCaptionLabel(color(213, 239, 197)).setColorActive(color(54, 60, 50)).setPosition(175, 240).setSize(125, 50).setFont(textFont).setFocus(true).setColorBackground(color(213, 239, 197)).setColor(color(54, 60, 50)).setColorCursor(color(54, 60, 50));
    ageTextfield = cp5.addTextfield("age").setColorCaptionLabel(color(213, 239, 197)).setColorActive(color(54, 60, 50)).setPosition(175, 340).setSize(125, 50).setFont(textFont).setFocus(true).setColorBackground(color(213, 239, 197)).setColor(color(54, 60, 50)).setColorCursor(color(54, 60, 50));
    heightTextfield = cp5.addTextfield("user_height").setColorCaptionLabel(color(213, 239, 197)).setColorActive(color(54, 60, 50)).setPosition(175, 440).setSize(125, 50).setFont(textFont).setFocus(true).setColorBackground(color(213, 239, 197)).setColor(color(54, 60, 50)).setColorCursor(color(54, 60, 50));
    weightTextfield = cp5.addTextfield("user_weight").setColorCaptionLabel(color(213, 239, 197)).setColorActive(color(54, 60, 50)).setPosition(175, 540).setSize(125, 50).setFont(textFont).setFocus(true).setColorBackground(color(213, 239, 197)).setColor(color(54, 60, 50)).setColorCursor(color(54, 60, 50));
    //genderTextfield = cp5.addTextfield("gender").setColorCaptionLabel(color(213, 239, 197)).setColorActive(color(54, 60, 50)).setPosition(175, 640).setSize(125, 50).setFont(textFont).setFocus(true).setColorBackground(color(213, 239, 197)).setColor(color(54, 60, 50)).setColorCursor(color(54, 60, 50));
    bGenderMale = cp5.addButton("male").setPosition(180, 640).setSize(90, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bGenderFemale = cp5.addButton("female").setPosition(300, 640).setSize(125, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bGenderNonBinary = cp5.addButton("non-binary").setPosition(180, 700).setSize(220, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    textFont = createFont("Corbel Light", 20);
    bIn = cp5.addButton("in").setPosition(310, 440).setSize(50, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bCm = cp5.addButton("cm").setPosition(370, 440).setSize(50, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bLb = cp5.addButton("lb").setPosition(310, 540).setSize(50, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bKg = cp5.addButton("kg").setPosition(370, 540).setSize(50, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bNext = cp5.addButton("next").setPosition(175, 775).setSize(125, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(54, 60, 50));
  } else if (state == 2) {
    textFont = createFont("Corbel Light", 35);
    bVegan = cp5.addButton("vegan").setPosition(30, 320).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bVegetarian = cp5.addButton("vegetarian").setPosition(30, 420).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bNonVegetarian = cp5.addButton("non-vegetarian").setPosition(30, 520).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
  } else if (state == 3) {
    textFont = createFont("Corbel Light", 35);
    bLoseWeight = cp5.addButton("lose weight").setPosition(30, 320).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bGainWeight = cp5.addButton("gain weight").setPosition(30, 420).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bMaintainWeight = cp5.addButton("maintain weight").setPosition(30, 520).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
  } else if (state == 4) { 
    textFont = createFont("Corbel Light", 35);
    bLowIntensity = cp5.addButton("low intensity").setPosition(30, 320).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bMediumIntensity = cp5.addButton("medium intensity").setPosition(30, 420).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bHighIntensity = cp5.addButton("high intensity").setPosition(30, 520).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    durationTextfield = cp5.addTextfield("duration").setColorCaptionLabel(color(213, 239, 197)).setColorActive(color(54, 60, 50)).setPosition(185, 620).setSize(100, 50).setFont(textFont).setFocus(true).setColorBackground(color(213, 239, 197)).setColor(color(54, 60, 50)).setColorCursor(color(54, 60, 50));
    bNextExercise = cp5.addButton("next page").setPosition(140, 775).setSize(200, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(54, 60, 50));
  } else if (state == 5) {
    textFont = createFont("Corbel Light", 35);
    bLightMeal = cp5.addButton("Light Meal").setPosition(30, 520).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bMediumMeal = cp5.addButton("Medium Meal").setPosition(30, 620).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bHeavyMeal = cp5.addButton("Heavy Meal").setPosition(30, 720).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
  } else if (state == 6) {
    textFont = createFont("Corbel Light", 30);
    bEat1 = cp5.addButton("Eat1").setCaptionLabel("Eat!").setPosition(30, 120).setSize(80, 40).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(0, 255, 128)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(50, 205, 50));
    bDislike1 = cp5.addButton("Dislike1").setCaptionLabel("Dislike").setPosition(350, 120).setSize(100, 40).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(128, 0, 0)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(164, 65, 65));
    bSkip1 = cp5.addButton("Skip1").setCaptionLabel("Skip").setPosition(350, 170).setSize(100, 40).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(128, 128, 128)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(137, 123, 123));
    bRecipe1 = cp5.addButton("Recipe1").setPosition(120, 120).setSize(220, 200).setColorCaptionLabel(color(255, 255, 255, 1)).setColorForeground(color(128, 128, 128, 1)).setColorActive(color(54, 60, 50, 1)).setFont(textFont).setColorBackground(color(100, 0, 0, 1));


    bEat2 = cp5.addButton("Eat2").setCaptionLabel("Eat!").setPosition(30, 370).setSize(80, 40).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(0, 255, 128)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(50, 205, 50));
    bDislike2 = cp5.addButton("Dislike2").setCaptionLabel("Dislike").setPosition(350, 370).setSize(100, 40).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(128, 0, 0)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(164, 65, 65));
    bSkip2 = cp5.addButton("Skip2").setCaptionLabel("Skip").setPosition(350, 420).setSize(100, 40).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(128, 128, 128)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(137, 123, 123));
    bRecipe2 = cp5.addButton("Recipe2").setPosition(120, 370).setSize(220, 200).setColorCaptionLabel(color(255, 255, 255, 1)).setColorForeground(color(128, 128, 128, 1)).setColorActive(color(54, 60, 50, 1)).setFont(textFont).setColorBackground(color(100, 0, 0, 1));

    bEat3 = cp5.addButton("Eat3").setCaptionLabel("Eat!").setPosition(30, 620).setSize(80, 40).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(0, 255, 128)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(50, 205, 50));
    bDislike3 = cp5.addButton("Dislike3").setCaptionLabel("Dislike").setPosition(350, 620).setSize(100, 40).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(128, 0, 0)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(164, 65, 65));
    bSkip3 = cp5.addButton("Skip3").setCaptionLabel("Skip").setPosition(350, 670).setSize(100, 40).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(128, 128, 128)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(137, 123, 123));
    bRecipe3 = cp5.addButton("Recipe3").setPosition(120, 620).setSize(220, 200).setColorCaptionLabel(color(255, 255, 255, 1)).setColorForeground(color(128, 128, 128, 1)).setColorActive(color(54, 60, 50, 1)).setFont(textFont).setColorBackground(color(100, 0, 0, 1));
  } else if (state == 7) {
    textFont = createFont("Corbel Light", 35);
    bEatHightlight =cp5.addButton("EatHighlight").setCaptionLabel("Eat!").setPosition(30, 800).setSize(80, 40).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(0, 255, 128)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(50, 205, 50));
    bSkipHightlight = cp5.addButton("SkipHighlight").setCaptionLabel("Skip").setPosition(180, 800).setSize(100, 40).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(128, 128, 128)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(137, 123, 123));
    bDislikeHightlight = cp5.addButton("DislikeHighlight").setCaptionLabel("Dislike").setPosition(350, 800).setSize(100, 40).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(128, 0, 0)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(164, 65, 65));
    textFont = createFont("Corbel Light", 25);
    bBackHighlight = cp5.addButton("BackHighlight").setCaptionLabel("Back").setPosition(20, 20).setSize(60, 40).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(0, 165, 255)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(0, 165, 255));
  }
  // Set interaction start time

  loadData(dataPath("reduced_rand.arff"));
  loadModel(dataPath("j48_rand_test.model"));

if(mealType == 1){
  mealTypeSelect = "Light and Not Filling";
} else if (mealType == 2){
  mealTypeSelect = "Just Right for Me";
} else if (mealType == 3){
  mealTypeSelect = "Heavy and Filling";
}


diffCarbs = maxCarbs - currentCarbs;
diffProtein = maxProtein - currentProtein;
diffFat = maxFat - currentFat;
diffCal = maxCal - currentCal;
largestValue = max(diffCarbs, diffProtein, diffFat);

if(largestValue == diffCarbs){
  mealReasonSelect = "High Carb";
} else if (largestValue == diffProtein){
  mealReasonSelect = "High Protein";
} else if (largestValue == diffFat){
  mealReasonSelect = "High Fat";
}

  println(predict1());
  println(predict2());
 // println(predict3());
  startTime = millis();
}

String predict1() {
  String r = "Sorry, unable to predict";
  if (j48 == null) return r;

  // build a new instance with the given input
  Instance di = new DenseInstance(35);
  di.setDataset(data);

  for (int i=0; i< 35; i++) {
  //  println(di.attribute(i));
  }

  //println(di.attribute(2));
  // the block of code below allows you to input data for prediction.
  // you need the whole thing.
  // (x,y) --> Change the values of y why to obtain different prediction.
  di.setValue(0, 2); //fit_goal   [not used]
  di.setValue(1, vegan); //xEgg      
  di.setValue(2, 0); //xOnion
  di.setValue(3, 0); //@attribute xGarlic {TRUE,FALSE}
  di.setValue(4, 2); //@attribute Food_Preference {-2,-1,0,1,2}
  di.setValue(5, 1); //@attribute xbutter {FALSE,TRUE}
  di.setValue(6, mealReasonSelect); //@attribute Meal_Reason {'High Protein','High Carb','High Fat','High Fibre'}
  di.setValue(7, 0); //@attribute Energy_Feeling {-2,-1,0,1,2}
  di.setValue(8, mealTypeSelect); //@attribute Meal_Heavy/Light {'Light and Not Filling','Just Right for Me','Heavy and Filling'}
  di.setValue(9, 0); //@attribute 'xOlive Oil' {TRUE,FALSE}
  di.setValue(10, "Easy to Make"); //@attribute Meal_Difficulty {'Easy to Make','Very easy to Make','Hard to Make'}
  di.setValue(11, 1); //@attribute xSugar {FALSE,TRUE}
  di.setValue(12, 1); //@attribute xFlour {FALSE,TRUE}
  di.setValue(13, 1); //@attribute xSalt {TRUE,FALSE}
  di.setValue(14, 1); //@attribute 'xVegetable Oil' {FALSE,TRUE}
  di.setValue(15, 0); //@attribute xRice {FALSE,TRUE}
  di.setValue(16, 0); //@attribute xCorn {FALSE,TRUE}
  di.setValue(17, vegan); //@attribute xBeef {FALSE,TRUE}
  di.setValue(18, 0); //@attribute xCheese {FALSE,TRUE}
  di.setValue(19, vegan); //@attribute xBacon {FALSE,TRUE}
  di.setValue(20, 0); //@attribute xFennel {FALSE,TRUE}
  di.setValue(21, 1); //@attribute Dinner {0,1}
  di.setValue(22, 0); //@attribute xOrange {FALSE,TRUE}
  di.setValue(23, 0); //@attribute xMushrooms {FALSE,TRUE}
  di.setValue(24, "heyMando"); //@attribute Username {turbo,Potato,tomato,heyMando}
  di.setValue(25, vegan); //@attribute xChicken {FALSE,TRUE}
  di.setValue(26, 0); //@attribute xApple {FALSE,TRUE}
  di.setValue(27, 0); //@attribute xMayonnaise {FALSE,TRUE}
  di.setValue(28, 0); //@attribute xAlmonds {FALSE,TRUE}
  di.setValue(29, 1); //@attribute Set_Feeling {-2,0,1}
  di.setValue(30, 0); //@attribute xCoconut {FALSE,TRUE}
  di.setValue(31, 1); //@attribute Set_Activity {-2,-1,0,1}
  di.setValue(32, 0); //@attribute Lunch {0,1}
  di.setValue(33, vegan); //@attribute xTurkey {FALSE,TRUE}

  try { 
    int i = (int)j48.classifyInstance(di);
    r = di.classAttribute().value(i);
  }
  catch(Exception ex) {
    ex.printStackTrace();
  }
  return r;
}
String predict2() {
  String t = "Sorry, unable to predict";
  if (j48 == null) return t;

  // build a new instance with the given input
  Instance di = new DenseInstance(35);
  di.setDataset(data);

  for (int i=0; i< 35; i++) {
   // println(di.attribute(i));
  }

  //println(di.attribute(2));
  // the block of code below allows you to input data for prediction.
  // you need the whole thing.
  // (x,y) --> Change the values of y why to obtain different prediction.
  di.setValue(0, 2); //fit_goal
  di.setValue(1, vegan); //xEgg
  di.setValue(2, 0); //xOnion
  di.setValue(3, 0); //@attribute xGarlic {TRUE,FALSE}
  di.setValue(4, 2); //@attribute Food_Preference {-2,-1,0,1,2}
  di.setValue(5, 1); //@attribute xbutter {FALSE,TRUE}
  di.setValue(6, mealReasonSelect); //@attribute Meal_Reason {'High Protein','High Carb','High Fat','High Fibre'}
  di.setValue(7, 0); //@attribute Energy_Feeling {-2,-1,0,1,2}
  di.setValue(8, mealTypeSelect); //@attribute Meal_Heavy/Light {'Light and Not Filling','Just Right for Me','Heavy and Filling'}
  di.setValue(9, 0); //@attribute 'xOlive Oil' {TRUE,FALSE}
  di.setValue(10, "Hard to Make"); //@attribute Meal_Difficulty {'Easy to Make','Very easy to Make','Hard to Make'}
  di.setValue(11, 1); //@attribute xSugar {FALSE,TRUE}
  di.setValue(12, 1); //@attribute xFlour {FALSE,TRUE}
  di.setValue(13, 0); //@attribute xSalt {TRUE,FALSE}
  di.setValue(14, 1); //@attribute 'xVegetable Oil' {FALSE,TRUE}
  di.setValue(15, 0); //@attribute xRice {FALSE,TRUE}
  di.setValue(16, 0); //@attribute xCorn {FALSE,TRUE}
  di.setValue(17, vegan); //@attribute xBeef {FALSE,TRUE}
  di.setValue(18, 0); //@attribute xCheese {FALSE,TRUE}
  di.setValue(19, vegan); //@attribute xBacon {FALSE,TRUE}
  di.setValue(20, 0); //@attribute xFennel {FALSE,TRUE}
  di.setValue(21, 1); //@attribute Dinner {0,1}
  di.setValue(22, 0); //@attribute xOrange {FALSE,TRUE}
  di.setValue(23, 1); //@attribute xMushrooms {FALSE,TRUE}
  di.setValue(24, "heyMando"); //@attribute Username {turbo,Potato,tomato,heyMando}
  di.setValue(25, vegan); //@attribute xChicken {FALSE,TRUE}
  di.setValue(26, 0); //@attribute xApple {FALSE,TRUE}
  di.setValue(27, 0); //@attribute xMayonnaise {FALSE,TRUE}
  di.setValue(28, 0); //@attribute xAlmonds {FALSE,TRUE}
  di.setValue(29, 1); //@attribute Set_Feeling {-2,0,1}
  di.setValue(30, 0); //@attribute xCoconut {FALSE,TRUE}
  di.setValue(31, 1); //@attribute Set_Activity {-2,-1,0,1}
  di.setValue(32, 0); //@attribute Lunch {0,1}
  di.setValue(33, vegan); //@attribute xTurkey {FALSE,TRUE}
  
  try { 
    int i = (int)j48.classifyInstance(di);
    t = di.classAttribute().value(i);
  }
  catch(Exception ex) {
    ex.printStackTrace();
  }
  return t;
}




void draw() {
  // calculateMaxCal();
  worldTime = 7;
  correctedWorldTime = worldTime;
  if (worldTime < 6) {
    correctedWorldTime = 0;
  }
  if (worldTime > 21) {
    correctedWorldTime = 24;
  }
  scaledWorldTime = (correctedWorldTime*1.6);
  mappedWorldTime = map(scaledWorldTime, 0, 38.4, 0, 24);
  //println(worldTime + " " + correctedWorldTime+" " + scaledWorldTime+" " +mappedWorldTime);
  Eaten = 0;                                       //insert function for cal eaten here
  Burned = 0;                                      //insert function for cal burned here
  //insert function for max cal, carbs, protein and fat here
  currentCarbs = mappedWorldTime*(maxCarbs/24);
  ;                              //insert function for current carbs here
  //currentProtein = 0;                            //insert function for current protein here
  //currentFat = 0;                                //insert function for current Fat here
  //calMaxresult
  if (gender == 1) {
    //calMaxResult = calculateMaxCal();            //test values
    maxCal = 2100.0;
  } else if (gender == 2) {
    calMaxResult = 1800.0;
    maxCal = calMaxResult;
  } else if (gender == 3) {
    calMaxResult = 1900.0;
    maxCal = calMaxResult;
  } else {
    maxCal = 2000;
  }

  if (calMaxResult != null) {
    maxCal = calMaxResult;
  }

  progressCal = currentCal / maxCal;
  progressCarbs = currentCarbs / maxCarbs;
  progressProtein = currentProtein / maxProtein;
  progressFat = currentFat / maxFat;

  progressArcDegrees = map(progressCal, 0, 1, 0, 180);
  progressArcRadians = radians(progressArcDegrees);

  progressCarbsBar = map(progressCarbs, 0, 1, 0, 80);
  progressProteinBar = map(progressProtein, 0, 1, 0, 80);
  progressFatBar = map(progressFat, 0, 1, 0, 80);

  

  imageRecipe1 = int(predict1());
  imageRecipe2 = int(predict2());
  imageRecipe3 = int(predict3);

  titleRecipe1 = imageRecipe1;
  titleRecipe2 = imageRecipe2;
  titleRecipe3 = imageRecipe3;



  //println(currentCal + " " + maxCal+ " " + progressCal);
  background(213, 239, 197);
  fill(54, 60, 50);
  if (state == 0) {
    titleFont = createFont("Bodoni MT Black", 65);
    textFont(titleFont);
    fill(0);
    text("Hello!", 145, 150);
    textFont = createFont("Corbel Light", 30);
    textFont(textFont);
    fill(54, 60, 50);
    text("Do you already have a username?", 45, 300);
  } else if (state == 1) {
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
  } else if (state == 2) {
    titleFont = createFont("Bodoni MT Black", 65);
    textFont(titleFont);
    fill(0);
    text("What food do", CENTER+10, 150);
    text("you like?", CENTER+80, 250);
  } else if (state == 3) {
    titleFont = createFont("Bodoni MT Black", 65);
    textFont(titleFont);
    fill(0);
    text("What is", CENTER+100, 150);
    text("your goal?", CENTER+70, 250);
  } else if (state == 4) {
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
  } else if (state == 5) {
    titleFont = createFont("Bodoni MT Black", 65);
    textFont(titleFont);
    fill(0);
    text("Overview", CENTER+90, 150);
    subTitleFont = createFont("Bodoni MT Black", 35);
    textFont(subTitleFont);
    text("Choose your meal!", CENTER+70, 480);
    textFont = createFont("Corbel Light", 25);
    textFont(textFont);
    //fill(54, 60, 50);
    fill(0);
    text("Eaten", CENTER + 50, 320);
    text("Kcal", CENTER + 210, 320);
    text("Burned", CENTER + 340, 320);

    text("Carbs", CENTER + 50, 380);
    text("Protein", CENTER + 200, 380);
    text("Fat", CENTER + 360, 380);
    strokeWeight(2);
    stroke(0, 127);
    //line(45, 332, 420, 332);
    mainNumber = createFont("Corbel Bold", 25);
    textFont(mainNumber);
    text(Eaten, CENTER + 70, 280);
    if (currentCal >1000) {
      text(currentCal + "/" + maxCal, CENTER+160, 280);
    } else {
      text(currentCal + "/" + maxCal, CENTER+162, 280);
    }
    text(Burned, CENTER + 365, 280);
    noFill();
    strokeWeight(5);
    stroke(153, 153, 153, 80);

    strokeCap(SQUARE);
    arc(CENTER+230, 260, 130, 130, PI, 2*PI);
    strokeWeight(15);
    line(45, 395, 125, 395);
    line(200, 395, 280, 395);
    line(345, 395, 425, 395);
    strokeWeight(5);
    stroke(0);
    arc(CENTER+230, 260, 130, 130, PI, PI + progressArcRadians);

    strokeWeight(15);
    stroke(164, 65, 65);
    line(45, 395, 45+progressCarbsBar, 395);
    line(200, 395, 200+progressProteinBar, 395);
    line(345, 395, 345+progressFatBar, 395);
    //println(progressCarbsBar);
  } else if (state == 6) {
    subTitleFont = createFont("Bodoni MT Black", 18);
    textFont(subTitleFont);
    noFill();
    stroke(0);
    strokeWeight(1);
    rect(120, 120, 220, 200);
    rect(120, 370, 220, 200);
    rect(120, 620, 220, 200);
    image(recipe_img[imageRecipe1], 120, 120, 220, 200);
    image(recipe_img[imageRecipe2], 120, 370, 220, 200);
    image(recipe_img[imageRecipe3], 120, 620, 220, 200);

    stringTitleRecipe1 =  recipe_table.getString(titleRecipe1-1, "Recipe_Name [string]");
    stringTitleRecipe2 =  recipe_table.getString(titleRecipe2-1, "Recipe_Name [string]");
    stringTitleRecipe3 =  recipe_table.getString(titleRecipe3-1, "Recipe_Name [string]");

    text(stringTitleRecipe1, 120, 110);
    text(stringTitleRecipe2, 120, 360);
    text(stringTitleRecipe3, 120, 610);
  } else if (state == 7) {
    if (mealHighlight == 1) {
      image(recipe_img[imageRecipe1], 0, 0, width, height/3);
      stringTitleRecipeHighlight = recipe_table.getString(titleRecipe1-1, "Recipe_Name [string]");
    }
    if (mealHighlight == 2) {
      image(recipe_img[imageRecipe2], 0, 0, width, height/3);
      stringTitleRecipeHighlight = recipe_table.getString(titleRecipe2-1, "Recipe_Name [string]");
    }
    if (mealHighlight == 3) {
      image(recipe_img[imageRecipe3], 0, 0, width, height/3);
      stringTitleRecipeHighlight = recipe_table.getString(titleRecipe3-1, "Recipe_Name [string]");
    }
    subTitleFont = createFont("Bodoni MT Black", 18);
    textFont(subTitleFont);
    text(stringTitleRecipeHighlight, 20, 350);
    mainNumber = createFont("Corbel Bold", 25);
    textFont(mainNumber);
    //text("Kcal: " + addedCal, 20, 450);
    //text("Carbs: " + addedCarbs, 20, 490);
    //text("Fat: " + addedFat, 20, 530);
    //text("Protein: " + addedProtein, 20, 580);

    totalCurrentCarbs = currentCarbs+addedCarbs;
    totalCurrentFat = currentFat+addedFat;
    totalCurrentProtein = currentProtein+addedProtein;

    text("Carbs", 30, 550);
    text("Fat", 180, 550);
    text("Protein", 330, 550);
    text(nf(totalCurrentCarbs, 0, 1)+ " / " + maxCarbs, 20, 600);
    text(nf(totalCurrentFat, 0, 1)+ " / " + maxFat, 170, 600);
    text(nf(totalCurrentProtein, 0, 1)+ " / " + maxProtein, 320, 600);
  }


  // Check every 5 seconds
  if (millis() > 5000 && frameCount % 600 == 0) {
    //fetchData();
  }
}
/*
float calculateMaxCal() {
 user_age = float(cp5.get(Textfield.class, "age").getText());
 user_height = float(cp5.get(Textfield.class, "user_height").getText());
 user_weight = float(cp5.get(Textfield.class, "user_weight").getText());
 //int user_activity = int(cp5.get(Slider.class, "set_activity_slider").getValue());        test
 int user_activity = 0;
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
 */
void controlEvent(ControlEvent theEvent) {
  if (theEvent.isController()) {
    print("control event from : "+theEvent.getController().getName());
    println(", value : "+theEvent.getController().getValue());
    if (theEvent.getController().getName()=="male") {
      gender = 1;
    } else if (theEvent.getController().getName()=="female") {
      gender = 2;
    } else  if (theEvent.getController().getName()=="non-binary") {
      gender = 3;
    }
    if (theEvent.getController().getName()=="Light Meal") {
      mealType = 1;
    } else if (theEvent.getController().getName()=="Medium Meal") {
      mealType = 2;
    } else  if (theEvent.getController().getName()=="Heavy Meal") {
      mealType = 3;
    }

    if (theEvent.getController().getName()=="Eat1") {
      recipeDataSend = 1;
    } else if (theEvent.getController().getName()=="Eat2") {
      recipeDataSend = 2;
    } else if (theEvent.getController().getName()=="Eat3") {
      recipeDataSend = 3;
    }

    if (theEvent.getController().getName()=="Skip1") {
      skipDataSend = 1;
    } else if (theEvent.getController().getName()=="Skip2") {
      skipDataSend = 2;
    } else if (theEvent.getController().getName()=="Skip3") {
      skipDataSend = 3;
    } else {
      skipDataSend = 0;
    }
    if (theEvent.getController().getName()=="Dislike1") {
      dislikeDataSend = 1;
    } else if (theEvent.getController().getName()=="Dislike2") {
      dislikeDataSend = 2;
    } else if (theEvent.getController().getName()=="Dislike3") {
      dislikeDataSend = 3;
    } else {
      dislikeDataSend = 0;
    }


    if (theEvent.getController().getName()=="no") {
      state = 1;
      bYes.hide();
      bNo.hide();
      setup();
    } else if (theEvent.getController().getName()=="yes") {
      usernameTextfield.show();
      bSubmit.show();
    }
    if (theEvent.getController().getName()=="submit") {
      state = 4;
      bYes.hide();
      bNo.hide();
      usernameExisting.hide();
      bSubmit.hide();
      setup();
    }
    if (theEvent.getController().getName()=="next") {
      state = 2;
      usernameTextfield.hide();
      ageTextfield.hide();
      weightTextfield.hide();
      heightTextfield.hide();
      //genderTextfield.hide();
      bGenderMale.hide();
      bGenderFemale.hide();
      bGenderNonBinary.hide();
      bIn.hide();
      bCm.hide();
      bKg.hide();
      bLb.hide();
      bNext.hide();
      //calMaxResult = calculateMaxCal();
      setup();
    }
    if (theEvent.getController().getName()=="vegan") {
      state = 3;
      vegan = 1;
      bVegan.hide();
      bVegetarian.hide();
      bNonVegetarian.hide();
      setup();
    } else if (theEvent.getController().getName()=="vegetarian") {
      state = 3;
      vegan = 1;
      bVegan.hide();
      bVegetarian.hide();
      bNonVegetarian.hide();
      setup();
    } else if (theEvent.getController().getName()=="non-vegetarian") {
      state = 3;
      vegan = 0;
      bVegan.hide();
      bVegetarian.hide();
      bNonVegetarian.hide();
      setup();
    }
    if (theEvent.getController().getName()=="lose weight") {
      state = 4;
      bLoseWeight.hide();
      bGainWeight.hide();
      bMaintainWeight.hide();
      setup();
    } else if (theEvent.getController().getName()=="gain weight") {
      state = 4;
      bLoseWeight.hide();
      bGainWeight.hide();
      bMaintainWeight.hide();
      setup();
    } else if (theEvent.getController().getName()=="maintain weight") {
      state = 4;
      bLoseWeight.hide();
      bGainWeight.hide();
      bMaintainWeight.hide();
      setup();
    }
    if (theEvent.getController().getName()=="next page") {
      state = 5;
      bLowIntensity.hide();
      bMediumIntensity.hide();
      bHighIntensity.hide();
      durationTextfield.hide();
      bNextExercise.hide();
      setup();
    }
    if (theEvent.getController().getName()=="Light Meal") {
      state = 6;
      mealType = 1;
      bLightMeal.hide();
      bMediumMeal.hide();
      bHeavyMeal.hide();
      setup();
    }
    if (theEvent.getController().getName()=="Medium Meal") {
      state = 6;
      mealType = 2;
      bLightMeal.hide();
      bMediumMeal.hide();
      bHeavyMeal.hide();
      setup();
    }
    if (theEvent.getController().getName()=="Heavy Meal") {
      state = 6;
      mealType = 3;
      bLightMeal.hide();
      bMediumMeal.hide();
      bHeavyMeal.hide();
      setup();
    }

    if (theEvent.getController().getName()=="Recipe1") {
      state = 7;
      addedCal = recipe_table.getFloat(imageRecipe1-1, "Kcal [int]");
      addedCarbs = recipe_table.getFloat(imageRecipe1-1, "Carbohydrates [int]");
      addedProtein = recipe_table.getFloat(imageRecipe1-1, "Proteins in g [int]");
      addedFat = recipe_table.getFloat(imageRecipe1-1, "Fat in g [int]");
      println(addedCal+" "+addedCarbs+" "+addedProtein+" "+addedFat);
      mealHighlight = 1;
      bEat1.hide();
      bDislike1.hide();
      bSkip1.hide();
      bRecipe1.hide();
      bEat2.hide();
      bDislike2.hide();
      bSkip2.hide();
      bRecipe2.hide();
      bEat3.hide();
      bDislike3.hide();
      bSkip3.hide();
      bRecipe3.hide();
      setup();
    }
    if (theEvent.getController().getName()=="Recipe2") {
      state = 7;
      addedCal = recipe_table.getFloat(imageRecipe2-1, "Kcal [int]");
      addedCarbs = recipe_table.getFloat(imageRecipe2-1, "Carbohydrates [int]");
      addedProtein = recipe_table.getFloat(imageRecipe2-1, "Proteins in g [int]");
      addedFat = recipe_table.getFloat(imageRecipe2-1, "Fat in g [int]");
      println(addedCal+" "+addedCarbs+" "+addedProtein+" "+addedFat);
      mealHighlight = 2;
      bEat1.hide();
      bDislike1.hide();
      bSkip1.hide();
      bRecipe1.hide();
      bEat2.hide();
      bDislike2.hide();
      bSkip2.hide();
      bRecipe2.hide();
      bEat3.hide();
      bDislike3.hide();
      bSkip3.hide();
      bRecipe3.hide();
      setup();
    }
    if (theEvent.getController().getName()=="Recipe3") {
      state = 7;
      addedCal = recipe_table.getFloat(imageRecipe3-1, "Kcal [int]");
      addedCarbs = recipe_table.getFloat(imageRecipe3-1, "Carbohydrates [int]");
      addedProtein = recipe_table.getFloat(imageRecipe3-1, "Proteins in g [int]");
      addedFat = recipe_table.getFloat(imageRecipe3-1, "Fat in g [int]");
      println(addedCal+" "+addedCarbs+" "+addedProtein+" "+addedFat);
      mealHighlight = 3;
      bEat1.hide();
      bDislike1.hide();
      bSkip1.hide();
      bRecipe1.hide();
      bEat2.hide();
      bDislike2.hide();
      bSkip2.hide();
      bRecipe2.hide();
      bEat3.hide();
      bDislike3.hide();
      bSkip3.hide();
      bRecipe3.hide();
      setup();
    }
    if (theEvent.getController().getName()=="BackHighlight") {
      state = 6;
      bBackHighlight.hide();
      bEatHightlight.hide();
      bSkipHightlight.hide();
      bDislikeHightlight.hide();
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
  /* if (mealReasonNum == 1) {
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
   */
  // Add data, then send off the log
  /*
  iotDS.data("Time", 0000).data("meal", count_done).data("Username", userName).data("Age", ageSend).data("Gender", gender).data("Food_Preference", foodPref).data("Target_Cal", targetCal)
   .data("Set_Goal", setGoal).data("Set_Feeling", setFeeling).data("Set_Activity", setActivity).data("Fit_Goal", fitGoal).data("Energy_Feeling", energyFeeling)
   .data("xOlive Oil", ingredientsToSend[count_done][1]).data("xFlour", ingredientsToSend[count_done][2]).data("xbutter", ingredientsToSend[count_done][3]).data("xChicken", ingredientsToSend[count_done][4]).data("xSugar", ingredientsToSend[count_done][5])
   .data("xSalt", ingredientsToSend[count_done][6]).data("xEgg", ingredientsToSend[count_done][7]).data("xRice", ingredientsToSend[count_done][8]).data("xVegetable Oil", ingredientsToSend[count_done][9]).data("xPork", ingredientsToSend[count_done][10])
   .data("xBeef", ingredientsToSend[count_done][12]).data("xCheese", ingredientsToSend[count_done][12]).data("xGarlic", ingredientsToSend[count_done][13]).data("xOrange", ingredientsToSend[count_done][14]).data("xTurkey", ingredientsToSend[count_done][15])
   .data("xOnion", ingredientsToSend[count_done][16]).data("xCorn", ingredientsToSend[count_done][17]).data("xWhole Milk", ingredientsToSend[count_done][18]).data("xMayonnaise", ingredientsToSend[count_done][19]).data("xChiles", ingredientsToSend[count_done][20])
   .data("xAlmonds", ingredientsToSend[count_done][21]).data("xBacon", ingredientsToSend[count_done][22]).data("xMushrooms", ingredientsToSend[count_done][23]).data("xCoconut", ingredientsToSend[count_done][24]).data("xBeets", ingredientsToSend[count_done][25])
   .data("xStrawberries", ingredientsToSend[count_done][26]).data("xFennel", ingredientsToSend[count_done][27]).data("xLamb", ingredientsToSend[count_done][28]).data("xApple", ingredientsToSend[count_done][29]).data("xShrimp", ingredientsToSend[count_done][30])
   .data("User_Height", user_height).data("User_Weight", user_weight).data("Meal_Reason", mealReason).data("Meal_Heavy/Light", mealHeavyLight).data("Meal_Difficulty", mealDifficulty).data("Breakfast", breakfast).data("Lunch", lunch).data("Dinner", dinner)
   .log();*/

  iotDS.data("Time", 0000).data("chosen_recipe", recipeDataSend).data("skipped_recipe", skipDataSend).data("disliked_recipe", recipeDataSend).log();
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

void loadData(String filepath) {
  try { 
    weka.core.converters.ConverterUtils.DataSource source 
      = new weka.core.converters.ConverterUtils.DataSource(filepath);
    data = source.getDataSet();
    // setting class attribute if the data format does not provide this information
    // For example, the XRFF format saves the class attribute information as well
    if (data.classIndex() == -1)
      data.setClassIndex(data.numAttributes() - 1);
  }
  catch(Exception ex) {
    ex.printStackTrace();
  }
}

void loadModel(String filepath) {
  try {
    j48 = (weka.classifiers.trees.J48) SerializationHelper.read(filepath);
    println("J48 loaded");
    println(j48.toString());
  }
  catch(Exception ex) {
    ex.printStackTrace();
  }
}
