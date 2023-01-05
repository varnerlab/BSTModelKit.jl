import Base.+


## ===== PRIVATE METHODS BELOW HERE ============================================================= ##
function +(buffer::Array{String,1}, line::String)
    push!(buffer, line)
end

function _parse_species_record(buffer::Array{String,1})::Array{String,1}

    # initialize -
    species_symbol_array = Array{String,1}()

    # main -
    for line ∈ buffer

        # split around the ,
        tmp_array = String.(split(line, ","))

        for species ∈ tmp_array

            species_symbol_string = species |> lstrip |> rstrip
            if (in(species_symbol_string, species_symbol_array) == false)
                push!(species_symbol_array, species_symbol_string)
            end
        end
    end

    return species_symbol_array
end

function _parse_structure_section(buffer::Array{String,1})::Array{Dict{String,Any}}

    # initialize -
    record_array = Array{Dict{String,Any},1}()

    for line ∈ buffer

        # split around the :: 
        record_components = String.(split(line, "::"))
        
        # First component is the name -
        name = record_components[1]

        # the second component is a structure like {x} --> {y}
        original_structure_phrase = record_components[2]
        original_structure_phrase = replace(original_structure_phrase, "{" => "", "}" => "")

        # split around the --> symbol
        left_phrase = rstrip.(lstrip.(String.(split(original_structure_phrase,"-->"))))[1]
        right_phrase = rstrip.(lstrip.(String.(split(original_structure_phrase,"-->"))))[2]

        # now, we can have a , in the left or right record, run the spit one more time for a ,
        left_phase_species_list = split(left_phrase,",")
        right_phase_species_list = split(right_phrase,",")

        # add -
        tmp_dict = Dict{String,Any}()
        tmp_dict["name"] = name

        # process reactants -
        for factor ∈ left_phase_species_list
            tmp_dict[factor] = -1.0
        end
        
        # process products -
        for prod ∈ right_phase_species_list
            tmp_dict[prod] = 1.0
        end

        # store -
        push!(record_array, tmp_dict)
    end

    # return -
    return record_array
end

function _parse_rate_section(buffer::Array{String,1})::Array{Dict{String,Any}}

    # initialize -
    record_array = Array{Dict{String,Any},1}()

    for record ∈ buffer

        # slpit around ::
        record_components = String.(split(record, "::"))

        # process each component -
        name = record_components[1]
        factors = record_components[2]

        # factors are a set of stuff, so we need to split around the ,
        factor_list = factors[2:end-1] # this get's rid of the {}
        factor_list_components = String.(split(factor_list, ","))

        # ok, let's rock ...
        tmp_dict = Dict{String,Any}()
        tmp_dict["name"] = name
        for factor ∈ factor_list_components
            tmp_dict[factor] = 1.0
        end

        # grab -
        push!(record_array, tmp_dict)
    end

    # return -
    return record_array
end

function _parse_stoichiometry_section(buffer::Array{String,1})::Dict{Tuple{String, String}, Float64}

    # initialize -
    records_dictionary = Dict{Tuple{String, String}, Float64}();

    # main -
    for record ∈ buffer
        
        # 

        # check: what kind of record is this?
        if (occursin("{", record) == true || occursin("}", record) == true)
            
            # sometype of group record -
            # ....

        else

            # old school record
            # rxn, species, coeff
            
            # split around the ","
            record_components = split(record, ",")
            reaction_name = record_components[1];
            species_name = record_components[2];
            coeff_value = record_components[3];

            # build the key, and then store in dict -
            key_tuple = (reaction_name, species_name);
            records_dictionary[key_tuple] = parse(Float64, coeff_value);
        end
    end

    # return -
    return records_dictionary;
end

function _build_stoichiometric_matrix(list_of_dynamic_species::Array{String,1},
    reactions::Array{Dict{String,Any}})::Array{Float64,2}

    # initialize -
    ℳ = length(list_of_dynamic_species)
    ℛ = length(reactions)
    S = zeros(ℳ, ℛ)

    for species_index ∈ 1:ℳ

        # get the species -
        species_symbol = list_of_dynamic_species[species_index]

        for reaction_index = 1:ℛ

            reaction_dictionary = reactions[reaction_index]
            if (haskey(reaction_dictionary, species_symbol) == true)
                S[species_index, reaction_index] = reaction_dictionary[species_symbol]
            end
        end
    end

    # return -
    return S
end

function _build_exponent_matrix(list_of_factors::Array{String,1},
    reaction_factors::Array{Dict{String,Any}})

    # initialize -
    ℳ = length(list_of_factors)
    ℛ = length(reaction_factors)
    factor_matrix = zeros(ℳ, ℛ)

    # main -
    for (i, f) ∈ enumerate(list_of_factors)
        for (j, d) ∈ enumerate(reaction_factors)

            # ok: so in this d, to we have f?
            if (haskey(d, f) == true)
                factor_matrix[i, j] = d[f]
            end
        end
    end

    # return -
    return factor_matrix
end

function _extract_model_section(file_buffer_array::Array{String,1},
    start_section_marker::String, end_section_marker::String)

    # initialize -
    section_buffer = String[]

    # find the SECTION START AND END -
    section_line_start = 1
    section_line_end = 1
    for (index, line) in enumerate(file_buffer_array)

        if (occursin(start_section_marker, line) == true)
            section_line_start = index
        elseif (occursin(end_section_marker, line) == true)
            section_line_end = index
        end
    end

    for line_index = (section_line_start+1):(section_line_end-1)
        line_item = file_buffer_array[line_index]
        push!(section_buffer, line_item)
    end

    if (isempty(section_buffer) == true)
        return nothing
    end

    # return -
    return section_buffer
end

function _build_default_model_dictionary(model_buffer::Array{String,1})::Dict{String,Any}

    # initialize -
    model_dict = Dict{String,Any}()
    tmp_rate_order_array = Array{String,1}()

    # get the sections of the model file -
    dynamic_section = _extract_model_section(model_buffer, "#dynamic::start", "#dynamic::end")
    static_section = _extract_model_section(model_buffer, "#static::start", "#static::end")
    structure_section = _extract_model_section(model_buffer, "#structure::start", "#structure::end")
    rate_section = _extract_model_section(model_buffer, "#rate::start", "#rate::end")
    stoichiometry_section = _extract_model_section(model_buffer, "#stoichiometry::start", "#stoichiometry::end")

    # get list of dynamic species -
    list_of_dynamic_species = _parse_species_record(dynamic_section)
    number_of_dynamic_states = length(list_of_dynamic_species)

    # get list of static species -
    list_of_static_species = _parse_species_record(static_section)
    number_of_static_states = length(list_of_static_species)
    static_factors_array = zeros(number_of_static_states)

    # total species list -
    total_species_list = vcat(list_of_dynamic_species, list_of_static_species)

    # build the stoichiometric (connectivity) array -
    structure_dict_array = _parse_structure_section(structure_section)
    S = _build_stoichiometric_matrix(list_of_dynamic_species, structure_dict_array)

    # build the rate order array -
    for record ∈ structure_dict_array
        name = record["name"];
        push!(tmp_rate_order_array, name);
    end

    # check: if the stoichiometry_section is empty, then we can skip this code -
    if (stoichiometry_section !== nothing)
    
        # build list of stoichiometry records -
        list_of_stoichiometry_records = _parse_stoichiometry_section(stoichiometry_section);
        for (key, value) ∈ list_of_stoichiometry_records
            
            reaction_name = key[1]; # reaction name
            species_name = key[2]; # species name 

            # look indexs -
            index_reaction_name = findfirst(x->x==reaction_name, tmp_rate_order_array);
            index_species_name = findfirst(x->x==species_name, list_of_dynamic_species);

            # patch -
            old_value = S[index_species_name, index_reaction_name];
            S[index_species_name, index_reaction_name] = old_value*value;
        end
    end

    # build and sort the rate dict array -
    rate_dict_array = _parse_rate_section(rate_section)
    sorted_rate_dict_array = Array{Dict{String,Any},1}(undef, length(rate_dict_array))
    for rate_dictionary ∈ rate_dict_array

        # get the name -
        name = rate_dictionary["name"];

        # what key is this name?
        idx_name_key = findall(x->x==name, tmp_rate_order_array)
        sorted_rate_dict_array[first(idx_name_key)] = rate_dictionary;
    end

    # build rate exponent array -
    G = _build_exponent_matrix(total_species_list, sorted_rate_dict_array)

    # build the rate constant array -
    α = ones(length(rate_dict_array))

    # populate -
    model_dict["number_of_dynamic_states"] = number_of_dynamic_states
    model_dict["number_of_static_states"] = number_of_static_states
    model_dict["list_of_dynamic_species"] = list_of_dynamic_species
    model_dict["list_of_static_fators"] = list_of_static_species
    model_dict["total_species_list"] = total_species_list
    model_dict["static_factors_array"] = static_factors_array
    model_dict["initial_condition_array"] = zeros(number_of_dynamic_states)
    model_dict["list_of_reactions"] = tmp_rate_order_array;
    model_dict["S"] = S
    model_dict["G"] = G
    model_dict["α"] = α

    # return -
    return model_dict
end

function _read_model_file(path_to_file::String)::Array{String,1}

    # initialize -
    model_file_buffer = String[]
    model_buffer = Array{String,1}()

    # Read in the file -
    open("$(path_to_file)", "r") do file
        for line in eachline(file)
            +(model_file_buffer, line)
        end
    end

    # process -
    for line ∈ model_file_buffer

        # skip comments and empty lines -
        if (occursin("//", line) == false &&
            isempty(line) == false)

            # grab -
            push!(model_buffer, line)
        end
    end

    # return -
    return model_buffer
end

function _build_default_model_dictionary_toml(path_to_file::String)::Dict{String,Any}

    # try to parse the toml file -
    toml_model = TOML.tryparsefile(path_to_file);
    
    # initialize -
    model_dict = Dict{String, Any}();
    tmp_rate_order_array = Array{String,1}()

    # get list of dynamic species -
    list_of_dynamic_species = toml_model["model"]["list_of_dynamic_species"]
    number_of_dynamic_states = length(list_of_dynamic_species)
 
    # get list of static species -
    list_of_static_species = toml_model["model"]["list_of_static_species"]
    number_of_static_states = length(list_of_static_species)
    static_factors_array = zeros(number_of_static_states)
 
    # total species list -
    total_species_list = vcat(list_of_dynamic_species, list_of_static_species)
 
    # build the stoichiometric (connectivity) array -
    structure_section = toml_model["model"]["list_of_connection_records"]
    structure_dict_array = _parse_structure_section(structure_section)
    S = _build_stoichiometric_matrix(list_of_dynamic_species, structure_dict_array)
 
    # build the rate order array -
    for record ∈ structure_dict_array
        name = record["name"];
        push!(tmp_rate_order_array, name);
    end
 
    # build list of stoichiometry records -
    if (haskey(toml_model["model"],"list_of_stoichiometry_records") == true)
        stoichiometry_section = toml_model["model"]["list_of_stoichiometry_records"];
        if (length(stoichiometry_section) != 0)
            list_of_stoichiometry_records = _parse_stoichiometry_section(stoichiometry_section);

            for (key, value) ∈ list_of_stoichiometry_records
                
                reaction_name = key[1]; # reaction name
                species_name = key[2]; # species name 

                # look indexs -
                index_reaction_name = findfirst(x->x==reaction_name, tmp_rate_order_array);
                index_species_name = findfirst(x->x==species_name, list_of_dynamic_species);
        
                # patch -
                old_value = S[index_species_name, index_reaction_name];
                S[index_species_name, index_reaction_name] = old_value*value;
            end
        end
    end
 
    # build and sort the rate dict array -
    rate_section = toml_model["model"]["list_of_kinetics_records"]
    rate_dict_array = _parse_rate_section(rate_section)
    sorted_rate_dict_array = Array{Dict{String,Any},1}(undef, length(rate_dict_array))
    for rate_dictionary ∈ rate_dict_array
 
        # get the name -
        name = rate_dictionary["name"];
 
        # what key is this name?
        idx_name_key = findall(x->x==name, tmp_rate_order_array)
        sorted_rate_dict_array[first(idx_name_key)] = rate_dictionary;
    end
 
    # build rate exponent array -
    G = _build_exponent_matrix(total_species_list, sorted_rate_dict_array)
 
    # build the rate constant array -
    α = ones(length(rate_dict_array))
 
    # populate -
    model_dict["number_of_dynamic_states"] = number_of_dynamic_states
    model_dict["number_of_static_states"] = number_of_static_states
    model_dict["list_of_dynamic_species"] = list_of_dynamic_species
    model_dict["list_of_static_fators"] = list_of_static_species
    model_dict["total_species_list"] = total_species_list
    model_dict["static_factors_array"] = static_factors_array
    model_dict["initial_condition_array"] = zeros(number_of_dynamic_states)
    model_dict["list_of_reactions"] = tmp_rate_order_array;
    model_dict["S"] = S
    model_dict["G"] = G
    model_dict["α"] = α

    # add meta stuff to dictionary -
    model_dict["author"] = toml_model["metadata"]["author"]
    model_dict["date"] = toml_model["metadata"]["date"]
    model_dict["version"] = toml_model["metadata"]["version"]
    model_dict["description"] = toml_model["metadata"]["description"]

    # return -
    return model_dict
end

function _build(internal::Dict{String,Any})::BSTModel

    # create new BSTModel -
    model = BSTModel();

    # get one chnuck of data -
    number_of_dynamic_states = internal["number_of_dynamic_states"];

    # add data to new model instance -
    model.number_of_dynamic_states = internal["number_of_dynamic_states"]
    model.number_of_static_states = internal["number_of_static_states"] 
    model.list_of_dynamic_species = internal["list_of_dynamic_species"]
    model.list_of_static_species = internal["list_of_static_fators"] 
    model.total_species_list = internal["total_species_list"]
    model.static_factors_array = internal["static_factors_array"]
    model.list_of_reactions = internal["list_of_reactions"]
    model.initial_condition_array = zeros(number_of_dynamic_states);
    model.S = internal["S"]
    model.G = internal["G"]
    model.α = internal["α"]

    # do we have metadata?
    metadata_keys = ["author", "version", "date", "description"]
    for key in metadata_keys

        if (haskey(internal, key))
            setproperty!(model, Symbol(key), internal[key])
        else
            setproperty!(model, Symbol(key), "");
        end
    end

    # return -
    return model;
end

function _build(model::BSTModel)::Dict{String,Any}

    # initialize -
    internal_model_dictionary = Dict{String,Any}();

    # get the data from the model object, put into dictionary -
    internal_model_dictionary["number_of_dynamic_states"] = model.number_of_dynamic_states
    internal_model_dictionary["number_of_static_states"] = model.number_of_static_states
    internal_model_dictionary["list_of_dynamic_species"] = model.list_of_dynamic_species
    internal_model_dictionary["list_of_static_fators"] = model.list_of_static_species
    internal_model_dictionary["total_species_list"] = model.total_species_list
    internal_model_dictionary["static_factors_array"] = model.static_factors_array
    internal_model_dictionary["initial_condition_array"] = model.initial_condition_array
    internal_model_dictionary["list_of_reactions"] = model.list_of_reactions
    internal_model_dictionary["S"] = model.S
    internal_model_dictionary["G"] = model.G
    internal_model_dictionary["α"] = model.α

    # return -
    return internal_model_dictionary;
end

## ===== PRIVATE METHODS ABOVE HERE ============================================================= ##

## ===== PUBLIC METHODS BELOW HERE ============================================================= ##
function build(path::String)::BSTModel

    # what are the "approved" components -
    approved_file_extenstions_set = Set{String}();
    push!(approved_file_extenstions_set,".bst");
    push!(approved_file_extenstions_set,".txt");
    push!(approved_file_extenstions_set,".jld2");
    push!(approved_file_extenstions_set,".dat");
    push!(approved_file_extenstions_set,".net");
    push!(approved_file_extenstions_set,".toml");

    try

        # get the file extension -
        extension = splitext(path)[2]; # the extension is the last element -
        if (in(extension, approved_file_extenstions_set) == false)
            throw(ArgumentError("File extension: $(extension) is not recognized. For approaved file types, see documentation."))
        end

        # check: if jld2 then we can just load the file, and build the model. If another type, then we need to parse the file
        # and then build the model

        if (extension == ".jld2")
            internal_model_dictionary = load(path)["model"];
            return _build(internal_model_dictionary);
        elseif (extension == ".toml")

            # build the model -
            return _build(_build_default_model_dictionary_toml(path));
        else
            # load the reaction file -
            model_buffer = _read_model_file(path)

            # build the model -
            return _build(_build_default_model_dictionary(model_buffer));
        end

    catch error

        # get the original error message -
        error_message = sprint(showerror, error, catch_backtrace())
        vl_error_obj = ErrorException(error_message)

        # throw -
        throw(vl_error_obj);
    end
end

function save(path::String, model::T)::Bool where T <: AbstractBSTModel

    # check: path needs to end in jld2 -
    approved_file_extenstions_set = Set{String}();
    push!(approved_file_extenstions_set,".jld2");
    
    try

        # get the file extension -
        extension = splitext(path)[2]; # the extension is the last element -
        if (in(extension, approved_file_extenstions_set) == false)
            throw(ArgumentError("File extension: $(extension) is not recognized. For approaved file types, see documentation."))
        end

        # build an internal model dictionary -
        internal_model_dictionary = _build(model)

        # write -
        FileIO.save(path, Dict("model"=>internal_model_dictionary));

        # return -
        return true;

    catch error

        # get the original error message -
        error_message = sprint(showerror, error, catch_backtrace())
        vl_error_obj = ErrorException(error_message)

        # throw -
        throw(vl_error_obj);
    end

    # not sure how this could happen, but just in case -
    return false;
end
## ===== PUBLIC METHODS ABOVE HERE ============================================================= ##