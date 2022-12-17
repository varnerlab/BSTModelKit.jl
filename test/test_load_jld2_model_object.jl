# load package -
using BSTModelKit

# test logic -
function test_load_jld2_model_object()::Bool

    # set path to bst file -
    path_to_jld2_model_file = joinpath(pwd(),"tmp","Feedback.jld2");

    # build -
    model_object = build(path_to_jld2_model_file);

    # check: do we have a S that is a 5 x 6 with -2.0 as the 1,1 entry?
    S = model_object.S;
    (NR,NC) = size(S);
    if (NR == 5 && NC == 6 && S[1,1] == -2.0)
        return true
    end
 
    # default: always fail -
    return false;
end