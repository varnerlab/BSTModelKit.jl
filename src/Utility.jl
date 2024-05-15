import Base.indexin

"""
    indexin(dd::Dict{String,Any},species_symbol::String; 
        key="total_species_list")::Union{Nothing,Int}

The `indexin` function is a utility function that returns the index of a species in the total species list of a model.

### Arguments
- `dd::Dict{String,Any}`: a dictionary that contains the model data.
- `species_symbol::String`: the symbol of the species to find.
- `key::String`: the key in the dictionary that contains the total species list.

### Returns
- an integer that represents the index of the species in the total species list, or `nothing` if the species is not found.

"""
function indexin(dd::Dict{String,Any},species_symbol::String; 
    key="total_species_list")::Union{Nothing,Int}

    # get the total species list -
    if (haskey(dd,key) == false)
        return nothing
    end
    total_species_list = dd[key]

    # check -
    return findfirst(x->x==species_symbol,total_species_list)
end