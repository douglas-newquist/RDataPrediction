import csv
import numpy
import sys


def count_words(words: list):
    counts = {}

    for word in words:
        counts[word] = 1 + counts.get(word, 0)

    return counts


def merge_dicts(*dicts):
    result = {}

    for d in dicts:
        for key, value in d.items():
            current = result.get(key, None)
            if current is None:
                result[key] = value
            elif isinstance(current, dict):
                result[key] = merge_dicts(current, value)
            else:
                result[key] = current + value

    return result


def analyze(row: list, column: int):
    words = row[column].split(' ')

    counts = count_words(words)

    data = {}

    score = float(row[4])
    for word, count in counts.items():
        word_info = data.get(word, None)
        if word_info is None:
            word_info = {}
            data[word] = word_info

        word_info["count"] = count + word_info.get("count", 0)
        word_info["unique"] = 1
        word_info["scores"] = [score] + word_info.get("scores", [])
        word_info["length"] = len(words)

    return data


def analyze_rows(rows, column):
    if len(rows) > 2048:
        a = analyze_rows(rows[::2], column)
        b = analyze_rows(rows[1::2], column)

        return merge_dicts(a, b)

    results = [analyze(row, column) for row in rows]
    return merge_dicts(*results)


def main():
    if len(sys.argv) < 4:
        print("Usage: <input csv> <column name> <output csv>")
        return -1

    input_file = sys.argv[1]
    with open(input_file) as f:
        header, *rows = csv.reader(f)

    column = int(header.index(sys.argv[2]))
    data = analyze_rows(rows, column)

    output_file = sys.argv[3]
    with open(output_file, 'w') as f:
        f.write(
            "Word,Count,Unique,Length,Mean Score,Min Score,Max Score,STD Score\n")

        for word, values in sorted(data.items(), key=lambda kv: -kv[1]["count"]):
            unique = values["unique"]
            count = values["count"]

            if len(word) < 2:
                continue

            ratio = unique / count

            if ratio > 0.99 or ratio < 0.9:
                continue

            length = values["length"] / unique
            scores = numpy.array(values["scores"])
            mean = scores.mean()
            std = scores.std()
            low, high = scores.min(), scores.max()

            f.write(
                f"{word},{count},{unique},{length},{mean},{low},{high},{std}\n")


if __name__ == "__main__":
    main()
