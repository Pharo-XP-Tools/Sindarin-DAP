class Counter:
    def __init__(self, value):
        self.value = value

    def increment(self):
        self.value = self.value + 1
    
    def copyTo(self, other):
        other.value = self.value


def main():
    c = Counter(0)
    c.increment()
    c2 = Counter(0)
    c.copyTo(c2)

if __name__ == "__main__":
    main()