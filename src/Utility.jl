import Base.indexin

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