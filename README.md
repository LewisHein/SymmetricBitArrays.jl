# SymmetricBitArrays

[![Build Status](https://travis-ci.org/LewisHein/SymmetricBitArrays.jl.svg?branch=master)](https://travis-ci.org/LewisHein/SymmetricBitArrays.jl)

[![Coverage Status](https://coveralls.io/repos/LewisHein/SymmetricBitArrays.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/LewisHein/SymmetricBitArrays.jl?branch=master)

[![codecov.io](http://codecov.io/github/LewisHein/SymmetricBitArrays.jl/coverage.svg?branch=master)](http://codecov.io/github/LewisHein/SymmetricBitArrays.jl?branch=master)

SymmetricBitArrays
==================

Adjacency matrices are automatically symmetric and only need one bit/element; however Julia provides no built-in type to handle such matrices well.
Options in Julia are:

 - `BitArray{2}`: Uses ~1 bit/element but provides no provision for symmetry, thus using 2x the needed memory
 - `Array{Bool, 2}`: Uses 8 bits/element without provision for symmetry, thus using 16x the needed memory
 - `Symmetric`: Requires construction of an Array{Bool, 2} anyway.

Any of the options work well until memory gets tight. Then every little bit counts, and a factor of two can easily make the difference between solving
a problem and running out of memory. `SymmetricBitArrays` provides a type that that uses 1 bit/element and only stores these bits once; element accessess
in symmetric locations in the lower or upper half of the matrix will access the same location in memory.

# Indexing.
Although SymmetricBitArrays do not support fast linear indexing, this does not mean they don't support fast indexing -- Again, the inherent symmetry of
certain problems comes into play.

Suppose you want to compute an adjacency matrix for some list of items. The naive way would be

```julia
nitems = length(items)
adj_mat = SymBitArray(nitems)
fill!(adj_mat, false)
for (i, item1) in enumerate(items)
    for (j, item2) in enumerate(items)
        if is_adjacent(item2, item2)
	    adj_mat[i, j] = true
	end
    end
end
```

This is functional but inefficient; Not only is each element computed twice, linear indexing into `adj_mat` is not cache-freindly. Instead, it is better to do:

```julia
nitems = length(items)
adj_mat = SymBitArray(nitems)
fill!(adj_mat, false)
for (i, item1) in enumerate(items)
    for (j, item2) in enumerate(view(items(i:nitems)))
	if is_adjacent(item1, item2)
	    adj_mat[i, j] = true
	end
    end
end
```
