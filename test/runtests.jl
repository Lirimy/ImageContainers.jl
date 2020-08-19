using ImageContainers
using Test
using Base64, FileIO

function writebuf(c::ImageContainer, mime::AbstractString)
    buf = IOBuffer()
    show(buf, MIME(mime), c)
    take!(buf)
end

@testset "ImageContainers.jl" begin
    data = rand(UInt8, 4)
    b64data = base64encode(data)

    @test ImageContainer{:a}(3).content == 3
    for (fmt, mime) in ImageContainers.plainmimes
        c = ImageContainer{fmt}(data)
        @test c.content == data
        @test writebuf(c, mime) == data
    end
    for fmt in (:gif, :bmp)
        c = ImageContainer{fmt}(data)
        @test c.content == data
        @test String(writebuf(c, "text/html")) ==
            "<img src=\"data:image/$fmt;base64,$b64data\" />"
    end
    for fmt in (:mp4, :webm)
        for mime in ("text/html", "application/prs.juno.plotpane+html")
            c = ImageContainer{fmt}(data)
            @test c.content == data
            @test String(writebuf(c, mime)) ==
                "<video controls autoplay loop " *
                "src=\"data:video/$fmt;base64,$b64data\" />"
        end
    end
end
