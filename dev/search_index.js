var documenterSearchIndex = {"docs":
[{"location":"functions/#Functions","page":"Functions","title":"Functions","text":"","category":"section"},{"location":"functions/#Models","page":"Functions","title":"Models","text":"","category":"section"},{"location":"functions/","page":"Functions","title":"Functions","text":"BSTModelKit.jl provides a set of tools for constructing and solving S-system BST representations. Models are represented by the BSTModel type, which is a mutable composite type holding information about the model structure and parameters:","category":"page"},{"location":"functions/","page":"Functions","title":"Functions","text":"BSTModelKit.BSTModel","category":"page"},{"location":"functions/#BSTModelKit.BSTModel","page":"Functions","title":"BSTModelKit.BSTModel","text":"mutable struct BSTModel <: AbstractBSTModel\n\nMutable holding structure for the BST model object. This object is used to store all the data that is needed to simulate the model. The object is passed to the evaluate function to simulate the model. A BSTModel object is created using the build function.\n\nFields\n\nnumber_of_dynamic_states::Int64: The number of dynamic states in the model.\nnumber_of_static_states::Int64: The number of static states in the model.\nlist_of_dynamic_species::Array{String,1}: A list of the dynamic species in the model.\nlist_of_static_species::Array{String,1}: A list of the static species in the model.\nlist_of_reactions::Array{String,1}: A list of the reactions in the model.\ntotal_species_list::Array{String,1}: A list of all the species in the model.\nstatic_factors_array::Array{Float64,1}: A list of the static factors in the model.\ninitial_condition_array::Array{Float64,1}: A list of the initial conditions for the dynamic states.\nS::Array{Float64,2}: The stoichiometry matrix.\nG::Array{Float64,2}: The exponent matrix.\nα::Array{Float64,1}: The rate constant vector.\n\nMetadata fields\n\nauthor::String: The author of the model.\nversion::String: The version of the model.\ndate::String: The date the model was created.\ndescription::String: A description of the model.\n\n\n\n\n\n","category":"type"},{"location":"functions/","page":"Functions","title":"Functions","text":"Models can be constructed from a variety of file formats in combination with the build function:","category":"page"},{"location":"functions/","page":"Functions","title":"Functions","text":"BSTModelKit.build","category":"page"},{"location":"functions/#BSTModelKit.build","page":"Functions","title":"BSTModelKit.build","text":"build(path::String) -> BSTModel\n\nThis function is used to build a BSTModel object from a model file. The model file can be in one of the following formats: bst, txt, jld2, dat, net, toml. The function will parse the file and build the model object.\n\nArguments\n\npath::String: The path to the model file.\n\nReturns\n\nA BSTModel object. See the BSTModel documentation for more information on the fields of the model object.\n\n\n\n\n\n","category":"function"},{"location":"functions/","page":"Functions","title":"Functions","text":"Once a model instance is constructed, it can be saved to a file or loaded from a file using the savemodel and loadmodel functions:","category":"page"},{"location":"functions/","page":"Functions","title":"Functions","text":"BSTModelKit.loadmodel\nBSTModelKit.savemodel","category":"page"},{"location":"functions/#BSTModelKit.loadmodel","page":"Functions","title":"BSTModelKit.loadmodel","text":"loadmodel(path::String) -> AbstractBSTModel\n\nThis function is used to load a BSTModel object from a file. The file can be in one of the following formats: JLD2. The function will load the model object from the file specified by the path argument.\n\nArguments\n\npath::String: The path to the file where the model object will be loaded from.\n\nReturns\n\nA BSTModel object that was loaded from the file.\n\n\n\n\n\n","category":"function"},{"location":"functions/#BSTModelKit.savemodel","page":"Functions","title":"BSTModelKit.savemodel","text":"savemodel(path::String, model::T) -> Bool where T <: AbstractBSTModel\n\nThis function is used to save a BSTModel object to a file. The file can be in one of the following formats: JLD2. The function will save the model object to the file specified by the path argument.\n\nArguments\n\npath::String: The path to the file where the model object will be saved.\nmodel::T: The BSTModel object that will be saved to the file.\n\nReturns\n\nA boolean indicating if the model object was saved successfully.\n\n\n\n\n\n","category":"function"},{"location":"functions/#Solving","page":"Functions","title":"Solving","text":"","category":"section"},{"location":"functions/","page":"Functions","title":"Functions","text":"BSTModelKit.evaluate\nBSTModelKit.steadystate","category":"page"},{"location":"functions/#BSTModelKit.evaluate","page":"Functions","title":"BSTModelKit.evaluate","text":"evaluate(model::BSTModel; tspan::Tuple{Float64,Float64} = (0.0,20.0), Δt::Float64 = 0.01, \n    input::Union{Nothing,Function} = nothing) -> Tuple{Array{Float64,1}, Array{Float64,2}}\n\nThis function is used to evaluate the model object that has been built using the build function.  The evaluate function will return a tuple with two elements: a vector of time points and a matrix of state values.\n\nArguments\n\nmodel::BSTModel: A model object that has been built using the build function.\ntspan::Tuple{Float64,Float64}: A tuple that defines the time span for the simulation. The default is (0.0,20.0).\nΔt::Float64: The time step for the simulation. The default is 0.01.\ninput::Union{Nothing,Function}: An optional input function that can be used to drive the simulation. The default is nothing.\n\nReturns\n\nA tuple with two elements:\nArray{Float64,1}: A vector of time points.\nArray{Float64,2}: A matrix of state values.\n\n\n\n\n\n","category":"function"},{"location":"functions/#BSTModelKit.steadystate","page":"Functions","title":"BSTModelKit.steadystate","text":"steadystate(model::BSTModel; tspan::Tuple{Float64,Float64} = (0.0,20.0), Δt::Float64 = 0.01, input::Union{Nothing,Function} = nothing) -> Array{Float64,1}\n\nThe steadystate function is used to evaluate the steady state of the model object that has been built using the build function.\n\nArguments\n\nmodel::BSTModel: A model object that has been built using the build function.\ntspan::Tuple{Float64,Float64}: A tuple that defines the time span for the simulation. The default is (0.0,20.0).\nΔt::Float64: The time step for the simulation. The default is 0.01.\ninput::Union{Nothing,Function}: An optional input function that can be used to drive the simulation. The default is nothing.\n\nReturns\n\nA vector of state values that represent the steady state of the system.\n\n\n\n\n\n","category":"function"},{"location":"functions/#Sensitivity-Analysis","page":"Functions","title":"Sensitivity Analysis","text":"","category":"section"},{"location":"functions/","page":"Functions","title":"Functions","text":"BSTModelKit.sobol\nBSTModelKit.morris","category":"page"},{"location":"functions/#BSTModelKit.sobol","page":"Functions","title":"BSTModelKit.sobol","text":"sobol(performance::Function, L::Array{Float64,1}, U::Array{Float64,1}; \n    number_of_samples::Int64 = 1000, orders::Array{Int64,1} = [0, 1, 2])\n\nThe sobol function is a wrapper around the gsa function that uses the Sobol method to perform a global sensitivity analysis.\n\nArguments\n\nperformance::Function: a function that takes a vector of parameters and returns a scalar performance metric.\nL::Array{Float64,1}: a vector of lower bounds for the parameters.\nU::Array{Float64,1}: a vector of upper bounds for the parameters.\nnumber_of_samples::Int64: the number of samples to use in the analysis.\norders::Array{Int64,1}: the orders of sensitivity to compute.\n\nReturns\n\na SobolResult object.\n\n\n\n\n\n","category":"function"},{"location":"functions/#BSTModelKit.morris","page":"Functions","title":"BSTModelKit.morris","text":"morris(performance::Function, L::Array{Float64,1}, U::Array{Float64,1}; \n    number_of_samples::Int64 = 1000) -> Array{Float64,2}\n\nThe morris function is a wrapper around the gsa function that uses the Morris method to perform a global sensitivity analysis.\n\nArguments\n\nperformance::Function: a function that takes a vector of parameters and returns a scalar performance metric.\nL::Array{Float64,1}: a vector of lower bounds for the parameters.\nU::Array{Float64,1}: a vector of upper bounds for the parameters.\nnumber_of_samples::Int64: the number of samples to use in the analysis.\n\nReturns\n\na matrix of results where the first column is the mean and the second column is the variance of the sensitivity analysis.\n\n\n\n\n\n","category":"function"},{"location":"functions/#Utility","page":"Functions","title":"Utility","text":"","category":"section"},{"location":"functions/","page":"Functions","title":"Functions","text":"BSTModelKit.indexin","category":"page"},{"location":"functions/#Base.indexin","page":"Functions","title":"Base.indexin","text":"indexin(dd::Dict{String,Any},species_symbol::String; \n    key=\"total_species_list\")::Union{Nothing,Int}\n\nThe indexin function is a utility function that returns the index of a species in the total species list of a model.\n\nArguments\n\ndd::Dict{String,Any}: a dictionary that contains the model data.\nspecies_symbol::String: the symbol of the species to find.\nkey::String: the key in the dictionary that contains the total species list.\n\nReturns\n\nan integer that represents the index of the species in the total species list, or nothing if the species is not found.\n\n\n\n\n\n","category":"function"},{"location":"examples/#Examples","page":"Examples","title":"Examples","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"Coming soon...","category":"page"},{"location":"#BSTModelKit.jl","page":"Home","title":"BSTModelKit.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"BSTModelKit.jl is a package for constructing, solving, and analyzing Biochemical Systems Theory (BST) models of biochemical networks written in the Julia programming language. In particular, BSTModelKit.jl provides a set of tools for constructing and solving S-system BST representations of the form:","category":"page"},{"location":"","page":"Home","title":"Home","text":"beginequation*\nfracdX_idt = alpha_iprod_jinmathcalPX_j^g_ij - beta_iprod_jinmathcalRX_j^h_ijqquadi=1dotsn\nendequation*","category":"page"},{"location":"","page":"Home","title":"Home","text":"where X_i is the concentration of the species i, the values alpha_i and beta_i are kinetic parameters (rate constants), mathcalP is the set of species that produce X_i, mathcalR is the set of species that consume X_i, and g_ij and h_ij are the kinetic order coefficients relating species i and j. ","category":"page"},{"location":"","page":"Home","title":"Home","text":"The S-system BST representation was developed by Savageau, Voit, and coworkers. For a nice introduction to the S-system representation, see:","category":"page"},{"location":"","page":"Home","title":"Home","text":"Savageau M, Voit E, Irvine D. Biochemical systems theory and metabolic control theory: 1. fundamental similarities and differences. Math Biosci. 1987 86(2): 127-45. doi.org/10.1016/0025-5564(87)90007-1.\nSavageau M. Biochemical systems analysis: a study of function and design in molecular biology. Reading, MA: Addison-Wesley; 1976.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Finally, BSTModelKit.jl is a research code, expect there will be (many x 1000) bugs, breaking changes (often), etc. ","category":"page"},{"location":"#Installation-and-Requirements","page":"Home","title":"Installation and Requirements","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"BSTModelKit.jl can be installed, updated, or removed using the Julia package management system. To access the package management interface, open the Julia REPL, and start the package mode by pressing ]. While in package mode, to install BSTModelKit.jl, issue the command:","category":"page"},{"location":"","page":"Home","title":"Home","text":"(@v1.1.x) pkg> add BSTModelKit","category":"page"},{"location":"","page":"Home","title":"Home","text":"To use BSTModelKit.jl in your projects, issue the command:","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> using BSTModelKit","category":"page"},{"location":"#Funding","page":"Home","title":"Funding","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"The work described here was supported by the following grants: ","category":"page"},{"location":"","page":"Home","title":"Home","text":"The Interaction of Basal Risk, Pharmacological Ovulation Induction, Pregnancy and Delivery on Hemostatic Balance  NIH NHLBI R-33 HL 141787 (PI’s Bernstein , Orfeo) and \nThe Pregnancy Phenotype and Predisposition to Preeclampsia NIH NHLBI R01 HL 71944 (PI Bernstein).","category":"page"},{"location":"#Disclaimer","page":"Home","title":"Disclaimer","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This software is proved \"AS IS\" without warranty of any kind, express or implied, including but not limited to warranties of merchantability, fitness for a particular purpose, and non-infringement. In no event shall the authors or copyright holders be liable for any claim, damages, or other liability, whether in action or contract, tort or otherwise, arising from, out of, or in connection with the software or the use of other dealings in the software.","category":"page"}]
}
