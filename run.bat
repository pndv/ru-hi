@echo on

xelatex -aux-directory=out -output-directory=out -interaction=nonstopmode -enable-installer main.tex
xelatex -aux-directory=out -output-directory=out -interaction=nonstopmode -enable-installer main.tex
biber --output-directory out --isbn13 --isbn-normalise main
makeindex out/main.idx

rem Run XeLaTeX two more times to include the generated index, bibliography and tables
xelatex -aux-directory=out -output-directory=out -synctex=1 -interaction=nonstopmode -enable-installer main.tex
xelatex -aux-directory=out -output-directory=out -synctex=1 -interaction=nonstopmode -enable-installer main.tex
