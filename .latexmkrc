# elegantbook loads fontspec, so this document must be built with XeLaTeX.
# Setting this makes a bare `latexmk` (no flags) do the right thing.
$pdf_mode = 5;    # 5 = xelatex

# Without this, a bare `latexmk` builds every .tex in the directory -- including
# cover.tex, which would overwrite the committed cover.pdf. Restrict it to the book.
# >>> rename this to your document <<<
@default_files = ("tutorial.tex");
