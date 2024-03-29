using Quantum, Test

@testset "Quantum" begin
    @testset "QuantumRegister" begin
        @testset "Construction" begin
            @test QuantumRegister(1) == [1, 0]
            @test QuantumRegister(2) == [1, 0, 0, 0]
            @test QuantumRegister(3) == [1, 0, 0, 0, 0, 0, 0, 0]
            @test QuantumRegister(2) == QuantumRegister(2)
            @test [1, 0, 0, 0] == QuantumRegister(2)
        end
        @testset "Length" begin
            @test length(QuantumRegister(1)) == 1
            @test length(QuantumRegister(2)) == 2
            @test length(QuantumRegister(3)) == 3
            @test length(QuantumRegister(4)) == 4
        end
    end
    @testset "Basic Gates" begin
        @testset "X" begin
            @test X(QuantumRegister(1), 1) == [0, 1]
            @test X(QuantumRegister(2), 1) == [0, 0, 1, 0]
            @test X(QuantumRegister(2), 2) == [0, 1, 0, 0]
            @test X(QuantumRegister(3), 2) == [0, 0, 1, 0, 0, 0, 0, 0]
        end
        @testset "H" begin
            @test H(QuantumRegister(1), 1) == [1 / √2, 1 / √2]
            @test H(X(QuantumRegister(1), 1), 1) == [1 / √2, -1 / √2]
        end
        @testset "CNOT" begin
            @test CNOT(QuantumRegister(2), 1, 2) == [1, 0, 0, 0]
            @test CNOT(X(QuantumRegister(2), 1), 1, 2) == [0, 0, 0, 1]
            @test CNOT(X(QuantumRegister(2), 2), 1, 2) == [0, 1, 0, 0]
            @test CNOT(X(QuantumRegister(2), 1), 2, 1) == [0, 0, 1, 0]
            @test CNOT(X(QuantumRegister(2), 2), 2, 1) == [0, 0, 0, 1]
            @test CNOT(X(QuantumRegister(3), 1), 1, 3) == [0, 0, 0, 0, 0, 1, 0, 0]
        end
        @testset "Swap" begin
            @test Swap(QuantumRegister(2), 1, 2) == [1, 0, 0, 0]
            @test Swap(QuantumRegister(2), 2, 1) == [1, 0, 0, 0]
            @test Swap(X(QuantumRegister(2), 1), 1, 2) == [0, 1, 0, 0]
            @test Swap(X(QuantumRegister(2), 2), 1, 2) == [0, 0, 1, 0]
            @test Swap(X(QuantumRegister(2), 1), 2, 1) == [0, 1, 0, 0]
        end
        @testset "Entanglement" begin
            @test CNOT(H(QuantumRegister(2), 1), 1, 2) == [1 / √2, 0, 0, 1 / √2]
            @test CNOT(H(X(QuantumRegister(2), 2), 1), 1, 2) == [0, 1 / √2, 1 / √2, 0]
        end
    end
    @testset "Single Qubit" begin
        @testset "Pauli Gates" begin
            @test Y(QuantumRegister(1), 1) == [0.0, im]
            @test Y(X(QuantumRegister(1), 1), 1) == [-im, 0.0]
            @test Z(QuantumRegister(1), 1) == [1, 0]
            @test Z(X(QuantumRegister(1), 1), 1) == [0, -1]
        end
        @testset "S(dag)" begin
            @test S(QuantumRegister(1), 1) == [1, 0]
            @test S(X(QuantumRegister(1), 1), 1) == [0, im]
            @test S(QuantumRegister(1), 1) == T(T(QuantumRegister(1), 1), 1)
            @test Sdag(QuantumRegister(1), 1) == [1, 0]
            @test Sdag(X(QuantumRegister(1), 1), 1) == [0, -im]
        end
        @testset "T(dag)" begin
            @test T(QuantumRegister(1), 1) == [1, 0]
            @test T(X(QuantumRegister(1), 1), 1) == [0, exp(im * pi / 4)]
            @test T(T(QuantumRegister(1), 1), 1) == S(QuantumRegister(1), 1)
            @test Tdag(QuantumRegister(1), 1) == [1, 0]
            @test Tdag(X(QuantumRegister(1), 1), 1) == [0, exp(-im * pi / 4)]
        end
    end
    @testset "Controlled Gates" begin
        @testset "Single Control" begin
            @test CZ(QuantumRegister(2), 1, 2) == [1, 0, 0, 0]
            @test CZ(X(QuantumRegister(2), 1), 1, 2) == [0, 0, 1, 0]
            @test CZ(X(QuantumRegister(2), 2), 1, 2) == [0, 1, 0, 0]
            @test CZ(X(QuantumRegister(2), 1), 2, 1) == [0, 0, 1, 0]
            @test CZ(X(QuantumRegister(2), 2), 2, 1) == [0, 1, 0, 0]
            @test CZ(X(QuantumRegister(3), 1), 1, 3) == [0, 0, 0, 0, 1, 0, 0, 0]
            @test CNOT(H(QuantumRegister(2), 2), 2, 1) == [1 / √2, 0, 0, 1 / √2]
            @test CNOT(H(X(QuantumRegister(2), 1), 2), 2, 1) == [0, 1 / √2, 1 / √2, 0]
        end
    end
end
