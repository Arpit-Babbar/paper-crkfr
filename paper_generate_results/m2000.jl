using Tenkai, Tenkai
using Trixi
using TrixiBase: trixi_include

nx = 800
final_time = 1e-3
trixi_include(joinpath(cRK_elixirs_dir(), "elixir_euler_astrophysical_m2000.jl"),
              output_directory = joinpath("paper_results", "out_trixi_m2000"),
              trees_per_dimension = (nx, nx),
              tspan = (0.0, final_time))

trixi_include(joinpath(cRK_examples_dir(), "2d", "run_jet_m2000.jl"),
              saveto = joinpath("paper_results", "cRK_jet_m2000"),
              nx = nx, final_time = final_time)
