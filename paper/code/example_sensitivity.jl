using BSTModelKit
using NumericalIntegration
using Plots

# build the model -
path_to_model_file = joinpath(@__DIR__, "Feedback.toml");
model = build(path_to_model_file);

# set baseline parameters -
model.initial_condition_array = [0.1, 0.1, 0.1, 0.1, 0.0];
model.static_factors_array = [1.0, 1.0, 1.0];

# baseline rate constants: [r1, r2, r3, r5, r0, r4]
α_base = [10.0, 10.0, 10.0, 0.1, 1.0, 3.0];
model.α = α_base;

# baseline feedback -
G = model.G;
G[4, 1] = -0.5;
model.G = G;

# performance function: integrated X4 concentration over time -
# parameter vector κ = [α1, α2, α3, α4_branch, α0, α4_deg, g_feedback]
function _performance(κ, m::BSTModel)
    m.α = κ[1:6];
    Gm = m.G;
    Gm[4, 1] = κ[7];
    m.G = Gm;
    (T, X) = evaluate(m; tspan=(0.0, 20.0));
    return integrate(T, X[:, 4])  # integrated X4
end
F(κ) = _performance(κ, model);

# parameter names -
param_names = ["r1", "r2", "r3", "r5", "r0", "r4", "g(X4,r1)"];

# parameter bounds: ±50% around baseline for rate constants, feedback from -2 to 0
NP = 7;
L = zeros(NP);
U = zeros(NP);
for i in 1:6
    L[i] = 0.5 * α_base[i];
    U[i] = 2.0 * α_base[i];
end
L[7] = -2.0;
U[7] = 0.0;

# --- Morris method ---
morris_result = morris(F, L, U; number_of_samples=500);
μ_star = abs.(morris_result[:, 1]);
σ_morris = sqrt.(abs.(morris_result[:, 2]));

# --- Sobol method ---
sobol_result = sobol(F, L, U; number_of_samples=1000);
S1 = sobol_result.S1;
ST = sobol_result.ST;
S1_CI = sobol_result.S1_Conf_Int;
ST_CI = sobol_result.ST_Conf_Int;

# --- Plot ---
default(
    background_color=:white,
    background_color_outside=:white,
    background_color_subplot=:white,
)

_defaults = (;
    background_color_inside=RGB(0.96, 0.96, 0.96),
    framestyle=:box,
    grid=true,
    gridcolor=:white,
    gridlinewidth=1.5,
    minorgrid=false,
    fontfamily="Helvetica",
    guidefontsize=10,
    tickfontsize=8,
    legendfontsize=8,
)

# panel A: Morris μ* with σ error bars
p1 = bar(param_names, μ_star;
    yerror=σ_morris,
    ylabel="Mean |EE| (AU)",
    color=:steelblue, legend=false,
    title="Morris screening",
    xrotation=45,
    _defaults...)

# panel B: Sobol first-order and total-order indices with confidence intervals
x_pos = collect(1:NP);
bar_width = 0.35;
p2 = bar(x_pos .- bar_width/2, S1;
    yerror=S1_CI,
    bar_width=bar_width, label="S1 (first-order)",
    color=:steelblue, _defaults...)
bar!(p2, x_pos .+ bar_width/2, ST;
    yerror=ST_CI,
    bar_width=bar_width, label="ST (total-order)",
    color=:coral,
    xlabel="", ylabel="Sensitivity index",
    xticks=(x_pos, param_names),
    xrotation=45,
    title="Sobol decomposition",
    legend=:topleft)

plot(p1, p2, layout=(1, 2), size=(900, 450),
    left_margin=5Plots.mm, bottom_margin=10Plots.mm)
savefig(joinpath(@__DIR__, "..", "figures", "sensitivity_analysis.pdf"))
