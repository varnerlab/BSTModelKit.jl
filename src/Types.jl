# Declare an anstract parent type -
abstract type AbstractBSTModel end

# concrete subtypes -
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