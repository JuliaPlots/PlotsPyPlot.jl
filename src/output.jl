function _display(plt::Plot{PyPlotBackend})
    plt.o[:show]()
end



_pyplot_mimeformats = Dict(
    "application/eps"         => "eps",
    "image/eps"               => "eps",
    "application/pdf"         => "pdf",
    "image/png"               => "png",
    "application/postscript"  => "ps",
    "image/svg+xml"           => "svg"
)


for (mime, fmt) in _pyplot_mimeformats
    @eval function _show(io::IO, ::MIME{Symbol($mime)}, plt::Plot{PyPlotBackend})
        fig = plt.o
        fig[:canvas][:print_figure](
            io,
            format=$fmt,
            # bbox_inches = "tight",
            # figsize = map(px2inch, plt[:size]),
            facecolor = fig[:get_facecolor](),
            edgecolor = "none",
            dpi = plt[:dpi] * plt[:thickness_scaling]
        )
    end
end

closeall(::PyPlotBackend) = PyPlot.plt[:close]("all")
