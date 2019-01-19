float angle;
Table table;
float r = 200;
PImage earth;
PShape globe;
int last = 0;
int m = 0;
int start;

void setup() {
  size(800, 800, P3D);
  earth = loadImage("earth2.jpg");
  table = loadTable("cityData.csv", "header");

  noStroke();
  //draw the sphere with a world texture
  globe = createShape(SPHERE, r);
  globe.setTexture(earth);
  
  // get the time when the program first runs
  start = millis() / 1000;
}

void draw() {
  background(10);
  int m = millis();
  int secondsElapsed = (m / 1000) - start;
  drawText("1955");
  angle += 0.005;
  pushMatrix();
  translate(width*0.5, height*0.6);
  //rotate the globe every frame so it spins around
  rotateY(angle);
  drawGlobe(9);
  popMatrix();
  
  // every 5 seconds I redraw the text and code with new values to create the timelaps
  if (secondsElapsed >= 5) {
    background(10);
    drawText("1960");
    pushMatrix();
    translate(width*0.5, height*0.6);
    rotateY(angle);
    drawGlobe(9);
    popMatrix();
  }
  if (secondsElapsed >= 10) {
    background(10);
    drawText("1970");
    pushMatrix();
    translate(width*0.5, height*0.6);
    rotateY(angle);
    drawGlobe(11);
    popMatrix();
  }
  if (secondsElapsed >= 15) {
    background(10);
    drawText("1980");
    pushMatrix();
    translate(width*0.5, height*0.6);
    rotateY(angle);
    drawGlobe(13);
    popMatrix();
  }
  if (secondsElapsed >= 20) {
    background(10);
    drawText("1990");
    pushMatrix();
    translate(width*0.5, height*0.6);
    rotateY(angle);
    drawGlobe(15);
    popMatrix();
  }
  if (secondsElapsed >= 25) {
    background(10);
    drawText("2000");
    pushMatrix();
    translate(width*0.5, height*0.6);
    rotateY(angle);
    drawGlobe(17);
    popMatrix();
  }
  if (secondsElapsed >= 30) {
    background(10);
    drawText("2010");
    pushMatrix();
    translate(width*0.5, height*0.6);
    rotateY(angle);
    drawGlobe(19);
    popMatrix();
  }
  if (secondsElapsed >= 35) {
    background(10);
    drawText("2020");
    pushMatrix();
    translate(width*0.5, height*0.6);
    rotateY(angle);
    drawGlobe(21);
    popMatrix();
  }
  if (secondsElapsed >= 40) {
    background(10);
    drawText("2030");
    pushMatrix();
    translate(width*0.5, height*0.6);
    rotateY(angle);
    drawGlobe(23);
    popMatrix();
  }
  if (secondsElapsed >= 45) {
    secondsElapsed = 0;
    start = millis() / 1000;
    background(10);
    pushMatrix();
    translate(width*0.5, height*0.6);
    rotateY(angle);
    drawGlobe(8);
    popMatrix();
  } //<>//
}

//the function to draw the globe, I put it in a seperate function so i can redraw it over time with differen 
//values to create a timelaps effect
void drawGlobe(int dataRow) {
  fill(0);
  noStroke();
  shape(globe);

//I got the logic of positioning the values on its latitude and longtitude from a coding train tutorial
//https://www.youtube.com/watch?v=dbs4IYGfAXc
//
  for (TableRow row : table.rows()) {
    float lat = row.getFloat("Latitude");
    float lon = row.getFloat("Longitude");
    //the population data consists of the rows 8 to 23 in the csv file.
    String date1950 = row.getString(dataRow); //8 tot 23
    int int1950 = Integer.valueOf(date1950.replaceAll(",", "").toString());

    float theta = radians(lat) + PI/2;

    float phi = radians(-lon) + PI;  

    float x = r * sin(theta) * cos(phi);
    float y = r * cos(theta);
    float z = r * sin(theta) * sin(phi);

    PVector pos = new PVector(x, y, z);

    float h = map(int1950, 0, 10000, 10, 100);
    //The the boxes are rotated based on a vector that points from the center of the box to it's
    //position on the globe. The height of the boxes are based on the population values
    PVector xaxis = new PVector(1, 0, 0);
    float angleb = PVector.angleBetween(xaxis, pos);
    PVector raxis = xaxis.cross(pos);

    pushMatrix();
    translate(x, y, z);
    rotate(angleb, raxis.x, raxis.y, raxis.z);
    fill(255,255,204);
    box(h, 1, 1);
    popMatrix();
  }
}

//function to draw the text.
//I put it in a seperate function so i can redraw it with a different year value every time i redraw the globe.
void drawText(String year) {
  rotateY(0);
  fill(255);
  textSize(26);
  text("World population timelaps", 220, 80);
  textSize(32);
  text(year, 345, 150); 
}