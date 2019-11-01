module Quantum

using LinearAlgebra
import Base: ==, length

export Swap
export QuantumRegister

mutable struct QuantumRegister
    qubit_product::Vector{Float64}
    QuantumRegister(length::Int) = new(vcat([1], zeros(Float64, 2^length - 1)))
end

==(register::QuantumRegister, vector::Vector) = register.qubit_product == vector
==(vector::Vector, register::QuantumRegister) = vector == register.qubit_product
==(a::QuantumRegister, b::QuantumRegister) = a.qubit_product == b.qubit_product

# Because `QuantumRegister` saves the tensor product of all its qubits,
# its length is 2^n (where n is the amount of qubits) and needs to be modified
length(register::QuantumRegister) = log2size(register.qubit_product)

# This is where the real gates start

Swap(register::QuantumRegister, from::Int, to::Int) =
    apply!(register, pad_matrix(swap_matrix(abs(to - from)), length(register), max(from, to)))

# Helper functions for the gates

apply!(register::QuantumRegister, matrix::Matrix) =
    register.qubit_product = matrix * register.qubit_product

pad_matrix(matrix::Matrix, tosize::Int, from::Int) =
    # kron together identity matrices with `matrix` in index `from`
    foldl(kron, vcat(fill(I₂, from - 1), [matrix], fill(I₂, tosize - from - log2size(matrix) + 1)))

function swap_matrix(span::Int)
    matrix = I + zeros(2^span, 2^span)

    for i in 1:2^(span - 1)
        if iseven(i)
            swap_rows!(matrix, i, i + 2^(span - 1) - 1)
        end
    end

    matrix
end

function swap_rows!(matrix::Matrix, x::Int, y::Int)
    for i in 1:size(matrix, 2)
        temp = matrix[x, i]
        matrix[x, i] = matrix[y, i]
        matrix[y, i] = temp
    end

    matrix
end

log2size(array::Array) = Int(log2(size(array, 1)))

I₂ = [1 0 ; 0 1]

end # module
