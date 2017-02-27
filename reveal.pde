//This is an interactive game that asks the player to reveal the original picture by moving the mouse
//By clicking, the mosaic become smaller, therefore the player could see the picture more clearly.
//The game gives hints by giving the contour of the original picture
PImage img;         // Source image
PImage destination; // Destination image
PImage colored; //Blank Image
int divisor=100; 

void setup() {

  //original image
  //img = loadImage("sunflower.jpg");
  img=loadImage("chicken.jpg");
  //contour image
  destination = createImage(img.width, img.height, ARGB);
  //a transparent image to store color
  colored = createBlankImage(img.width, img.height);

  size(600, 600);
  
  destination=drawContour(img);
  image(destination,0,0);
  writeInCenter("HERE");


}

void draw() {
  //change();
}




PImage createBlankImage(int w, int h){
  PImage pic= createImage(w, h, RGB);
  pic.loadPixels();
  for (int i=0; i<pic.pixels.length; i++) {
    pic.pixels[i]= color(200, 200, 200, 0);
  }
  pic.updatePixels();
  return pic;
}

PImage drawContour(PImage img){
  PImage destination=createBlankImage(img.width, img.height);
  img.loadPixels();
  destination.loadPixels();
  // Since we are looking at left neighbors, We skip the first column
  for (int x = 1; x < destination.width; x++ ) {
    for (int y = 0; y < destination.height; y++ ) {

      // Pixel location and color
      int loc = x + y*destination.width;
      color pix = img.pixels[loc];

      // Pixel to the left location and color
      int leftLoc = (x - 1) + y*destination.width;
      color leftPix = img.pixels[leftLoc];

      // New color is difference between pixel and left neighbor
      float diff = abs(brightness(pix) - brightness(leftPix));
      // Draw the threshold
      if (diff>50) {
        //if different, make the pixel black 
        destination.pixels[loc] = color(0); 
      } else {
        //if not, make it transparent
        destination.pixels[loc]= color(200, 200, 200, 0); 
      }
      
    }
  }
  destination.updatePixels();//finish drawing the contour
  return destination;
}

void writeInCenter(String s) {
  int size=32;
  textSize(size);
  fill(0, 102, 153);
  text(s, (int)(img.width/2-size/2), (int)img.height/2); 
}


boolean hasColor(color p) {
  return p!=color(200, 200, 200, 0);
}

void reveal() {
  img.loadPixels();
  //the pixel which the mouse is pointing at
  int pixelth=mouseX+mouseY*img.width;
  pixelth=int(constrain(pixelth, 0, img.pixels.length-1));
  
  color ocolor =img.pixels[pixelth];
  destination.loadPixels();
  colored.loadPixels();
  colored.pixels[pixelth]=ocolor;
  
  //color the blank image with a a*a square of color
  //l is half the side length of the  square
  int l=int(img.width*img.height/sq(divisor));
  for (int i=-l; i<l; i++) {
    for (int j=-l; j<l; j++) {
      int cp=int(constrain(pixelth+i+j*img.width, 0, img.height*img.width-1));
      colored.pixels[cp]=ocolor;
    }
  }

  colored.updatePixels();
  image(colored, 0, 0);
  //image(destination,0,0);
}

void mousePressed() {
  //shrink the side length of the square, thus shrink the square to reveal more details in the original picture
  divisor=min(img.pixels.length, divisor+5);
}
void mouseMoved() {
  reveal();
}