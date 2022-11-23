function _powerlaw(x, k, G)

    # set negatives to zero -
    x = max.(0.0, x)

    # get system dimension -
    ℛ = length(k)
    ℳ = length(x)

    # initialize the rate array -
    rate_array = Array{Float64,1}(undef,ℛ)

    for i ∈ 1:ℛ
        
        # tmp -
        tmp_value = 1.0
        for j ∈ 1:ℳ
            tmp_value = tmp_value*(x[j])^(G[j,i])
        end

        # store the rate value -
        rate_array[i] = k[i]*tmp_value
    end

    # return -
    return rate_array
end