# MermaidCereal
N-body magnetocapillary code and simulation data

## Introduction
This code complements the article "Mermaid Cereal: Interactions and Pattern Formation in a Macroscopic Magnetocapillary SALR System" at FILL IN. This code is used to simulate magnetocapillary interactions in both confined and periodic geometries. For the code provided, a collection of $n$ disks are evolved through time which are able to interact with one another via capillary and magnetic effects.

Sample final configurations for various packing fractions are available to highlight the pattern formation which occurs due to the interaction potential having competing attractive (capillary) and repulsive (magnetic) effects.

## Setup and Usage
For this project, we focused on simulating magnetocapillary interactions in both confined and periodic geometries. For each of the scenarios, 2 Matlab functions and 2 Matlab scripts are provided to set up, simulate, and visualize the pattern formation which arise as a function of system parameters, packing fraction, and boundary geometry.
### Confinement Code
The following description outlines simulating magnetocapillary interactions when confined in a circular geometry.
#### Setup
The setup necessary for the confinement code is found in $\mathtt{init_cond_maker}$ and $\mathtt{motion_nbod_confine}$. When initializing our set of ODEs to evolve, we need to provide $2n$ initial positions ($x$ and $y$ components for each of the $n$ disks). $\mathtt{init_cond_maker}$ is an algorithm which randomly chooses initial positions from a circle of radius $R$ for $n$ disks of radius $a$. The positions are chosen sequentially with the position of the next disk chosen both randomly but also with the additional constraint that it cannot overlap with an already placed disk. This is to ensure that the simulation is realistic to experiment where the disks cannot overlap. As the packing fraction / number of disks increases, this step in running the simulation acts as the bottleneck given that it becomes increasingly challenging to place the next disk as less and less space is available to be placed in.

The bulk of the setup if found in $\mathtt{motion_nbod_confine}$ which takes in all of the experiment parameters related to the disks and bath. The code is written more generally to compute the forces and torques on a set of $n$ ellipses which are interacting with a magnetocapillary potential. For the scope of this project, we focused on disks. However, future work with non-axissymetric geometries can easily be explored with the framework provided here. A vectorization approach is used to quickly compute the pairwise forces experienced between disks. As an artifact of preparing for more generalized shapes in future work, additional precautions are embedded in the code to ensure that self interaction forces are identically zero (where a particle represented as a collection of disks could erroneously recieve nonzero force from itself). Finally, confinement effects are handled using the potential found in FILL IN EQUATION of the accompying paper. $\mathtt{motion_nbod_confine}$ outputs a vector of size $2n$ in the appropriate format to be fed-in to one of Matlab's built-in ODE solvers. Given our range of parameters used, $\mathtt{ODE45}$ was sufficient however stiffer solvers like $\mathtt{ODE23s}$ could be used at the expense of longer computational times.
#### Simulate
To simulate over time the evolution of a collection of interacting magnetocapillary disks, the script $\mathtt{main_mermaid_code_confinement}$ is used. Here, the code is written to allow for batches of results to be gathered at once. The user can provide a vector different amount of disks to simulate (which corresponds to a packing fraction) with the number of simulations indicating the number of times to run a specific number of disks. The code provided has an example set of experimental parameters which were used for the results displayed in Figure 3. The code outputs '.mat' files which are named after the number of disks simulated. 
#### Visualize
To visualize the final configurations which are outputted after running the built-in ODE solver, $\mathtt{end_config_plots_confine}$ is used. Here, the final configuration is shown with options to directly save the Matlab figures whilst running the script in a variety of formats.
### Periodic Code
#### Setup
#### Simulate
#### Visualize
