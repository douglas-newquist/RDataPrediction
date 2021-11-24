
import pandas as pd
import csv
import sys


def analyze(row, column, words, columns):
    text = row[column]
    words = [word in text for word in words]
    return words + [row[c] for c in columns]


def main():

    reviews = pd.read_csv(sys.argv[1]).astype(str)
    frequency = pd.read_csv(sys.argv[2])

    column = sys.argv[3]
    columns = ["country", "points", "price", "province", "region_1",
               "region_2", "taster_name", "variety", "winery"]
    sample_size = int(sys.argv[5]) if len(sys.argv) > 4 else 25

    words = list(frequency["Word"].values[:sample_size])
    a = reviews.apply(lambda row: analyze(row, column, words, columns), axis=1)

    with open(sys.argv[4], 'w') as result:
        writer = csv.writer(result)
        writer.writerow(words + columns)
        writer.writerows(a)


if __name__ == "__main__":
    main()
