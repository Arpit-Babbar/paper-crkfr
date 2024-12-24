using Tenkai

@assert Threads.nthreads() == 1 "There is a race condition in the code. Please use
   a single thread for this code"

include("StepGrid.jl")
include("FR2D.jl")
include("EqEuler2D.jl")
