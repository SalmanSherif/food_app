
// log data --------------------------------------------------------------------------

public void submit(String act) {
  
  color tempColor = rColor;
  isStart = true;
  long ctime = millis();
  rColor = color(0);


  // send data to both datasets
  logIoTData(act, (ctime - lastClickTime), tempColor);
  updateUserProfile(ctime);

  // new random color
  rColor = color(random(40, 220), random(40, 220), random(40, 220));
  lastClickTime = ctime;
}

// to IoT dataset
void logIoTData(String act, long relativeTime, color tempColor) {
  // set resource id (refId of device in the project)
  iotDS.device("user1");
  // set activity for the log
  if(act.equals("start") || act.equals("stop")) {
    iotDS.activity(act);
  } else {
    iotDS.activity("color_classification");
  }
  // add data, then send off the log
  iotDS.data("time", relativeTime).data("choice", act).data("color", hex(tempColor)).log();
}

// to Entity dataset
void updateUserProfile(long ctime) {
  float avgTime = (ctime - startTime) / clicks;
  String freqColor = "1";
  
  // select item with id and token combination
  entityDS.id(uname).token(uname);
  // add data to send (=update)
  entityDS.data("average_time", avgTime).data("most_frequent_color", freqColor)
    .data("plays", clicks).update();
}

// get user profile ------------------------------------------------------------------

void fetchData() {
  // set item
  entityDS.id(uname).token(uname);
 iotDS.id(uname).token(uname);
  // get item
  Map<String, Object> result = entityDS.get();
Map<String, Object> test = iotDS.get();
  // extract and check item "most_frequent_color" from the Map
  String UserNameEnt = checkProfileItem(result.get("Username"), "No data");
  String UserNameIot = checkProfileItem(test.get("Username"), "No data");
  // same here
  String resp_avgTime = checkProfileItem(result.get("average_time"), "0");
  String resp_plays = checkProfileItem(result.get("plays"), "0");
println(UserNameEnt);println(UserNameIot);
  //bgColor = text2Color(resp_freqColor);
}

// utilities -------------------------------------------------------------------------

// return true if txt is not null and not empty
String checkProfileItem(Object profileItem, String defaultValue) {
  return profileItem != null && ((String) profileItem).length() != 0 ? (String) profileItem : defaultValue;
}
