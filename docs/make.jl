using Documenter
using DocumenterTools
using BSTModelKit

push!(LOAD_PATH,"../src/")


makedocs(
    sitename = "BSTModelKit",
    format = Documenter.HTML(; prettyurls = get(ENV, "CI", nothing) == "true"),
    modules = [BSTModelKit],
    pages = [
        "Home" => "index.md",
        "Functions" => "functions.md",
        "Examples" => "examples.md",
    ]
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

# deploydocs(
#     root = ".",
#     target = "build",
#     dirname = "",
#     repo = "github.com/varnerlab/BSTModelKit.jl.git",
#     branch = "gh-pages",
#     devbranch = nothing,
#     forcepush = false,
#     deploy_config = auto_detect_deploy_system(),
#     push_preview = false,
#     repo_previews = repo,
#     branch_previews = branch,
# )
