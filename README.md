# meng-pv
This is the code repository for the PV power converter reliability MEng project completed April 2022.

Folder `assets` includes a version of the paper post-hand-in, pre-submission for publication. It is recommended to read that first before trying to understand this code.

All code written in MATLAB 2021b. 

![Project workflow](/assets/fig3.jpg)

## Usage

1. Use `nrel2mat` to generate data for training/testing of neural network models and Simulink model
2. Run `PV_model_final_02` on input data (possibly using `run_simulation` to run multiple) to get output of junction temperatures
3. Use `combo` to run training and testing of neural network models and output results

Once you open the code, you will notice that there a lot of dependices on other functions. It was easier/simpler to write code for a single usage, turn it into a function, then use that function many times in a 'higher level' script.

The approximate heirarchy goes: 
`'combo' > 'bestnet' > 'bulktrain' > 'training' > 'simanalysis' > 'lifetime_consumption'`
and 
`'combo' > 'bulktest' > 'testing'`

## PV_model_final_02

* Simulink .slx file of modelled grid connected 10 kW PV system with boost converter MPPT. 
* Note: Runs only on MATLAB 2020a. Developed on MATLAB 2021b, then ported back to 2020a to work on department computers.

## nrel2mat

* Extract NREL irradiance and temperature data from a text file downloaded form [here](https://midcdmz.nrel.gov/apps/sitehome.pl?site=BMS) into 'useful' .mat files.

## training_analysis

* Display a plot of the whole downloaded NREL text file with corresponding day numbers. 
* Useful for searching for specific environmental conditions in a lot of data. 
* The corresponding day numbers can then be used in nrel2mat.

## run_simulation

* Run multiple simulations back to back, loading each input and saving each output as required. 
* Makes it easier to run many simulations, as they can be running when the department is inaccesible.

## combo

* An all-in-one script for the total training and testing of neural networks. 
* See section `Usage` above for function heirarchy.
* Call `bestnet` to train networks
* Test trained networks
* Print results

## bestnet

* Passes number of full training & testing iterations (netnum) to bulktrain function
* Call `bulktrain` for each set of networks: Normal, ATC1, ATC2
* Save all data to be used by combo/displayed by user

## bulktrain

* For amount of iterations set by netnum, call training function
* If network is better than previous best, replace and save network and details

## training

* Settings for neural network layer structure and other training specifics
* Train an LC and EG regression neural network 
* Pass back to higher function
* If not already done: run `simanalysis` on Simulink model results to generate network target values (code commented at this time)

## simanalysis

* Play around with inputted data to create 1 minute boundaries of data to pass to `lifetime_consumption`
* Call `lifetime_consumption`
* Output data array ready for network training, with irradiance, temperatures, lifetime consumption and energy generated

## lifetime_consumption

* Find peaks and valleys of inputted data to clean up non-important temperature cycles
* Apply a rainflow counting algorithm to cleaned data to extract cycles
* Calculate lifetime consumption value of each cycle
* Sum all cycle LC values and return

## bulktest

* Call `testing` function on specified network and weather type
* Create a normalised table of results from testing

## testing

* Load network and testing data based on input
* Predict values, rescale output and sum
* Return values back to higher function
