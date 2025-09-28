import requests
from io import StringIO
from IPython.display import display
from random import shuffle
from itertools import combinations


if __name__ == "__main__":
    url = "https://raw.githubusercontent.com/ahmedmohamed98/ASDM/main/readme.md"
    response = requests.get(url)
    data = StringIO(response.text)
    lines = data.readlines()
    shuffle(lines)
    for line1, line2 in combinations(lines, 2):
        if line1.strip() == line2.strip():
            print("Duplicate lines found:")
            print(line1.strip())
            break
    else:
        print("No duplicate lines found.")