# default implementation 

# lod required packages -
using BSTModelKit
using Test

# load my test files -
test_filename_array = [
    "test_build_bst_model_object.jl"    ;
    "test_build_toml_model_object.jl"   ;
    "test_load_jld2_model_object.jl"    ;
    "test_save_jld2_model_object.jl"    ;
    "test_build_run_feedback_model.jl"  ;
];

for filename ∈ test_filename_array
    include(joinpath(pwd(),filename));
end

# -- Default test ------------------------------------------------------ #
function default_bstmodelkit_test() 
    return true
end
# ------------------------------------------------------------------------------- #

@testset "default_test_set" begin
    @test default_bstmodelkit_test() == true
    @test test_build_bst_model_object() == true
    @test test_build_toml_model_object() == true
    @test test_save_jld2_model_object() == true
    @test test_load_jld2_model_object() == true
    @test test_build_run_feedback_model() == true
end