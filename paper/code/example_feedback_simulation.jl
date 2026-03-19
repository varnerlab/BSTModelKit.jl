using BSTModelKit
using Plots

# build the model from the TOML file -
path_to_model_file = joinpath(@__DIR__, "Feedback.toml");
model = build(path_to_model_file);

# set initial conditions: [X1, X2, X3, X4, X5] -
model.initial_condition_array = [0.1, 0.1, 0.1, 0.1, 0.0];

# set static factor values: [E1, E2, E3] -
model.static_factors_array = [1.0, 1.0, 1.0];

# set rate constants -
# reaction order from connection records: [r1, r2, r3, r5, r0, r4]
# r0 = 0 because we drive X1 production via the input function
model.α = [10.0, 10.0, 10.0, 0.1, 0.0, 3.0];

# set kinetic orders in the G matrix -
# X4 inhibits r1 (feedback): g(X4, r1) = -0.5
G = model.G;
G[4, 1] = -0.5;
model.G = G;

# define a time-varying input function for X1 production:
# multiple steps: low → high → low → medium → low
function input_function(t::Float64, x::Array{Float64,1}, p::Tuple)::Array{Float64,1}
    u = zeros(length(x));
    if t < 5.0
        u[1] = 1.0      # baseline
    elseif t < 15.0
        u[1] = 10.0     # high pulse
    elseif t < 25.0
        u[1] = 1.0      # return to baseline
    elseif t < 35.0
        u[1] = 5.0      # medium pulse
    else
        u[1] = 1.0      # return to baseline
    end
    return u
end

# helper: compute the input profile over a time grid
function input_profile(T::AbstractVector)
    x_dummy = zeros(5)
    p_dummy = ()
    return [input_function(t, x_dummy, p_dummy)[1] for t in T]
end

# set plot defaults -
default(
    background_color=:white,
    background_color_outside=:white,
    background_color_subplot=:white,
)

# simulate the dynamic trajectory -
(T, X) = evaluate(model; tspan=(0.0, 50.0), Δt=0.01, input=input_function);

# shared plot theme -
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

# two-panel plot -
p1 = plot(T, input_profile(T);
    xlabel="", ylabel="u1(t) (AU)",
    lw=2.5, color=:black, legend=false,
    ylims=(-0.5, 12.0), _defaults...)

p2 = plot(T, X;
    label=["X1" "X2" "X3" "X4" "X5"],
    xlabel="Time (AU)", ylabel="Concentration (AU)",
    lw=2.5, legend=:topright, _defaults...)

plot(p1, p2, layout=(2, 1), size=(700, 500), left_margin=5Plots.mm)
savefig(joinpath(@__DIR__, "..", "figures", "feedback_simulation.pdf"))
