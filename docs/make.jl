using Documenter
using BSTModelKit

makedocs(
    sitename = "BSTModelKit",
    format = Documenter.HTML(; prettyurls = get(ENV, "CI", nothing) == "true"),
    modules = [BSTModelKit],
    pages = [
        "Home" => "index.md",
        "File Formats" => "file_formats.md",
        "Examples" => "examples.md",
        "API Reference" => "functions.md",
    ]
)

deploydocs(
    repo = "github.com/varnerlab/BSTModelKit.jl.git",
    branch = "gh-pages",
    devbranch = "main",
)
