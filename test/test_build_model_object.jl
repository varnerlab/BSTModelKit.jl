# load package -
using BSTModelKit

# set path to bst file -
path_to_model_file = joinpath(pwd(),"test","data","Feedback.bst");

# build -
model_object = build(path_to_model_file);