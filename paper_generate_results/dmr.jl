using Tenkai, Tenkai
using Trixi
using TrixiBase: trixi_include

trixi_include(joinpath(cRK_elixirs_dir(), "elixir_double_mach_reflection.jl"),
              output_directory = joinpath(@__DIR__, "paper_results", "out_trixi_dmr"))
trixi_include(joinpath(cRK_examples_dir(), "2d/run_double_mach_reflection.jl"),
              saveto = joinpath("paper_results", "crk_dmr"))
