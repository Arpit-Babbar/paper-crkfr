using Tenkai, Tenkai
using TrixiBase: trixi_include

trixi_include(joinpath(cRK_examples_dir(), "1d",
                       "run_tenmom_two_rare_homogeneous.jl"),
              solver = cRK44(),
              saveto = "paper_results/tenmom_homogeneous")

trixi_include(joinpath(cRK_examples_dir(), "1d",
                       "run_tenmom_two_rare_source.jl"),
              solver = cRK44(),
              saveto = "paper_results/tenmom_source")

nuT = 1.0
trixi_include(joinpath(cRK_examples_dir(), "2d",
                       "run_tenmom_realistic.jl"),
              solver = cRK44(), nuT_ = nuT,
              nx = 25, ny = 25,
              saveto = "paper_results/tenmom_realistic_nuT$nuT")

nuT = 0.0
trixi_include(joinpath(cRK_examples_dir(), "2d",
                       "run_tenmom_realistic.jl"),
              solver = cRK44(), nuT_ = nuT,
              nx = 25, ny = 25,
              saveto = "paper_results/tenmom_realistic_nuT$nuT")


