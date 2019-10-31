#=
runtests:
- Julia version: 1.2.0
- Author: user
- Date: 2019-10-31
=#

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
end
