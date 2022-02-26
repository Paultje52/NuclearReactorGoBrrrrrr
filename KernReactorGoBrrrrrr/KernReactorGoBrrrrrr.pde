// Github link: https://github.com/Paultje52/NuclearReactorGoBrrrrrr
import controlP5.ControlP5;

UserInput userInput;
Display display;

void settings() {
  size(700, 400);
}

void setup() {
  background(0);
  fill(255, 255, 255);
  
  userInput = new UserInput(new ControlP5(this));
  userInput.createInputs();
  
  display = new Display(this);
}

void draw() {
  display.draw();
  
  if (userInput.handleClickedButton()) {
    int start = millis(); // We'll show the user how long it took!
    
    Model model = new Model(
      userInput.getMass(),
      userInput.getEfficiency(),
      userInput.getUsagePerHouse()
    );
    
    // Run the calculations
    float totalJoule = model.getTotalJoule();
    float convertedJoule = model.getConvertedJoule(totalJoule);
    float supportedHouses = model.getSupportedHouses(convertedJoule);
    
    double bariumTime = model.getLongestBariumStableTime();
    double kryptonTime = model.getLongestKryptonStableTime();
    
    // Send the results to the display class!
    int duration = millis()-start;
    System.out.println("Finished! Duration:" + duration + "ms");
    
    display.setCalculations(
      duration,
      totalJoule, convertedJoule,
      supportedHouses,
      bariumTime, kryptonTime
    );
  }
}
