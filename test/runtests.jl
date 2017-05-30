using SymmetricBitArrays
using Base.Test

# write your own tests here
@testset "Construction" begin
    b = SymBitArray(10)
end

@testset "Size" begin
    b = SymBitArray(10)
    @test size(b) == (10, 10)
end

@testset "Element access" begin
    b = SymBitArray(10)
    fill!(b, false)
    b[5, 2] = true
    @test b[2, 5] == b[5, 2] == true
    @test issymmetric(b)
end
