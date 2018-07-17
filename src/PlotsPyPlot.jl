module PlotsPyPlot

include("init.jl")
include("backend.jl")
include("output.jl")

__init__() = pyplot()

end # module
