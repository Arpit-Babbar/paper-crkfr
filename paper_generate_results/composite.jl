using Tenkai, Tenkai
using TrixiBase: trixi_include

composite_run_file = joinpath(cRK_examples_dir(), "2d", "run_rotate_composite.jl")
trixi_include(composite_run_file, solver = cRK44(), degree = 3, final_time = 2.0 * pi,
              nx = 100,
              limiter = :limiter_blend, blend_type = :MH,
              saveto = "paper_results/composite_mh_blend")
trixi_include(composite_run_file, solver = cRK44(), degree = 3, final_time = 2.0 * pi,
              nx = 100,
              limiter = :limiter_blend, blend_type = :FO,
              saveto = "paper_results/composite_fo_blend")
trixi_include(composite_run_file, solver = cRK44(), degree = 3, final_time = 2.0 * pi,
              nx = 100,
              limiter = :limiter_tvb,
              saveto = "paper_results/composite_tvb")
