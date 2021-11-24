CSVs=description-25.csv description-50.csv designation-25.csv title-25.csv description-word-frequency.csv designation-word-frequency.csv title-word-frequency.csv

PLOTS=description.png designation.png title.png wine.png wine-price-tree.png

all: ${PLOTS} ${CSVs}

plots: ${PLOTS}

csvs: ${CSVs}

description-50.csv: tokenized.csv description-word-frequency.csv combine.py
	python3 combine.py tokenized.csv description-word-frequency.csv description description-50.csv 50

description-25.csv: tokenized.csv description-word-frequency.csv combine.py
	python3 combine.py tokenized.csv description-word-frequency.csv description description-25.csv 25

designation-25.csv: tokenized.csv designation-word-frequency.csv combine.py
	python3 combine.py tokenized.csv designation-word-frequency.csv designation designation-25.csv 25

title-25.csv: tokenized.csv title-word-frequency.csv combine.py
	python3 combine.py tokenized.csv title-word-frequency.csv title title-25.csv 25

description-word-frequency.csv: tokenized.csv analyze.py
	python3 analyze.py tokenized.csv description $@

designation-word-frequency.csv: tokenized.csv analyze.py
	python3 analyze.py tokenized.csv designation $@

title-word-frequency.csv: tokenized.csv analyze.py
	python3 analyze.py tokenized.csv title $@

tokenized.csv: winemag-data-130k-v2.csv tokenizer.py ignored-words.txt
	python3 tokenizer.py winemag-data-130k-v2.csv tokenized.csv

wine-price-tree.png: wine-tree.R
	Rscript wine-tree.R

description.png designation.png title.png wine.png: pairs.R description-word-frequency.csv designation-word-frequency.csv title-word-frequency.csv tokenized.csv
	Rscript pairs.R

clean:
	rm ${CSVs} ${PLOTS} tokenized.csv
