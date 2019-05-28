# ImageContainers

Store image to show in Jupyter


![example](example/example.png)

More examples in [Jupyter Notebook](example/example.ipynb)


## Installation

```julia
]add https://github.com/Lirimy/ImageContainers.jl
```

## Usage

```julia
using ImageContainers

imagedata = ... # from file, etc.
fmt = :png
c = ImageContainers{fmt}(imagedata)

# access to content
c.content # == imagedata
```

## Image Formats


- jlc = Matrix{<:Color}
- png
- svg
- jpg/jpeg
- bmp
- gif
- mp4

