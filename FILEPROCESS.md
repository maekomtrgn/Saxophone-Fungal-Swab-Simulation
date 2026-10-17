# Saxophone Fungal Growth & Swab Efficacy Simulation

## 📖 Project Overview
This repository contains a computational model to simulate the growth of **dematiaceous molds** (specifically *Phialophora richardsiae*) within the internal environment of a saxophone. The primary goal is to understand fungal biomass accumulation over time and evaluate the effectiveness of standard cleaning protocols (swabbing 1 to 5 times).

The outputs of this simulation are intended to generate quantitative data to derive **System Design Requirements** for novel prevention strategies (e.g., antimicrobial materials, improved swabs) or diagnosis solutions (e.g., sensor detection thresholds).

## 🧬 The Biological Model
Based on literature review and environmental mapping (see `docs/mindmap.jpg`), the saxophone presents an ideal ecosystem for fungal growth:
*   **Moisture:** Condensation and saliva create a high Relative Humidity (RH > 70-90%).
*   **Temperature:** The instrument sits at room temperature (~25°C), which is optimal for many molds.
*   **Substrate:** Saliva, food particles, and organic debris trapped in the bore provide nutrients.

### Target Organism Constants
*   **Species:** *Phialophora richardsiae*
*   **Optimal Growth Temp:** 25°C
*   **Radial Growth Rate:** ~0.35 cm/day
*   **Swab Efficacy (η):** 0.60 (60% removal per swab, assuming a high-efficiency flocked nylon swab; traditional swabs may be as low as 0.20).

## 🧮 Mathematical Framework

### 1. Fungal Growth (Logistic Growth Model)
Fungal growth on the instrument's inner surface is modeled using a logistic differential equation to account for resource limits (carrying capacity).
\[
 \frac{dB}{dt} = r \cdot B \cdot \left(1 - \frac{B}{K}\right) 
\]
*   \(B\): Fungal biomass
*   \(r\): Intrinsic growth rate (derived from radial growth)
*   \(K\): Carrying capacity of the saxophone bore

### 2. Swabbing Removal (Discrete Event)
Swabbing removes a fraction of the fungal biomass. Multiple swabs exponentially decrease the remaining biomass.
\[
 B_{\text{after n swabs}} = B_{\text{before}} \cdot (1 - \eta)^n 
\]
*   \(\eta\): Swab efficacy (0.60)
*   \(n\): Number of consecutive swabs (1 to 5)

## 📂 Repository Structure
```text
saxophone-fungal-swab-simulation/
│
├── README.md                 # Project overview and instructions
├── docs/                     # Literature review, constants, and mind maps
│   ├── constants_matrix.xlsx # Sourced constants (Temp, RH, Growth rates)
│   └── mindmap.jpg           # Ecosystem mapping
│
├── src/                      # MATLAB source code
│   ├── define_parameters.m   # Sets up constants (r, K, eta)
│   ├── growth_model.m        # ODE function for logistic growth
│   ├── swab_model.m          # Function for swab removal logic
│   └── main_simulation.m     # Master script to run and plot scenarios
│
└── results/                  # Generated plots and data
    └── .gitkeep
