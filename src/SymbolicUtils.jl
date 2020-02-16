module SymbolicUtils

const TIMER_OUTPUTS = true
const being_timed = Ref{Bool}(false)

if TIMER_OUTPUTS
    using TimerOutputs

    macro timer(name, expr)
        :(if being_timed[]
              @timeit $(esc(name)) $(esc(expr))
          else
              $(esc(expr))
          end)
    end

    macro iftimer(expr)
        esc(expr)
    end

else
    macro timer(name, expr)
        esc(expr)
    end

    macro iftimer(expr)
    end
end

abstract type Symbolic{T} end

symtype(x) = typeof(x) # For types outside of SymbolicUtils
symtype(::Symbolic{T}) where {T} = T

Base.one( s::Symbolic) = one( symtype(s))
Base.zero(s::Symbolic) = zero(symtype(s))

@noinline function promote_symtype(f, xs...)
    error("promote_symtype($f, $(join(xs, ", "))) not defined")
end

include("symbolic.jl")
include("methods.jl")
include("util.jl")
include("rewrite.jl")
include("simplify.jl")
include("rulesets.jl")

end # module
