from sys import stdout

input = iter(open(0).read().splitlines())

[n, m] = [int(x) for x in input]

stdout.write(f"{n + m}\n")
