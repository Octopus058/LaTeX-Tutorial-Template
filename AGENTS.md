# Tutorial Guide

How to **revise** my LaTeX tutorials: the standard they conform to, the revision procedure, how to match my voice, and the traps this environment sets.
Drawn from revising Convex Optimization, Linux, Compressed Sensing and Linear Algebra between 2026-09-30 and 2026-10-01.

**The prose is written by hand.** The body of every tutorial is mine.
This guide is for working on what is already there — restructuring, copyediting, aligning a document with the standard — and for the few places new prose does get written on request: chapter overviews, the README, and release notes.
It is not a template for generating tutorial content.

This is the master copy.
**Copy it into a tutorial repository as `AGENTS.md`** and it loads automatically in every session there, so the rules do not have to be restated each time.

**Starting a new tutorial?** That is the rest of this folder: `tutorial.tex`, `README-template.md`, `.latexmkrc` and `.gitignore`.
See `README.md`.

> Why a file rather than memory.
> DSH loads `$DSH_HOME/AGENTS.md` (default `~/.dsh/AGENTS.md`) in every session, but that store is global and holds nothing about one particular project. An `AGENTS.md` copied into each repo is the only thing that reliably travels with it.

---

## The reference standard

**`Octopus058/Introduction-to-Convex-Optimization` is the canonical template.** Where any tutorial diverges from it, the Convex repo wins.
Copy from it rather than re-deriving anything.

```bash
git clone git@github.com:Octopus058/Introduction-to-Convex-Optimization.git
```

There are two standards, and they answer different questions.

**The framework comes from `Octopus058/Introduction-to-Information-Theory`.**
That covers the document class, the whole preamble, the theorem-like environments, the title page, the table-of-contents spacing, the running heads, `.latexmkrc`, `.gitignore`, and the source conventions in §0.7.
The skeleton below is copied from that repo, not retyped from a description.

**Convex defines the editorial layer**: the shape of a `README.md`, how a chapter overview reads, the commit message, and the wording of release notes.
Nothing in that list is a `.tex` file.

Where the two disagree, Information Theory wins on anything the compiler reads, and Convex wins on anything only the reader sees.

### Preamble skeleton

```latex
\documentclass[10pt,a4paper,oneside,numbers=noenddot]{scrbook}

% ---- Title Information ----
\title{<Title>}
\author{Octopus058}
\date{<Month DD, YYYY>}
\newcommand*{\bookversion}{<x.y>}
\newcommand*{\bookquote}{``<a short quotation>''\quad --- <attribution>}

% ---- Fonts ----
% Text in TeX Gyre Termes and maths in Computer Modern, the pairing the book already used.
\usepackage{fontspec}
\setmainfont{TeXGyreTermesX}
\setsansfont{texgyreheros}

% ---- Page layout ----
\usepackage[a4paper]{geometry}
\geometry{margin=25.4mm}
% One inch all round leaves a 159mm measure, and some paragraphs carry inline maths with no
% breakpoint in them.
% Allow slightly looser lines first, then a third pass with emergency stretch, rather than
% push a formula into the margin.
\tolerance=1000
\setlength{\emergencystretch}{3em}
\linespread{1.2}

% ---- Packages ----
\usepackage{mathtools}
\usepackage{amssymb}
\usepackage{amsthm}
\usepackage{xcolor}
\usepackage{tcolorbox}
\tcbuselibrary{breakable}
\usepackage{booktabs}
\usepackage{graphicx}
\usepackage{tikz}
\usepackage{enumitem}
\usepackage{microtype}
\usepackage{mleftright}
\mleftright
\usepackage[
  backend=biber,
  style=numeric-comp
]{biblatex}
\addbibresource{refs.bib}
\usepackage[headsepline]{scrlayer-scrpage}
\usepackage[hidelinks]{hyperref}

% ---- Running heads ----
% The section title sits above a thin rule on the right, the page number at the foot.
\pagestyle{scrheadings}
\clearpairofpagestyles
\automark{section}
\ohead{\headmark}
\cfoot*{\pagemark}
% The running head carries a section title on top of a rule, and the foot a page
% number; both need more room than one baseline, which KOMA warns about when they do not get it.
\setlength{\headheight}{30pt}
\setlength{\footheight}{20pt}
% Content runs short of the lower edge more often than a book with no floats would, and
% flush bottom then stretches every page to the same depth.
\raggedbottom

% ---- Spacing in the table of contents ----
\RedeclareSectionCommand[tocbeforeskip=1.1em]{chapter}
\RedeclareSectionCommand[tocbeforeskip=0.5em]{section}
\RedeclareSectionCommand[tocbeforeskip=0.15em]{subsection}

% ---- Math Operators ----
\DeclareMathOperator*{\argmin}{arg\,min}
\DeclareMathOperator*{\argmax}{arg\,max}
\DeclareMathOperator{\Vol}{Vol}
\DeclareMathOperator{\Var}{Var}
\DeclareMathOperator{\tr}{tr}

% ---- Cross-references ----
\newcommand*{\figref}[1]{\textbf{Figure}~\ref{#1}}
\newcommand*{\tabref}[1]{\textbf{Table}~\ref{#1}}

% ---- Theorem-like environments, set the way Cover and Thomas set theirs ----
% A run-in bold head, a full stop after the number, and nothing else around it.
% Definitions, examples and remarks set their body roman; results set it italic, and carry
% a very light grey panel so they can be found by flipping through the book.
% A panel with no rule and no title bar: a very light grey fill that keeps the black-and-white
% look while telling a result apart from the prose around it.
\tcbset{
  ctresult/.style={
    breakable,
    colback=black!4, colframe=black!4,
    boxrule=0pt, arc=0pt, outer arc=0pt,
    % The text inside the panel has to sit on the same left edge as the prose outside
    % it, so the panel carries no side padding at all: it spans the measure exactly and
    % the grey band reads as a highlighted paragraph. Vertical padding stays, because a
    % band that clips the ascenders looks like a mistake.
    boxsep=0pt, left=0pt, right=0pt, top=5pt, bottom=5pt,
    before skip=0.9em, after skip=0.9em,
  },
}
% amsthm's default end-of-proof mark is drawn from rules and never reaches the PDF text
% layer. Use the open square the book has always used, which is a real glyph.
\renewcommand*{\qedsymbol}{\(\Box\)}
\newtheoremstyle{ctplain}{0.8em}{0.8em}{}{}{\bfseries}{.}{0.5em}{}
\newtheoremstyle{ctresult}{0.8em}{0.8em}{\itshape}{}{\bfseries}{.}{0.5em}{}

\theoremstyle{ctplain}
\newtheorem{definition}{Definition}[chapter]
\newtheorem{example}{Example}[chapter]
\newtheorem*{remark}{Remark}

\theoremstyle{ctresult}
\newtheorem{ctheorem}{Theorem}[chapter]
\newtheorem{clemma}{Lemma}[chapter]
\newtheorem{ccorollary}{Corollary}[chapter]
\newtheorem{cproposition}{Proposition}[chapter]
\newtheorem*{note}{Note}

\NewDocumentEnvironment{theorem}{o}
  {\begin{tcolorbox}[ctresult]\IfNoValueTF{#1}{\begin{ctheorem}}{\begin{ctheorem}[#1]}}
  {\end{ctheorem}\end{tcolorbox}}
\NewDocumentEnvironment{lemma}{o}
  {\begin{tcolorbox}[ctresult]\IfNoValueTF{#1}{\begin{clemma}}{\begin{clemma}[#1]}}
  {\end{clemma}\end{tcolorbox}}
\NewDocumentEnvironment{corollary}{o}
  {\begin{tcolorbox}[ctresult]\IfNoValueTF{#1}{\begin{ccorollary}}{\begin{ccorollary}[#1]}}
  {\end{ccorollary}\end{tcolorbox}}
\NewDocumentEnvironment{proposition}{o}
  {\begin{tcolorbox}[ctresult]\IfNoValueTF{#1}{\begin{cproposition}}{\begin{cproposition}[#1]}}
  {\end{cproposition}\end{tcolorbox}}

% ---- Title page ----
\makeatletter
\renewcommand*{\maketitle}{%
  \begin{titlepage}
    \hypersetup{pageanchor=false}
    \centering
    \null\vspace{5em}
    {\Huge\bfseries \@title\par}
    \vspace{1.5em}
    {\large Version \bookversion\par}
    \vspace{3em}
    \rule{\textwidth}{0.4pt}\par
    \vspace{1.2em}
    {\itshape \bookquote\par}
    \vspace{1.2em}
    \rule{\textwidth}{0.4pt}\par
    \vfill
    {\large \@author\par}
    \vspace{0.6em}
    {\large \@date\par}
    \vspace{2em}
  \end{titlepage}
}
\makeatother
\begin{document}

\maketitle

\frontmatter
\tableofcontents

% ============================================================
\chapter*{Preface}
\addcontentsline{toc}{chapter}{Preface}
\linespread{1.55}\selectfont

Write why you took this subject on, whose course or book the tutorial follows, who it is for, and one piece of advice for the reader.

\linespread{1.2}\selectfont

\mainmatter

% ============================================================
\chapter{...}

\backmatter

\printbibliography[heading=bibintoc, title={References}]

% ============================================================
\chapter*{Afterwords}
\addcontentsline{toc}{chapter}{Afterwords}

\linespread{1.55}\selectfont

<what writing the tutorial taught you, what it left out>

\begin{flushright}
  Octopus058\\
  <Month DD, YYYY>
\end{flushright}

\end{document}
```

**`scrbook` is not a file to copy in.** It ships inside the `koma-script` bundle, which is part of every TeX Live installation:
`kpsewhich scrbook.cls` finds it, and `tlmgr info koma-script` should report `installed: Yes`.
Only a class that is *not* in the distribution gets vendored into the repo.
The theorem environments come from `amsthm` plus a small `tcolorbox` wrapper; see §0.5.

### `.latexmkrc` — copy verbatim, change the filename on the last line

```perl
# fontspec needs a Unicode engine. We use LuaLaTeX. Setting this makes a bare
# `latexmk` (no flags) do the right thing.
$pdf_mode = 4;    # 4 = lualatex

# Without this, a bare `latexmk` builds every .tex in the directory. Restrict it
# to the book.
@default_files = ("<exact main filename>.tex");
```

**LuaLaTeX is the engine for every tutorial**, and this file is the only place that decides it.
XeLaTeX loads `fontspec` just as well, so the two agree on fonts; they differ in pagination, and that difference is large enough to matter.

The four older tutorials are still on XeLaTeX — their `.latexmkrc` says `$pdf_mode = 5` — so porting them means changing that line to 4 as well as replacing the preamble.
**Expect the page count to move.**
`latexmk -C`, rebuild, and write down the new number before touching the README or the release notes, because both quote it.

### `.gitignore` — copy verbatim, change the output name at the bottom

```
# LaTeX build artifacts
*.aux
*.bbl
*.bcf
*.blg
*.fdb_latexmk
*.fls
*.log
*.out
*.run.xml
*.synctex.gz
*.toc
*.xdv

# Compiled output
<exact output filename>.pdf
```

Note `*.pdf` is **not** used as a glob. A tutorial may keep a tracked PDF next to the source, and a glob would sweep it away.
Name the built PDF exactly.

### Chapter overview format

Directly after `\chapter{...}`, before the first `\section`:

```latex
\subsection*{Overview}

<three short paragraphs, ~18 words/sentence, no em-dashes, no semicolons>
```

See **§0.1 My voice** below for the metrics.

### README shape

Centred title + one-line description + `**Version x.y** · date · N pages`, then: `About` → `Who this is for` → `Contents` (grouped by part, 3–5 lines per chapter) → `What this tutorial does not cover` → `Building the PDF` → `Repository layout` → `Acknowledgements` → `License`.

### Commit messages

```
v<version>: <what changed>
```

e.g. `v1.1: add chapter overviews, fix typos, update README and build config`

---

## 0. Standing rules (apply to every tutorial)

### 0.1 My voice — measure it, never guess it

My English prose has a consistent fingerprint:

| Metric | My body text |
| --- | --- |
| Average sentence length | **18 words** |
| Em-dash `—` density | **0.07 per 100 words** |
| Semicolons | **almost never** — 6 in ~21,800 words |

**The failure mode to guard against.** When an assistant writes "in my style", it reliably produces:

- em-dashes at **10–20×** my rate (measured: 1.16 vs 0.07 per 100 words) — 23 in one README where I would have used 1
- sentences **30–45% longer** than mine (measured: 22.8 and 26.3 words/sentence against my 18.4)

This is not a grammar problem.
The prose is *correct* — it just doesn't sound like me.
It reads as a different author, and it is the single most repeated mistake.

**Measure before claiming a match.** Run this on the file being edited and on the body text it has to blend into:

```bash
# strip LaTeX, join lines
detex() { sed -e 's/\\[a-zA-Z]*//g' -e 's/[${}\\]//g' | tr '\n' ' ' | sed 's/  */ /g'; }

w=$(detex < body.tex | wc -w)
s=$(detex < body.tex | grep -oE '[.!?] ' | wc -l)
echo "avg words/sentence: $((w / s))"                    # target 18
echo "em-dashes per 100w: $(grep -o '—' body.tex | wc -l | awk -v w=$w '{printf "%.2f\n", $1/w*100}')"   # target 0.07
```

Counting semicolons needs care — LaTeX's `\;` spacing command is not punctuation, and a naive count will read as "0 real semicolons" while being completely wrong.
Use a **fixed-string** match:

```bash
total=$(grep -o ';' f.tex | wc -l)
spacers=$(grep -oF '\;' f.tex | wc -l)     # -oF is required; see below
echo "real semicolons: $((total - spacers))"
```

> **Verified trap.** Of the four obvious ways to write the spacer pattern (`grep -o '\;'`, `grep -o '\\;'`, `grep -oF '\;'`, `awk gsub`), **only `grep -oF` gave the right answer** (339 spacers).
> The other three silently matched *every* semicolon, returning `total - total = 0`.
> A plausible-looking zero is worse than an error — always sanity-check against the raw total.

Target for anything new: **≤1 em-dash per section, 0 semicolons**, max sentence ~30 words, and a sentence length matching **the document being edited** — not the 18 above.

That last point matters more than it looks.
The 18-word figure is the *Convex* baseline.
Measured baselines differ between tutorials:

| Tutorial | Average sentence length |
| --- | --- |
| Convex Optimization | 18.4 |
| Linear Algebra | 18.4 |
| Compressed Sensing | **23.1** |
| Information Theory | **16.4** |

Writing 18-word prose into Compressed Sensing makes the new text 22% shorter than its surroundings, which reads as a different author just as surely as writing 26-word prose into Convex.
**Measure the target document first**, then aim at that number.
The other two metrics (em-dashes, semicolons) are low in every tutorial and carry over unchanged.
Information Theory measured 16.4 across its nine overviews (97 sentences, 1589 words), and its chapter 9 body prose measured 15.9, so new text there aims at 16 rather than at the Convex 18.

Expect to iterate.
When I rewrote 8 chapter overviews for Convex, the first attempt came out at 22.8 words/sentence and the second at 11.6 — one overshoot in each direction before landing on 17.9.
Check with numbers each time.

### 0.2 What to fix vs. what to leave alone

**Fix — grammar only, and only these categories:**

- articles: `a invertible` → `an invertible`, `an standard` → `a standard`
- subject–verb agreement: `We obeys` → `We obey`
- comparatives: `much easy` → `much easier`, `much hard` → `much harder`
- possessives: `it's extended-value extension` → `its`; `used for it's convexity` → `its`
- spelling: `Howeever` → `However`
- numerals in running prose: `2 cases` → `two cases`, `at least 1` → `at least one` (digits stay for math, chapter/section refs, algorithm step numbers, `rank-2`)
- missing relative pronoun: `there must be $y$ satisfies` → `$y$ **that** satisfies`
- prepositions: `divide this equation to 2 parts` → `**into** two parts`

**Leave alone — this is voice, not error:**

- `See what? $V$ is the nullspace of $A$.`
- `Don't make a fool of yourself.` / `Don't get yourself lost.`
- `Till now, Prof. Ling began to talk about...`
- `Human beings are creatures in 3D world.`
- the "pot / reaches the sky / a super pot" metaphor
- `We obey that the right side of the constraints are 0` — odd wording, but fixing it is a rewrite, not a correction.
  Ask first.

These are Chinese rhetorical moves carried into English.
They are the author's fingerprint.
Flattening them makes the book generic.

### 0.3 Fact-check the front matter against the repo

A Preface or README that promises something the repo does not contain is worse than a typo.
In the Convex tutorial the Preface claimed *"Every algorithm is accompanied by intuition, convergence analysis, and MATLAB code"* — while the repo contained **zero** code listings:

```bash
grep -c 'begin{lstlisting}\|begin{verbatim}\|begin{minted}' *.tex   # 0
find . -name '*.m' -o -name '*.py' | grep -v '^./.git'              # nothing
grep -c 'begin{algorithm}' *.tex                                    # 8 -- pseudocode only
```

The claim traced back to a commit that had deleted the `\lstset{language=Matlab}` block and forgotten to delete the sentence.
**Check every claim of the form "every chapter…", "all algorithms…", "the code…" before trusting it.**

---

### 0.4 Read the class before overriding any value

`scrbook` is KOMA-Script, and KOMA-Script has opinions: it derives the type area from the font size and a `DIV` factor, and it measures the running head and the foot for itself.
Guessing costs a rebuild and can silently change the whole document.

| Setting | KOMA-Script default | This book | Why |
| --- | --- | --- | --- |
| type area | scales with the font size and `DIV` | `geometry`, one inch all round | a fixed 159mm measure |
| `\linespread` | 1 | **1.2** | 10pt Times at leading 1 is too tight for a book |
| `\headheight`, `\footheight` | computed | 30pt, 20pt | a section title above a rule needs more than one line |
| TOC spacing | class default | `\RedeclareSectionCommand[tocbeforeskip=…]` | a chapter entry needs air above it |

**Three failures, none of which errored:**

1. **Resetting a section's leading to `\linespread{1}`**, on the assumption that 1 is normal.
   The body's real leading is 1.2, so this *tightened* the whole book: 60 pages became 54.

2. **Skipping `\setlength{\headheight}`.** `scrlayer-scrpage` announces `\headheight to low` and then overlaps the header with the first line of text.
   It is one warning among many, which is exactly why it gets missed.
   The fix is a length, not an option:

   ```latex
   \setlength{\headheight}{30pt}
   \setlength{\footheight}{20pt}
   ```

3. **Changing the margins and leaving a package's cached copy of the width behind.** A package that latches a running-head width from `\textwidth` when it is loaded keeps the *old* value when `\geometry` changes `\textwidth` afterwards.
   The header then ran 10.4mm past its rule and the page number sat 5.4mm right of centre — neither errored, and both read as a rendering quirk.
   `scrlayer-scrpage` reads `\textwidth` directly, so this book is clear of that particular case, but the shape of the bug does not go away: **any package that computes a width at load time from `\textwidth`, `\textheight` or `\linewidth` keeps the old value.**

The first two are about a value the class *sets*.
The third is about a value a package *derives and caches*.
Both kinds fail silently, and both are found by measuring rather than by reading the log.

**Before writing any length or spacing value, read the class:**

```bash
grep -n 'baselinestretch\|linespread\|setstretch\|headheight\|footheight' "$(kpsewhich scrbook.cls)"
```

And when something looks wrong in the output, **render it and look** — `pdftotext` extraction loses spaces and can make a layout bug look like a text-extraction artifact, and vice versa.

Header and footer alignment is the exception: it is measurable, and a measurement settles whether what looks off actually is.
The `headsepline` rule spans `\textwidth`, so it coincides with the text block.
Extract the word boxes and compare:

```bash
pdftotext -f 20 -l 20 -bbox book.pdf boxes.xml
```

Take the words whose `yMin` is smallest (the header) and largest (the footer), and compare their `xMax` and centre against the body text's. On A4 with one-inch margins the body runs from 71.6pt to 523.3pt, so the header must end at or before 523.3 and the page number must centre on 297.5.
A header ending at 553.9 and a page number centred on 312.9 is not a visual illusion.

### 0.5 What the theorem environments actually are

`scrbook` ships **no theorem environments**.
They are built here from `amsthm`, styled to match Cover and Thomas: a run-in bold head, a full stop after the number, and nothing else around the statement.

| Environment | Numbered | Body | Grey panel |
| --- | --- | --- | --- |
| `definition` | per chapter | roman | no |
| `example` | per chapter | roman | no |
| `theorem` | per chapter | italic | **yes** |
| `lemma` | per chapter | italic | **yes** |
| `corollary` | per chapter | italic | **yes** |
| `proposition` | per chapter | italic | **yes** |
| `remark` | unnumbered | roman | no |
| `note` | unnumbered | italic | no |

**Each type has its own counter**, numbered within the chapter, so `Definition 1.1` and `Theorem 1.1` coexist and `Lemma 6.1` means the first lemma of chapter 6.
That is what the cross-references in the body assume; sharing one counter would renumber every reference.

The panel is `tcolorbox`, not `amsthm`'s own styles, and its whole definition is this:

```latex
ctresult/.style={
  breakable,
  colback=black!4, colframe=black!4,
  boxrule=0pt, arc=0pt, outer arc=0pt,
  boxsep=0pt, left=0pt, right=0pt, top=5pt, bottom=5pt,
  before skip=0.9em, after skip=0.9em,
}
```

It is wrapped around the amsthm environment, and the optional title is forwarded:

```latex
\NewDocumentEnvironment{theorem}{o}
  {\begin{tcolorbox}[ctresult]\IfNoValueTF{#1}{\begin{ctheorem}}{\begin{ctheorem}[#1]}}
  {\end{ctheorem}\end{tcolorbox}}
```

So `\begin{theorem}[AEP]` still works and still renders as "Theorem 2.4 (AEP).".
Because the counter is stepped by `\begin{ctheorem}`, a `\label` straight after `\begin{theorem}` records the right number.

**The horizontal padding is zero on purpose.**
With `left=6pt, right=6pt` the head of a theorem started **8.8pt** to the right of the prose around it, and a block that begins three millimetres right of the text column reads as a quotation rather than as body text.
`pdftotext -bbox` settles it: take the word boxes on a page that carries a theorem, and compare the smallest `xMin` inside the panel with the smallest `xMin` of the prose.
After the fix they are the same number, 72.00pt.
The vertical padding stays at 5pt, because a band that clips the ascenders looks like a mistake.

Seven traps:

- **`proof` now prints a QED.** `amsthm` appends `\qedsymbol`, which this book sets to `$\Box$`.
  **Never add `\hfill$\Box$` by hand** — it would print two.
- **`pdftotext` cannot see `$\Box$`.** It is a maths glyph, so a search of the text layer returns zero even when the symbol is there — the same trap as `\sim` in §3. To prove the mark is being drawn, change it temporarily: `\renewcommand*{\qedsymbol}{\textbf{QEDMARK}}`, rebuild, and count.
- **`breakable` needs its library.** `\usepackage{tcolorbox}` alone gives `Package pgfkeys Error: I do not know the key '/tcb/enhanced'`; add `\tcbuselibrary{breakable}`.
- **`framed`'s `shaded` is not a substitute.** With a run-in theorem head the panel has no paragraph break to split on, and it overflows the bottom of the page by about 13pt instead of breaking.
- **`enlarge left by` and `enlarge right by` are silently ignored here.** Setting them to 1pt and then to 10pt, with everything else unchanged, renders a panel of exactly the same width — **450.96pt** both times, measured pixel by pixel. Loading the `skins` library and adding `enhanced` changes nothing either.
- **`width=\linewidth+2pt` widens the panel to the right only.** The panel then spans 71.98–525.10pt where 70.15–525.13pt was wanted, because nothing at a paragraph start pushes a `tcolorbox` left: `\hspace*{-1pt}` and `\noindent\hspace*{-1pt}` are both discarded before the box starts. A symmetric bleed of 1pt is not reachable this way, so do not spend a rebuild on it.
- **An empty environment prints a bare head.** `\begin{definition}\end{definition}` compiles without any warning and renders a lone `Definition 9.7.` with nothing after it; an empty `proof` renders a lone `Proof.`. Lint for it before a release.

**Use them sparingly.** A grey panel on every definition turns a chapter into a stack of rectangles and breaks the prose into fragments.
The panel is for the results a reader wants to find by flipping: `theorem`, `lemma`, `corollary`, `proposition`.
Definitions and examples carry the label and nothing else.

**A list of properties is not a set of theorems.**
When one lemma yields three consequences, state them in one `enumerate` and prove them in one `proof` with a matching `[label=(\arabic*)]` list.
Three separate `proof` environments in a row read as three theorems that happen to be unlabelled, and they lose the sentence that binds them.

### 0.6 Figure cross-references

Use the preamble's own macro, `\figref{...}`, rather than a hand-rolled `Figure~\ref{...}`.
It is defined as `\textbf{Figure}~\ref{#1}`, so the word is typeset bold without being repeated in the source.
`\tabref` does the same for tables.

```latex
\begin{figure}[htbp]
  \centering
  \includegraphics[width=0.5\textwidth]{assets/.../foo.png}
  \caption{Caption text}
  \label{fig:short-name}
\end{figure}
```

**Watch the preamble for the opposite.** An earlier version of the starter kit shipped

```latex
\usepackage{caption}
\captionsetup[figure]{labelformat=empty}
```

which suppresses the "Figure N:" prefix.
The caption then reads "Caption text" while the body says "Figure 1.2" — a cross-reference pointing at a number that appears nowhere on the page.
The mismatch is easy to miss because the reference itself resolves without error; only the caption is wrong.

**Both lines are gone from the template as of 2026-10-09.** Numbered captions and working `\figref` references are the house standard, so no tutorial keeps `labelformat=empty` any longer.
Dropping the pair changes nothing else: the caption still renders, the reference still resolves, and the page count is unchanged.

One thing this leaves behind:

- **The four finished tutorials still ship the line.** It is harmless where nothing is cross-referenced, so this is a consistency debt rather than a bug.
  Fix each one the next time it is touched, rather than in a sweep.

### 0.7 House conventions for the source itself

**One sentence per line.**
Every sentence starts a new line, and one blank line separates paragraphs.
The file is never wrapped at a column, so a diff shows the sentences that changed rather than the paragraph they sit in.
The preamble follows the same rule: one option or one comment per line.

**Mark a term the first time it is defined, and mark it with `\emph{}`.**
Inside a `definition` and outside it, the first occurrence carries the emphasis: `the \emph{type} $P_{x^n}$`, `Such a channel is said to be \emph{symmetric}.`
**Never use `\textbf` for a term.**
The four older tutorials do exactly that — `\textbf{projection matrix}`, `\textbf{orthogonal complement}`, `\textbf{Examples}` — so this is a convention that changed rather than one that was always there.
§5 converts them on the way past.
Bold already means three things on these pages — `Figure 1.2` and `Table 1.1` from `\figref` and `\tabref`, the run-in head of a theorem, and the title on the title page — and a fourth meaning makes all four unreadable.
Italics are the only free slot, and they are what Cover and Thomas use: measured with `pdftohtml`, `entropy` and `relative entropy` are set as `<i>` in their §2.1, while the same words stay roman in the §1.1 preview, where nothing is being defined yet.

**Every `align*` has the same shape.**

```latex
\begin{align*}
  H(X)
   & = -\sum_x p(x) \log p(x) \\
   & \le \log |\mathcal{X}|.
\end{align*}
```

The left hand side sits alone on the first line, every continuation row begins with ` & `, all `&` stand in one column, and all `\\` stand in one column.
The relation signs then form a single vertical line the eye can follow down the page.

**Notation.**
`\doteq` for equality to first order in the exponent, `\coloneqq` for "defined as", `\sim` for "is distributed as".
Never write `~` where `\sim` is meant: it is an active character, it typesets as a non-breaking space, and it disappears without an error.
`\Var` for variance, never `D` — `D` belongs to the relative entropy `D(p \| q)`, and a page that shows both `D[T]` and `D(P\|Q)` cannot be read at speed.

**Never hand-write `\hfill$\Box$`.**
`amsthm` appends `\qedsymbol` to every `proof`, so a hand-written mark prints a second square.
This book carried one for weeks after a corollary was moved, and it was found by `grep -c 'hfill\$\Box\$'` returning something other than zero.

---

## 1. Standard revision (the v1.0 → v1.1 treatment)

**Every tutorial must end up with all three of these**, matching the Convex repo:

| Deliverable | Where | Standard |
| --- | --- | --- |
| **README** | `README.md` | same section shape as Convex's |
| **Commit record** | git history | one `v<x.y>: <summary>` commit for the revision |
| **Release notes** | GitHub Release | tag `v<x.y>`, PDF asset, notes body |

Do these in order.
Each step has a verification.

### Step 1 — Fix the source filename

Check for the recurring typo first — it is a habit, not a one-off:

```bash
ls *.tex | grep -i introdution
```

Fix with `git mv` so history is preserved, then update **every** reference: `.latexmkrc`, `.gitignore`, `README.md`, any build script.

Verify: `git status` shows `renamed`, and `grep -rn "Introdution" . --exclude-dir=.git` returns nothing.

### Step 2 — Add a chapter overview

One `\subsection*{Overview}` block (3 short paragraphs) immediately after each `\chapter{...}`, before the first `\section`.
Follow §0.1 metrics, then re-measure.

Content rule: say what the chapter covers, what connects it to the previous chapter, and what it is *for*.
Do not re-list the section headings.

### Step 3 — Light copyedit

Apply §0.2 exactly.
Do not sweep for missing articles beyond the categories listed — that becomes a rewrite.

Verify with a re-scan:

```bash
grep -noE '\ba [aeiou][a-z]+' *.tex          # should be empty
grep -n 'We obeys' *.tex                      # should be empty
grep -noE 'much (easy|hard|simple|clear)' *.tex
grep -noE '\b[0-9]+ (points|parts|things|cases|kinds|vectors|properties)\b' *.tex
```

### Step 4 — Fix the front matter

Rewrite any claim that the repo does not support (§0.3).

### Step 5 — Build configuration

Copy `.latexmkrc` and `.gitignore` from **The reference standard** above, substituting the two filenames (main source, built PDF).
Do not retype them — the copies drift.

Then delete any build artifacts that were already committed to the repo.
Both `ctexart` tutorials currently track a `.synctex.gz`:

```bash
git ls-files | grep -E '\.(aux|log|toc|out|synctex\.gz|fls|fdb_latexmk|bcf|blg|xdv)$'
```

### Step 6 — Rewrite the README

Sections, in this order:

1. Centred title + one-line description + `**Version x.y** · date · N pages`
2. **About** — what it is, what it follows, what makes it different
3. **Who this is for** — prerequisites, and "development-first rather than proof-first; read Boyd alongside" if applicable
4. **Contents** — grouped by part, each chapter with 3–5 lines of real description, not a one-line table row
5. **What this tutorial does not cover** — be explicit; this builds trust
6. **Building the PDF** — requirements (full TeX Live, not minimal), then `latexmk`
7. **Repository layout**
8. **Acknowledgements** / **License**

Match the body's voice per §0.1.
A README is a different genre and may run slightly longer, but the em-dash discipline still applies.

### Step 7 — Version and date

Bump `\bookversion{}` and `\date{}` in the preamble.
Check the title page renders them.
If a README states a version and page count, update it too — or drop the version line from the README so it cannot drift.

### Step 8 — Compile and verify

```bash
rm -f *.aux *.log *.toc *.out *.bcf *.run.xml *.xdv *.fls *.fdb_latexmk *.synctex.gz *.bbl *.blg
latexmk
pdfinfo "<output>.pdf" | grep -E "Pages|Producer"     # Producer should be LuaTeX
pdftotext -layout -f 2 -l 2 "<output>.pdf" - | head   # TOC must not be empty
```

A single-pass build from clean produces an **empty table of contents** and, in one measured case, 62 pages instead of 63.
`latexmk` converges on its own; a bare `lualatex` does not.

### Step 9 — Commit

Message format: `v<version>: <what changed>`, e.g.

```
v1.1: add chapter overviews, fix typos, update README and build config
```

One commit is fine for a personal repo.
Add a short body if the change set is large.

**Publishing is a separate decision.** Built PDFs go to GitHub Releases as assets, not into git.
Do not force-push or rewrite published history without asking explicitly.

### Step 10 — Release notes and GitHub Release

Every revision gets a Release: tag `v<x.y>`, the built PDF as an asset, and notes in the body.
Without this the download page silently serves the previous version, and the README describes something the reader cannot get.

**Write the body unwrapped — one line per paragraph, one line per bullet.**

GitHub renders issue, PR and release bodies in *comment mode*, where a **single newline becomes a hard line break**.
Text wrapped at 80–90 columns — the correct habit for `.tex` and for `README.md` — renders as broken lines every 90 characters, which looks like a formatting accident.
Markdown files viewed as documents behave the opposite way, so the same text cannot be reused verbatim between this guide and a Release body.

The template below is shown wrapped for readability here; paste it unwrapped.

Structure:

```markdown
## v<x.y>

<one sentence: what kind of revision this is>

### Added
- ...

### Changed
- ...

### Fixed
- ...

### For readers building from source
- ...

### Version
- Bumped to <x.y>; date on the title page updated to <date>.
```

Rules:

- **Write for someone who downloaded the previous PDF** and wants to know whether to re-download.
  They do not care about commit hashes, branch strategy, or history rewrites.
- **Name concrete things.** "The Preface claimed every algorithm comes with MATLAB code, but there is none — corrected" beats "fixed inaccuracies".
- **Do not overclaim.** Write "the main algorithms are given as pseudocode", not "every algorithm", when the latter is not literally true.
  This is the same trap as §0.3.
- **Get the asset filename right.** The v1.0 release shipped its PDF as `Introdution.to.Convex.Optimization.pdf` — the same typo as the source file.
- **Never rewrite an existing Release.** Old download links may be referenced elsewhere.
  Leave it as the historical record and get the next one right.

Fill in the three fields:

| Field | Value |
| --- | --- |
| Tag | `v<x.y>` — created at release time, target `main` |
| Release title | `v<x.y>` |
| Asset | the built PDF, **spelled correctly** |

Releases are created in the GitHub web UI or via `gh release create`.
Both are outward-facing: confirm before publishing.

---

## 2. Per-repo status

Measured 2026-11-10 by cloning each repository and reading its `.tex`.
The first row is the standard; every other row is a target brought up to it.

| Repo | State | Porting to `scrbook` |
| --- | --- | --- |
| **Introduction-to-Convex-Optimization** | ⬛ **THE EDITORIAL STANDARD** — v1.1 done; commit titles cleaned; release notes written for v1.0 and v1.1. `ad3e57a`, 3518 lines, 10 chapters, `elegantbook`, **0 theorem environments**, `\emph` 0, `\textbf` 99 | New preamble; delete `cover.tex`/`cover.pdf`; `pdf_mode` 5→4; convert `\textbf` (three kinds, see §5) |
| **Introduction-to-Linux** | ✅ v3.2 done; commit titles cleaned; CHANGELOG deleted. Its four old release bodies still say "see CHANGELOG" and now point at a file that is gone — they need replacing with the notes already drafted | **Out of scope** |
| **Introduction-to-Compressed-Sensing** | ✅ v2.1 done, migrated from `ctexart`, 60 pages; commit titles cleaned; tag `v2.1` re-pointed. `5d08504`, 2245 lines, `elegantbook`, `xeCJK` **present**, `\emph` 0, `\textbf` 70, still ships `labelformat=empty` | New preamble **keeping `xeCJK`**; delete only the `\cover{assets/…png}` line — it has no cover files; `pdf_mode` 5→4; convert `\textbf` |
| **Retracing-the-Path-of-Linear-Algebra** | ✅ v1.1 done, migrated, new TikZ cover, 38 pages. `9160092`, 2543 lines, 9 chapters, `elegantbook`, **0 theorem environments**, `\emph` 0, `\textbf` 56, still ships `labelformat=empty` | New preamble; delete `cover.tex`/`cover.pdf`; `pdf_mode` 5→4; convert `\textbf` |
| **LaTeX-Tutorial-Template** | ✅ created and pushed 2026-10-01 — the starter kit. `abfc07b`, `tutorial.tex` 83 lines, `elegantbook`, and the guide inside is `CLAUDE.md`, 789 lines, written for `elegantbook` | **Rewrite, not port** — see §5 |
| **Introduction-to-Information-Theory** | ✅ **9 chapters, 81 pages, `scrbook`**, 0 errors, 0 undefined references, 0 overfull boxes. The framework standard, and the source of the skeleton. No `.git` and not on GitHub yet | Nothing — this is the source |

**Three facts that decide the port, all measured rather than assumed:**

- **`\figref` and `\tabref` live inside the vendored `elegantbook.cls`.** They are not defined in any of the four `.tex` files. Deleting the class before the new preamble is in place takes `\figref` out from under the document.
- **Not one of the four uses a theorem environment.** Convex, Linear Algebra and the Template use none at all; Compressed Sensing uses one `note`. The whole amsthm and `tcolorbox` apparatus therefore ports across **unused**, which is fine, and the seven traps in §0.5 cost nothing.
- **`\textbf` is doing the term-marking job** — `\textbf{dom}` 58 times in Convex, `\textbf{projection matrix}`, `\textbf{orthogonal complement}`, `\textbf{Examples}`. §0.7 now says terms are `\emph`, so this is a real conversion, not a rename.

**Settled:** the body size stays at **10pt** (this book: nine chapters, 81 pages, 159mm measure).
The table-of-contents leading and the Preface and Afterwords leading are settled too — the skeleton carries both.

**Still open, one item:** whether stripping `\textbf` from heading lines belongs to the standard.
It is defined per repo in §5, so it is a decision about scope rather than about typography.

The `ctexart` migration recipe has been dropped: every `ctexart` tutorial is converted, and a new one starts from the template.
If a `ctexart` document ever needs converting again, the traps to expect were a heading-ladder shift that leaves `\paragraph` numbered `1.1.2.0.2`, a top-level `\section` absorbed into the last chapter, divider blocks nesting `\begin{center}`, leftover `\fontsize{12}{14}\newpage` pairs, and the dropped `\captionsetup[figure]{labelformat=empty}` line.

---

## 3. Environment notes

- **Network:** `github.com` over **HTTPS works**, through the local proxy that is already in the environment (Clash Verge on `127.0.0.1:7897`, exported as `HTTP_PROXY` and `HTTPS_PROXY`).
  `git clone https://github.com/Octopus058/<repo>.git` and `git ls-remote` both succeed.
  **SSH does not work**: `~/.ssh` holds only `known_hosts`, there is no key, and `git@github.com` answers `Permission denied (publickey)`.
  **The REST API is rate limited** to 60 requests an hour without a token, and a working session spends that quickly; it answered `403 rate limit exceeded` with 0/60 left.
  So probe a repository with `git ls-remote`, not with `api.github.com`.
- **LaTeX Workshop (VS Code):** the default recipe must be `latexmk -lualatex`.
  A recipe using `latexmk -pdf` **silently** falls back to pdfLaTeX: `fontspec` cannot load at all, and any Unicode character outside Latin-1 becomes a fatal error.
  A bare `lualatex` recipe skips the extra passes and leaves cross-references stale.
- **`latexmk -c`** removes auxiliary files but keeps the PDF; **`latexmk -C`** removes everything including the PDF.

### Chinese text renders as blank by default

`scrbook` loads no CJK support at all, and nor does anything else in the preamble.
So `\setCJKmainfont` is undefined and any Chinese in the body **renders as nothing**, or as a train of tofu boxes, with no error and no warning.
It just disappears, and the surrounding sentence reads as if a word were missing.

Compressed Sensing and Linear Algebra both turned out to contain Chinese.
Compressed Sensing genuinely needed it (`压缩感知` in the Preface, a Chinese bibliography entry) and required an explicit `\usepackage{xeCJK}` plus `\setCJKmainfont{Microsoft YaHei}`.
Linear Algebra's Chinese was all in preamble comments, so it needed nothing.

Do not assume either way.
Check with perl, not grep:

```bash
perl -CSD -ne 'print "$ARGV:$.: $_" if /\p{Han}/' *.tex
```

A `[一-龥]` range **byte-matches** in this locale and reports every em-dash as Chinese.
A zero from a byte-range grep is a false zero; only `\p{Han}` is trustworthy.

### Backslashes through the shell

Backslashes do not survive this shell reliably.
One-liners containing `\\`, `\{`, or `$'\r'` fail **silently** and return a plausible-looking wrong answer. Observed in one session: `grep -c $'\r'` reporting 0 on a CRLF file; `grep -E '...\{\\textbf\{...'` matching every line; `sed -i` converting CRLF to LF and turning a 13-line diff into 2585; `perl -pe 's/\\version.../'` doing nothing.

**Write the logic to a script file** (`Write` tool) and run `perl script.pl <in >out`.
Prefer the `Grep` tool over `grep` for patterns with escapes.
Verify counts against an independent measure.

### The tilde is not a tilde, and `pdftotext` cannot see it

In LaTeX source, `~` is an **active character** — a non-breaking space.
Writing `$(X, Y) ~ p(x, y)$` intending "is distributed as" produces `(X,Y) p(x,y)`: the tilde **vanishes silently**, no error, no warning.
The markup is `\sim`, and the same confusion waits in any language that uses the symbol for asymptotic equivalence.

**Do not try to confirm it with `pdftotext`.** Math symbols are only partially extractable, and `\sim` is one of the ones that is not: the correct `\sim` came out as two blank spaces, which reads exactly like the broken `~`.
The two states are indistinguishable from the text layer.
Render the page and look — this is the same trap as the `\captionsetup` case in §0.6, in the opposite direction: there a real layout change looked like an extraction artifact, here a correct symbol looked like a missing one.

### Line endings

These repos use `core.autocrlf=true` and most sources are **CRLF** in the working tree.
Two consequences, both learned the hard way:

1. **Any script that splits on `\n` must normalise CRLF first.** `split /\n/` leaves a trailing `\r` on every line, so `$line eq '\newpage'` is never true and the script reports 0 matches. Normalise at the top, restore on output:

   ```perl
   my $crlf = ($t =~ /\r\n/) ? 1 : 0;
   $t =~ s/\r\n/\n/g;
   # ... work ...
   $t =~ s/\n/\r\n/g if $crlf;
   ```

2. **Never `cp` a script's output over the source without checking it is non-empty.** A Perl syntax error produces an empty file, and `cp` will happily blank the source.
   Guard every write:

   ```bash
   perl script.pl < src > /tmp/out && [ -s /tmp/out ] && cp /tmp/out src || echo "aborted"
   ```

**`cat -A` does not mark the CR** in this environment, and `grep -c $'\r'` lies. Only `tr -dc '\r' < file | wc -c` is trustworthy.

**Line-end anchors fail on CRLF as well.** Searching for `^\newpage$` in a CRLF file returns **nothing**, because the line really ends `\newpage\r\n` and `$` never reaches the end of the line.
That reads as a confident zero — "there is no leftover `\newpage`" — when in fact there is one after every chapter.
This is how the Linear Algebra leftover was almost missed.
The same is true of the `Grep` tool, whose `$` behaves identically.

Do not trust a zero from an anchored pattern in these repos.
Match on the *start* of the following construct instead, or normalise the file first and then search.

---

## 4. Daily loop

One `.tex` file produces two artifacts, and they fail in different ways.
The PDF from `latexmk` is the deliverable.
The live preview is an editor convenience with its own cache, and that cache is behind almost every false alarm.

### What to do after each kind of edit

| Changed | Do this |
| --- | --- |
| Prose, maths, a theorem environment | Nothing. Saving is enough; the preview updates incrementally. |
| **Anything under `assets/`** — added, deleted, renamed, moved | **Three steps**: clear the preview cache, `Developer: Reload Window`, reopen the preview. |
| `.vscode/settings.json` or `.latexmkrc` | Reload the window (VS Code), or start a fresh terminal (`latexmk`). |
| Want the real result | `latexmk`, then read the PDF. |

The one rule worth memorising: **anything under `assets/` means clear the cache.** Realtime TeX mirrors the whole project into a build directory and tracks file *content*, not the set of files.
A new or renamed image leaves the mirror stale, and the preview then either reports the file missing or draws whichever figure used to occupy that position.
Deleting the cache alone is not enough, because the extension also holds engine state in memory — the window reload is what makes it re-read the project and the settings.

### The three commands

```powershell
cd "<repo>"

latexmk                        # routine build; reads .latexmkrc, so lualatex
.\_clear-rtex-cache.ps1        # after touching assets/
latexmk -C; latexmk            # when a build fails for no visible reason
```

The cache lives outside the repo, in VS Code's per-workspace storage: `%APPDATA%\Code\User\workspaceStorage\<workspace-hash>\henryxiaoyang.realtime-tex`.
Stopping `rtex.exe` first is usually required, since it holds file locks and the extension respawning it is normal — retry the deletion a few times.

### Which side to trust

| Surface | Reliable for |
| --- | --- |
| Live preview | Prose, maths, line breaking. **Not images.** |
| The `latexmk` PDF | Everything: page count, figures, cross-references, the table of contents. |

Paragraphs containing `\includegraphics` are never rendered on the live path.
`rtex verify` reports them as ineligible for the reason `NeedsPackage("graphicx")` and serves them from the background capture's PDF page instead, so a figure in the preview is only as fresh as that capture.
Draft against the preview; accept against the PDF.

**`pdftotext` cannot see a font.**
The text layer keeps the characters and throws the typeface away, so a term that should be italic and one that stayed roman extract identically, and so does a QED square that is missing.
`pdftohtml -xml -f <page> -l <page> -stdout book.pdf` keeps it: it prints a `<fontspec>` table naming each face (`OJDIOO+Times` for roman, `OJDPKM+Times` for the italic cut in Cover and Thomas), and every span carries an `<i>` or `<b>` marker.
That is how the twelve newly marked terms in this book were confirmed, and it is also how Cover and Thomas were measured.

### Symptom, cause, fix

| Symptom | Cause | Fix |
| --- | --- | --- |
| Preview: `File ... not found` | the mirrored asset copy is stale | clear cache, reload, reopen |
| Preview shows **the wrong figure** | the layout table is stale; a new figure shifted everything below it | the same three steps, then `Realtime TeX: Recompile Whole Document` |
| `! LaTeX Error: Missing \begin{document}` | a corrupted `.aux` left by an interrupted run | `latexmk -C`, rebuild |
| `! File ended while scanning use of \@writefile` | same, with a truncated `.toc` | `latexmk -C`, rebuild |
| A first pass full of `Reference ... undefined` | clean build, no `.aux` yet | normal; let `latexmk` finish |
| `! Undefined control sequence` | a macro with no declaration (`\Var` was one) | add `\DeclareMathOperator` to the preamble |
| pdfLaTeX stops on `Unicode character 、` | a non-Latin-1 character leaked into the source | find and delete it |
| Missing figures in the editor but fine in the terminal | wrong working directory, or a recipe that is not `latexmk -lualatex` | check `pwd`; fix the recipe |

### Before stopping

```powershell
latexmk        # exit 0?
```

Then confirm three things: no `not found` anywhere in the log, the page count matches what you expect, and `pdfimages -list <output>.pdf` shows one image per figure.
That count is cheap insurance — a figure silently dropped by a layout change still leaves a valid PDF.

---

## 5. Porting the scrbook setup

The preamble above is the whole framework; everything else is bookkeeping.
The order matters, because `\figref` and `\tabref` are defined **inside the vendored `elegantbook.cls`**.
Delete that file first and every `\figref` in the document becomes an undefined control sequence.

1. **Put the new preamble in**, with `\figref` and `\tabref` and the whole theorem block from the skeleton above.
   Change `\version{x}` to `\bookversion{x}` and `\extrainfo{``quote''}` to `\bookquote{``quote''\quad --- source}`, because `elegantbook` supplied those two commands and `scrbook` does not.
2. **Then delete the vendored class**: `elegantbook.cls`.
   A class file left in the folder silently wins over the one you think you are using.
3. **Delete the cover.** Convex, Linear Algebra and the Template each carry `cover.tex` and `cover.pdf`; delete both files and the `\cover{cover.pdf}` line.
   Compressed Sensing has no cover files at all — its cover is `\cover{assets/3.1 What is Compressed Sensing/Compressed Sensing.png}`, so only that line goes.
   The skeleton's `\maketitle` draws the title page from `\@title`, `\bookversion`, `\bookquote`, `\@author` and `\@date`, and needs no cover.
4. **Rewrite `.latexmkrc`**: `$pdf_mode = 5` (XeLaTeX) becomes **4** (LuaLaTeX), and `@default_files` names the actual source file.
   Copy `.gitignore` across unchanged.
5. **`latexmk -C`, then `latexmk`.** It must reach exit 0 before anything else is looked at.
   **Record the new page count** — switching engine re-flows every paragraph, so it will not be the old number, and both the README and the release notes quote it.
6. **Three greps on the log, each of which must be zero**: undefined references, `^Overfull`, and empty environments.
   An empty `\begin{definition}\end{definition}` raises no error at all; it prints a lone `Definition 9.7.` and stops there.
   Then the two checks the text layer cannot answer, both measured in §4: the grey panel spans the measure exactly, and every first-occurrence term is italic.
7. **Convert `\textbf` to `\emph`.** Three kinds, and only the third one changes:

   | What it marks | Example | Action |
   | --- | --- | --- |
   | a bold maths operator | `\textbf{dom}`, `\textbf{aff}`, `\textbf{relint}`, `\textbf{conv}` | **keep it bold**, that is a name and not a term |
   | a heading | `\textbf{Examples}`, `\textbf{P.S.}` | **drop the `\textbf`**, the heading already looks like one |
   | a defined term | `\textbf{projection matrix}`, `\textbf{orthogonal complement}` | **`\emph{}`**, per §0.7 |

   Convex has 99 `\textbf`, Compressed Sensing 70, Linear Algebra 56.

### The Template is rewritten, not ported

`LaTeX-Tutorial-Template` is the only repository where nothing survives as it stands.

- `CLAUDE.md`, 789 lines, is the guide from before `scrbook` existed — rename it to `AGENTS.md` and replace the contents with this file.
- `tutorial.tex`, 83 lines, is `elegantbook`: replace it with the skeleton above, with `<Title>` and the date filled in.
  Its body is also wrapped at about 95 columns, which breaks §0.7, so it comes out one sentence per line.
- `cover.tex`, `cover.pdf` and `\cover{cover.pdf}` are deleted.
- `README-template.md` stays, but check it for `\version` and other `elegantbook`-only commands.

### What each repo needs beyond the seven steps

- **Compressed Sensing is the only one with a Chinese body text.** `scrbook` loads no CJK support, so carry `\usepackage{xeCJK}` and `\setCJKmainfont{Microsoft YaHei}` across from its current preamble, beside the font setup.
  Without them every Chinese character disappears, with no warning.
- **The other three need no extra package.**
- **All four lose their colour.** `elegantbook` is loaded with `color=blue` and the covers are coloured TikZ drawings; after the port the books are black and white like this one, which is the point but is worth saying in each release note.

Linux is out of scope for this port.
