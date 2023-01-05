# load package -
using BSTModelKit


function test_steady_state_solve()::Bool

    # set path to bst file -
    path_to_model_file = joinpath(pwd(),"data","Branched-Feedback.toml");

    # build -
    model_object = build(path_to_model_file);

    # set the initial conditions -
    icv = [10.0, 0.1, 0.1, 1.1, 0.1];
    model_object.initial_condition_array = icv;

    # set the values for the static factors -
    model_object.static_factors_array = [0.1, 0.1, 0.1, 0.1];

    # set the values for the α -
    model_object.α = [0.1, 1.0, 1.0, 1.0, 0.1, 0.01, 0.01];

    # set values for G -
    Gₒ = model_object.G;
    Gₒ[5,1] = -2.0; # inhibition of E1 by E
    Gₒ[4,2] = -2.0; # inhibition of E2 by D

    # solve the model -
    XSS = steadystate(model_object);

    # is XSS empty?
    if (isempty(XSS) == false)
        return true
    end

    return false
end

function steady_state_solve()

    # set path to bst file -
    path_to_model_file = joinpath(pwd(),"test", "data", "Branched-Feedback.toml");

    # build -
    model_object = build(path_to_model_file);

    # set the initial conditions -
    icv = [10.0, 0.1, 0.1, 1.1, 0.1];
    model_object.initial_condition_array = icv;

    # set the values for the static factors -
    model_object.static_factors_array = [0.1, 0.1, 0.1, 0.1];

    # set the values for the α -
    model_object.α = [0.1, 1.0, 1.0, 1.0, 0.1, 0.01, 0.01];

    # set values for G -
    Gₒ = model_object.G;
    Gₒ[5,1] = -2.0; # inhibition of E1 by E
    Gₒ[4,2] = -2.0; # inhibition of E2 by D

    # solve the model -
    XSS = steadystate(model_object);

    return XSS
end