module ImageContainers

import Base: show
import FileIO: save, @format_str, Stream
import Base64: Base64EncodePipe

export ImageContainer

include("show.jl")

end # module
