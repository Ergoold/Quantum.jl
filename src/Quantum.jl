module Quantum

using LinearAlgebra
import Base: ==, length

export Swap, X, Y, Z, H, S, Sdag, T, Tdag, Rx, Ry, Rz, R, CNOT, CZ
export QuantumRegister

mutable struct QuantumRegister
    qubit_product::Vector{Complex{Float64}}
    QuantumRegister(length::Int) = new(vcat([1], zeros(Complex{Float64}, 2^length - 1)))
end

==(register::QuantumRegister, vector::Vector) = register.qubit_product == vector
==(vector::Vector, register::QuantumRegister) = vector == register.qubit_product
==(a::QuantumRegister, b::QuantumRegister) = a.qubit_product == b.qubit_product

# Because `QuantumRegister` saves the tensor product of all its qubits,
# its length is 2^n (where n is the amount of qubits) and needs to be modified
length(register::QuantumRegister) = log2size(register.qubit_product)

# These functions are defined here because they give an `UndefVarError` bellow

single_qubit_gate(matrix::Matrix) =
    (register::QuantumRegister, at::Int) -> apply!(register, matrix, at)

controlled_gate(matrix::Matrix) = function(register::QuantumRegister, control::Int, target::Int)
    _control = control
    _target = target

    if(control == length(register))
        _control -= 1
        Swap(register, control, _control)
        if(_control == target)
            _target = control
        end
    end

    if(_control + 1 != _target)
        _target = _control + 1
        Swap(register, target, _target)
    end

    apply!(register, controlled_matrix(matrix), _control)

    Swap(register, _target, target)

    if(_control == _target)
        Swap(register, _control, control)
    end

    register
end

# This is where the real gates start

Swap(register::QuantumRegister, from::Int, to::Int) =
    apply!(register, swap_matrix(abs(to - from) + 1), min(from, to))

X = single_qubit_gate([0 1 ; 1 0])

Y = single_qubit_gate([0 -im ; im 0])

Z = single_qubit_gate([1 0 ; 0 -1])

H = single_qubit_gate([1/√2 1/√2 ; 1/√2 -1/√2])

S = single_qubit_gate([1 0 ; 0 im])

Sdag = single_qubit_gate([1 0 ; 0 -im])

T = single_qubit_gate([1 0 ; 0 exp(im * pi / 4)])

Tdag = single_qubit_gate([1 0 ; 0 exp(-im * pi / 4)])

Rx(register::QuantumRegister, at::Int, θ::Float64) =
    apply!(register, [cos(θ) -im * sin(θ) ; -im * sin(θ) cos(θ)], at)

Ry(register::QuantumRegister, at::Int, θ::Float64) =
    apply!(register, [cos(θ / 2) -im * -sin(θ / 2) ; -im * sin(θ) cos(θ / 2)], at)

Rz(register::QuantumRegister, at::Int, θ::Float64) =
    apply!(register, [0 1 ; 0 exp(im * θ)], at)

# R is often used to denote Rz
R = Rz

CNOT = controlled_gate([0 1 ; 1 0])

CZ = controlled_gate([1 0 ; 0 -1])

# Helper functions for the gates

controlled_matrix(matrix::Matrix) = kron([1 0 ; 0 0], I₂) + kron([0 0 ; 0 1], matrix)

function apply!(register::QuantumRegister, matrix::Matrix, from::Int)
    register.qubit_product = pad_matrix(matrix, length(register), from) * register.qubit_product

    register
end

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
