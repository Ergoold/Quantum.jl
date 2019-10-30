module Quantum

using LinearAlgebra

export QuantumRegister

struct QuantumRegister
    size::Int
    prod::Vector{Float64}

    QuantumRegister(size::Int) = new(size, vcat([1], zeros(Float64, 2 ^ size - 1)))
end

end # module
