"""
    morris(performance::Function, L::Array{Float64,1}, U::Array{Float64,1}; 
        number_of_samples::Int64 = 1000) -> Array{Float64,2}

The `morris` function is a wrapper around the `gsa` function that uses the Morris method to perform a global sensitivity analysis.

### Arguments
- `performance::Function`: a function that takes a vector of parameters and returns a scalar performance metric.
- `L::Array{Float64,1}`: a vector of lower bounds for the parameters.
- `U::Array{Float64,1}`: a vector of upper bounds for the parameters.
- `number_of_samples::Int64`: the number of samples to use in the analysis.

### Returns
- a matrix of results where the first column is the mean and the second column is the variance of the sensitivity analysis.

"""
function morris(performance::Function, L::Array{Float64,1}, U::Array{Float64,1}; 
    number_of_samples::Int64 = 1000)::Array{Float64,2}

    # how many parameters do we have?
    NP = length(L);
    results_array = Array{Float64,2}(undef, NP, 2)

    # call -
    m = gsa(performance, Morris(num_trajectory=number_of_samples), [[L[i],U[i]] for i in 1:NP]);

    # package the results -
    μ̂ = m.means;
    σ̂ = m.variances;
    for i ∈ 1:NP
        results_array[i,1] = μ̂[i];
        results_array[i,2] = σ̂[i];
    end

    # return -
    return results_array;
end

"""
    sobol(performance::Function, L::Array{Float64,1}, U::Array{Float64,1}; 
        number_of_samples::Int64 = 1000, orders::Array{Int64,1} = [0, 1, 2])

The `sobol` function is a wrapper around the `gsa` function that uses the Sobol method to perform a global sensitivity analysis.

### Arguments
- `performance::Function`: a function that takes a vector of parameters and returns a scalar performance metric.
- `L::Array{Float64,1}`: a vector of lower bounds for the parameters.
- `U::Array{Float64,1}`: a vector of upper bounds for the parameters.
- `number_of_samples::Int64`: the number of samples to use in the analysis.
- `orders::Array{Int64,1}`: the orders of sensitivity to compute.

### Returns
- a `SobolResult` object.

"""
function sobol(performance::Function, L::Array{Float64,1}, U::Array{Float64,1}; 
    number_of_samples::Int64 = 1000, orders::Array{Int64,1} = [0, 1, 2])

    # initialize -
    sampler = SobolSample()
    
    # generate a sampler -
    (A,B) = QuasiMonteCarlo.generate_design_matrices(number_of_samples,L,U,sampler)

    # call -
    result = gsa(performance, Sobol(order=orders), A, B)

    # rerturn -
    return result
end