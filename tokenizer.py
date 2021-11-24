import re
import sys
import pandas as pd

with open("ignored-words.txt") as file:
    ignored_words = re.findall("[^ \n]+", file.read())


def remove_ignored(words, to_remove=ignored_words):
    for word in words:
        if word not in to_remove:
            yield word


def get_words(text):
    if isinstance(text, str):
        words = re.findall("\w+'\w+|\w+", text.lower())
        return ' '.join(remove_ignored(words))
    return text


def main():
    if len(sys.argv) < 3:
        print("Usage: <input csv> <output csv>")
        return -1

    input_file = sys.argv[1]
    output = sys.argv[2]

    pd.read_csv(input_file).applymap(get_words).fillna(
        "").to_csv(output, index=False)


if __name__ == "__main__":
    main()
