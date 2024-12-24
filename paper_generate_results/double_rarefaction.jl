using Tenkai, Tenkai
using TrixiBase: trixi_include

blast_run_file = joinpath(cRK_examples_dir(), "1d", "run_double_rarefaction.jl")
trixi_include(blast_run_file, solver = cRK44(), degree = 3, nx = 200,
              limiter = :limiter_blend, blend_type = :MH,
              saveto = "paper_results/double_rarefaction_mh_blend")
trixi_include(blast_run_file, solver = cRK44(), degree = 3, nx = 200,
              limiter = :limiter_blend, blend_type = :FO,
              saveto = "paper_results/double_rarefaction_fo_blend")
