
## ===== PRIVATE METHODS BELOW HERE ============================================================= ##
function _evaluate(model::Dict{String,Any}; 
    tspan::Tuple{Float64,Float64} = (0.0,20.0), Δt::Float64 = 0.01, input::Union{Nothing,Function} = nothing)

    # get stuff from model -
    xₒ = model["initial_condition_array"]

    # This is stuf going to the solver. 
    # Converting to a tuple to pass to the solver.
    p  = (
        model["α"],
        model["G"],
        model["S"],
        model["number_of_dynamic_states"],
        model["static_factors_array"],
        input
    );
    # p[1] = model["α"]
    # p[2] = model["G"]
    # p[3] = model["S"]
    # p[4] = model["number_of_dynamic_states"]
    # p[5] = model["static_factors_array"]
    # p[6] = input;

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

function _evaluate_steady_state(model::Dict{String,Any}; 
    tspan::Tuple{Float64,Float64} = (0.0,20.0), Δt::Float64 = 0.01, input::Union{Nothing,Function} = nothing)::Array{Float64,1}

    # get stuff from model -
    xₒ = model["initial_condition_array"]

    # build parameter tuple -
    p = (
        model["α"],
        model["G"],
        model["S"],
        model["number_of_dynamic_states"],
        model["static_factors_array"],
        input
    );
    # p[1] = model["α"]
    # p[2] = model["G"]
    # p[3] = model["S"]
    # p[4] = model["number_of_dynamic_states"]
    # p[5] = model["static_factors_array"]
    # p[6] = input;

    # setup the solver -
    odeprob = ODEProblem(_balances, xₒ, tspan, p; saveat = Δt)
    ssprob = SteadyStateProblem(odeprob)
    soln = solve(ssprob, DynamicSS(Rosenbrock23(autodiff=false)), dt=1.0)

    # get the results from the solver -
    sssoln = soln.u
    
    # return -
    return sssoln;
end

## ===== PRIVATE METHODS ABOVE HERE ============================================================= ##

## ===== PUBLIC METHODS BELOW HERE ============================================================== ##

"""
    evaluate(model::BSTModel; tspan::Tuple{Float64,Float64} = (0.0,20.0), Δt::Float64 = 0.01, 
        input::Union{Nothing,Function} = nothing) -> Tuple{Array{Float64,1}, Array{Float64,2}}

This function is used to evaluate the model object that has been built using the `build` function. 
The `evaluate` function will return a tuple with two elements: a vector of time points and a matrix of state values.

### Arguments
- `model::BSTModel`: A model object that has been built using the `build` function.
- `tspan::Tuple{Float64,Float64}`: A tuple that defines the time span for the simulation. The default is `(0.0,20.0)`.
- `Δt::Float64`: The time step for the simulation. The default is `0.01`.
- `input::Union{Nothing,Function}`: An optional input function that can be used to drive the simulation. The default is `nothing`.

### Returns
- A tuple with two elements:
    - `Array{Float64,1}`: A vector of time points.
    - `Array{Float64,2}`: A matrix of state values.
"""
function evaluate(model::BSTModel; tspan::Tuple{Float64,Float64} = (0.0,20.0), Δt::Float64 = 0.01, 
    input::Union{Nothing,Function} = nothing)::Tuple{Array{Float64,1}, Array{Float64,2}}

    try
        # convert the model object to the internal_model_dictionary -
        internal_model_dictionary = _build(model);
        return _evaluate(internal_model_dictionary, tspan = tspan, Δt = Δt, input = input); 

    catch error
        
        # get the original error message -
        error_message = sprint(showerror, error, catch_backtrace())
        vl_error_obj = ErrorException(error_message)

        # throw -
        throw(vl_error_obj);
    end
end

"""
    steadystate(model::BSTModel; tspan::Tuple{Float64,Float64} = (0.0,20.0), Δt::Float64 = 0.01, input::Union{Nothing,Function} = nothing) -> Array{Float64,1}

The `steadystate` function is used to evaluate the steady state of the model object that has been built using the `build` function.

### Arguments
- `model::BSTModel`: A model object that has been built using the `build` function.
- `tspan::Tuple{Float64,Float64}`: A tuple that defines the time span for the simulation. The default is `(0.0,20.0)`.
- `Δt::Float64`: The time step for the simulation. The default is `0.01`.
- `input::Union{Nothing,Function}`: An optional input function that can be used to drive the simulation. The default is `nothing`.

### Returns
- A vector of state values that represent the steady state of the system.
"""
function steadystate(model::BSTModel; tspan::Tuple{Float64,Float64} = (0.0,20.0), Δt::Float64 = 0.01, 
    input::Union{Nothing,Function} = nothing)::Array{Float64,1}
    
    try
        # convert the model object to the internal_model_dictionary -
        internal_model_dictionary = _build(model);
        return _evaluate_steady_state(internal_model_dictionary, tspan = tspan, Δt = Δt, input = input);

    catch error
        
        # get the original error message -
        error_message = sprint(showerror, error, catch_backtrace())
        vl_error_obj = ErrorException(error_message)
    
        # throw -
        throw(vl_error_obj);
    end
end
## ===== PUBLIC METHODS ABOVE HERE ============================================================== ##