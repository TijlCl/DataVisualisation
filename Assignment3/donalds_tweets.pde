//for this visualisation i use the java package twitter4j to 
//connect to a twitter stream in processing
import twitter4j.conf.*;
import twitter4j.*;
import twitter4j.auth.*;
import twitter4j.api.*;
import java.util.*;
Twitter twitter;
String searchString = "donald";
List<Status> tweets;
PImage img;

int currentAmount;
int start;
TwitterStream twitterStream;

Head[] heads;
Head newHead;

void setup()
{
  size(800,600);
  heads = new Head[0];
  start = millis() / 1000;
  //twitter auth keys
  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey("uCU9EOgnvE7McBgcjXRFN73E5");
  cb.setOAuthConsumerSecret("UsEeUMJUg7TNUKtnV78992udpsJrtdJMVCOGMY8ifBOLP4kIpv");
  cb.setOAuthAccessToken("387639395-lbylGarfrhMGV6O1vWqEMLjHdPES0jFP1UWf9Rk9");
  cb.setOAuthAccessTokenSecret("DcFW5h6APVKyQJqBwHXuYn7IiHd0J9ajqnnMPFQYz1SLV");
  
  TwitterStream twitterStream = new TwitterStreamFactory(cb.build()).getInstance();
  FilterQuery filtered = new FilterQuery();
  //the twitter stream listens to the words in the keywords array
  String keywords[] = {
    "trump"
  };
  filtered.track(keywords);
  twitterStream.addListener(listener);
 
  if (keywords.length==0) {
    twitterStream.sample();
  } else { 
    twitterStream.filter(filtered);
  }
  currentAmount = 0;
  img = loadImage("trump_head.png");
}

void draw()
{
  background(255);
   int secondsElapsed = (millis() / 1000) - start;
   //every second I draw a trumphead. The height of the trumphead is 
   //basen on the number of tweets sent in that second with the word "trump" in it.
   if (secondsElapsed > 1) {
     newHead = new Head(0, 600 - (currentAmount * 2));
     heads = (Head[]) append(heads, newHead);
     currentAmount = 0;
     secondsElapsed = 0; //<>//
     start = millis() / 1000;
   }
   if (millis() / 1000 >= 3) {
     for (Head head : heads) {
     head.update();
     head.display();
    }
   }
}

//trumphead object
class Head {
  float x, y;
  int xDirection = 2;
  float speed = 0.5; 
  //constructor
  Head(float xTemp, float yTemp) {
    x = xTemp;
    y = yTemp;
  }
  //every frame the x value is moved to the right
  void update() {
    x = x + (speed * xDirection);
  }
  //draw function
  void display() {
    image(img, x, y, 50, 50);
  }
  
}
//the basic twitter stream functions I only use the "onStatus()" function
//this function is executed every time it finds a twitter with "thrump" in it.
StatusListener listener = new StatusListener() {
 
  public void onStatus(Status status) {
    //I increment the counter to cet the number of tweets with trump in them.
    currentAmount++;
    System.out.println("@" + status.getUser().getScreenName() + " - " + status.getText());
  }
 
  public void onDeletionNotice(StatusDeletionNotice statusDeletionNotice) {
    System.out.println("Got a status deletion notice id:" + statusDeletionNotice.getStatusId());
  }
 
  public void onTrackLimitationNotice(int numberOfLimitedStatuses) {
    System.out.println("Got track limitation notice:" + numberOfLimitedStatuses);
  }
 
  public void onScrubGeo(long userId, long upToStatusId) {
    System.out.println("Got scrub_geo event userId:" + userId + " upToStatusId:" + upToStatusId);
  }
 
  public void onStallWarning(StallWarning warning) {
    System.out.println("Got stall warning:" + warning);
  }
 
  public void onException(Exception ex) {
    ex.printStackTrace();
  }
};