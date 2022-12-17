# default implementation 

# lod required packages -
using BSTModelKit
using Test

# -- Default test ------------------------------------------------------ #
function default_bstmodelkit_test() 
    return true
end
# ------------------------------------------------------------------------------- #

@testset "default_test_set" begin
    @test default_bstmodelkit_test() == true
end