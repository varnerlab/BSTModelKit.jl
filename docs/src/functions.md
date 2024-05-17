# Functions

## Models
`BSTModelKit.jl` provides a set of tools for constructing and solving S-system BST representations.
Models are represented by the `BSTModel` type, which is a mutable composite type holding information about the model structure and parameters:
```@docs
BSTModelKit.BSTModel
```

Models can be constructed from a variety of file formats in combination with the `build` function:
```@docs
BSTModelKit.build
```

Once a model is constructed, it can be saved to a file or loaded from a file using the `savemodel` and `loadmodel` functions:
```@docs
BSTModelKit.loadmodel
BSTModelKit.savemodel
```

## Solving
```@docs
BSTModelKit.evaluate
BSTModelKit.steadystate
```

## Sensitivity Analysis
```@docs
BSTModelKit.sobol
BSTModelKit.morris
```

## Utility
```@docs
BSTModelKit.indexin
```