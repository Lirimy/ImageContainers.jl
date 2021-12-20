# ImageContainers

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://Lirimy.github.io/ImageContainers.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://Lirimy.github.io/ImageContainers.jl/dev)
[![Build Status](https://travis-ci.com/Lirimy/ImageContainers.jl.svg?branch=master)](https://travis-ci.com/Lirimy/ImageContainers.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/Lirimy/ImageContainers.jl?svg=true)](https://ci.appveyor.com/project/Lirimy/ImageContainers-jl)
[![Codecov](https://codecov.io/gh/Lirimy/ImageContainers.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/Lirimy/ImageContainers.jl)
[![Coveralls](https://coveralls.io/repos/github/Lirimy/ImageContainers.jl/badge.svg?branch=master)](https://coveralls.io/github/Lirimy/ImageContainers.jl?branch=master)
[![Build Status](https://api.cirrus-ci.com/github/Lirimy/ImageContainers.jl.svg)](https://cirrus-ci.com/github/Lirimy/ImageContainers.jl)

Just display an image.

Lightweight, no decoding.

![sample](https://user-images.githubusercontent.com/31124605/73450248-5d790380-43a8-11ea-8f6a-d321accd809e.png)

More examples are in [Jupyter Notebook](example/example.ipynb)

## Installation

```julia
]add ImageContainers
```

## Usage

```julia
using ImageContainers
c = loadimage("sample.png") # automatically displayed
```

## Supported Image Formats

- png
- svg
- jpg/jpeg
- bmp
- gif
- mp4
- webm

