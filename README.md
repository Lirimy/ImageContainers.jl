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

imagedata = read("sample.png")
fmt = :png
c = storeimage(fmt, imagedata)

# shortened form (automatic format inference by the file extension)
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

