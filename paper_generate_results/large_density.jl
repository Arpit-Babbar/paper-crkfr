using Tenkai, Tenkai
using TrixiBase: trixi_include

blast_run_file = joinpath(cRK_examples_dir(), "1d", "run_large_density.jl")
trixi_include(blast_run_file, solver = cRK44(), degree = 3, nx = 500,
              limiter = :limiter_blend, blend_type = :MH,
              saveto = "paper_results/large_density_mh_blend")
trixi_include(blast_run_file, solver = cRK44(), degree = 3, nx = 500,
              limiter = :limiter_blend, blend_type = :FO,
              saveto = "paper_results/large_density_fo_blend")
trixi_include(blast_run_file, solver = cRK44(), degree = 3,
              limiter = :limiter_tvb, nx = 500,
              saveto = "paper_results/large_density_tvb")
