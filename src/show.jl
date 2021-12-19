using Base64
using FileIO

"""
ImageContainer{fmt}(data)

Stores raw image `data` as format `fmt`.

supported format = [:png, :svg, :jpeg, :bmp, :gif, :mp4, :webm]
"""
struct ImageContainer{fmt, T}
    content::T
    ImageContainer{fmt}(data) where fmt = new{fmt, typeof(data)}(data)
end

getformat(filename::AbstractString) = query(filename) |> getformat
getformat(f::File{DataFormat{:UNKNOWN}}) = file_extension(f)[2:end] |> Symbol
getformat(f::File{DataFormat{T}}) where T = lowercase(string(T)) |> Symbol

loadimage(filename::AbstractString; fmt=getformat(filename)) = ImageContainer{fmt}(read(filename))

const plainmimes = Dict(
    :png    => "image/png",
    :svg    => "image/svg+xml",
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
for fmt in (:jpeg, :gif, :bmp)
    @eval function Base.show(io::IO, ::MIME"text/html",
                             c::ImageContainer{$(QuoteNode(fmt))})
        write(io, "<img src=\"data:image/", $(QuoteNode(fmt)), ";base64,")
        ioenc = Base64EncodePipe(io)
        write(ioenc, c.content)
        close(ioenc)
        write(io, "\" />")
    end
end

const videomimes = Dict(
    :mp4        => "video/mp4",
    :matroska   => "video/webm"
)

# Videos
for (fmt, mime) in videomimes
    @eval function Base.show(io::IO, ::MIME"text/html",
                             c::ImageContainer{$(QuoteNode(fmt))})
        write(io, "<video controls autoplay loop src=\"data:",
                  $mime, ";base64,")
        ioenc = Base64EncodePipe(io)
        write(ioenc, c.content)
        close(ioenc)
        write(io, "\" />")
    end
end

# Juno videos
for fmt in (:jpeg, :gif, :bmp, :mp4, :webm), mime in (MIME"application/prs.juno.plotpane+html", MIME"juliavscode/html")
    @eval function Base.show(io::IO, ::$(mime), c::ImageContainer{$(QuoteNode(fmt))})
        show(io, MIME("text/html"), c)
    end
end

const testimages = begin
    testimagedir = joinpath(pkgdir(ImageContainers), "resources\\testimage\\")
    readdir(testimagedir; join=true)
end

function showtestimages(ix=eachindex(testimages))
    d = Base.Multimedia.displays[end]
    println(d)
    for i in ix
        c = loadimage(testimages[i])
        println(typeof(c))
        display(c)
    end
end
