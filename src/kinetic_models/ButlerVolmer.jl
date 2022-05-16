"""
    ButlerVolmer(A, α)
    ButlerVolmer(A)

Computes Butler-Volmer kinetics. 

If initialized with one argument, assumes symmetric electron transfer (α=0.5) and sets this to be the prefactor A. Note that this prefactor implicitly contains information about equilibrium activation energies, as well as geometric information.
"""
struct ButlerVolmer <: KineticModel
    A::Float64
    α::Float64
end

# default to unit prefactor and symmetric response
ButlerVolmer() = ButlerVolmer(1.0, 0.5)
ButlerVolmer(A) = ButlerVolmer(A, 0.5)

function (bv::ButlerVolmer)(V_app, ::Val{true}; kT::Real = 0.026)
    exp_arg = (bv.α .* V_app) ./ kT
    bv.A .* exp.(exp_arg)
end

function (bv::ButlerVolmer)(V_app, ::Val{false}; kT::Real = 0.026)
    exp_arg = -((1 - bv.α) .* V_app) ./ kT
    bv.A .* exp.(exp_arg)
end