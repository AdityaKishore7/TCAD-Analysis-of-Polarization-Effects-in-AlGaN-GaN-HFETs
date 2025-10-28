# TCAD Analysis of Polarization Effects in AlGaN/GaN HFETs

A Sentaurus TCAD project dedicated to simulating and analyzing the DC characteristics of AlGaN/GaN Heterostructure Field-Effect Transistors (HFETs). This study focuses on the critical impact of spontaneous and piezoelectric polarization charges on device performance, particularly the $I_{ds}-V_{ds}$ and $I_{ds}-V_{gs}$ curves.

## Key Objectives
* **Simulate DC Characteristics:** Generate $I_{ds}-V_{ds}$ (output) and $I_{ds}-V_{gs}$ (transfer) curves for the device.
* **Model Polarization:** Accurately model the 2D Electron Gas (2DEG) formed at the AlGaN/GaN heterointerface due to spontaneous and piezoelectric polarization.
* **Parameter Sweeping:** Investigate the impact of varying the AlGaN barrier thickness (`tAlGaN`) and Al mole fraction (`xAlGaN`) on device performance.
* **Implement Wide-Bandgap Physics:** Utilize the correct numeric settings (e.g., Extended Precision) and physics models required for accurately simulating wide-bandgap materials like GaN and AlGaN.

## Device Structure
The simulated device is an RF GaN HFET based on a structure published by Kikkawa et al.. The nominal heterostructure consists of:

* **Cap:** 3 nm GaN 
* **Barrier:** 18 nm AlGaN (variable) 
* **Spacer:** 2 nm AlGaN 
* **Buffer:** 2 µm GaN 
* **Gate Length ($L_g$):** 0.8 µm


![Untitled design](pictures/Untitled%20design.png)


## Physics and Models Implemented
This simulation employs a robust, physics-based model set within Sentaurus Device, tailored for III-nitride materials:

* **Carrier Transport & Recombination:**
    * **Mobility Models:** Standard models are used that include dependencies on doping concentration, temperature, and high-field saturation.
    * **Recombination:** Shockley-Read-Hall (SRH) processes are included to model generation-recombination.
    * **Carrier Statistics:** Fermi-Dirac statistics are used for accurate carrier concentration modeling.

* **Polarization Model:**
    * The simulation computes polarization charges at interfaces automatically. It accounts for both **spontaneous** and strain-induced **piezoelectric** components based on the formulation by Ambacher et al.
    * This is enabled in the global physics section with the keyword `Piezoelectric_Polarization(strain (GateDependent)).
    * The `GateDependent` option modifies the anisotropic dielectric tensor to account for the **converse piezoelectricity effect**.
    * The resulting anisotropic Poisson equation is enabled with `Aniso (Poisson direction = (0,0,1))` to align the anisotropic direction with the c-axis of the crystal.

* **Interface Traps:**
    * To compensate for the large negative polarization charge at the GaN cap surface, deep, single-level trap states are defined at that interface. The specified parameters are $N_{T_{surt}} = 5 \times 10^{13} \text{cm}^{-2}$ and $E_{T_{ourf}}-E_{i}=0.4$ eV.

* **Electrical Contacts:**
    * **Source/Drain:** Modified Ohmic contacts are used to ensure proper carrier densities across the heterointerfaces. This is set with the `EqOhmic` keyword in the `Electrode` section.
    * **Gate:** A **Schottky-type** contact is defined with a metal workfunction of $\Phi_{MG} = 4.4$ V.

* **Numerics for Wide-Bandgap Materials:**
    * To ensure robust and accurate solutions for large-bandgap materials, `ExtendedPrecision` is enabled along with `Digits=8`.
    * The carrier density thresholds for the `HighFieldSaturation` model (`eDrForceRefDens` and `hDrForceRefDens`) are set to `1e8 cm-3` to prevent numeric noise in regions with low carrier densities.

## Simulation Workflow
The project is managed via a Sentaurus Workbench project, which automates the following tool flow:

1.  **Sentaurus Structure Editor (SDE):** Generates the 2D device geometry, defines regions, and creates the mesh. The key parameters `tAlGaN` and `xAlGaN` are parameterized here for experiments.
2.  **Sentaurus Device (SDevice):** Solves the coupled Poisson and drift-diffusion equations.
    * A common command file (`common_des.cmd`) defines all physics models.
    * The simulation first ramps the gate bias ($V_{gs}$) and saves solutions.
    * These solutions are then used as the initial guesses for the drain bias ($V_{ds}$) ramps, ensuring better convergence while generating the $I_{ds}-V_{ds}$ curves.
3.  **Sentaurus Visual (SVisual):** Automatically loads the output data and plots the $I_{ds}-V_{ds}$ and $I_{ds}-V_{gs}$ curves for analysis.

## Example Results
The simulation generates standard DC characteristic curves, allowing for the extraction of key metrics like threshold voltage, transconductance ($g_m$), and on-state current.


![output_graph_2](pictures/output_graph_2.png)

![output_graph_1](pictures/output_graph_1.png)

