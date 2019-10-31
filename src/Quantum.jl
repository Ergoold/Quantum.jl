module Quantum

using LinearAlgebra
import Base: ==, length

export QuantumRegister

⊗ = kron
⊗(matrix::Matrix, eye::UniformScaling) = matrix ⊗ (zeros(2, 2) + UniformScaling)
⊗(eye::UniformScaling, matrix::Matrix) = (zeros(2, 2) + UniformScaling) ⊗ matrix

struct QuantumRegister
    qubit_product::Vector{Float64}
    QuantumRegister(length::Int) = new(vcat([1], zeros(Float64, 2 ^ length - 1)))
end

==(register::QuantumRegister, vector::Vector) = register.qubit_product == vector
==(vector::Vector, register::QuantumRegister) = vector == register.qubit_product
==(a::QuantumRegister, b::QuantumRegister) = a.qubit_product == b.qubit_product

# Because `QuantumRegister` saves the tensor product of all its qubits,
# its length is 2^n (where n is the amount of qubits)
length(register::QuantumRegister) = Int(log2(length(register.qubit_product)))

function pad_matrix(matrix::Matrix, size::Int)
    if(size(matrix, 1) > size)
        throw(ArgumentError("Matrix is too big"))
    end
end

end # module
