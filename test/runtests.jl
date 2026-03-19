# load required packages -
using BSTModelKit
using Test

# create tmp directory for save/load tests -
_test_tmp_dir = joinpath(pwd(), "tmp")
if !isdir(_test_tmp_dir)
    mkdir(_test_tmp_dir)
end

# load test files -
test_filename_array = [
    "test_build_bst_model_object.jl"    ;
    "test_build_toml_model_object.jl"   ;
    "test_save_jld2_model_object.jl"    ;
    "test_load_jld2_model_object.jl"    ;
    "test_build_run_feedback_model.jl"  ;
    "test_steady_state_solve.jl"        ;
    "test_morris_method.jl"             ;
    "test_sobol_method.jl"              ;
];

for filename ∈ test_filename_array
    include(joinpath(pwd(), filename));
end

@testset "BSTModelKit tests" begin

    @testset "Model building" begin
        @test test_build_bst_model_object() == true
        @test test_build_toml_model_object() == true
    end

    @testset "Model save/load" begin
        @test test_save_jld2_model_object() == true
        @test test_load_jld2_model_object() == true
    end

    @testset "Simulation" begin
        @test test_build_run_feedback_model() == true
        @test test_steady_state_solve() == true
    end

    @testset "Sensitivity analysis" begin
        @test test_morris_method() == true
        @test test_sobol_method() == true
    end
end
