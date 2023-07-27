using Documenter
using DocumenterTools
using BSTModelKit

makedocs(
    sitename = "BSTModelKit",
    format = Documenter.HTML(),
    modules = [BSTModelKit]
)

deploydocs(
    repo = "github.com/varnerlab/BSTModelKit.jl.git", branch = "gh-pages", target = "build", deploy_config = auto_detect_deploy_system()
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
