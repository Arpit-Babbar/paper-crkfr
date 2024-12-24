function bf2str(bflux)
    if bflux == evaluate
        return "EA"
    else
        @assert bflux == extrapolate
        return "AE"
    end
end

solver2string(solver::String) = solver
solver2string(solver::cRKSolver) = string(solver)[1:end-2]
degree2solver(degree) = eval(Meta.parse("cRK$(degree+1)$(degree+1)"))