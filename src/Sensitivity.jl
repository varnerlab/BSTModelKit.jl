function morris(peformance::Function, L::Array{Float64,1}, U::Array{Float64,1}; 
    number_of_samples::Int64 = 1000)

    # how many parameters do we have?
    NP = length(L);

    # call -
    m = gsa(peformance, Morris(num_trajectory=number_of_samples), [[L[i],U[i]] for i in 1:(NP-1)]);

    # return -
    return m;
end