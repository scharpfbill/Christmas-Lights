/* 
 *  W. Scharpf, 16July 2022
 *  This script reads data from an SD card then tells which LED to light.  At teach time step all LEDs are defined.
 *  Used here are the WWS2811 leds. They come in groups af 50, here are call LED strings
 *  
 *  There are three versions of this program:
 *  1) Echos the data from the file on the SD drive to the Serial Port. Runs only once, in the setup section.
 *  2) Doesn't echo data to teh Serial port. Runs only once, in the setup section.
 *  3) Loops, Runs in the loop section.

Some notes:
 - Required to use a Arduino wiht larer sram or ram.  the ARDUINO UNO memory is too small.  Can't run both the SD card and LED Libs.
 - For some reason, There is about 500 charater max per read call. I had to buffer per string.  
 - the SD card format:
    - Each line defines the LED intensity.
    - each line defines an indivual string (1 to 7) 
    - [0 to 5] are the line number.  Not used in the Arduino script
    - [6 to 7] are the string number.  Used by this script
    - [8] should be a colon, ':'.  
    - for each LED, the intensity is a 0 to 255 uint8, in %3i format
    - for each LED, there are three uint8 for Red, Green and Blue
    - [9 to 458]
      - <Led1 R><LED1 G><LED1 B><Led2 R><LED2 G><LED2 B>...<Led458 R><LED458 G><LED458 B>
    - [459 to 462] "|" and CR LF
*/

// For SD card reading
#include <SPI.h>
#include <SD.h>
#define SDPIN     10 // pin for reading data from the SD card

File myFile;  // I am not sure what this does

// For LED cntrol
#include <Adafruit_NeoPixel.h>  
#define PIN        6 // Pin the commands the LEDs
#define Nstrings 7 // Number of strings
#define LEDsperstrings 50 // Number of LEDs per strings

// for reading the data file
#define FNAME  "LEDsList.txt"
#define BUFSIZE 461 // Buffer size

// display timing
#define DELAYVAL 10 // defines the time step size


#define COLONLOC 8 // location of the colon ":" in the buffer
#define VERTLOC 459 // location of the vertical "|" in the buffer

// adafruit lib led control
Adafruit_NeoPixel pixels(LEDsperstrings*Nstrings, PIN, NEO_GRB + NEO_KHZ800);

void setup() {

  // define parametersm: buffer and the led values
  char buf1[BUFSIZE];
  char buf2[3];
  int strng;
  int red;
  int green;
  int blue;

  pixels.begin(); // INITIALIZE NeoPixel strip object (REQUIRED)

  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }

  if (!SD.begin(SDPIN)) {
    Serial.println("initialization failed!");
    while (1);
  }
  Serial.println("initialization done.");

  // open the file for reading:
  myFile = SD.open(FNAME);  // (FNAME);
  Serial.println(myFile);  // not sure why these lines are necessary.  Serial port doesn't seem to work I remove these 4 line.  I get extra charaterters
  if (myFile) {
    Serial.println(FNAME);
  }

  // loop over the number of lines in the file
//  for (int ii=0; ii < 20; ii++) {  // use this when looking at just the first few lines.  comment out the next
  while (myFile.available()) {

//  Serial.println(myFile.available());

    myFile.read(buf1,BUFSIZE);
//    Serial.println(buf1);

    // print out jsut the header charaters for each line
    char buf4[COLONLOC];
    for (int jj=0; jj <= COLONLOC; jj++) {
      buf4[jj] = buf1[jj];
    }
    Serial.print(buf4);

    // Check the buffer: Make sure the colon and vertical are in the correct location
    if (buf1[COLONLOC] != ':') {
      Serial.println("problem, not finding the colon");
      Serial.println(buf1);
      errorflash(1);
    }

    if (buf1[VERTLOC] != '|') {
      Serial.println("problem, not finding Vertical line");
      Serial.println(buf1);
      errorflash(2);
    }

    // determine which string this line refers to
    char buf3[1];
    buf3[0] = buf1[COLONLOC-2];
    buf3[1] = buf1[COLONLOC-1];     
//    Serial.println(buf3);

    // convert to integer
    strng = atoi(buf3);
//    Serial.println(strng);

    for (int LED=0; LED <50; LED++) {

    buf2[0] = buf1[9*LED + COLONLOC + 1];  
    buf2[1] = buf1[9*LED + COLONLOC + 2];
    buf2[2] = buf1[9*LED + COLONLOC + 3];
//    Serial.print(buf2);
    red = atoi(buf2);
//    Serial.print(" ");
//    Serial.print(red);
    buf2[0] = buf1[9*LED + COLONLOC + 4];
    buf2[1] = buf1[9*LED + COLONLOC + 5];
    buf2[2] = buf1[9*LED + COLONLOC + 6];
//    Serial.print(buf2);
    green = atoi(buf2);
//    Serial.print(" ");
//    Serial.print(green);
    buf2[0] = buf1[9*LED + COLONLOC + 7];
    buf2[1] = buf1[9*LED + COLONLOC + 8];
    buf2[2] = buf1[9*LED + COLONLOC + 9];
//    Serial.print(buf2);
    blue = atoi(buf2);
//    Serial.print(" ");
//    Serial.print(blue);

        pixels.setPixelColor(LED + strng*LEDsperstrings, pixels.Color(green, red ,blue));
//        Serial.println(LED + LEDsperstrings*strng);
    
    }  
        Serial.println();
  

    if (strng == 0) {
      pixels.show();
      delay(DELAYVAL); // Pause
    }
    
  }
  // close the file:
  myFile.close();
}

void loop() {

errorflash(Nstrings*LEDsperstrings - 1);
  
}

void errorflash(int err) {
// error with the buffer.  Either the colon or vertical is not in the correct location.  LED will flash white. the LED # determines where the error is 

//Serial.println("error 1");

  while (1) {
    pixels.clear(); // Set all pixel colors to 'off'
    pixels.show();   // Send the updated pixel colors to the hardware.
    delay(500); // Pause
    pixels.setPixelColor(err, pixels.Color(50, 50, 50));
    pixels.show();
    delay(500); // Pause
  }
}
