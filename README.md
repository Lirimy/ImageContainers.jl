# ImageContainers

Store an image to show in Jupyter / Juno.

![sample](https://user-images.githubusercontent.com/31124605/73450248-5d790380-43a8-11ea-8f6a-d321accd809e.png)

More examples are in [Jupyter Notebook](example/example.ipynb)


## Installation

```julia
]add https://github.com/Lirimy/ImageContainers.jl
```

## Usage

```julia
using ImageContainers

c = storeimage(:png, "sample.png")

# shortened form
c = storeimage("sample.png")
```

## Supported Image Formats


- jlc = Matrix{<:Color}
- png
- svg
- jpg/jpeg
- bmp
- gif
- mp4
- webm

