using Base64
using FileIO

"""
    ImageContainer{format, S}

Stores raw image data as `format`.

supported format = [:jlc, :png, :svg, :jpg, :jpeg, :bmp, :gif, :mp4, :webm]
`:jlc` represents `Matrix{T<:Color}`.
"""
struct ImageContainer{fmt, T}
    content::T
    ImageContainer{fmt}(data) where fmt = new{fmt, typeof(data)}(data)
end

#function loadimage(filename::AbstractString)


const plainmimes = Dict(
    :png    => "image/png",
    :svg    => "image/svg+xml",
    :jpg    => "image/jpeg",
    :jpeg   => "image/jpeg",
    :bmp    => "image/bmp",     # for Juno
    :gif    => "image/gif"      # for Juno
)

# Without converting
for (fmt, mime) in plainmimes
    @eval function Base.show(io::IO, ::@MIME_str($mime),
                             c::ImageContainer{$(QuoteNode(fmt))})
        write(io, c.content)
    end
end

# With Base64 encoding
for fmt in (:gif, :bmp)
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
for fmt in (:mp4, :webm)
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

# Julia image = Matrix{<:Color}
# Needs converting to Bitmap
function Base.show(io::IO, ::MIME"text/html", c::ImageContainer{:jlc})
    write(io, "<img src=\"data:image/bmp;base64,")
    ioenc = Base64EncodePipe(io)
    save(Stream(format"BMP", ioenc), c.content)
    close(ioenc)
    write(io, "\" />")
end

# Juno videos
for fmt in (:mp4, :webm)
    @eval function Base.show(io::IO,
                            ::MIME"application/prs.juno.plotpane+html",
                            c::ImageContainer{$(QuoteNode(fmt))})
        show(io, MIME("text/html"), c)
    end
end
