using Reexport
@reexport using Plots

for sym in names(Plots, all = true)
    if !(sym in (:eval, Symbol("#eval"), :include, Symbol("#include")))
        @eval import Plots.$sym
    end
end

using Plots.PlotMeasures
import Plots.PlotMeasures: Length, AbsoluteLength, Measure, width, height

# problem: https://github.com/tbreloff/Plots.jl/issues/308
# solution: hack from @stevengj: https://github.com/stevengj/PyPlot.jl/pull/223#issuecomment-229747768
otherdisplays = splice!(Base.Multimedia.displays, 2:length(Base.Multimedia.displays))
import PyPlot, PyCall
export PyPlot, PyCall
import LaTeXStrings: latexstring
append!(Base.Multimedia.displays, otherdisplays)

pycolors = PyPlot.pyimport("matplotlib.colors")
pypath = PyPlot.pyimport("matplotlib.path")
mplot3d = PyPlot.pyimport("mpl_toolkits.mplot3d")
pypatches = PyPlot.pyimport("matplotlib.patches")
pyfont = PyPlot.pyimport("matplotlib.font_manager")
pyticker = PyPlot.pyimport("matplotlib.ticker")
pycmap = PyPlot.pyimport("matplotlib.cm")
pynp = PyPlot.pyimport("numpy")
pynp["seterr"](invalid="ignore")
pytransforms = PyPlot.pyimport("matplotlib.transforms")
pycollections = PyPlot.pyimport("matplotlib.collections")
pyart3d = PyPlot.art3D

# "support" matplotlib v1.5
set_facecolor_sym = if PyPlot.version < v"2"
    warn("You are using Matplotlib $(PyPlot.version), which is no longer officialy supported by the Plots community. To ensure smooth Plots.jl integration update your Matplotlib library to a version >= 2.0.0")
    :set_axis_bgcolor
else
    :set_facecolor
end

# we don't want every command to update the figure
PyPlot.ioff()


_attr[:pyplot] = merge_with_base_supported([
    :annotations,
    :background_color_legend, :background_color_inside, :background_color_outside,
    :foreground_color_grid, :foreground_color_legend, :foreground_color_title,
    :foreground_color_axis, :foreground_color_border, :foreground_color_guide, :foreground_color_text,
    :label,
    :linecolor, :linestyle, :linewidth, :linealpha,
    :markershape, :markercolor, :markersize, :markeralpha,
    :markerstrokewidth, :markerstrokecolor, :markerstrokealpha,
    :fillrange, :fillcolor, :fillalpha,
    :bins, :bar_width, :bar_edges, :bar_position,
    :title, :title_location, :titlefont,
    :window_title,
    :guide, :lims, :ticks, :scale, :flip, :rotation,
    :titlefontfamily, :titlefontsize, :titlefontcolor,
    :legendfontfamily, :legendfontsize, :legendfontcolor,
    :tickfontfamily, :tickfontsize, :tickfontcolor,
    :guidefontfamily, :guidefontsize, :guidefontcolor,
    :grid, :gridalpha, :gridstyle, :gridlinewidth,
    :legend, :legendtitle, :colorbar,
    :marker_z, :line_z, :fill_z,
    :levels,
    :ribbon, :quiver, :arrow,
    :orientation,
    :overwrite_figure,
    :polar,
    :normalize, :weights,
    :contours, :aspect_ratio,
    :match_dimensions,
    :clims,
    :inset_subplots,
    :dpi,
    :colorbar_title,
    :stride,
    :framestyle,
    :tick_direction,
    :camera,
    :contour_labels,
  ])
_seriestype[:pyplot] = [
        :path, :steppre, :steppost, :shape, :straightline,
        :scatter, :hexbin, #:histogram2d, :histogram,
        # :bar,
        :heatmap, :pie, :image,
        :contour, :contour3d, :path3d, :scatter3d, :surface, :wireframe
    ]
_style[:pyplot] = [:auto, :solid, :dash, :dot, :dashdot]
_marker[:pyplot] = vcat(_allMarkers, :pixel)
_scale[:pyplot] = [:identity, :ln, :log2, :log10]
is_marker_supported(::PyPlotBackend, shape::Shape) = true
