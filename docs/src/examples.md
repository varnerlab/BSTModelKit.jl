# Examples

## Building and simulating a model

This example builds a model from a TOML file, sets parameters and initial conditions, and simulates the dynamic trajectory.

Consider a linear biochemical pathway with feedback inhibition:

```
       E1      E2      E3
X0 ──→ X1 ──→ X2 ──→ X3 ──→ X4
        ↑                     │
        └─────────────────────┘
              (inhibition)
```

where species `X1` through `X4` are dynamic, and `E1`, `E2`, `E3` are static enzyme concentrations.

### Step 1: Build the model

```julia
using BSTModelKit

# build the model from a TOML file
model = build("path/to/Feedback.toml");
```

The [`build`](@ref) function parses the file and returns a [`BSTModel`](@ref) object containing the stoichiometry matrix `S`, exponent matrix `G`, and rate constant vector `α`.

### Step 2: Set parameters and initial conditions

After building, the model parameters need to be configured:

```julia
# set initial conditions for dynamic species [X1, X2, X3, X4, X5]
model.initial_condition_array = [10.0, 0.1, 0.1, 1.1, 0.0];

# set static factor concentrations [E1, E2, E3]
model.static_factors_array = [0.1, 0.1, 0.1];

# set rate constants [α₀, α₁, α₂, α₃, α₄, α₅]
model.α = [0.0, 10.0, 10.0, 10.0, 0.1, 0.1];

# modify the exponent matrix to add feedback inhibition
G = model.G;
G[4, 1] = -1.0;   # X4 inhibits reaction r1 (negative kinetic order)
model.G = G;
```

### Step 3: Simulate

```julia
# simulate from t = 0 to t = 20 with time step 0.01
(T, X) = evaluate(model);
```

The [`evaluate`](@ref) function returns a tuple `(T, X)` where:
- `T` is a vector of time points
- `X` is a matrix of state values (rows = time steps, columns = species)

You can also specify a custom time span and time step:

```julia
(T, X) = evaluate(model; tspan=(0.0, 50.0), Δt=0.1);
```

## Steady-state computation

To find the steady-state concentrations instead of the full dynamic trajectory:

```julia
using BSTModelKit

# build and configure model (same as above)
model = build("path/to/Branched-Feedback.toml");
model.initial_condition_array = [10.0, 0.1, 0.1, 1.1, 0.1];
model.static_factors_array = [0.1, 0.1, 0.1, 0.1];
model.α = [0.1, 1.0, 1.0, 1.0, 0.1, 0.01, 0.01];

# compute steady state
XSS = steadystate(model);
```

The [`steadystate`](@ref) function returns a vector of steady-state concentrations using the `DynamicSS` solver.

## Saving and loading models

Once a model is fully configured, you can save it for later use:

```julia
# save the model to a JLD2 file
savemodel("my_model.jld2", model);

# load it back
model = loadmodel("my_model.jld2");

# or equivalently, use build
model = build("my_model.jld2");
```

## Global sensitivity analysis

`BSTModelKit.jl` provides wrappers for the [Morris](https://en.wikipedia.org/wiki/Morris_method) and [Sobol](https://en.wikipedia.org/wiki/Variance-based_sensitivity_analysis) global sensitivity analysis methods via [GlobalSensitivity.jl](https://github.com/SciML/GlobalSensitivity.jl).

### Morris method

The Morris method computes elementary effects to screen for important parameters:

```julia
using BSTModelKit
using NumericalIntegration  # for the performance function

# build and configure model
model = build("path/to/Feedback.toml");
model.initial_condition_array = [2.0, 0.1, 0.1, 0.1, 0.0];
model.static_factors_array = [0.1, 0.1, 0.1];
model.α = [1.0, 1.0, 1.0, 1.0, 0.01, 0.01];

# define a scalar performance function
# this function takes a parameter vector and returns a scalar metric
function performance(κ, model::BSTModel)

    # update model parameters from κ
    model.α = κ[1:end-1];
    G = model.G;
    G[4, 1] = κ[end];
    model.G = G;

    # simulate
    (T, X) = evaluate(model; tspan=(0.0, 5.0));

    # return the integrated area under X1 as the performance metric
    return integrate(T, X[:, 1])
end

# define parameter bounds
ialpha = model.α;
NP = length(ialpha) + 1;
L = zeros(NP);
U = zeros(NP);
for i ∈ 1:(NP-1)
    L[i] = 0.1 * ialpha[i]
    U[i] = 10.0 * ialpha[i]
end
L[end] = -3.0;    # bounds for the feedback exponent
U[end] = 0.0;

# create a closure and run Morris method
F(κ) = performance(κ, model);
results = morris(F, L, U; number_of_samples=1000);
```

The [`morris`](@ref) function returns an `NP × 2` matrix where column 1 contains the mean elementary effects (``\hat{\mu}``) and column 2 contains the variances (``\hat{\sigma}``).

### Sobol method

The Sobol method decomposes output variance into contributions from each parameter:

```julia
# using the same model and bounds as above
result = sobol(F, L, U; number_of_samples=10000);
```

The [`sobol`](@ref) function returns a `SobolResult` object containing first-order and total-order sensitivity indices.

## Using an input function

The [`evaluate`](@ref) function accepts an optional `input` argument to drive the system with an external forcing function. The input function must have the signature `u(t, x, p)` and return a vector of length equal to the number of dynamic states:

```julia
# define an input function: step increase in X1 supply at t = 5
function my_input(t, x, p)
    u = zeros(length(x));
    if t >= 5.0
        u[1] = 1.0   # add a constant input to species X1
    end
    return u
end

# simulate with the input
(T, X) = evaluate(model; tspan=(0.0, 20.0), input=my_input);
```
