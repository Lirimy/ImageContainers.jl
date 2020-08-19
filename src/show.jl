using Base64
using FileIO

"""
ImageContainer{fmt}(data)

Stores raw image `data` as format `fmt`.

supported format = [:PNG, :SVG, :JPEG, :BMP, :GIF, :MP4, :WEBM]
"""
struct ImageContainer{fmt, T}
    content::T
    ImageContainer{fmt}(data) where fmt = new{fmt, typeof(data)}(data)
end

getformat(f::File{DataFormat{T}}) where T = T
getformat(filename::AbstractString) = query(filename) |> getformat

loadimage(filename::AbstractString; fmt=getformat(filename)) = ImageContainer{fmt}(read(filename))

const plainmimes = Dict(
    :PNG    => "image/png",
    :SVG    => "image/svg+xml",
    :JPEG   => "image/jpeg",
    :BMP    => "image/bmp",     # for Juno
    :GIF    => "image/gif"      # for Juno
)

# Without converting
for (fmt, mime) in plainmimes
    @eval function Base.show(io::IO, ::@MIME_str($mime),
                             c::ImageContainer{$(QuoteNode(fmt))})
        write(io, c.content)
    end
end

# With Base64 encoding
for fmt in (:GIF, :BMP)
    @eval function Base.show(io::IO, ::MIME"text/html",
                             c::ImageContainer{$(QuoteNode(fmt))})
        write(io, "<img src=\"data:image/", $(QuoteNode(fmt)), ";base64,")
        ioenc = Base64EncodePipe(io)
        write(ioenc, c.content)
        close(ioenc)
        write(io, "\" />")
    end
end

# Videos
for fmt in (:MP4, :WEBM)
    @eval function Base.show(io::IO, ::MIME"text/html",
                             c::ImageContainer{$(QuoteNode(fmt))})
        write(io, "<video controls autoplay loop src=\"data:video/",
                  $(QuoteNode(fmt)), ";base64,")
        ioenc = Base64EncodePipe(io)
        write(ioenc, c.content)
        close(ioenc)
        write(io, "\" />")
    end
end

# Juno videos
for fmt in (:MP4, :WEBM)
    @eval function Base.show(io::IO,
                            ::MIME"application/prs.juno.plotpane+html",
                            c::ImageContainer{$(QuoteNode(fmt))})
        show(io, MIME("text/html"), c)
    end
end
