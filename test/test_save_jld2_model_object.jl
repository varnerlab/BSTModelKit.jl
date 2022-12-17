# load package -
using BSTModelKit

# test logic -
function test_save_jld2_model_object()::Bool

    # set path to bst file -
    path_to_toml_model_file = joinpath(pwd(),"data","Feedback.toml");
    path_to_jld2_model_file = joinpath(pwd(),"tmp","Feedback.jld2");

    # build -
    model_object = build(path_to_toml_model_file);

    # save -
    return save(path_to_jld2_model_file, model_object);
end