// The model class, where all the magic happens!
class Model {
  
  // The user input data
  private final float mass;
  private final float efficiency;
  private final float usagePerHouse;
  
  public Model(float mass /*KG*/, float efficiency /*%*/, float usagePerHouse /*KWh*/) {
    this.mass = mass;
    this.efficiency = efficiency / 100F; // We get the efficiency in a percentage - This will turn is to 0.X so we can multiply and make the calculations more readable!
    this.usagePerHouse = usagePerHouse;
  }
  
  // Static variables
  private static final int uranium235AtomicMass = 235; // I did not expect that :P
  private static final float nucleusPerMole = 6.022E23;
  private static final float electronVoltPerNucleus = 1E8; // 1,0 * 10^8
  private static final float electronVoltPerJoule = 6.242E18; // 6,242 * 10^18
  private static final float joulePerKWh = 3.6E6; // 3,6 * 10^6
  
  // Methods to calculate everything!
  private float getMole(float mass, int atomicMass) {
    float massInGrams = mass * 1000;
    float mole = massInGrams / atomicMass;
    return mole;
  }
  
  private double getNuclei(float mole) {
    float nuclei = nucleusPerMole * mole; // Constant of Avogadro times the amount of mole gives the amount of particles
    return nuclei;
  }
  
  private double getElectronVolt(double nuclei) {
    double totalElectronVolt = nuclei * Model.electronVoltPerNucleus; // Each U-235 emits 1,0 * 10^8 electron volt
    return totalElectronVolt;
  }
  
  private float electronVoltToJoule(double electronVolt) {
    float totalJoule = (float) (electronVolt / Model.electronVoltPerJoule); // One joule is 6,242 * 10^18 EV. Devide to get the total joule.
    return totalJoule;
  }
  
  public float getTotalJoule() {
    float mole = this.getMole(this.mass, Model.uranium235AtomicMass);
    double nuclei = this.getNuclei(mole);
    
    double totalElectronVolt = this.getElectronVolt(nuclei); // This is a double to make sure we have enough space!
    float totalJoule = this.electronVoltToJoule(totalElectronVolt);
    return totalJoule;
  }
  
  public float getConvertedJoule(float totalJoule) {
    float convertedJoule = totalJoule * this.efficiency;
    return convertedJoule;
  }
  
  private float getTotalKWh(float joule) {
    float totalKWh = joule / Model.joulePerKWh;
    return totalKWh;
  }
  
  private int getRoundedHouses(float KWh) {
    int supported = (int) Math.floor(KWh / this.usagePerHouse); // If this gives 1,5, we cannot support 2 houses with Math.round. Using Math.floor, even 1,99999 gives 1.
    return supported;
  }
  
  public int getSupportedHouses(float convertedJoule) {
    float totalKWh = this.getTotalKWh(convertedJoule);
    int houses = this.getRoundedHouses(totalKWh);
    return houses;
  }
  
  // Decay, the favorite part of this model :-)
  private static final float halfLifeBarium = 0.3045; // Hour
  private static final float halfLifeLanthanum = 3.92; // Hour
  private static final float halfLifeCerium = 7693.15068; // Year
  
  private static final float halfLifeKrypton = 1.82; // Seconds
  private static final float halfLifeRubidium = 1.2477778333; // Hours
  private static final float halfLifeStrontium = 2.66; // Hours
  private static final float halfLifeYttrium = 3.54; // Hours
  
  private double getNucleiLeft(double startNuclei, double time, float halfLife) {
    double nucleiLeft = startNuclei * Math.pow(0.5, time/halfLife); // N = N0 * 0.5^(t / t1/2)
    nucleiLeft = Math.floor(nucleiLeft); // We cannot have 0.5 nuclei
    
    return nucleiLeft;
  }
  private double getNucleiDecayed(double startNuclei, double time, float halfLife) {
    double nucleiLeft = this.getNucleiLeft(startNuclei, time, halfLife);
    double nucleiDecayed = startNuclei-nucleiLeft;
    return nucleiDecayed; // Model#getNucleiLeft already makes sure we do not have half nuclei :-)
  }
  
  public double getLongestBariumStableTime() {
    // Because of chemistry, we have the same amount of nuclei in the decay as in the original atom :-)
    float mole = this.getMole(this.mass, Model.uranium235AtomicMass);
    double bariumNuclei = this.getNuclei(mole);
    double longestTime = 0;
    
    // First loop - Get the nuclei that changed and continue the chain
    double bariumTime = 1;
    while ( this.getNucleiLeft(bariumNuclei, bariumTime, Model.halfLifeBarium) >= 1 ) { // Every time we have at least one nucleus, run the loop!
      System.out.println("Barium nuclei left: "+this.getNucleiLeft(bariumNuclei, bariumTime, Model.halfLifeBarium)); // Progress message in the console
      
      // Barium decays into lanthanum
      double lanthanumNuclei = this.getNucleiDecayed(bariumNuclei, bariumTime, Model.halfLifeBarium);
      bariumTime++; // We did all the calculations, we can now increment the time!
      if (lanthanumNuclei == 0) continue; // Nothing to convert yet!
      
      double lanthanumTime = 1;
      
      // Second loop
      while ( this.getNucleiLeft(lanthanumNuclei, lanthanumTime, Model.halfLifeLanthanum) >= 1 ) {
        // Lanthanum decays into cerium
        double ceriumNuclei = this.getNucleiDecayed(lanthanumNuclei, lanthanumTime, Model.halfLifeLanthanum);
        lanthanumTime++; // We did all the calculations, we can now increment the time!
        if (ceriumNuclei == 0) continue; // Nothing to convert yet!
        
        double ceriumTime = 1;
        
        // Third (And last) loop
        while ( this.getNucleiLeft(ceriumNuclei, ceriumTime, Model.halfLifeCerium) >= 1 ) {
          ceriumTime++;
          // Cerium decays into praseodymium - A stable isotope. We do not need to do anything except for adding the time so we know how long it took!
        }
        
        // Calculate the total time
        double totalTime = bariumTime*3600 /* Hours to seconds */ + lanthanumTime*3600 /* Hours to seconds */ + ceriumTime*31536000; /* Years to seconds */
        if (totalTime > longestTime) longestTime = totalTime;
        
      }
      
    }
    
    // Return the longest time :-)
    return longestTime;
  }
  
  public double getLongestKryptonStableTime() {
    // Because of chemistry, we have the same amount of nuclei in the decay as in the original atom :-)
    float mole = this.getMole(this.mass, Model.uranium235AtomicMass);
    double kryptonNuclei = this.getNuclei(mole);
    double longestTime = 0;
    
    // First loop - Get the nuclei that changed and continue the chain
    double kryptonTime = 1;
    while ( this.getNucleiLeft(kryptonNuclei, kryptonTime, Model.halfLifeKrypton) >= 1 ) { // Every time we have at least one nucleus, run the loop!
      System.out.println("Krypton nuclei left: "+this.getNucleiLeft(kryptonNuclei, kryptonTime, Model.halfLifeKrypton)); // Progress message in the console
      
      // Barium decays into lanthanum
      double rubidiumNuclei = this.getNucleiDecayed(kryptonNuclei, kryptonTime, Model.halfLifeKrypton);
      kryptonTime++; // We did all the calculations, we can now increment the time!
      if (rubidiumNuclei == 0) continue; // Nothing to convert yet!
      
      double rubidiumTime = 1;
      
      // Second loop
      while ( this.getNucleiLeft(rubidiumNuclei, rubidiumTime, Model.halfLifeRubidium) >= 1 ) {
        // Lanthanum decays into cerium
        double strontiumNuclei = this.getNucleiDecayed(rubidiumNuclei, rubidiumTime, Model.halfLifeRubidium);
        rubidiumTime++; // We did all the calculations, we can now increment the time!
        if (strontiumNuclei == 0) continue; // Nothing to convert yet!
        
        double strontiumTime = 1;
        
        // Third loop
        while ( this.getNucleiLeft(strontiumNuclei, strontiumTime, Model.halfLifeStrontium) >= 1 ) {
          // Lanthanum decays into cerium
          double yttriumNuclei = this.getNucleiDecayed(strontiumNuclei, strontiumTime, Model.halfLifeStrontium);
          strontiumTime++; // We did all the calculations, we can now increment the time!
          if (yttriumNuclei == 0) continue; // Nothing to convert yet!
          
          double yttriumTime = 1;
          
          // Fourth (and final) loop
          while ( this.getNucleiLeft(yttriumNuclei, yttriumTime, Model.halfLifeYttrium) >= 1 ) {
            yttriumTime++;
            // Yttrium decays into zirconium - A stable isotope. We do not need to do anything except for adding the time so we know how long it took!
          }
          
          // Calculate the total time
          double totalTime = kryptonTime /* Seconds */ + rubidiumTime*3600 /* Hours to seconds */ + yttriumTime*3600 /* Hours to seconds */ + strontiumTime*3600; /* Hours to seconds */
          if (totalTime > longestTime) longestTime = totalTime;
          
        }
        
      }
      
    }
    
    // Return the longest time :-)
    return longestTime;
  }
  
}
