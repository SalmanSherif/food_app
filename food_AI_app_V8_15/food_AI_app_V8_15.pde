// Import libraries
import java.util.Map;
import controlP5.*;
import nl.tue.id.datafoundry.*;
import weka.classifiers.Classifier;
import weka.classifiers.bayes.NaiveBayes;
import weka.classifiers.meta.AdaBoostM1;
import weka.classifiers.meta.Bagging;
import weka.classifiers.meta.Stacking;
import weka.classifiers.meta.Vote;
import weka.classifiers.trees.DecisionStump;
import weka.classifiers.trees.J48;
import weka.classifiers.trees.RandomForest;
import weka.classifiers.trees.RandomTree;
import weka.core.Instances;
import java.io.*;
import java.util.*;

// Initialize WEKA classifier
weka.classifiers.trees.J48 j48 = null;
weka.classifiers.meta.AdaBoostM1 boostedJ48 = null;   //---NEW-------------------------------
Instances data = null;

// Settings for DataFoundry library
String host = "data.id.tue.nl";
String iot_api_token = "9QuRXGYI3Z8mQE7oHAiwmm2gjDc6Aj1EG+uRZ4M1JRIzhdJVljnc54QGFfwsFyPl";
String entity_api_token = "K42jfbGeoMWVFBptrK12Ic9Bo+vzCpo6ONpHHE61GsMAdHg2R6z6gu4nA2suTuM8";
long iot_id = 908; //change to user inputs8
long entity_id = 847;

// DataFoundry connection
DataFoundry df = new DataFoundry(host);

// Access to two datasets: iotDS and entityDS
DFDataset iotDS = df.dataset(iot_id, iot_api_token);
DFDataset entityDS = df.dataset(entity_id, entity_api_token);

// Initialize ControlP5
ControlP5 cp5;
PFont titleFont;
PFont textFont;
PFont subTitleFont;
PFont mainNumber;
PFont subNumber;
PImage background, backbutton, backbutton_2, logout_button;
Button bSubmitFinal, back1, back2, back3, back4, back5, back6, back7, bLogOut0, bLogOut1, bLogOut2, bLogOut3, bYes, bNo, bSubmit, bVegan, bVegetarian, bNonVegetarian, bNext1, bNext2, bLoseWeight, bMaintainWeight, bGainWeight, bNext1Exercise, bInActive, bSlightlyActive, bAveragelyActive, bVeryActive, bExtremelyActive, bLightMeal, bMediumMeal, bHeavyMeal, bEatHightlight, bEat1, bEat2, bEat3, bDislikeHightlight, bDislike1, bDislike2, bDislike3, bSkipHightlight, bSkip1, bSkip2, bSkip3, bBackHighlight, bRecipe1, bRecipe2, bRecipe3 ;
Textfield durationTextfield, usernameExisting, usernameTextfield, ageTextfield, heightTextfield, weightTextfield, genderTextfield;
Slider recommandationSlider, fitGoalSlider, weight_slider;
DropdownList gender_list;

// Load in table
Table recipe_table;

// General variables
String uname = "d9980f7cb03f346d4";
int state=0;
long startTime, lastClickTime;
int count_done = 1;
int startUp = 0;
float worldTime;
float correctedWorldTime;
float scaledWorldTime;
float mappedWorldTime;

// Recipe variables
PImage recipe_img[];
int numberRecipes;
String recipeName;
String url;
String row;
String imageUrl;
String ingredients_list;
boolean [][] ingredientsToSend;
int mealType;
int fitGoal;

// User variables
String user_name;
int gender = 0;
int vegan = 0;
float currentCal = 1400;
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
float recommendedCalory = 2000;

// Dashboard variables
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
float addedCal;
float addedCarbs;
float addedProtein;
float addedFat;
float totalCurrentCarbs;
float totalCurrentFat;
float totalCurrentProtein;
float totalCurrentCal;

// Recommendation variables
int imageRecipe1=1;
int imageRecipe2=1;
int imageRecipe3=1;
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
int skipData;
int dislikeData;
int predictLoop = 0;
int recommandationLike;
int confirmedMeal;
int skipHighlight = 0;
int dislikeHighlight = 0;

void setup() {
  // Set interaction start time
  loadData(dataPath("reduced_06.arff"));
  loadBoostedModel(dataPath("boosted_j48.model"));

  // Set display size
  size(480, 900);
  background(0);
  frameRate(20);
  noStroke();

  // Set background depending on state
  if (state < 5) {
    background = loadImage("background.jpg");
  } else if (state == 5) {
    background = loadImage("background_3.jpg");
  } else if (state == 7) {
    background = loadImage("background_4.jpg");
  } else if (state == 6 || state == 8) {
    background = loadImage("background_5.jpg");
  } else {
    background = loadImage("background_2.jpg");
  }

  // Load button images
  backbutton = loadImage("back_button.JPG");
  logout_button = loadImage("logout_button.jpg");

  // Initialize CP5 functionality
  cp5 = new ControlP5(this);
  PFont p = createFont("Verdana", 11); 
  ControlFont font = new ControlFont(p);
  cp5.setFont(font);

  // On start-up, load table
  if (startUp == 0) {
    loadTable(false); // Set true when testing;
    predict3 = int(random(1, 20));
    startUp = startUp + 1;
  }

  // Load interactive elements based on state
  if (state == 0) {
    // Sign-in screen
    textFont = createFont("Corbel Light", 35);
    bYes = cp5.addButton("yes").setPosition(30, 330).setSize(200, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bNo = cp5.addButton("no").setPosition(250, 330).setSize(200, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    usernameExisting = cp5.addTextfield("username").setVisible(false).setColorCaptionLabel(color(255, 255, 255)).setColorActive(color(54, 60, 50)).setPosition(30, 410).setSize(419, 50).setFont(textFont).setFocus(true).setColorBackground(color(213, 239, 197)).setColor(color(54, 60, 50)).setColorCursor(color(54, 60, 50)).setColorForeground(color(54, 60, 50));
    bSubmit = cp5.addButton("sign in").setVisible(false).setPosition(30, 490).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
  } else if (state == 1) {
    // Profile set-up: user information screen
    textFont = createFont("Corbel Light", 35);
    back1 = cp5.addButton("back1").setImage(backbutton).setPosition(25, 50).setSize(50, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    usernameTextfield = cp5.addTextfield("username").setColorCaptionLabel(color(255, 255, 255)).setColorActive(color(54, 60, 50)).setPosition(250, 270).setSize(125, 50).setFont(textFont).setFocus(true).setColorBackground(color(213, 239, 197)).setColor(color(54, 60, 50)).setColorCursor(color(54, 60, 50)).setColorForeground(color(255, 255, 255));
    ageTextfield = cp5.addTextfield("age").setColorCaptionLabel(color(255, 255, 255)).setColorActive(color(54, 60, 50)).setPosition(250, 370).setSize(125, 50).setFont(textFont).setFocus(true).setColorBackground(color(213, 239, 197)).setColor(color(54, 60, 50)).setColorCursor(color(54, 60, 50)).setColorForeground(color(255, 255, 255));
    heightTextfield = cp5.addTextfield("height").setColorCaptionLabel(color(255, 255, 255)).setColorActive(color(54, 60, 50)).setPosition(250, 470).setSize(125, 50).setFont(textFont).setFocus(true).setColorBackground(color(213, 239, 197)).setColor(color(54, 60, 50)).setColorCursor(color(54, 60, 50)).setColorForeground(color(255, 255, 255));
    weightTextfield = cp5.addTextfield("weight").setColorCaptionLabel(color(255, 255, 255)).setColorActive(color(54, 60, 50)).setPosition(250, 570).setSize(125, 50).setFont(textFont).setFocus(true).setColorBackground(color(213, 239, 197)).setColor(color(54, 60, 50)).setColorCursor(color(54, 60, 50)).setColorForeground(color(255, 255, 255));
    textFont = createFont("Corbel Light", 20);
    bNext1 = cp5.addButton("next").setPosition(175, 775).setSize(125, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(54, 60, 50));
    gender_list = cp5.addDropdownList("gender").setPosition(250, 670).setFont(textFont).setSize(125, 200).setBackgroundColor(color(190)).setBarHeight(50).setItemHeight(50).setValue(1).close().setColorLabel(color(54, 60, 50)).setColorValue(color(54, 60, 50)).addItem("Female", 1).addItem("Male", 2).addItem("Non-Binary", 3).setColorBackground(color(213, 239, 197)).setColorActive(color(167, 188, 154)).setColorForeground(color(167, 188, 154));
  } else if (state == 2) {
    // Profile set-up: diet restrictions screen
    back2 = cp5.addButton("back2").setImage(backbutton).setPosition(25, 50).setSize(50, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    textFont = createFont("Corbel Light", 35);
    bVegan = cp5.addButton("vegan").setPosition(30, 320).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bVegetarian = cp5.addButton("vegetarian").setPosition(30, 420).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bNonVegetarian = cp5.addButton("non-vegetarian").setPosition(30, 520).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
  } else if (state == 3) {
    // Profile set-up: monthly weight-goal
    back3 = cp5.addButton("back3").setImage(backbutton).setPosition(25, 50).setSize(50, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    textFont = createFont("Corbel Light", 35);
    weight_slider = cp5.addSlider("weight_goal").setPosition(30, 320).setHeight(50).setWidth(420).setRange(-2.5, 2.5).setValue(0).setNumberOfTickMarks(51).setSliderMode(Slider.FLEXIBLE).setColorBackground(color(167, 188, 154)).setColorValue(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setColorCaptionLabel(color(0, 0, 0)).setColorForeground(color(54, 60, 50)).setLabelVisible(false);
    textFont = createFont("Corbel Light", 20);
    bNext2 = cp5.addButton("next ").setPosition(175, 775).setSize(125, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(54, 60, 50));
  } else if (state == 4) {
    // Weekly activity indication screen
    bYes.hide();
    bNo.hide();
    bSubmit.hide();
    textFont = createFont("Corbel Light", 35);
    bLogOut0 = cp5.addButton("logout0").setImage(logout_button).setPosition(400, 50).setSize(50, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bInActive = cp5.addButton("inactive").setPosition(30, 280).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bSlightlyActive = cp5.addButton("slightly active").setPosition(30, 350).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bAveragelyActive = cp5.addButton("averagely active").setPosition(30, 420).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bVeryActive = cp5.addButton("very active").setPosition(30, 490).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bExtremelyActive = cp5.addButton("extremely active").setPosition(30, 560).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    textFont = createFont("Corbel Light", 20);
    bNext1Exercise = cp5.addButton("recommend").setPosition(140, 775).setSize(200, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(54, 60, 50));
  } else if (state == 5) {
    // Main overview dashboard screen
    bYes.hide();
    bNo.hide();
    bSubmit.hide();
    textFont = createFont("Corbel Light", 35);
    back4 = cp5.addButton("back4").setImage(backbutton).setPosition(25, 50).setSize(50, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bLogOut1 = cp5.addButton("logout1").setImage(logout_button).setPosition(400, 50).setSize(50, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    textFont = createFont("Corbel Light", 35);
    bLightMeal = cp5.addButton("Light Meal").setPosition(30, 520).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bMediumMeal = cp5.addButton("Medium Meal").setPosition(30, 600).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    bHeavyMeal = cp5.addButton("Heavy Meal").setPosition(30, 680).setSize(419, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
  } else if (state == 6) {
    // Recipe recommendation screen
    textFont = createFont("Corbel Light", 35);
    bLogOut2 = cp5.addButton("logout2").setImage(logout_button).setPosition(400, 50).setSize(50, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    back5 = cp5.addButton("back5").setImage(backbutton).setPosition(25, 50).setSize(50, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    textFont = createFont("Corbel Light", 20);
    bEat1 = cp5.addButton("Eat1").setCaptionLabel("Eat!").setPosition(30, 160).setSize(80, 40).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(0, 255, 128)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(50, 205, 50));
    bDislike1 = cp5.addButton("Dislike1").setCaptionLabel("Dislike").setPosition(350, 160).setSize(100, 40).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(128, 0, 0)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(164, 65, 65));
    bSkip1 = cp5.addButton("Skip1").setCaptionLabel("Skip").setPosition(350, 210).setSize(100, 40).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(128, 128, 128)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(137, 123, 123));
    bRecipe1 = cp5.addButton("Recipe1").setPosition(120, 120).setSize(220, 240).setColorCaptionLabel(color(255, 255, 255, 1)).setColorForeground(color(128, 128, 128, 100)).setColorActive(color(54, 60, 50, 1)).setFont(textFont).setColorBackground(color(100, 0, 0, 1));
    bEat2 = cp5.addButton("Eat2").setCaptionLabel("Eat!").setPosition(30, 410).setSize(80, 40).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(0, 255, 128)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(50, 205, 50));
    bDislike2 = cp5.addButton("Dislike2").setCaptionLabel("Dislike").setPosition(350, 410).setSize(100, 40).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(128, 0, 0)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(164, 65, 65));
    bSkip2 = cp5.addButton("Skip2").setCaptionLabel("Skip").setPosition(350, 460).setSize(100, 40).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(128, 128, 128)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(137, 123, 123));
    bRecipe2 = cp5.addButton("Recipe2").setPosition(120, 370).setSize(220, 240).setColorCaptionLabel(color(255, 255, 255, 1)).setColorForeground(color(128, 128, 128, 100)).setColorActive(color(54, 60, 50, 1)).setFont(textFont).setColorBackground(color(100, 0, 0, 1));
    bEat3 = cp5.addButton("Eat3").setCaptionLabel("Eat!").setPosition(30, 660).setSize(80, 40).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(0, 255, 128)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(50, 205, 50));
    bDislike3 = cp5.addButton("Dislike3").setCaptionLabel("Dislike").setPosition(350, 660).setSize(100, 40).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(128, 0, 0)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(164, 65, 65));
    bSkip3 = cp5.addButton("Skip3").setCaptionLabel("Skip").setPosition(350, 710).setSize(100, 40).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(128, 128, 128)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(137, 123, 123));
    bRecipe3 = cp5.addButton("Recipe3").setPosition(120, 620).setSize(220, 240).setColorCaptionLabel(color(255, 255, 255, 1)).setColorForeground(color(128, 128, 128, 100)).setColorActive(color(54, 60, 50, 1)).setFont(textFont).setColorBackground(color(100, 0, 0, 1));
  } else if (state == 7) {
    // Recipe detail screen
    textFont = createFont("Corbel Light", 35);
    back6 = cp5.addButton("back6").setImage(backbutton).setPosition(25, 60).setSize(50, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    textFont = createFont("Corbel Light", 20);
    bEatHightlight =cp5.addButton("EatHighlight").setCaptionLabel("Eat!").setPosition(30, 800).setSize(80, 40).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(0, 255, 128)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(50, 205, 50));
    bSkipHightlight = cp5.addButton("SkipHighlight").setCaptionLabel("Skip").setPosition(180, 800).setSize(100, 40).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(128, 128, 128)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(137, 123, 123));
    bDislikeHightlight = cp5.addButton("DislikeHighlight").setCaptionLabel("Dislike").setPosition(350, 800).setSize(100, 40).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(128, 0, 0)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(164, 65, 65));
    textFont = createFont("Corbel Light", 25);
  } else if (state == 8) {
    // Recipe rating screen
    bLogOut3 = cp5.addButton("logout3").setImage(logout_button).setPosition(400, 50).setSize(50, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    textFont = createFont("Corbel Light", 35);
    back7 = cp5.addButton("back7").setImage(backbutton).setPosition(25, 50).setSize(50, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(167, 188, 154));
    textFont = createFont("Corbel Light", 20);
    recommandationSlider = cp5.addSlider("recommandationSlider").setPosition(30, 240).setHeight(50).setWidth(420).setRange(-2.5, 2.5).setValue(0).setNumberOfTickMarks(51).setSliderMode(Slider.FLEXIBLE).setColorBackground(color(167, 188, 154)).setColorValue(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setColorCaptionLabel(color(0, 0, 0)).setColorForeground(color(54, 60, 50)).setLabelVisible(false);
    fitGoalSlider = cp5.addSlider("fitGoalSlider").setPosition(30, 520).setHeight(50).setWidth(420).setRange(-2.5, 2.5).setValue(0).setNumberOfTickMarks(51).setSliderMode(Slider.FLEXIBLE).setColorBackground(color(167, 188, 154)).setColorValue(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setColorCaptionLabel(color(0, 0, 0)).setColorForeground(color(54, 60, 50)).setLabelVisible(false);
    bSubmitFinal = cp5.addButton("submitFinal").setCaptionLabel("submit").setPosition(140, 775).setSize(200, 50).setColorCaptionLabel(color(255, 255, 255)).setColorForeground(color(54, 60, 50)).setColorActive(color(54, 60, 50)).setFont(textFont).setColorBackground(color(54, 60, 50));
  }

  // Meal selection screen functionality
  diffCarbs = maxCarbs - currentCarbs;
  diffProtein = maxProtein - currentProtein;
  diffFat = maxFat - currentFat;
  diffCal = maxCal - currentCal;
  largestValue = max(diffCarbs, diffProtein, diffFat);
  if (mealType == 1) {
    mealTypeSelect = "Light and Not Filling";
  } else if (mealType == 2) {
    mealTypeSelect = "Just Right for Me";
  } else if (mealType == 3) {
    mealTypeSelect = "Heavy and Filling";
  }
  if (largestValue == diffCarbs) {
    mealReasonSelect = "High Carb";
  } else if (largestValue == diffProtein) {
    mealReasonSelect = "High Protein";
  } else if (largestValue == diffFat) {
    mealReasonSelect = "High Fat";
  }

  // Set interaction start time
  startTime = millis();
}

void draw() {
  // Draw background
  background(background);
  fill(54, 60, 50);

  // Main overview dashboard
  Eaten = 0;
  Burned = 0;
  currentCarbs = mappedWorldTime*(maxCarbs/24);
  maxCal = recommendedCalory;
  progressCal = currentCal / maxCal;
  progressCarbs = currentCarbs / maxCarbs;
  progressProtein = currentProtein / maxProtein;
  progressFat = currentFat / maxFat;
  progressArcDegrees = map(progressCal, 0, 1, 0, 180);
  progressArcRadians = radians(progressArcDegrees);
  progressCarbsBar = map(progressCarbs, 0, 1, 0, 80);
  progressProteinBar = map(progressProtein, 0, 1, 0, 80);
  progressFatBar = map(progressFat, 0, 1, 0, 80);

  if (state == 0) {
    // Sign-in screen
    titleFont = createFont("Corbel", 50);
    textFont(titleFont);
    fill(54, 60, 50);
    text("Hello!", 180, 150);
    textFont = createFont("Corbel Light", 30);
    textFont(textFont);
    fill(54, 60, 50);
    text("Do you already have a username?", 45, 300);
  } else if (state == 1) {
    // Profile set-up: user information screen
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
  } else if (state == 2) {
    // Profile set-up: diet restrictions screen
    titleFont = createFont("Corbel", 50);
    textFont(titleFont);
    fill(54, 60, 50);
    text("What food do", CENTER+95, 115);
    text("you like?", CENTER+155, 180);
  } else if (state == 3) {
    // Profile set-up: monthly weight goal screen
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
  } else if (state == 4) {
    // Weekly activity level screen
    bYes.hide();
    bNo.hide();
    bSubmit.hide();
    titleFont = createFont("Corbel", 50);
    textFont(titleFont);
    fill(54, 60, 50);
    text("How active were", CENTER+60, 115);
    text("you this week?", CENTER+85, 180);
    textFont = createFont("Corbel Light", 14);
    textFont(textFont);
    fill(54, 60, 50);
    text("* This information helps us change your diet based on  your activity level. \n    - Inactive is: excersizing 0 to 1 times a week   \n    - Averagely active is: excersizing 3 to 5 times a week \n    - Extremely active is: excersizing 7 times a week", 38, 650);
  } else if (state == 5) {
    // Main overview window screen
    bYes.hide();
    bNo.hide();
    bSubmit.hide();
    titleFont = createFont("Corbel", 50);
    textFont(titleFont);
    fill(0);
    text("Overview", CENTER+130, 120);
    titleFont = createFont("Corbel", 40);
    textFont(titleFont);
    text("Choose your meal!", CENTER+80, 480);
    textFont = createFont("Corbel Light", 25);
    textFont(textFont);
    fill(0);
    text("Eaten", CENTER + 50, 320);
    text("Kcal", CENTER + 210, 320);
    text("Burned", CENTER + 340, 320);
    text("Carbs", CENTER + 50, 380);
    text("Protein", CENTER + 200, 380);
    text("Fat", CENTER + 360, 380);
    strokeWeight(2);
    stroke(0, 127);
    mainNumber = createFont("Corbel Bold", 25);
    textFont(mainNumber);
    text(Eaten, CENTER + 70, 280);
    if (currentCal >1000) {
      text(currentCal + "/" + nf(maxCal, 0, 1), CENTER+160, 280);
    } else {
      text(currentCal + "/" + nf(maxCal, 0, 1), CENTER+162, 280);
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
    textFont = createFont("Corbel Light", 14);
    textFont(textFont);
    fill(54, 60, 50);
    text("- A light meal is a small quick meal \n- A medium meal is a regular sized portion for lunch or dinner \n- A heavy meal is very filling", 38, 770);
  } else if (state == 6) {
    // Recipe recommendation list screen
    titleFont = createFont("Corbel", 25);
    textFont(titleFont);
    text("Your recommended recipes:", 90, 73);
    subTitleFont = createFont("Corbel", 22);
    textFont(subTitleFont);
    noFill();
    stroke(0);
    strokeWeight(1);
    rect(120, 160, 220, 200);
    rect(120, 410, 220, 200);
    rect(120, 660, 220, 200);
    imageRecipe3 = int(predict3);
    titleRecipe1 = imageRecipe1;
    titleRecipe2 = imageRecipe2;
    titleRecipe3 = imageRecipe3;
    image(recipe_img[imageRecipe1], 120, 160, 220, 200);
    image(recipe_img[imageRecipe2], 120, 410, 220, 200);
    image(recipe_img[imageRecipe3], 120, 660, 220, 200);
    stringTitleRecipe1 =  recipe_table.getString(titleRecipe1-1, "Recipe_Name [string]");
    stringTitleRecipe2 =  recipe_table.getString(titleRecipe2-1, "Recipe_Name [string]");
    stringTitleRecipe3 =  recipe_table.getString(titleRecipe3-1, "Recipe_Name [string]");
    text(stringTitleRecipe1, 120, 150);
    text(stringTitleRecipe2, 120, 400);
    text(stringTitleRecipe3, 120, 650);
  } else if (state == 7) {
    // Recipe detail screen
    if (mealHighlight == 1) {
      image(recipe_img[imageRecipe1], 40, 150, 400, 270);
      stringTitleRecipeHighlight = recipe_table.getString(titleRecipe1-1, "Recipe_Name [string]");
    }
    if (mealHighlight == 2) {
      image(recipe_img[imageRecipe2], 40, 150, 400, 270);
      stringTitleRecipeHighlight = recipe_table.getString(titleRecipe2-1, "Recipe_Name [string]");
    }
    if (mealHighlight == 3) {
      image(recipe_img[imageRecipe3], 40, 150, 400, 270);
      stringTitleRecipeHighlight = recipe_table.getString(titleRecipe3-1, "Recipe_Name [string]");
    }
    titleRecipe1 = imageRecipe1;
    titleRecipe2 = imageRecipe2;
    titleRecipe3 = imageRecipe3;
    subTitleFont = createFont("Corbel", 25);
    textFont(subTitleFont);
    text(stringTitleRecipeHighlight, 90, 95);
    mainNumber = createFont("Corbel Bold", 25);
    textFont(mainNumber);
    text("Kcal: " + addedCal, 40, 470);
    text("Carbs: " + addedCarbs, 40, 510);
    text("Fat: " + addedFat, 300, 470);
    text("Protein: " + addedProtein, 300, 510);
    textFont = createFont("Corbel", 20);
    textFont(textFont);
    fill(54, 60, 50);
    text("* The recommended intakes for today are: \n Carbs: " + maxCarbs + " Fat: " + maxFat + " Protein: " + maxProtein, 38, 550);
    totalCurrentCarbs = currentCarbs+addedCarbs;
    totalCurrentFat = currentFat+addedFat;
    totalCurrentProtein = currentProtein+addedProtein;
  } else if (state == 8) {
    // Recipe rating screen
    titleFont = createFont("Corbel", 25);
    textFont(titleFont);
    text("Rate your recommendation:", 90, 83);
    titleFont = createFont("Corbel", 20);
    textFont(titleFont);
    text("How much do you like your recommendation?", 30, 200);
    text("How well does this fit your goal?", 30, 475);
    textFont = createFont("Corbel", 30);
    textFont(textFont);
    text("|", 37, 320);
    text("|", 137, 320);
    text("|", 237, 320);
    text("|", 337, 320);
    text("|", 437, 320);
    text("|", 37, 595);
    text("|", 137, 595);
    text("|", 237, 595);
    text("|", 337, 595);
    text("|", 437, 595);
    textFont = createFont("Corbel", 20);
    textFont(textFont);
    text("not so much", 30, 355);
    text("not so well", 30, 625);
    text("very much", 370, 355);
    text("very well", 380, 625);
    textFont = createFont("Corbel Light", 16);
    textFont(textFont);
    fill(54, 60, 50);
    text("This information is collected to improve your recommendations.", 38, 750);
  }

  // Check every 5 seconds
  if (millis() > 5000 && frameCount % 600 == 0) {
    //fetchData();
  }
}

// Button functionality
void controlEvent(ControlEvent theEvent) {
  if (theEvent.isController()) {
    print("control event from : "+theEvent.getController().getName());
    println(", value : "+theEvent.getController().getValue());

    // State 0
    // Sign-in screen button functionality
    if (theEvent.getController().getName()=="no") {
      // If no username is given (state 0)
      state = 1;
      bYes.hide();
      bNo.hide();
      bSubmit.hide();
      usernameExisting.hide();
      setup();
    } else if (theEvent.getController().getName()=="yes") {
      // If a username exists (state 0)
      usernameExisting.show();
      bSubmit.show();
    }
    // If existing username entered
    if (theEvent.getController().getName()=="sign in") {
      // Select item with id and token combination
      entityDS.id(uname).token(uname);
      // Check whether username exists
      Map<String, Object> result = entityDS.get();
      user_name = usernameExisting.getText();
      if (result.containsValue(user_name)) {
        // Display welcome message
        javax.swing.JOptionPane.showMessageDialog(null, "Welcome " + user_name + "!");
        // Save all user variables from database locally
        user_name = checkProfileItem(result.get("user_name"), "Null");
        user_age = checkProfileItem(result.get("user_age"), "Null");
        user_height = checkProfileItem(result.get("user_height"), "Null");
        user_weight = checkProfileItem(result.get("user_weight"), "Null");
        user_gender = parseFloat(checkProfileItem(result.get("user_gender"), "Null"));
        user_vegan = checkProfileItem(result.get("user_vegan"), "false");
        user_vegetarian = checkProfileItem(result.get("user_vegetarian"), "false");
        user_nonvegetarian = checkProfileItem(result.get("user_nonvegetarian"), "false");
        user_weightgoal = parseFloat(checkProfileItem(result.get("user_weightgoal"), "Null"));
        if (user_vegan == "true") {
          vegan = 1;
        } else if (user_vegetarian == "true") {
          vegan = 1;
        } else {
          vegan = 0;
        }
        state = 4;
        bYes.hide();
        bNo.hide();
        usernameExisting.hide();
        bSubmit.hide();
        setup();
      } else {
        // When username is given that does not exist in the database
        javax.swing.JOptionPane.showMessageDialog(null, "This username is not yet in the dataset. Please fill in the form to create a new profile.");
        state = 1;
        bYes.hide();
        bNo.hide();
        usernameExisting.hide();
        bSubmit.hide();
        setup();
      }
    }

    // State 1
    // Profile set-up screen button functionality
    if (theEvent.getController().getName()=="next") {
      // If introductory form filled in
      user_name = usernameTextfield.getText();
      user_age = ageTextfield.getText();
      user_height = heightTextfield.getText();
      user_weight = weightTextfield.getText();
      user_gender = gender_list.getValue();
      // Select item with id and token combination
      entityDS.id(uname).token(uname);
      // Check whether username exists
      Map<String, Object> result = entityDS.get();
      if (state == 1 && result.containsValue(user_name)==true) {
        // If username already exists
        javax.swing.JOptionPane.showMessageDialog(null, "An error has occured! The chosen username is already in the database or not all fields have been filled in...");
      } else if (state == 1 && (user_name == "" || user_age == "" || user_height == "" || user_weight == "")) {
        // If any of the fields are empty
        javax.swing.JOptionPane.showMessageDialog(null, "Please fill in all the fields.");
      } else {
        // Else, submit and hide elements
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

    // State 2
    // Diet restrictions selection screen button functionality
    if (theEvent.getController().getName()=="vegan") {
      state = 3;
      user_vegan = "true";
      vegan = 1;
      user_vegetarian = "false";
      user_nonvegetarian = "false";
      bVegan.hide();
      bVegetarian.hide();
      bNonVegetarian.hide();
      back2.hide();
      setup();
    } else if (theEvent.getController().getName()=="vegetarian") {
      user_vegan = "false";
      vegan = 1;
      user_vegetarian = "true";
      user_nonvegetarian = "false";
      state = 3;
      bVegan.hide();
      bVegetarian.hide();
      bNonVegetarian.hide();
      back2.hide();
      setup();
    } else if (theEvent.getController().getName()=="non-vegetarian") {
      user_vegan = "false";
      vegan = 0;
      user_vegetarian = "false";
      user_nonvegetarian = "true";
      state = 3;
      bVegan.hide();
      bVegetarian.hide();
      bNonVegetarian.hide();
      back2.hide();
      setup();
    }

    // State 3
    // Monthly weight goal screen button functionality
    if (theEvent.getController().getName()=="next ") {
      user_weightgoal = weight_slider.getValue();
      weight_slider.hide();
      state = 0;
      back3.hide();
      // Select item with id and token combination
      entityDS.id(uname).token(uname);
      // Check whether username exists
      Map<String, Object> result = entityDS.get();  
      if (result.containsValue(user_name)==false) {
        // Select item with id and token combination
        entityDS.id(uname).token(uname);
        // Add data to send (=update)
        entityDS.data("user_name", user_name).data("user_age", user_age).data("user_height", user_height).data("user_weight", user_weight)
          .data("user_gender", user_gender).data("user_vegan", user_vegan).data("user_vegetarian", user_vegetarian).data("user_nonvegetarian", user_nonvegetarian)
          .data("user_weightgoal", user_weightgoal).update();
        javax.swing.JOptionPane.showMessageDialog(null, "Welcome " + user_name + "! Your profile has successfully been generated in the database.");
        javax.swing.JOptionPane.showMessageDialog(null, "Please sign-in with your username: '" + user_name + "'.");
        state = 0;
      }
      setup();
    }

    // State 4
    // Weekly activity screen button functionality
    if (theEvent.getController().getName()=="inactive") {
      inActive = true;
      slightlyActive = false;
      averagelyActive = false;
      veryActive = false;
      extremelyActive = false;
      javax.swing.JOptionPane.showMessageDialog(null, "So you were inactive today, " + user_name + "? Press recommend to confirm.");
      println("inactive");
    } else if (theEvent.getController().getName()=="slightly active") {
      inActive = false;
      slightlyActive = true;
      averagelyActive = false;
      veryActive = false;
      extremelyActive = false;
      javax.swing.JOptionPane.showMessageDialog(null, "So you were slightly active today, " + user_name + "? Press recommend to confirm.");
      println("slightly active");
    } else if (theEvent.getController().getName()=="averagely active") {
      inActive = false;
      slightlyActive = false;
      averagelyActive = true;
      veryActive = false;
      extremelyActive = false;
      javax.swing.JOptionPane.showMessageDialog(null, "So you were averagely active today, " + user_name + "? Press recommend to confirm.");
      println("averagely active");
    } else if (theEvent.getController().getName()=="very active") {
      inActive = false;
      slightlyActive = false;
      averagelyActive = false;
      veryActive = true;
      extremelyActive = false;
      javax.swing.JOptionPane.showMessageDialog(null, "So you were very active today, " + user_name + "? Press recommend to confirm.");
      println("very active");
    } else if (theEvent.getController().getName()=="extremely active") {
      inActive = false;
      slightlyActive = false;
      averagelyActive = false;
      veryActive = false;
      extremelyActive = true;
      javax.swing.JOptionPane.showMessageDialog(null, "So you were extremely active today, " + user_name + "? Press recommend to confirm.");
      println("extremely active");
    }
    // Recommend recommendations after selecting activity level
    if (theEvent.getController().getName()=="recommend") {  
      state = 5;
      println("test");
      setup();
      calculateMaxCal();
      bLogOut0.hide();
      bInActive.hide();
      bSlightlyActive.hide();
      bAveragelyActive.hide();
      bExtremelyActive.hide();
      bVeryActive.hide();
      bNext1Exercise.hide();
      bNext2.hide();
      bYes.hide();
      bNo.hide();
      println("test");
    }

    // State 5
    // Main overview dashboard screen button functionality
    if (theEvent.getController().getName()=="Light Meal") {
      state = 6;
      imageRecipe1 = int(predict1());
      imageRecipe2 = int(predict2());
      mealType = 1;
      bLightMeal.hide();
      bMediumMeal.hide();
      bHeavyMeal.hide();
      back4.hide();
      bLogOut1.hide();
      setup();
    }
    if (theEvent.getController().getName()=="Medium Meal") {
      state = 6;
      imageRecipe1 = int(predict1());
      imageRecipe2 = int(predict2());
      mealType = 2;
      bLightMeal.hide();
      bMediumMeal.hide();
      bHeavyMeal.hide();
      back4.hide();
      bLogOut1.hide();
      setup();
    }
    if (theEvent.getController().getName()=="Heavy Meal") {
      state = 6;
      imageRecipe1 = int(predict1());
      imageRecipe2 = int(predict2());
      mealType = 3;
      bLightMeal.hide();
      bMediumMeal.hide();
      bHeavyMeal.hide();
      back4.hide();
      bLogOut1.hide();
      setup();
    }
    if (theEvent.getController().getName()=="EatHighlight") {
      state = 8;
      bEatHightlight.hide();
      bSkipHightlight.hide();
      bDislikeHightlight.hide();
      back6.hide();
      setup();
    }
    if (theEvent.getController().getName()=="Light Meal") {
      mealType = 1;
    } else if (theEvent.getController().getName()=="Medium Meal") {
      mealType = 2;
    } else  if (theEvent.getController().getName()=="Heavy Meal") {
      mealType = 3;
    }

    // State 6
    // Recipe recommendation list button functionality
    if ((theEvent.getController().getName()=="Recipe1")||(theEvent.getController().getName()=="Eat1")) {
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
      bLogOut2.hide();
      back5.hide();
      setup();
    }
    if (theEvent.getController().getName()=="Recipe2"||(theEvent.getController().getName()=="Eat2")) {
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
      bLogOut2.hide();
      back5.hide();
      setup();
    }
    if (theEvent.getController().getName()=="Recipe3"||(theEvent.getController().getName()=="Eat3")) {
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
      bLogOut2.hide();
      back5.hide();
      setup();
    }
    if (theEvent.getController().getName()=="Eat1") {
      recipeDataSend = 1;
    } else if (theEvent.getController().getName()=="Eat2") {
      recipeDataSend = 2;
    } else if (theEvent.getController().getName()=="Eat3") {
      recipeDataSend = 3;
    }
    if (theEvent.getController().getName()=="Skip1") {
      skipData = 1;
    } else if (theEvent.getController().getName()=="Skip2") {
      skipData = 2;
    } else if (theEvent.getController().getName()=="Skip3") {
      skipData = 3;
    }  
    if (theEvent.getController().getName()=="SkipHighlight") {
      skipHighlight = 1;
    } else {
      skipHighlight = 0;
    }
    if (theEvent.getController().getName()=="DislikeHighlight") {
      dislikeHighlight = 1;
    } else {
      dislikeHighlight = 0;
    }
    if (theEvent.getController().getName()=="Dislike1") {
      dislikeData = 1;
    } else if (theEvent.getController().getName()=="Dislike2") {
      dislikeData = 2;
    } else if (theEvent.getController().getName()=="Dislike3") {
      dislikeData= 3;
    }

    // State 7
    // Recipe rating screen button functionality
    if (theEvent.getController().getName()=="submitFinal") {
      recommandationLike = int(recommandationSlider.getValue());
      fitGoal = int(fitGoalSlider.getValue());
      logIoTDataV2();
      print("data_send");
      state = 5;
      bLogOut3.hide();
      back7.hide();
      recommandationSlider.hide();
      fitGoalSlider.hide();
      bSubmitFinal.hide();
      javax.swing.JOptionPane.showMessageDialog(null, "Thank you for your feedback, " + user_name + "!");
      setup();
    }

    // Global back-button functionality
    if (theEvent.getController().getName()=="back1") {
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
    if (theEvent.getController().getName()=="back2") {
      state = 1;
      bVegan.hide();
      bVegetarian.hide();
      bNonVegetarian.hide();
      back2.hide();
      setup();
    }
    if (theEvent.getController().getName()=="back3") {
      state = 2;
      weight_slider.hide();
      bNext2.hide();
      back3.hide();
      setup();
    }
    if (theEvent.getController().getName()=="back4") {
      state = 4;
      bLightMeal.hide();
      bMediumMeal.hide();
      bHeavyMeal.hide();
      back4.hide();
      setup();
    }
    if (theEvent.getController().getName()=="back5") {
      state = 5;
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
      bLogOut2.hide();
      back5.hide();
      setup();
    }
    if (theEvent.getController().getName()=="back6") {
      state = 6;
      bEatHightlight.hide();
      bSkipHightlight.hide();
      bDislikeHightlight.hide();
      back6.hide();
      bLogOut2.hide();
      setup();
    }
    if (theEvent.getController().getName()=="back7") {
      state = 7;
      bLogOut3.hide();
      back7.hide();
      recommandationSlider.hide();
      fitGoalSlider.hide();
      bSubmitFinal.hide();
      setup();
    }

    // Global log-out button functionality
    if (theEvent.getController().getName()=="logout0") {
      state = 0;
      bLogOut0.hide();
      bInActive.hide();
      bSlightlyActive.hide();
      bAveragelyActive.hide();
      bVeryActive.hide();
      bExtremelyActive.hide();
      bNext1Exercise.hide();
      bLogOut0.hide();
      setup();
    }
    if (theEvent.getController().getName()=="logout1") {
      state = 0;
      bHeavyMeal.hide();
      bLightMeal.hide();
      bMediumMeal.hide();
      bLogOut1.hide();
      back4.hide();
      bLogOut1.hide();
      setup();
    }
    if ( theEvent.getController().getName()=="logout2") {
      state = 0;
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
      bLogOut2.hide();
      back5.hide();
      setup();
    }
    if ( theEvent.getController().getName()=="logout3") {
      state = 0;
      bLogOut3.hide();
      back7.hide();
      recommandationSlider.hide();
      fitGoalSlider.hide();
      bSubmitFinal.hide();
      setup();
    }
  }
}

// To IoT dataset
void logIoTDataV2() {
  // Set resource id (refId of device in the project)
  if (mealHighlight == 1) {
    confirmedMeal = imageRecipe1;
    if (skipHighlight == 1) {
      skipDataSend = imageRecipe1;
    }
    if (dislikeHighlight == 1) {
      dislikeDataSend = imageRecipe1;
    }
  }
  if (mealHighlight == 2) {
    confirmedMeal = imageRecipe2;
    if (skipHighlight == 1) {
      skipDataSend = imageRecipe2;
    }
    if (dislikeHighlight == 1) {
      dislikeDataSend = imageRecipe2;
    }
  }
  if (mealHighlight == 3) {
    confirmedMeal = imageRecipe3;
    if (skipHighlight == 1) {
      skipDataSend = imageRecipe3;
    }
    if (dislikeHighlight == 1) {
      dislikeDataSend = imageRecipe3;
    }
  }
  if (skipData == 1) {
    skipDataSend = imageRecipe1;
  } else if (skipData == 2) {
    skipDataSend = imageRecipe2;
  } else if (skipData == 3) {
    skipDataSend = imageRecipe3;
  } else {
  }
  if (dislikeData == 1) {
    dislikeDataSend = imageRecipe1;
  } else if (dislikeData == 2) {
    dislikeDataSend = imageRecipe2;
  } else if (dislikeData == 3) {
    dislikeDataSend = imageRecipe3;
  } else {
  }
  iotDS.device(uname);
  String act = "other";
  // Set activity for the log
  if (act.equals("start") || act.equals("stop")) {
    iotDS.activity(act);
  } else {
    iotDS.activity("data_entry");
  }
  iotDS.data("Time", 0000).data("chosen_recipe", recipeDataSend).data("Vegan", vegan).data("Meal_Type", mealTypeSelect).data("Meal_Reason", mealReasonSelect).data("Predict1", imageRecipe1).data("Predict2", imageRecipe2).data("PredictRandom", imageRecipe3).data("skipped_recipe", skipDataSend).data("disliked_recipe", dislikeDataSend)
    .data("Recommandation_Like", recommandationLike).data("Fit_Goal", fitGoal).data("confirmend_meal", confirmedMeal).data("user_name", user_name).data("user_age", user_age).data("user_heigth", user_height).data("user_weight", user_age).data("user_weightgoal", user_weightgoal).data("user_gender", user_gender)
    .data("xOlive Oil", ingredientsToSend[count_done][1]).data("xFlour", ingredientsToSend[count_done][2]).data("xbutter", ingredientsToSend[count_done][3]).data("xChicken", ingredientsToSend[count_done][4]).data("xSugar", ingredientsToSend[count_done][5])
    .data("xSalt", ingredientsToSend[count_done][6]).data("xEgg", ingredientsToSend[count_done][7]).data("xRice", ingredientsToSend[count_done][8]).data("xVegetable Oil", ingredientsToSend[count_done][9]).data("xPork", ingredientsToSend[count_done][10])
    .data("xBeef", ingredientsToSend[count_done][12]).data("xCheese", ingredientsToSend[count_done][12]).data("xGarlic", ingredientsToSend[count_done][13]).data("xOrange", ingredientsToSend[count_done][14]).data("xTurkey", ingredientsToSend[count_done][15])
    .data("xOnion", ingredientsToSend[count_done][16]).data("xCorn", ingredientsToSend[count_done][17]).data("xWhole Milk", ingredientsToSend[count_done][18]).data("xMayonnaise", ingredientsToSend[count_done][19]).data("xChiles", ingredientsToSend[count_done][20])
    .data("xAlmonds", ingredientsToSend[count_done][21]).data("xBacon", ingredientsToSend[count_done][22]).data("xMushrooms", ingredientsToSend[count_done][23]).data("xCoconut", ingredientsToSend[count_done][24]).data("xBeets", ingredientsToSend[count_done][25])
    .data("xStrawberries", ingredientsToSend[count_done][26]).data("xFennel", ingredientsToSend[count_done][27]).data("xLamb", ingredientsToSend[count_done][28]).data("xApple", ingredientsToSend[count_done][29]).data("xShrimp", ingredientsToSend[count_done][30]).log();
}

// Function to a user's calculate recommended daily calory intake
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

// Load recipe database table function
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

// 1st recipe recommendation predict function
String predict1() {
  String r = "Sorry, unable to predict";
  if (boostedJ48 == null) return r;
  Instance di = new DenseInstance(33);
  di.setDataset(data);
  for (int i=0; i< 33; i++) {
    println(di.attribute(i));
  }
  // the block of code below allows you to input data for prediction.
  // you need the whole thing.
  // (x,y) --> Change the values of y why to obtain different prediction.
  di.setValue(0, random(0, 2)); //xEgg                                                                                   <----------------these values have the most impact.
  di.setValue(1, random(0, 2)); //xOnion                                                                                 <----------------these values have the most impact.
  di.setValue(2, random(0, 2)); //@attribute xGarlic {TRUE,FALSE}                                                        <----------------these values have the most impact.
  di.setValue(3, random(0, 2)); //@attribute xbutter {FALSE,TRUE}                                                        <----------------these values have the most impact.
  di.setValue(4, mealReasonSelect); //@attribute Meal_Reason {'High Protein','High Carb','High Fat','High Fibre'} <----------------these values have the most impact.
  di.setValue(5, mealTypeSelect); //Meal_Heavy/Light {'Light and Not Filling','Just Right for Me','Heavy and Filling'} <----------------these values have the most impact.
  di.setValue(6, random(0, 2)); //'xOlive Oil' {TRUE,FALSE}                                                                                <----------------these values have the most impact.
  di.setValue(7, "Easy to Make"); // Meal_Difficulty {'Easy to Make','Very easy to Make','Hard to Make'}                        <----------------these values have the most impact.
  di.setValue(8, random(0, 2)); //@attribute xSugar {FALSE,TRUE}                                                                           <----------------these values have the most impact.
  di.setValue(9, random(0, 2)); //@attribute xFlour {FALSE,TRUE}                                                                           <----------------these values have the most impact.
  di.setValue(10, random(0, 2)); //@attribute xSalt {TRUE,FALSE}
  di.setValue(11, random(0, 2)); //@attribute 'xVegetable Oil' {FALSE,TRUE}
  di.setValue(12, random(0, 2)); //@attribute xRice {FALSE,TRUE}
  di.setValue(13, random(0, 2)); //@attribute xCorn {FALSE,TRUE}
  di.setValue(14, random(0, 2)); //@attribute xCheese {FALSE,TRUE}
  di.setValue(15, vegan); //@attribute xBeef {FALSE,TRUE}
  di.setValue(16, vegan); //@attribute xBacon {FALSE,TRUE}
  di.setValue(17, random(0, 2)); //@attribute xFennel {FALSE,TRUE}
  di.setValue(18, random(0, 2)); //@attribute Dinner {0,1}
  di.setValue(19, random(0, 2)); //@attribute xOrange {FALSE,TRUE}
  di.setValue(20, random(0, 2)); //@attribute xMushrooms {FALSE,TRUE}
  di.setValue(21, "405"); //@attribute device id {FALSE,TRUE}
  di.setValue(22, "tomato"); //@attribute Username {turbo,Potato,tomato,heyMando}
  di.setValue(23, random(0, 2)); //@attribute xMayonnaise {FALSE,TRUE}
  di.setValue(24, random(0, 2)); //@attribute xApple {FALSE,TRUE}
  di.setValue(25, vegan); //@attribute xChicken {FALSE,TRUE}
  di.setValue(26, random(0, 2)); //@attribute xAlmonds {FALSE,TRUE}
  di.setValue(27, random(0, 2)); //@attribute xCoconut {FALSE,TRUE}
  di.setValue(28, vegan); //@attribute xTurkey {FALSE,TRUE}
  di.setValue(29, random(0, 2)); //@attribute breakfast {0,1}
  di.setValue(30, vegan); //@attribute pork {0,1}
  di.setValue(31, random(0, 2)); //@attribute whole milk {0,1}
  try { 
    int i = (int)boostedJ48.classifyInstance(di);
    r = di.classAttribute().value(i);
  }
  catch(Exception ex) {
    ex.printStackTrace();
  }
  return r;
}

// 2nd recipe recommendation predict function
String predict2() {
  String r = "Sorry, unable to predict";
  if (boostedJ48 == null) return r;
  Instance di = new DenseInstance(33);
  di.setDataset(data);
  for (int i=0; i< 33; i++) {
    println(di.attribute(i));
  }

  // the block of code below allows you to input data for prediction.
  // you need the whole thing.
  // (x,y) --> Change the values of y why to obtain different prediction.
  di.setValue(0, vegan); //xEgg                                                                                   <----------------these values have the most impact.
  di.setValue(1, random(0, 2)); //xOnion                                                                                 <----------------these values have the most impact.
  di.setValue(2, random(0, 2)); //@attribute xGarlic {TRUE,FALSE}                                                        <----------------these values have the most impact.
  di.setValue(3, random(0, 2)); //@attribute xbutter {FALSE,TRUE}                                                        <----------------these values have the most impact.
  di.setValue(4, mealReasonSelect); //@attribute Meal_Reason {'High Protein','High Carb','High Fat','High Fibre'} <----------------these values have the most impact.
  di.setValue(5, mealTypeSelect); //Meal_Heavy/Light {'Light and Not Filling','Just Right for Me','Heavy and Filling'} <----------------these values have the most impact.
  di.setValue(6, random(0, 2)); //'xOlive Oil' {TRUE,FALSE}                                                                                <----------------these values have the most impact.
  di.setValue(7, "Easy to Make"); // Meal_Difficulty {'Easy to Make','Very easy to Make','Hard to Make'}                        <----------------these values have the most impact.
  di.setValue(8, random(0, 2)); //@attribute xSugar {FALSE,TRUE}                                                                           <----------------these values have the most impact.
  di.setValue(9, random(0, 2)); //@attribute xFlour {FALSE,TRUE}                                                                           <----------------these values have the most impact.
  di.setValue(10, random(0, 2)); //@attribute xSalt {TRUE,FALSE}
  di.setValue(11, random(0, 2)); //@attribute 'xVegetable Oil' {FALSE,TRUE}
  di.setValue(12, random(0, 2)); //@attribute xRice {FALSE,TRUE}
  di.setValue(13, random(0, 2)); //@attribute xCorn {FALSE,TRUE}
  di.setValue(14, random(0, 2)); //@attribute xCheese {FALSE,TRUE}
  di.setValue(15, vegan); //@attribute xBeef {FALSE,TRUE}
  di.setValue(16, vegan); //@attribute xBacon {FALSE,TRUE}
  di.setValue(17, random(0, 2)); //@attribute xFennel {FALSE,TRUE}
  di.setValue(18, random(0, 2)); //@attribute Dinner {0,1}
  di.setValue(19, random(0, 2)); //@attribute xOrange {FALSE,TRUE}
  di.setValue(20, random(0, 2)); //@attribute xMushrooms {FALSE,TRUE}
  di.setValue(21, "405"); //@attribute device id {FALSE,TRUE}
  di.setValue(22, "tomato"); //@attribute Username {turbo,Potato,tomato,heyMando}
  di.setValue(23, random(0, 2)); //@attribute xMayonnaise {FALSE,TRUE}
  di.setValue(24, random(0, 2)); //@attribute xApple {FALSE,TRUE}
  di.setValue(25, vegan); //@attribute xChicken {FALSE,TRUE}
  di.setValue(26, random(0, 2)); //@attribute xAlmonds {FALSE,TRUE}
  di.setValue(27, random(0, 2)); //@attribute xCoconut {FALSE,TRUE}
  di.setValue(28, vegan); //@attribute xTurkey {FALSE,TRUE}
  di.setValue(29, random(0, 2)); //@attribute breakfast {0,1}
  di.setValue(30, vegan); //@attribute pork {0,1}
  di.setValue(31, random(0, 2)); //@attribute whole milk {0,1}
  try { 
    int i = (int)boostedJ48.classifyInstance(di);
    r = di.classAttribute().value(i);
  }
  catch(Exception ex) {
    ex.printStackTrace();
  }
  return r;
}

// Function to load WEKA data
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

// Function to load WEKA model
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

// Function to load boosted prediction model
void loadBoostedModel(String filepath) {
  try {
    boostedJ48 = (weka.classifiers.meta.AdaBoostM1) SerializationHelper.read(filepath);
    println("J48 loaded");
    //println(boostedJ48.toString());
  }
  catch(Exception ex) {
    ex.printStackTrace();
  }
}

// return true if txt is not null and not empty
String checkProfileItem(Object profileItem, String defaultValue) {
  return profileItem != null && ((String) profileItem).length() != 0 ? (String) profileItem : defaultValue;
}
