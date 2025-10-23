# test_addition.py

from addition import add  # Import the add function from addition.py

def test_add():
    assert add(2, 3) == 5
    assert add(-1, 1) == 0
    assert add(0, 0) == 0
    assert add(10, 20) == 30
