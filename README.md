# NuclearReactorGoBrrrrrr
A model for school.
> **How much energy is released during nuclear fission, how many houses can we supply with electricity for one year and how long does it take before the waste is no longer radioactive?**

## Libraries
This project uses one library: [ControlP5](https://sojamo.de/libraries/controlP5/).

## Assumptions
- The used atoms is `U-235`.
- An neutron is fired at the `U-235`, wich turns it into `U-236`. This is a unstable istope, and decays into `Kr-92`, `Ba-142` and `3` nutreons that cause a chain reaction. It also emits `100.000.000` EV.
- 33% of the total energy is converted into `KWh`.
- View the code to see what unites of half-life values we used. We didn't use seconds everywhere, because computers are sometimes slow in calculations. Waiting 90 seconds for a result is long enough :-)  
