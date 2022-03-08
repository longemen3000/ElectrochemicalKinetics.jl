using FastGaussQuadrature

# helper function to be able to "naturally" use the interval of integration that we want with FastGaussQuadrature, which returns nodes and weights for the interval [-1, 1] (see https://en.wikipedia.org/wiki/Gaussian_quadrature#Change_of_interval)
function scale_integration_nodes(unscaled_x, unscaled_w, lb::Real, ub::Real)
    w = @. 0.5 * (ub - lb) * unscaled_w
    x = @. 0.5 * (ub + lb) + 0.5 * (ub - lb) * unscaled_x
    x, w
end

function scale_integration_nodes(unscaled_x, unscaled_w, lb, ub)
	# @show lb, ub
    ns_and_ws = scale_integration_nodes.(Ref(unscaled_x), Ref(unscaled_w), lb, ub)
    ns, ws = Zygote.unzip(ns_and_ws)
    reduce(hcat, ns), reduce(hcat, ws)
end


# Can't get this to broadcast correctly - but this is the right sort of
# approach to take here. Of note - this is 2x faster in the forwards pass
# and about 10x faster in the backwards pass compared to the other method
# function scale_integration_nodes2(unscaled_x, unscaled_w, lb, ub)
#     w_scale = @. 0.5 * (ub - lb)
#     x_scale = @. 0.5 * (ub + lb) + 0.5 * (ub - lb)
#     unscaled_x * x_scale', unscaled_w * w_scale'
#     # x_scale * unscaled_x, unscaled_w * w_scale'
# end
