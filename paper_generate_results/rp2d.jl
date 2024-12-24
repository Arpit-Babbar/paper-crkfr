using Tenkai, Tenkai
using Trixi
using TrixiBase: trixi_include

nx = 256
final_time = 0.25
trixi_include(joinpath(cRK_elixirs_dir(), "elixir_rp2d.jl"),
              output_directory = joinpath("paper_results", "out_trixi_rp2d"),
              trees_per_dimension = (2 * nx, 2 * nx),
              tspan = (0.0, final_time))

trixi_include(joinpath(cRK_examples_dir(), "2d", "run_rp2d_12.jl"),
              saveto = joinpath("paper_results", "cRK_rp2d"),
              nx = nx, final_time = final_time)
