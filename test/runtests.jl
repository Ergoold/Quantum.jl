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
            @test H(QuantumRegister(1), 1) == [1/√2, 1/√2]
            @test H(X(QuantumRegister(1), 1), 1) == [1/√2, -1/√2]
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
    end
end
