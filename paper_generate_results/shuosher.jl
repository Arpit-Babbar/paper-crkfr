using Tenkai, Tenkai
using TrixiBase: trixi_include

shuosher_run_file = joinpath(cRK_examples_dir(), "1d", "run_shuosher.jl")
trixi_include(shuosher_run_file, solver = cRK44(), degree = 3, nx = 400,
              limiter = :limiter_blend, blend_type = :MH,
              saveto = "paper_results/shuosher_mh_blend")
trixi_include(shuosher_run_file, solver = cRK44(), degree = 3, nx = 400,
              limiter = :limiter_blend, blend_type = :FO,
              saveto = "paper_results/shuosher_fo_blend")
trixi_include(shuosher_run_file, solver = cRK44(), degree = 3, nx = 400,
              limiter = :limiter_tvb,
              saveto = "paper_results/shuosher_tvb")
