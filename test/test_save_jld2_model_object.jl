# load package -
using BSTModelKit

# set path to bst file -
path_to_toml_model_file = joinpath(pwd(),"test","data","Feedback.toml");
path_to_jld2_model_file = joinpath(pwd(),"test","tmp","Feedback.jld2");

# build -
model_object = build(path_to_toml_model_file);

# save -
save(path_to_jld2_model_file, model_object);