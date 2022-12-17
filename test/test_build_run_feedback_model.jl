# load package -
using BSTModelKit

function test_build_run_feedback_model()::Bool

    # # set path to bst file -
    path_to_model_file = joinpath(pwd(), "data","Feedback.toml");

    # build -
    model_object = build(path_to_model_file);  
    
    # set the initial conditions -
    icv = [10.0, 0.1, 0.1, 1.1, 0.0];
    model_object.initial_condition_array = icv;

    # set the values for the static factors -
    model_object.static_factors_array = [0.1, 0.1, 0.1];

    # set the values for the α -
    model_object.α = [0.0, 10.0, 10.0, 10.0, 0.1, 0.1];

    # set values for G -
    G = model_object.G;
    G[4,1] = -1.0;
    model_object.G = G;

    # solve the model -
    (T,X) = evaluate(model_object);

    # values?
    if (T[end]>0.0 && X[end,end]>0)
        return true
    end

    # return -
    return true
end