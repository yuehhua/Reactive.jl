using Base.Test
using Reactive

facts("Flatten") do

    a = Signal(0)
    b = Signal(1)

    c = Signal(a)

    d = flatten(c)
    cnt = foldp((x, y) -> x+1, 0, d)

    context("Signal{Signal} -> flat Signal") do
        # Flatten implies:
        @fact value(c) --> a
        @fact value(d) --> value(a)
    end

    context("Initial update count") do

        @fact value(cnt) --> 0
    end

    context("Current signal updates") do
        push!(a, 2)
        step()

        @fact value(cnt) --> 1
        @fact value(d) --> value(a)
    end

    context("Signal swap") do
        push!(c, b)
        step()
        @fact value(cnt) --> 2
        @fact value(d) --> value(b)

        push!(a, 3)
        step()
        @fact value(cnt) --> 2
        @fact value(d) --> value(b)

        push!(b, 3)
        step()

        @fact value(cnt) --> 3
        @fact value(d) --> value(b)
    end
end
