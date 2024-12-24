using Tenkai, Tenkai
using TrixiBase: trixi_include

titarev_toro_run_file = joinpath(cRK_examples_dir(), "1d", "run_titarev_toro.jl")
trixi_include(titarev_toro_run_file, solver = cRK44(), degree = 3, nx = 800,
              limiter = :limiter_blend, blend_type = :MH,
              saveto = "paper_results/titarev_toro_mh_blend")
trixi_include(titarev_toro_run_file, solver = cRK44(), degree = 3, nx = 800,
              limiter = :limiter_blend, blend_type = :FO,
              saveto = "paper_results/titarev_toro_fo_blend")
trixi_include(titarev_toro_run_file, solver = cRK44(), degree = 3, nx = 800,
              limiter = :limiter_tvb,
              saveto = "paper_results/titarev_toro_tvb")
