using Tenkai, Tenkai
using Trixi
using TrixiBase: trixi_include

nx = 512
final_time = 0.4
trixi_include(joinpath(cRK_elixirs_dir(), "elixir_euler_kelvin_helmholtz_instability.jl"),
              output_directory = joinpath("paper_results", "out_trixi_kh"),
              initial_refinement_level = 9,
              tspan = (0.0, final_time))

trixi_include(joinpath(cRK_examples_dir(), "2d", "run_kh_schaal.jl"),
              saveto = joinpath("paper_results", "cRK_kh_schaal"),
              nx = nx, final_time = final_time)
