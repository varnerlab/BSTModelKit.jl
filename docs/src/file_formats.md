# File Formats

`BSTModelKit.jl` supports several file formats for defining BST models. The [`build`](@ref) function automatically detects the format based on the file extension.

## TOML Format (recommended)

The TOML format (`.toml`) is the recommended way to define models. A TOML model file has two sections: `[metadata]` and `[model]`.

### Example: Linear pathway with feedback inhibition

```toml
[metadata]
author = "jdv27@cornell.edu"
date = "12/17/22"
version = "0.1"
description = "Linear pathway with feedback inhibition"

[model]
list_of_static_species = ["E1", "E2", "E3"]
list_of_dynamic_species = ["X1", "X2", "X3", "X4", "X5"]

list_of_connection_records = [
    # name::{reactants} --> {products}
    "r1::{X1} --> X2",
    "r2::{X2} --> X3",
    "r3::X3 --> X4",
    "r5::X3 --> X5",

    # source and sink reactions use empty braces {}
    "r0::{} --> X1",
    "r4::X4 --> {}"
]

list_of_kinetics_records = [
    # name::{factor_1,factor_2,...}
    "r0::{}",
    "r1::{X1,X4,E1}",
    "r2::{X2,E2}",
    "r3::{X3,E3}",
    "r4::{X4}",
    "r5::{X3}"
]

list_of_stoichiometry_records = [
    # name,species,coefficient
    "r1,X1,2.0"
]
```

### Section descriptions

**`[metadata]`** — optional metadata about the model:
- `author`: Author of the model
- `date`: Date the model was created
- `version`: Model version
- `description`: A short description of the model

**`[model]`** — the model definition:
- `list_of_static_species`: Species with constant (externally set) concentrations, e.g., enzymes
- `list_of_dynamic_species`: Species governed by ODEs
- `list_of_connection_records`: Reaction connectivity in the format `name::{reactants} --> {products}`. Use empty braces `{}` for source or sink reactions
- `list_of_kinetics_records`: Kinetic dependencies in the format `name::{factor_1,factor_2,...}`. Lists which species appear in the rate law for each reaction
- `list_of_stoichiometry_records`: Override default stoichiometric coefficients (default is ``\pm 1``). Format: `name,species,coefficient`

## BST Format

The BST format (`.bst`) is a custom text format using section markers. Comments are prefixed with `//`.

### Example

```
// Linear pathway with feedback inhibition

#static::start
    E1,E2,E3
#static::end

#dynamic::start
    X1, X2, X3, X4, X5
#dynamic::end

#structure::start
    r1::{X1} --> X2
    r2::{X2} --> X3
    r3::X3 --> X4
    r5::X3 --> X5
    r0::{} --> X1
    r4::X4 --> {}
#structure::end

#rate::start
    r0::{}
    r1::{X1,X4,E1}
    r2::{X2,E2}
    r3::{X3,E3}
    r4::{X4}
    r5::{X3}
#rate::end

#stoichiometry::start
    r1,X1,2.0
#stoichiometry::end
```

### Sections
- `#static` — comma-separated list of static species
- `#dynamic` — comma-separated list of dynamic species
- `#structure` — reaction connectivity (same syntax as TOML `list_of_connection_records`)
- `#rate` — kinetic dependencies (same syntax as TOML `list_of_kinetics_records`)
- `#stoichiometry` — stoichiometric coefficient overrides

## JLD2 Format

Models can be saved to and loaded from [JLD2](https://github.com/JuliaIO/JLD2.jl) binary files (`.jld2`) using the [`savemodel`](@ref) and [`loadmodel`](@ref) functions. This is useful for serializing a fully configured model (with parameters, initial conditions, etc.) for later use.

```julia
# save a configured model
savemodel("my_model.jld2", model)

# load it back
model = loadmodel("my_model.jld2")

# or equivalently
model = build("my_model.jld2")
```
