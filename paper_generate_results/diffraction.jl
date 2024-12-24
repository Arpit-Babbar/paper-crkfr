using Tenkai, Tenkai
using Trixi
using TrixiBase: trixi_include

@assert Threads.nthreads() == 1 "There is a race condition in the code. Please use
   a single thread for this code"

trixi_include(joinpath(cRK_examples_dir(), "2d", "run_shock_diffraction.jl"),
              ny = 100,
              saveto = joinpath("paper_results", "shock_diffraction"))
