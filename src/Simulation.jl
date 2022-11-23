
## ===== PRIVATE METHODS BELOW HERE ============================================================= ##
function _evaluate(model::Dict{String,Any}; 
    tspan::Tuple{Float64,Float64} = (0.0,20.0), Δt::Float64 = 0.01)

    # get stuff from model -
    xₒ = model["initial_condition_array"]

    # build parameter vector -
    p = Array{Any,1}(undef,5)
    p[1] = model["α"]
    p[2] = model["G"]
    p[3] = model["S"]
    p[4] = model["number_of_dynamic_states"]
    p[5] = model["static_factors_array"]

    # setup the solver -
    prob = ODEProblem(_balances, xₒ, tspan, p; saveat = Δt)
    soln = solve(prob)

    # get the results from the solver -
    T = soln.t
    tmp = soln.u

    # build soln array -
    number_of_time_steps = length(T)
    number_of_dynamic_states = model["number_of_dynamic_states"]
    X = Array{Float64,2}(undef, number_of_time_steps,  number_of_dynamic_states);

    for i ∈ 1:number_of_time_steps
        soln_vector = tmp[i]
        for j ∈ 1:number_of_dynamic_states
            X[i,j] = soln_vector[j]
        end
    end

    # return -
    return (T,X)
end
## ===== PRIVATE METHODS ABOVE HERE ============================================================= ##

## ===== PUBLIC METHODS BELOW HERE ============================================================== ##
function evaluate(model::BSTModel; tspan::Tuple{Float64,Float64} = (0.0,20.0), Δt::Float64 = 0.01)::Tuple{Array{Float64,1}, Array{Float64,2}}

    try
        # convert the model object to the internal_model_dictionary -
        internal_model_dictionary = _build(model);
        return _evaluate(internal_model_dictionary, tspan = tspan, Δt = Δt); 

    catch error
        
        # get the original error message -
        error_message = sprint(showerror, error, catch_backtrace())
        vl_error_obj = ErrorException(error_message)

        # throw -
        throw(vl_error_obj);
    end
end
## ===== PUBLIC METHODS ABOVE HERE ============================================================== ##