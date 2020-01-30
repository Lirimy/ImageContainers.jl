# ImageContainers

Store an image to show in Jupyter / Juno.

Examples are in [Jupyter Notebook](example/example.ipynb)


## Installation

```julia
]add https://github.com/Lirimy/ImageContainers.jl
```

## Usage

```julia
using ImageContainers

imagedata = read("sample.png")
fmt = :png
c = storeimage(fmt, imagedata)

# short version (automatic inference by file extension)
c = storeimage("sample.png")

# access to content
c.content # == imagedata
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

