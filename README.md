
## Introduction
`BSTModelKit.jl` is a package for constructing, solving, and analyzing Biochemical Systems Theory (BST) models of biochemical networks written in the [Julia](https://julialang.org) programming language. In particular, `BSTModelKit.jl` provides a set of tools for constructing and solving S-system BST representations of the form:

$$
\frac{dX_{i}}{dt} = \alpha_{i}\prod_{j\in\mathcal{P}}X_{j}^{g_{ij}} - \beta_{i}\prod_{j\in\mathcal{R}}X_{j}^{h_{ij}}\qquad{i=1,\dots,n}
$$

where $X_{i}$ is the concentration of the species $i$, the values $\alpha_{i}$ and $\beta_{i}$ are kinetic parameters (rate constants), $\mathcal{P}$ is the set of species that produce $X_{i}$, $\mathcal{R}$ is the set of species that consume $X_{i}$, and $g_{ij}$ and $h_{ij}$ are the kinetic order coefficients relating species $i$ and $j$. 

The S-system BST representation was developed by [Savageau, Voit, and coworkers](https://en.wikipedia.org/wiki/Michael_Antonio_Savageau). For a nice introduction to the S-system representation of BST, see:

* [Savageau M, Voit E, Irvine D. Biochemical systems theory and metabolic control theory: 1. fundamental similarities and differences. Math Biosci. 1987 86(2): 127-45. doi.org/10.1016/0025-5564(87)90007-1.](https://www.sciencedirect.com/science/article/pii/0025556487900071)
* [Savageau M. Biochemical systems analysis: a study of function and design in molecular biology. Reading, MA: Addison-Wesley; 1976.](https://www.amazon.com/Biochemical-Systems-Analysis-Function-Molecular/dp/1449590764/ref=sr_1_1?crid=1MRBJ5U79CTTH&keywords=Biochemical+systems+analysis&qid=1690469004&sprefix=biochemical+systems+analysis%2Caps%2C69&sr=8-1)

Finally, `BSTModelKit.jl` is a research code, expect there will be (many) bugs, breaking changes (often), etc. 

## Installation and Requirements
`BSTModelKit.jl` can be installed, updated, or removed using the [Julia package management system](https://docs.julialang.org/en/v1/stdlib/Pkg/). To access the package management interface, open the [Julia REPL](https://docs.julialang.org/en/v1/stdlib/REPL/), and start the package mode by pressing `]`.
While in package mode, to install `BSTModelKit.jl`, issue the command:

    (@v1.9.x) pkg> add BSTModelKit

To use `BSTModelKit.jl` in your projects, issue the command:

    julia> using BSTModelKit

## Documentation
Documentation for the `BSTModelKit.jl` package can be found [here](https://varnerlab.github.io/BSTModelKitDocumentation/landing.html).

### Funding
The work described here was supported by the following grants: The Interaction of Basal Risk, Pharmacological Ovulation Induction, Pregnancy and Delivery on Hemostatic Balance  NIH NHLBI R-33 HL 141787 (PI’s [Bernstein](https://www.uvmhealth.org/medcenter/provider/ira-m-bernstein-md) , [Orfeo](https://www.med.uvm.edu/biochemistry/lab_orfeo_research)) and the Pregnancy Phenotype and Predisposition to Preeclampsia NIH NHLBI R01 HL 71944 (PI [Bernstein](https://www.uvmhealth.org/medcenter/provider/ira-m-bernstein-md)).

### Disclaimer
This software is proved "AS IS" without warranty of any kind, express or implied, including but not limited to warranties of merchantability, fitness for a particular purpose, and non-infringement. In no event shall the authors or copyright holders be liable for any claim, damages, or other liability, whether in action or contract, tort or otherwise, arising from, out of, or in connection with the software or the use of other dealings in the software.