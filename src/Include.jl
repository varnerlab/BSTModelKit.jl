# setup internal paths -
_PATH_TO_SRC = dirname(pathof(@__MODULE__))

# load external packages that are required -
using DifferentialEquations
using GlobalSensitivity
using QuasiMonteCarlo
using JLD2
using FileIO
using TOML
using NonlinearSolve

# load my codes -
include(joinpath(_PATH_TO_SRC, "Types.jl"))
include(joinpath(_PATH_TO_SRC, "Utility.jl"))
include(joinpath(_PATH_TO_SRC, "Factory.jl"))
include(joinpath(_PATH_TO_SRC, "Kinetics.jl"))
include(joinpath(_PATH_TO_SRC, "Balances.jl"))
include(joinpath(_PATH_TO_SRC, "Simulation.jl"))
include(joinpath(_PATH_TO_SRC, "Sensitivity.jl"))
