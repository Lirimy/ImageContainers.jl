#using Base: show
using Base64: Base64EncodePipe
using FileIO: save, @format_str, Stream

"""
    ImageContainer{format, S}

Stores raw image data as `format`.

supported format = [:jlc, :png, :svg, :jpg, :jpeg, :bmp, :gif, :mp4, :webm]
`:jlc` represents `Matrix{T<:Color}`.
"""
struct ImageContainer{format, S}
    content::S
end

function fileextension(file::AbstractString)
    _, ex = Base.Filesystem.splitext(file)
    if length(ex) <= 1
        ""
    else
        ex[2:end]
    end
end

"""
    storeimage(format::Symbol, data)
    storeimage(file::AbstractString)

Stores `data` as `format`.
Returns `ImageContainer{format, typeof(data)}`.

# Examples
```julia
c1 = storeimage(:png, read("image.png"))
c2 = storeimage("image.png")
```
"""
storeimage(format::Symbol, data) = ImageContainer{format, typeof(data)}(data)

function storeimage(file::AbstractString)
    ex = fileextension(file)
    if ex == ""
        error("Format identification failed: $file")
    else
        storeimage(Symbol(ex), read(file))
    end
end

# Formats Jupyter accepts without convert/processing
const mimetexts = Dict(
    :png    => "image/png",
    :svg    => "image/svg+xml",
    :jpg    => "image/jpeg",
    :jpeg   => "image/jpeg"
)


# function Base.show(io::IO, ::MIME"image/png", c::ImageContainer{:png})
#     write(io, c.content)
# end

for (fmt, mime) in mimetexts
    @eval function Base.show(io::IO, ::@MIME_str($mime), c::ImageContainer{$(QuoteNode(fmt))})
        write(io, c.content)
    end
end

# Julia Image
# Matrix{<:Color}
function Base.show(io::IO, ::MIME"text/html", c::ImageContainer{:jlc})
    write(io, "<img src=\"data:image/bmp;base64,")

    ioenc = Base64EncodePipe(io)
    save(Stream(format"BMP", ioenc), c.content)
    close(ioenc)

    write(io, "\" />")
end

function Base.show(io::IO, ::MIME"text/html", c::ImageContainer{:gif})

    write(io, "<img src=\"data:image/gif;base64,")

    ioenc = Base64EncodePipe(io)
    write(ioenc, c.content)
    close(ioenc)

    write(io, "\" />")
end

function Base.show(io::IO, ::MIME"text/html", c::ImageContainer{:bmp})

    write(io, "<img src=\"data:image/bmp;base64,")

    ioenc = Base64EncodePipe(io)
    write(ioenc, c.content)
    close(ioenc)

    write(io, "\" />")
end

function Base.show(io::IO, ::MIME"text/html", c::ImageContainer{:mp4})

    write(io, "<video controls autoplay loop src=\"data:video/mp4;base64,")

    ioenc = Base64EncodePipe(io)
    write(ioenc, c.content)
    close(ioenc)

    write(io, "\" />")
end

function Base.show(io::IO, ::MIME"text/html", c::ImageContainer{:webm})

    write(io, "<video controls autoplay loop src=\"data:video/webm;base64,")

    ioenc = Base64EncodePipe(io)
    write(ioenc, c.content)
    close(ioenc)

    write(io, "\" />")
end
