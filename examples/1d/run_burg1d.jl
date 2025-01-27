using Tenkai
using Tenkai
Eq = Tenkai.EqBurg1D

#------------------------------------------------------------------------------
xmin, xmax = 0.0, 2.0 * pi
initial_value = Eq.initial_value_burger_sin
boundary_value = Eq.zero_boundary_value # dummy function
boundary_condition = (periodic, periodic)
final_time = 2.0

exact_solution = Eq.exact_solution_burger_sin

source_terms_zero(u, x, t, eq) = zero(u)

degree = 2
solver = cRK33()
solution_points = "gl"
correction_function = "radau"
bflux = evaluate
numerical_flux = Eq.rusanov
bound_limit = "no"

nx = 100
cfl = 0.0
bounds = ([-0.2], [0.2])
tvbM = 0.0
save_iter_interval = 0
save_time_interval = 0.0
compute_error_interval = 0
animate = true
diss = "2"
diss = DCSX()
cfl_safety_factor = 0.9
#------------------------------------------------------------------------------
grid_size = nx
domain = [xmin, xmax]
problem = Problem(domain, initial_value, boundary_value, boundary_condition,
                  final_time, exact_solution, source_terms = source_terms_zero)
equation = Eq.get_equation()
limiter = setup_limiter_blend(blend_type = fo_blend(equation),
                              # indicating_variables = Eq.rho_p_indicator!,
                              indicating_variables = conservative_indicator!,
                              reconstruction_variables = conservative_reconstruction,
                              indicator_model = "gassner",
                              debug_blend = false,
                              pure_fv = true)
limiter = setup_limiter_none()
scheme = Scheme(solver, degree, solution_points, correction_function,
                numerical_flux, bound_limit, limiter, bflux, diss)
param = Parameters(grid_size, cfl, bounds, save_iter_interval,
                   save_time_interval, compute_error_interval,
                   animate = animate,
                   cfl_safety_factor = cfl_safety_factor)
#------------------------------------------------------------------------------
sol = Tenkai.solve(equation, problem, scheme, param);

println(sol["errors"])

return sol
