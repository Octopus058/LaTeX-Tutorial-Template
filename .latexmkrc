# fontspec needs a Unicode engine. We use LuaLaTeX.
# Setting this makes a bare `latexmk` (no flags) do the right thing.
$pdf_mode = 4;    # 4 = lualatex

# Without this, a bare `latexmk` builds every .tex in the directory. Restrict it
# to the book.
# >>> rename this to your document <<<
@default_files = ("tutorial.tex");
