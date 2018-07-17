using Test, PlotsPyPlot

plt = plot(sin)
@test typeof(plt) <: Plots.Plot{Plots.PyPlotBackend}
