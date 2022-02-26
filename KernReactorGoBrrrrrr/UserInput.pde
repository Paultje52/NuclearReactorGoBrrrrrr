import controlP5.ControlP5;
import controlP5.Textfield;
import controlP5.Button;

// UserInput class
// Takes care of all the user input
class UserInput {
  
  private final ControlP5 cp5;
  
  public UserInput(ControlP5 cp5) {
    this.cp5 = cp5;
  }
  
  // These are the input/button display names
  private final String massInput = Translations.mass;
  private final String efficiencyInput = Translations.efficiency;
  private final String usagePerHouseInput = Translations.usagePerHouse;
  private final String calculateButton = Translations.calculate;
  
  private ControlP5 getCP5() {
    return this.cp5;
  }
  
  public void createInputs() {
    // Mass input
    cp5.addTextfield(this.massInput)
      .setPosition(Positions.massInputX, Positions.massInputY)
      .setSize(Positions.massInputWidth, Positions.massInputHeight)
      .setFont(this.getFont())
      .setValue("100")
      .setColor(color(0, 255, 0));
    
    // Efficiency input
    cp5.addTextfield(this.efficiencyInput)
      .setPosition(Positions.efficiencyInputX, Positions.efficiencyInputY)
      .setSize(Positions.efficiencyInputWidth, Positions.efficiencyInputHeight)
      .setFont(this.getFont())
      .setValue("33")
      .setColor(color(0, 110, 255));
    
    // Usage per house input
    cp5.addTextfield(this.usagePerHouseInput)
      .setPosition(Positions.usagePerHouseInputX, Positions.usagePerHouseInputY)
      .setSize(Positions.usagePerHouseInputWidth, Positions.usagePerHouseInputHeight)
      .setFont(this.getFont())
      .setValue("2760")
      .setColor(color(255, 0, 0));  
     
    // Calculate button
    cp5.addButton(this.calculateButton)
      .setPosition(Positions.calculateButtonX, Positions.calculateButtonY)
      .setSize(Positions.calculateButtonWidth, Positions.calculateButtonHeight);
  }
  
  private PFont getFont() {
    return createFont("arial", 20);
  }
  
  // Methods to get the inpuut/button instances
  private Textfield getMassInput() {
    return this.getCP5().get(Textfield.class, this.massInput);
  }
  private Textfield getEfficiencyInput() {
    return this.getCP5().get(Textfield.class, this.efficiencyInput);
  }
  private Textfield getUsagePerHouseInput() {
    return this.getCP5().get(Textfield.class, this.usagePerHouseInput);
  }
  private Button getCalculateButton() {
    return this.getCP5().get(Button.class, this.calculateButton);
  }
  
  // Check if the calculate button is pressed
  public boolean handleClickedButton() {
    boolean isPressed = this.getCalculateButton().isPressed();
    this.getCalculateButton().setOff(); // Make sure the button is off again!
    
    return isPressed;
  }
  
  // Get the values
  public float getMass() {
    return Float.valueOf(this.getMassInput().getText()); 
  }
  public float getEfficiency() {
    return Float.valueOf(this.getEfficiencyInput().getText()); 
  }
  public float getUsagePerHouse() {
    return Float.valueOf(this.getUsagePerHouseInput().getText()); 
  }
  
}
