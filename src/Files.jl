"""
    savemodel(path::String, model::T) -> Bool where T <: AbstractBSTModel

This function is used to save a `BSTModel` object to a file. The file can be in one of the following formats: JLD2.
The function will save the model object to the file specified by the `path` argument.

### Arguments
- `path::String`: The path to the file where the model object will be saved.
- `model::T`: The `BSTModel` object that will be saved to the file.

### Returns
- A boolean indicating if the model object was saved successfully.
"""
function savemodel(path::String, model::T)::Bool where T <: AbstractBSTModel

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


"""
    loadmodel(path::String) -> AbstractBSTModel

This function is used to load a `BSTModel` object from a file. The file can be in one of the following formats: JLD2.
The function will load the model object from the file specified by the `path` argument.

### Arguments
- `path::String`: The path to the file where the model object will be loaded from.

### Returns
- A `BSTModel` object that was loaded from the file.
"""
function loadmodel(path::String)::AbstractBSTModel

    # check: path needs to end in jld2 -
    approved_file_extenstions_set = Set{String}();
    push!(approved_file_extenstions_set,".jld2");
    
    try

        # get the file extension -
        extension = splitext(path)[2]; # the extension is the last element -
        if (in(extension, approved_file_extenstions_set) == false)
            throw(ArgumentError("File extension: $(extension) is not recognized. For approaved file types, see documentation."))
        end

        # read -
        data = FileIO.load(path);

        # get the model -
        internal_model_dictionary = data["model"];
        return _build(internal_model_dictionary);
    
    catch error

        # get the original error message -
        error_message = sprint(showerror, error, catch_backtrace())
        vl_error_obj = ErrorException(error_message)

        # throw -
        throw(vl_error_obj);
    end

    # not sure how this could happen, but just in case -
    return nothing;
end