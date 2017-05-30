module SymmetricBitArrays

import Base: linearindexing, size, getindex, setindex!
export linearindexind, size, getindex, setindex!
export SymBitArray

type SymBitArray <: AbstractArray{Bool, 2}
    data::BitArray{1}
    SymBitArray(n::Int) = new(BitArray{1}(Int(n*(n+1)/2)))
end

linearindexing(a::SymBitArray) = Base.LinearSlow()

function size(a::SymBitArray)
    l = length(a.data)
    n = Int(sqrt(2l+1//4)-1//2)
    return (n, n)
end

#getindex(a::SymBitArray, i::Int) = getindex(a.data, i)

function getindex(a::SymBitArray, i::Int, j::Int)
    ncol = size(a)[1]
    row = max(i, j)
    col = min(i, j)
    c = ncol-col+1
    ind = Int((ncol*(ncol+1)/2) - (c*(c+1)/2)) + row - col + 1

    return a.data[ind]
end

#setindex!(a::SymBitArray, v::Bool, i::Int) = setindex!(a.data, v, i)

function setindex!(a::SymBitArray, v::Bool, i::Int, j::Int)
    row = min(i, j)
    col = max(i, j)
    ind = Int((col-1)*col/2)
    ind += row

    a.data[ind] = v
end

end # module
