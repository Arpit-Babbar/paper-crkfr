using Tenkai, Tenkai
using Trixi
using TrixiBase: trixi_include

nx = 64
final_time = 20.0
trixi_include(joinpath(cRK_elixirs_dir(), "elixir_sedov_periodic.jl"),
              output_directory = joinpath("paper_results", "out_trixi_sedov_periodic"),
              trees_per_dimension = (nx, nx), tspan = (0.0, final_time))

trixi_include(joinpath(cRK_elixirs_dir(), "elixir_sedov_periodic.jl"),
              output_directory = joinpath("paper_results",
                                          "out_trixi_sedov_periodic_reference"),
              trees_per_dimension = (2 * nx, 2 * nx), tspan = (0.0, final_time))

trixi_include(joinpath(cRK_examples_dir(), "2d", "run_sedov_gassner.jl"),
              saveto = joinpath("paper_results", "cRK_sedov_periodic"),
              nx = nx, final_time = final_time)
