using Documenter
using Pkg
using Test
using SymbolicUtils
import IfElse: ifelse

DocMeta.setdocmeta!(
    SymbolicUtils,
    :DocTestSetup,
    :(using SymbolicUtils);
    recursive=true
)

# Only test one Julia version to avoid differences due to changes in printing.
if v"1.6" ≤ VERSION < v"1.7-beta3.0"
    doctest(SymbolicUtils)
else
    @warn "Skipping doctests"
end

# == / != syntax is nice, let's use it in tests
macro eqtest(expr)
    @assert expr.head == :call && expr.args[1] in [:(==), :(!=)]
    if expr.args[1] == :(==)
        :(@test isequal($(expr.args[2]), $(expr.args[3])))
    else
        :(@test !isequal($(expr.args[2]), $(expr.args[3])))
    end |> esc
end
SymbolicUtils.show_simplified[] = false


include("basics.jl")
include("order.jl")
include("rewrite.jl")
include("rulesets.jl")
include("code.jl")
include("nf.jl")
include("interface.jl")
include("fuzz.jl")
include("adjoints.jl")
