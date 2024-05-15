# Declare an anstract parent type -
abstract type AbstractBSTModel end

# concrete subtypes -

"""
    mutable struct BSTModel <: AbstractBSTModel

Mutable holding structure for the BST model object. This object is used to store all the data that is needed to simulate the model.
The object is passed to the `evaluate` function to simulate the model. A `BSTModel` object is created using the `build` function.

### Fields
- `number_of_dynamic_states::Int64`: The number of dynamic states in the model.
- `number_of_static_states::Int64`: The number of static states in the model.
- `list_of_dynamic_species::Array{String,1}`: A list of the dynamic species in the model.
- `list_of_static_species::Array{String,1}`: A list of the static species in the model.
- `list_of_reactions::Array{String,1}`: A list of the reactions in the model.
- `total_species_list::Array{String,1}`: A list of all the species in the model.
- `static_factors_array::Array{Float64,1}`: A list of the static factors in the model.
- `initial_condition_array::Array{Float64,1}`: A list of the initial conditions for the dynamic states.
- `S::Array{Float64,2}`: The stoichiometry matrix.
- `G::Array{Float64,2}`: The exponent matrix.
- `α::Array{Float64,1}`: The rate constant vector.

### Metadata fields
- `author::String`: The author of the model.
- `version::String`: The version of the model.
- `date::String`: The date the model was created.
- `description::String`: A description of the model.
"""
mutable struct BSTModel <: AbstractBSTModel

    # data -
    number_of_dynamic_states::Int64
    number_of_static_states::Int64
    list_of_dynamic_species::Array{String,1}
    list_of_static_species::Array{String,1}
    list_of_reactions::Array{String,1}
    total_species_list::Array{String,1}
    static_factors_array::Array{Float64,1}
    initial_condition_array::Array{Float64,1}
    S::Array{Float64,2}
    G::Array{Float64,2}
    α::Array{Float64,1}

    # metadata -
    author::String
    version::String
    date::String
    description::String

    # constructor -
    BSTModel() = new()
end