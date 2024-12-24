using Tenkai, Tenkai
using TrixiBase: trixi_include

blast_run_file = joinpath(cRK_examples_dir(), "1d", "run_blast.jl")
trixi_include(blast_run_file, solver = cRK44(), degree = 3, nx = 400,
              limiter = :limiter_blend, blend_type = :MH,
              saveto = "paper_results/blast_mh_blend")
trixi_include(blast_run_file, solver = cRK44(), degree = 3, nx = 400,
              limiter = :limiter_blend, blend_type = :FO,
              saveto = "paper_results/blast_fo_blend")
trixi_include(blast_run_file, solver = cRK44(), degree = 3, nx = 400,
              limiter = :limiter_tvb,
              saveto = "paper_results/blast_tvb")
