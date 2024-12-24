using Tenkai, Tenkai
using Trixi
using TrixiBase: trixi_include

trixi_include(joinpath(cRK_examples_dir(), "2d", "run_rayleigh_taylor.jl"),
              saveto = joinpath("paper_results", "rayleigh_taylor"),
              nx = 64, final_time = 2.5)
