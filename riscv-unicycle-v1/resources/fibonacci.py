def fibonacci(n):
    fib, fib_next = 0, 1
    for _ in range(n):
        fib, fib_next = fib_next, fib + fib_next
    return fib
