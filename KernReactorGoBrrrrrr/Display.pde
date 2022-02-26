// Display class
// This class takes care of displaying all the values and unites for the inputs
static class Display {
  
  private final PApplet applet;
  
  private boolean resultsReady = false;
  private int duration;
  
  private float totalJoule;
  private float convertedJoule;
  
  private float supportedHouses;
  
  private double bariumTime;
  private double kryptonTime;
  
  public Display(PApplet applet) {
    this.applet = applet;
  }
  private void text(String text, float x, float y) {
    this.applet.text(text, x, y);
  }
  
  public void draw() {
    this.resetWindow();
    this.drawInputUnites();
    this.drawResult();
  }
  
  private void resetWindow() {
    this.applet.background(0);
    this.applet.fill(255, 255, 255);
  }
  
  private void drawInputUnites() {
    this.applet.textSize(12);
    this.applet.fill(255, 255, 255);
    
    this.text(Translations.kilogram, Positions.kilogramUnitX, Positions.kilogramUnitY);
    this.text(Translations.percent, Positions.percentUnitX, Positions.percentUnitY);
    this.text(Translations.kilowattHour, Positions.kilowattHourUnitX, Positions.kilowattHourUnitY);
  }
  
  private void drawResult() {
    if (!this.resultsReady) return;
    
    // Calculation time
    this.drawResult(Translations.time, ""+Math.round(this.duration/1000), "", Translations.seconds, Positions.timeResultX, Positions.timeResultY);
    
    // Total joule
    String[] totalJouleResult = this.parseFloat(this.totalJoule);
    this.drawResult(Translations.joule, totalJouleResult[0], totalJouleResult[1], Translations.jouleUnit, Positions.jouleResultX, Positions.jouleResultY);
    
    // Converted joule
    String[] convertedJouleResult = this.parseFloat(this.convertedJoule);
    this.drawResult("    "+Translations.converted, convertedJouleResult[0], convertedJouleResult[1], Translations.jouleUnit, Positions.convertedJouleResultX, Positions.convertedJouleResultY);
    
    // Houses
    String[] housesResult = this.parseFloat(this.supportedHouses);
    this.drawResult(Translations.houses, housesResult[0].replace(".0", ""), housesResult[1], "", Positions.housesResultX, Positions.houseseResultY);
    
    // Barium time
    this.drawResult(Translations.barium, String.valueOf(Math.floor(((double)this.bariumTime/3.154E7*100))/100) /* Display in years */, "", Translations.year, Positions.bariumResultX, Positions.bariumResultY);
    String[] bariumResult = this.parseFloat(this.bariumTime);
    this.drawResult("  ", bariumResult[0].replace(".0", ""), bariumResult[1], Translations.seconds, Positions.bariumFullResultX, Positions.bariumFullResultY);
    
    // Krypton time
    this.drawResult(Translations.krypton, String.valueOf(Math.floor(((double)this.kryptonTime/86400*100))/100) /* Display in days */, "", Translations.days, Positions.kryptonResultX, Positions.kryptonResultY);
    String[] kryptonResult = this.parseFloat(this.kryptonTime);
    this.drawResult("  ", kryptonResult[0].replace(".0", ""), kryptonResult[1], Translations.seconds, Positions.kryptonFullResultX, Positions.kryptonFullResultY);
  }
  
  private void drawResult(String label, String number, String power, String unit, int x, int y) {
    int atX = x;
    this.applet.textSize(15);
    
    // Value
    this.applet.fill(255, 255, 255); // White
    text(label, atX, y);
    atX += this.applet.textWidth(label); // Next position for the part with a color
    
    // Value
    this.applet.fill(34, 255, 255); // Aqua
    text(number, atX, y);
    atX += this.applet.textWidth(number); // Next position for power
    
    // Power (For scientific notation)
    this.applet.textSize(9);
    text(power, atX, y-8);
    atX += this.applet.textWidth(power); // Next position for unit
    
    // Unit
    this.applet.textSize(15);
    text(unit, atX+5, y);
  }
  
  private String[] parseFloat(double number) {
    String string = String.valueOf(number);
    String[] parts = string.split("E");
    
    if (parts.length == 1) { // There is no scientific notation we need to parse!
      String[] parsedParts = new String[]{ parts[0], "" };
      return parsedParts;
    }
    
    parts[0] += " * 10";
    parts[0] = parts[0].replace(".", ",");
    return parts;
  }
  
  public void setCalculations(int duration, float totalJoule, float convertedJoule, float supportedHouses, double bariumTime, double kryptonTime) {
    this.resultsReady = true;
    this.duration = duration;
    
    this.totalJoule = totalJoule;
    this.convertedJoule = convertedJoule;
    
    this.supportedHouses = supportedHouses;
    
    this.bariumTime = bariumTime;
    this.kryptonTime = kryptonTime;
  }
  
}
