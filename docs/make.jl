using Documenter, ImageContainers

makedocs(;
    modules=[ImageContainers],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/Lirimy/ImageContainers.jl/blob/{commit}{path}#L{line}",
    sitename="ImageContainers.jl",
    authors="Lirimy <31124605+Lirimy@users.noreply.github.com>",
    assets=String[],
)

deploydocs(;
    repo="github.com/Lirimy/ImageContainers.jl",
)
