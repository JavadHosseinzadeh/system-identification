# System Identification and Model Estimation

This repository includes various MATLAB scripts for system identification, model estimation, and performance evaluation using four different methodologies. This project encompasses system identification techniques using recursive, iterative, and neural network-based approaches.

## Part I: Transfer Function Estimation and Discretization
This part provides the development of a state-space and transfer function model of the system. It studies the system responses based on impulse, step, and frequency-domain analyses.

* **Key Files**: `Main.m`, `simulink_non.slx`
* **Features**:
- Derivation of transfer function from state-space
  - Continuous and discrete system analysis
  - Step response, impulse response, and Bode plots

## Part II: Correlation Methods for System Identification
The following part will apply the autocorrelation and cross-correlation methods in identifying the system and estimating the impulse responses from the input-output data of the system.

- **Key Files**: `Zmatrix.m`, `Autocorrel.m`, `Crosscorrel.m`, `Rxxmatrix.m`, `DMatrix.m`
- **Features**:
  - Impulse response estimation from the correlation matrices
- Plotting real vs estimated impulse responses

## Part III: Recursive and Iterative System Identification
This part covers recursive methods such as RLS, RIV, RELS etc. These methods estimate the parameters of the system in a real-time iterative fashion.
**Key Files:** `main.m`, `OPA.m`, `RLS.m`, `RIV.m`, `RELS.m`, `IGLS.m`
**Features:**
-Real time estimation of system parameters using recursive methods
- Covariance analysis for parameter uncertainty
  - Several different iterative procedures, IGLS and RML among them

## Part IV: Advanced Methods and Neural Networks
This chapter provides implementations of advanced system identification methods such as Stochastic Approximation (SA) and the use of Neural Networks (NN) to predict system dynamics. Recursive Least Squares methods are tried out for models of different orders.

- **Key Files**: `NN_Response.m`, `RLS1.m`, `RLS2.m`, `RLS3.m`, `ch9.m`, `ch10.m`
- **Features**:
Neural network-based system identification
Recursive Least Squares applied to systems of increasing order
Model evaluation by using AIC, fit, variance and R-squared methods

## Running the Code
To execute each part, just run the appropriate `main.m` file.
Comparisons between real system data and estimated models from the project show the performance of each method.
