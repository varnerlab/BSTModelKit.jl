using BSTModelKit
using Plots

# build the model -
path_to_model_file = joinpath(@__DIR__, "Branched-Feedback.toml");

# sweep E3 (enzyme for r3: C→D) while holding E4=1.0 fixed -
# this changes the branch split ratio at the C node,
# redirecting flux between the D and E branches.
# reaction order from connection records: [r1, r2, r3, r4, r0, r5, r6]
# static species order: [E1, E2, E3, E4]
E3_values = range(0.1, 5.0, length=30);
results = zeros(length(E3_values), 5);

for (i, E3) in enumerate(E3_values)

    model = build(path_to_model_file);
    model.initial_condition_array = [1.0, 0.1, 0.1, 0.1, 0.1];
    model.static_factors_array = [1.0, 1.0, E3, 1.0];
    model.α = [5.0, 5.0, 5.0, 5.0, 2.0, 1.0, 1.0];

    # set feedback kinetic orders -
    G = model.G;
    G[5, 1] = -0.5;  # E inhibits r1
    G[4, 2] = -0.5;  # D inhibits r2
    model.G = G;

    # compute steady state -
    XSS = steadystate(model; tspan=(0.0, 100.0));
    results[i, :] = XSS;
end

# plot defaults -
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

# plot -
plot(collect(E3_values), results,
    label=["A" "B" "C" "D" "E"],
    xlabel="E3 enzyme level (AU)",
    ylabel="Steady-state concentration (AU)",
    lw=2.5, legend=:right,
    marker=:circle, markersize=3,
    size=(600, 400), left_margin=5Plots.mm;
    _defaults...)
savefig(joinpath(@__DIR__, "..", "figures", "steady_state_sweep.pdf"))
