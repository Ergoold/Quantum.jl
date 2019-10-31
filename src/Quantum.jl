module Quantum

using LinearAlgebra
import Base.==
import Base.length

export QuantumRegister

struct QuantumRegister
    prod::Vector{Float64}
    QuantumRegister(length::Int) = new(vcat([1], zeros(Float64, 2 ^ length - 1)))
end

==(register::QuantumRegister, vector::Vector) = register.prod == vector
==(vector::Vector, register::QuantumRegister) = vector == register.prod
==(a::QuantumRegister, b::QuantumRegister) = a.prod == b.prod

# Because `QuantumRegister` saves the tensor product of all its qubits,
# its length is 2^n (where n is the amount of qubits)
length(register::QuantumRegister) = Int(log2(length(register.prod)))

end # module
