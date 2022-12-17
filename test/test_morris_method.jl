using BSTModelKit
using NumericalIntegration

# build a performance function -
function performance(κ, model::BSTModel)

    # get parameters -
    tmp_alpha = κ[1:end-1];
    g41 = κ[end];

    # set new parameters =
    model.α = tmp_alpha;

    # set values for G -
    G = model.G;
    G[4,1] = g41;
    model.G = G;

    # solve the model -
    (T,X) = evaluate(model; tspan=(0.0,5.0));

    # test -
    return integrate(T, X[:,1])
end

# setup default model -
path_to_model_file = joinpath(pwd(),"./test/data/Feedback.toml");

# build -
model_object = build(path_to_model_file);  

# set the initial conditions -
icv = [2.0, 0.1, 0.1, 0.1, 0.0];
model_object.initial_condition_array = icv;

# set the values for the static factors -
model_object.static_factors_array = [0.1, 0.1, 0.1];

# set the values for the α -
ialpha = [1.0, 1.0, 1.0, 1.0, 0.01, 0.01];
model_object.α = ialpha;

# setup bounds -
# create lower and upper bound array -
NP = length(ialpha) + 1
L = zeros(NP)
U = zeros(NP)
for pᵢ ∈ 1:(NP - 1)
    L[pᵢ] = 0.1*ialpha[pᵢ]
    U[pᵢ] = 10.0*ialpha[pᵢ]
end
L[end] = -3.0
U[end] = 0.0;

# setup performance 
F(κ) = performance(κ, model_object);

m = morris(F, L, U);

