function morris(peformance::Function, L::Array{Float64,1}, U::Array{Float64,1}; 
    number_of_samples::Int64 = 1000)::Array{Float64,2}

    # how many parameters do we have?
    NP = length(L);
    results_array = Array{Float64,2}(undef, NP, 2)

    # call -
    m = gsa(peformance, Morris(num_trajectory=number_of_samples), [[L[i],U[i]] for i in 1:NP]);

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