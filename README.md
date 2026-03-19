# BSTModelKit.jl

[![CI](https://github.com/varnerlab/BSTModelKit.jl/actions/workflows/varnerlab.yml/badge.svg)](https://github.com/varnerlab/BSTModelKit.jl/actions/workflows/varnerlab.yml)
[![Documentation](https://img.shields.io/badge/docs-latest-blue.svg)](https://varnerlab.github.io/BSTModelKit.jl/dev/)

`BSTModelKit.jl` is a [Julia](https://julialang.org) package for constructing, solving, and analyzing Biochemical Systems Theory (BST) models of biochemical networks. It provides tools for constructing and solving S-system BST representations of the form:

$$\frac{dX_{i}}{dt} = \alpha_{i}\prod_{j\in\mathcal{P}}X_{j}^{g_{ij}} - \beta_{i}\prod_{j\in\mathcal{R}}X_{j}^{h_{ij}}\qquad{i=1,\dots,n}$$

where $X_{i}$ is the concentration of species $i$, the values $\alpha_{i}$ and $\beta_{i}$ are kinetic parameters (rate constants), $\mathcal{P}$ is the set of species that produce $X_{i}$, $\mathcal{R}$ is the set of species that consume $X_{i}$, and $g_{ij}$ and $h_{ij}$ are the kinetic order coefficients. The S-system representation was developed by [Savageau, Voit, and coworkers](https://en.wikipedia.org/wiki/Michael_Antonio_Savageau).

## Features
* Build BST models from `.toml`, `.bst`, or `.jld2` files
* Simulate dynamic trajectories via ODE integration
* Compute steady-state solutions
* Perform global sensitivity analysis (Morris and Sobol methods)
* Save and load models in binary (JLD2) format

## Installation
`BSTModelKit.jl` requires Julia 1.8 or later. Install using the Julia package manager:

```julia
] add BSTModelKit
```

## Quick Start

```julia
using BSTModelKit

# build a model from a TOML file
model = build("path/to/Feedback.toml");

# set initial conditions and parameters
model.initial_condition_array = [10.0, 0.1, 0.1, 1.1, 0.0];
model.static_factors_array = [0.1, 0.1, 0.1];
model.α = [0.0, 10.0, 10.0, 10.0, 0.1, 0.1];

# simulate
(T, X) = evaluate(model);

# or compute steady state
XSS = steadystate(model);
```

## Documentation
Full documentation is available [here](https://varnerlab.github.io/BSTModelKit.jl/dev/).

## References
* [Savageau M, Voit E, Irvine D. Biochemical systems theory and metabolic control theory: 1. fundamental similarities and differences. Math Biosci. 1987 86(2): 127-45.](https://www.sciencedirect.com/science/article/pii/0025556487900071)
* [Savageau M. Biochemical systems analysis: a study of function and design in molecular biology. Reading, MA: Addison-Wesley; 1976.](https://www.amazon.com/Biochemical-Systems-Analysis-Function-Molecular/dp/1449590764)

## Funding
The work described here was supported by the following grants:
* The Interaction of Basal Risk, Pharmacological Ovulation Induction, Pregnancy and Delivery on Hemostatic Balance NIH NHLBI R-33 HL 141787 (PI's [Bernstein](https://www.uvmhealth.org/medcenter/provider/ira-m-bernstein-md), [Orfeo](https://www.med.uvm.edu/biochemistry/lab_orfeo_research))
* The Pregnancy Phenotype and Predisposition to Preeclampsia NIH NHLBI R01 HL 71944 (PI [Bernstein](https://www.uvmhealth.org/medcenter/provider/ira-m-bernstein-md))

## Disclaimer
This software is provided "AS IS" without warranty of any kind, express or implied, including but not limited to warranties of merchantability, fitness for a particular purpose, and non-infringement. In no event shall the authors or copyright holders be liable for any claim, damages, or other liability, whether in action or contract, tort or otherwise, arising from, out of, or in connection with the software or the use of other dealings in the software.
