module BSTModelKit

    # load the include -> this has the "using" call for all the packahes we need, and loads out *.jl files
    include("Include.jl")

    # export types -> these types will be visible to the public -
    export AbstractBSTModel, BSTModel

    # export methods -> these methods will be visible to the public -
    export build
    export save
    export evaluate
    export morris
    export sobol
    export steadystate

end # module BSTModelKit
