Write-Output "Running XeLaTeX first time"
xelatex -aux-directory=out -output-directory=out -interaction=nonstopmode -enable-installer main.tex

Write-Output "Running XeLaTeX second time"
xelatex -aux-directory=out -output-directory=out -interaction=nonstopmode -enable-installer main.tex

Write-Output "Running biber for bibliography"
biber --output-directory out --isbn13 --isbn-normalise main

Write-Output "Generating index"
makeindex out/main.idx

# Run XeLaTeX two more times to include the generated index, bibliography and tables
Write-Output "Running XeLaTeX third time to include the generated index"
xelatex -aux-directory=out -output-directory=out -synctex=1 -interaction=nonstopmode -enable-installer main.tex

Write-Output "Running XeLaTeX fourth time to include the generated indices, bibliography, tables etc."
xelatex -aux-directory=out -output-directory=out -synctex=1 -interaction=nonstopmode -enable-installer main.tex
