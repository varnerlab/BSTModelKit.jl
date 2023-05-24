using Documenter
using BSTModelKit

makedocs(
    sitename = "BSTModelKit",
    format = Documenter.HTML(),
    modules = [BSTModelKit]
)

deploydocs(
    repo = "github.com/varnerlab/BSTModelKit.jl.git", branch = "gh-pages", target = "build"
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
