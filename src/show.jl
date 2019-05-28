using Base: show
using Base64: Base64EncodePipe
using FileIO: save, @format_str, Stream

"""
Stores raw image data

format = [:jlc, :png, :svg, :jpg, :jpeg, :bmp, :gif, :mp4]

:jlc represents Matrix{T} where T <: Color

```
c = open("test.png") do io
    ImageContainer{:png}(read(io))
end
```
"""
struct ImageContainer{format}
    content
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
    @eval function Base.show(io::IO, ::@MIME_str($mime), c::ImageContainer{$[fmt]...})
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

