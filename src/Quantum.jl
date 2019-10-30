module Quantum

using LinearAlgebra
import Base.==

export QuantumRegister

struct QuantumRegister
    size::Int
    prod::Vector{Float64}

    QuantumRegister(size::Int) = new(size, vcat([1], zeros(Float64, 2 ^ size - 1)))
end

==(register::QuantumRegister, vector::Vector) = register.prod == vector
==(vector::Vector, register::QuantumRegister) = vector == register.prod
==(a::QuantumRegister, b::QuantumRegister) = a.prod == b.prod

end # module
