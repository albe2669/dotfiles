from io import BytesIO, read, fstat
from sys import stdout

input = BytesIO(read(0, fstat(0).st_size)).readline

[n, m] = [int(x) for x in input().decode().split()]

stdout.write(f"{n + m}\n")
