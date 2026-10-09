# Tutorial Guide

How to **revise** my LaTeX tutorials: the standard they conform to, the revision
procedure, how to match my voice, and the traps this environment sets. Drawn from revising
Convex Optimization, Linux, Compressed Sensing and Linear Algebra between 2026-09-30 and
2026-10-01.

**The prose is written by hand.** The body of every tutorial is mine. This guide is for
working on what is already there — restructuring, copyediting, aligning a document with the
standard — and for the few places new prose does get written on request: chapter overviews,
the README, and release notes. It is not a template for generating tutorial content.

This is the master copy. **Copy it into a tutorial repository as `CLAUDE.md`** and it loads
automatically in every session there, so the rules do not have to be restated each time.

**Starting a new tutorial?** That is the rest of this folder: `tutorial.tex`, `cover.tex`,
`README-template.md`, `.latexmkrc`, `.gitignore` and `elegantbook.cls`. See `README.md`.

> Why a file rather than memory. Memory is scoped to one project folder
> (`~/.claude/projects/<dir-slug>/memory/`), and does not follow to another repository. A
> `CLAUDE.md` copied into each repo is the only thing that reliably travels.

---

## The reference standard

**`Octopus058/Introduction-to-Convex-Optimization` is the canonical template.** Where
any tutorial diverges from it, the Convex repo wins. Copy from it rather than
re-deriving anything.

```bash
git clone git@github.com:Octopus058/Introduction-to-Convex-Optimization.git
```

It is the only tutorial that has been through the full treatment, so it defines the
target for: document class, preamble, chapter overviews, build config, README shape,
and commit messages.

### Preamble skeleton

```latex
\documentclass[lang=en,color=blue,mode=fancy,titlestyle=hang]{elegantbook}

% ---- Title Information ----
\title{<Title>}
\author{Lancet Ross}
\date{<Month DD, YYYY>}
\version{<x.y>}
\extrainfo{``<a short quotation>''}
\cover{cover.pdf}

% ---- Additional Packages ----
\usepackage{algorithm}
\usepackage{algpseudocode}
\usepackage{float}
\usepackage{subcaption}

% ---- Math Operators ----
\DeclareMathOperator*{\argmin}{arg\,min}

\begin{document}

\maketitle

\frontmatter
\tableofcontents

\mainmatter
\chapter{...}

\appendix
\chapter{Quiz}        % optional

\backmatter           % optional -- Afterword
\end{document}
```

Copy `elegantbook.cls` into the repo. It is bundled in the Convex repo, not fetched
from CTAN, so a tutorial without it will not build.

### `.latexmkrc` — copy verbatim, change the filename on the last line

```perl
# elegantbook loads fontspec, so this document must be built with XeLaTeX.
# Setting this makes a bare `latexmk` (no flags) do the right thing.
$pdf_mode = 5;    # 5 = xelatex

# Without this, a bare `latexmk` builds every .tex in the directory -- including
# cover.tex, which would overwrite the committed cover.pdf. Restrict it to the book.
@default_files = ("<exact main filename>.tex");
```

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

Note `*.pdf` is **not** used as a glob: `cover.pdf` is a tracked source file, and a
glob would risk it. Name the built PDF exactly.

### Chapter overview format

Directly after `\chapter{...}`, before the first `\section`:

```latex
\subsection*{Overview}

<three short paragraphs, ~18 words/sentence, no em-dashes, no semicolons>
```

See **§0.1 My voice** below for the metrics.

### README shape

Centred title + one-line description + `**Version x.y** · date · N pages`, then:
`About` → `Who this is for` → `Contents` (grouped by part, 3–5 lines per chapter) →
`What this tutorial does not cover` → `Building the PDF` → `Repository layout` →
`Acknowledgements` → `License`.

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

**The failure mode to guard against.** When an assistant writes "in my style", it
reliably produces:

- em-dashes at **10–20×** my rate (measured: 1.16 vs 0.07 per 100 words) — 23 in one
  README where I would have used 1
- sentences **30–45% longer** than mine (measured: 22.8 and 26.3 words/sentence
  against my 18.4)

This is not a grammar problem. The prose is *correct* — it just doesn't sound like me.
It reads as a different author, and it is the single most repeated mistake.

**Measure before claiming a match.** Run this on the file being edited and on the
body text it has to blend into:

```bash
# strip LaTeX, join lines
detex() { sed -e 's/\\[a-zA-Z]*//g' -e 's/[${}\\]//g' | tr '\n' ' ' | sed 's/  */ /g'; }

w=$(detex < body.tex | wc -w)
s=$(detex < body.tex | grep -oE '[.!?] ' | wc -l)
echo "avg words/sentence: $((w / s))"                    # target 18
echo "em-dashes per 100w: $(grep -o '—' body.tex | wc -l | awk -v w=$w '{printf "%.2f\n", $1/w*100}')"   # target 0.07
```

Counting semicolons needs care — LaTeX's `\;` spacing command is not punctuation, and
a naive count will read as "0 real semicolons" while being completely wrong. Use a
**fixed-string** match:

```bash
total=$(grep -o ';' f.tex | wc -l)
spacers=$(grep -oF '\;' f.tex | wc -l)     # -oF is required; see below
echo "real semicolons: $((total - spacers))"
```

> **Verified trap.** Of the four obvious ways to write the spacer pattern
> (`grep -o '\;'`, `grep -o '\\;'`, `grep -oF '\;'`, `awk gsub`), **only `grep -oF`
> gave the right answer** (339 spacers). The other three silently matched *every*
> semicolon, returning `total - total = 0`. A plausible-looking zero is worse than an
> error — always sanity-check against the raw total.

Target for anything new: **≤1 em-dash per section, 0 semicolons**, max sentence ~30
words, and a sentence length matching **the document being edited** — not the 18 above.

That last point matters more than it looks. The 18-word figure is the *Convex* baseline.
Measured baselines differ between tutorials:

| Tutorial | Average sentence length |
| --- | --- |
| Convex Optimization | 18.4 |
| Linear Algebra | 18.4 |
| Compressed Sensing | **23.1** |

Writing 18-word prose into Compressed Sensing makes the new text 22% shorter than its
surroundings, which reads as a different author just as surely as writing 26-word prose
into Convex. **Measure the target document first**, then aim at that number. The other two
metrics (em-dashes, semicolons) are low in every tutorial and carry over unchanged.

Expect to iterate. When I rewrote 8 chapter overviews for Convex, the first attempt came
out at 22.8 words/sentence and the second at 11.6 — one overshoot in each direction before
landing on 17.9. Check with numbers each time.

### 0.2 What to fix vs. what to leave alone

**Fix — grammar only, and only these categories:**

- articles: `a invertible` → `an invertible`, `an standard` → `a standard`
- subject–verb agreement: `We obeys` → `We obey`
- comparatives: `much easy` → `much easier`, `much hard` → `much harder`
- possessives: `it's extended-value extension` → `its`; `used for it's convexity` → `its`
- spelling: `Howeever` → `However`
- numerals in running prose: `2 cases` → `two cases`, `at least 1` → `at least one`
  (digits stay for math, chapter/section refs, algorithm step numbers, `rank-2`)
- missing relative pronoun: `there must be $y$ satisfies` → `$y$ **that** satisfies`
- prepositions: `divide this equation to 2 parts` → `**into** two parts`

**Leave alone — this is voice, not error:**

- `See what? $V$ is the nullspace of $A$.`
- `Don't make a fool of yourself.` / `Don't get yourself lost.`
- `Till now, Prof. Ling began to talk about...`
- `Human beings are creatures in 3D world.`
- the "pot / reaches the sky / a super pot" metaphor
- `We obey that the right side of the constraints are 0` — odd wording, but fixing it
  is a rewrite, not a correction. Ask first.

These are Chinese rhetorical moves carried into English. They are the author's
fingerprint. Flattening them makes the book generic.

### 0.3 Fact-check the front matter against the repo

A Preface or README that promises something the repo does not contain is worse than a
typo. In the Convex tutorial the Preface claimed *"Every algorithm is accompanied by
intuition, convergence analysis, and MATLAB code"* — while the repo contained **zero**
code listings:

```bash
grep -c 'begin{lstlisting}\|begin{verbatim}\|begin{minted}' *.tex   # 0
find . -name '*.m' -o -name '*.py' | grep -v '^./.git'              # nothing
grep -c 'begin{algorithm}' *.tex                                    # 8 -- pseudocode only
```

The claim traced back to a commit that had deleted the `\lstset{language=Matlab}`
block and forgotten to delete the sentence. **Check every claim of the form "every
chapter…", "all algorithms…", "the code…" before trusting it.**

---

### 0.4 Read the class before overriding any value

`elegantbook` sets its own defaults, and several are **not** the LaTeX default. Guessing
costs a rebuild and can silently change the whole document.

| Setting | LaTeX default | elegantbook | Where |
| --- | --- | --- | --- |
| `\baselinestretch` | 1 | **1.2** | cls line 164 |
| `\cftchapnumwidth` | tocloft's | sized for the **10pt** body | cls, in the `lang` branch |
| `\cft…font` (TOC) | tocloft's | left at tocloft's defaults | cls sets only the number widths |
| TOC entry level | — | `\subsection*` renders unnumbered | — |

**Two failures this caused, neither of which errored:**

1. **Resetting the Preface leading to `\linespread{1}`**, on the assumption that 1 is
   normal. The body's real leading is 1.2, so this *tightened* the whole book: 60 pages
   became 54.

2. **Raising `\cftchapfont` to `\large` squeezed the space out of the chapter TOC
   entries** — "Chapter 1Signal Transformation". tocloft typesets an entry as
   `\hb@xt@\cftchapnumwidth{...}`, a **fixed-width box**; the class sizes that box for the
   10pt body, so enlarging the font filled it and pushed the trailing space out. Fix by
   recomputing the width for the new size:

   ```latex
   \setlength{\cftchapnumwidth}{\widthof{\large\bfseries Chapter~99} + 0.5em}
   ```

**Before writing any length or spacing value, read the class:**

```bash
grep -n 'baselinestretch\|linespread\|setstretch\|cftchapnumwidth' elegantbook.cls
```

And when something looks wrong in the output, **render it and look** — `pdftotext`
extraction loses spaces and can make a layout bug look like a text-extraction artifact,
and vice versa.

### 0.5 What `elegantbook` actually provides

`elegantbook` ships a fixed set of environments. **There is no `tip`, `important` or
`caution`** — those belong to other classes and error out here. Enumerate before
recommending anything:

```bash
grep -oE '\\newenvironment\{[a-zA-Z]+\}' elegantbook.cls | sort -u
```

| Kind | Environments | Renders as |
| --- | --- | --- |
| **Boxed, numbered** (tcolorbox) | `theorem` `definition` `postulate` `axiom` `corollary` `lemma` `proposition` | coloured frame, title tab top-left, suit symbol bottom-right |
| **Counted, inline** | `example` `exercise` `problem` | bold label plus number, no frame |
| **Unnumbered, inline** | `note` `remark` `assumption` `conclusion` `property` `solution` `proof` `custom` | bold label only |

The boxed set comes in three colours by style: `defstyle` (definition) green, `thmstyle`
(theorem, lemma, corollary, axiom, postulate) orange, `prostyle` (proposition) blue. The
suit symbol follows the style — clubs for definitions, hearts for theorems, spades for
propositions. Any of them takes an optional bracket title, and `\begin{lemma}[Log-sum
inequality]` renders as "Lemma 1.1 (Log-sum inequality)".

**Each type has its own counter.** `\ELEGANT@usesamecnt` is off unless the class is
loaded with that option, so `definition`, `theorem` and `lemma` all number independently
from 1.1 within a chapter. Do not assume a shared sequence: five different environments
in one test file all printed "1.1".

Two traps inside these:

- **`proof` prints no QED symbol.** The class comments the line out
  (`% \hfill$\Box$\quad`, cls line 1193), so `\begin{proof}...\end{proof}` ends with
  nothing at all. Add `\hfill$\Box$` by hand if the book wants one, and settle on □ or
  ∎ once rather than mixing them.
- **`note` and `remark` are near-identical.** `note` hangs a red dingbat in the margin
  and sets the body italic; `remark` is a plain bold label with a roman body. Pick one
  and stay with it.

**Use them sparingly, and demo before adopting.** Wrapping every definition in a box
turns a chapter into a stack of coloured rectangles and breaks the prose into fragments.
One measured case: 20 environments across a single chapter put 7 label blocks on one
page. Render a sample page first and look at it before committing book-wide.

The set that earns a box is the **spine** — the few definitions the chapter is built on,
plus any named result a later chapter will cite. Lists of properties are not that: a
lead-in sentence and an `itemize` already say it, and the boxed label adds a count but no
information. Worse, these environments have **no terminator**, so a paragraph following
one reads as though it were still inside it. Reaching for an environment is the right
instinct; reaching for twenty is not.

### 0.6 Figure cross-references

Use the class's own macro, `\figref{...}`, rather than a hand-rolled `Figure~\ref{...}`.
It is defined in the `lang=en` branch as `\textbf{Figure}~\ref{#1}` (cls line 458), so the
word is typeset bold without being repeated in the source.

```latex
\begin{figure}[htbp]
  \centering
  \includegraphics[width=0.5\textwidth]{assets/.../foo.png}
  \caption{Caption text}
  \label{fig:short-name}
\end{figure}
```

**The starter kit's preamble used to fight this.** It shipped

```latex
\usepackage{caption}
\captionsetup[figure]{labelformat=empty}
```

which suppresses the "Figure N:" prefix. The caption then reads "Caption text" while the
body says "Figure 1.2" — a cross-reference pointing at a number that appears nowhere on
the page. The mismatch is easy to miss because the reference itself resolves without
error; only the caption is wrong.

**Both lines are gone from the template as of 2026-10-09.** Numbered captions and working
`\figref` references are the house standard, so no tutorial keeps `labelformat=empty` any
longer. Dropping the pair changes nothing else: the caption still renders, the reference
still resolves, and the page count is unchanged.

Two things this leaves behind:

- **§2 still recommends preserving `\captionsetup[figure]{labelformat=empty}`** during a
  `ctexart` migration, using it as the example of a setting that is easy to lose. The
  lesson about auditing non-package preamble lines stands, but the specific advice now
  contradicts this section. §2 carries an inline note until it is rewritten.
- **The four finished tutorials still ship the line.** It is harmless where nothing is
  cross-referenced, so this is a consistency debt rather than a bug. Fix each one the next
  time it is touched, rather than in a sweep.

---

## 1. Standard revision (the v1.0 → v1.1 treatment)

**Every tutorial must end up with all three of these**, matching the Convex repo:

| Deliverable | Where | Standard |
| --- | --- | --- |
| **README** | `README.md` | same section shape as Convex's |
| **Commit record** | git history | one `v<x.y>: <summary>` commit for the revision |
| **Release notes** | GitHub Release | tag `v<x.y>`, PDF asset, notes body |

Do these in order. Each step has a verification.

### Step 1 — Fix the source filename

Check for the recurring typo first — it is a habit, not a one-off:

```bash
ls *.tex | grep -i introdution
```

Fix with `git mv` so history is preserved, then update **every** reference:
`.latexmkrc`, `.gitignore`, `README.md`, any build script.

Verify: `git status` shows `renamed`, and `grep -rn "Introdution" . --exclude-dir=.git`
returns nothing.

### Step 2 — Add a chapter overview

One `\subsection*{Overview}` block (3 short paragraphs) immediately after each
`\chapter{...}`, before the first `\section`. Follow §0.1 metrics, then re-measure.

Content rule: say what the chapter covers, what connects it to the previous chapter,
and what it is *for*. Do not re-list the section headings.

### Step 3 — Light copyedit

Apply §0.2 exactly. Do not sweep for missing articles beyond the categories listed —
that becomes a rewrite.

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

Copy `.latexmkrc` and `.gitignore` from **The reference standard** above, substituting
the two filenames (main source, built PDF). Do not retype them — the copies drift.

Then delete any build artifacts that were already committed to the repo. Both `ctexart`
tutorials currently track a `.synctex.gz`:

```bash
git ls-files | grep -E '\.(aux|log|toc|out|synctex\.gz|fls|fdb_latexmk|bcf|blg|xdv)$'
```

### Step 6 — Rewrite the README

Sections, in this order:

1. Centred title + one-line description + `**Version x.y** · date · N pages`
2. **About** — what it is, what it follows, what makes it different
3. **Who this is for** — prerequisites, and "development-first rather than proof-first;
   read Boyd alongside" if applicable
4. **Contents** — grouped by part, each chapter with 3–5 lines of real description,
   not a one-line table row
5. **What this tutorial does not cover** — be explicit; this builds trust
6. **Building the PDF** — requirements (full TeX Live, not minimal), then `latexmk`
7. **Repository layout**
8. **Acknowledgements** / **License**

Match the body's voice per §0.1. A README is a different genre and may run slightly
longer, but the em-dash discipline still applies.

### Step 7 — Version and date

Bump `\version{}` and `\date{}` in the preamble. Check the title page renders them.
If a README states a version and page count, update it too — or drop the version line
from the README so it cannot drift.

### Step 8 — Compile and verify

```bash
rm -f *.aux *.log *.toc *.out *.bcf *.run.xml *.xdv *.fls *.fdb_latexmk *.synctex.gz *.bbl *.blg
md5sum cover.pdf > /tmp/cv.txt
latexmk
md5sum -c /tmp/cv.txt          # cover.pdf must be untouched
pdfinfo "<output>.pdf" | grep -E "Pages|Producer"     # Producer should be xdvipdfmx
pdftotext -layout -f 2 -l 2 "<output>.pdf" - | head   # TOC must not be empty
```

A single-pass build from clean produces an **empty table of contents** and, in one
measured case, 62 pages instead of 63. `latexmk` converges on its own; a bare
`xelatex` does not.

### Step 9 — Commit

Message format: `v<version>: <what changed>`, e.g.

```
v1.1: add chapter overviews, fix typos, update README and build config
```

One commit is fine for a personal repo. Add a short body if the change set is large.

**Publishing is a separate decision.** Built PDFs go to GitHub Releases as assets, not
into git. Do not force-push or rewrite published history without asking explicitly.

### Step 10 — Release notes and GitHub Release

Every revision gets a Release: tag `v<x.y>`, the built PDF as an asset, and notes in
the body. Without this the download page silently serves the previous version, and the
README describes something the reader cannot get.

**Write the body unwrapped — one line per paragraph, one line per bullet.**

GitHub renders issue, PR and release bodies in *comment mode*, where a **single newline
becomes a hard line break**. Text wrapped at 80–90 columns — the correct habit for `.tex`
and for `README.md` — renders as broken lines every 90 characters, which looks like a
formatting accident. Markdown files viewed as documents behave the opposite way, so the
same text cannot be reused verbatim between this guide and a Release body.

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

- **Write for someone who downloaded the previous PDF** and wants to know whether to
  re-download. They do not care about commit hashes, branch strategy, or history
  rewrites.
- **Name concrete things.** "The Preface claimed every algorithm comes with MATLAB code,
  but there is none — corrected" beats "fixed inaccuracies".
- **Do not overclaim.** Write "the main algorithms are given as pseudocode", not "every
  algorithm", when the latter is not literally true. This is the same trap as §0.3.
- **Get the asset filename right.** The v1.0 release shipped its PDF as
  `Introdution.to.Convex.Optimization.pdf` — the same typo as the source file.
- **Never rewrite an existing Release.** Old download links may be referenced elsewhere.
  Leave it as the historical record and get the next one right.

Fill in the three fields:

| Field | Value |
| --- | --- |
| Tag | `v<x.y>` — created at release time, target `main` |
| Release title | `v<x.y>` |
| Asset | the built PDF, **spelled correctly** |

Releases are created in the GitHub web UI or via `gh release create`. Both are
outward-facing: confirm before publishing.

---

## 2. ElegantBook migration (for `ctexart` tutorials)

Some tutorials are `\documentclass[12pt]{ctexart}` with hand-rolled headings:

```latex
\fontsize{26}{31.2}\section{\textbf{Solving linear equations}}\par
\titleformat{\section}[block]{\normalfont\Large\bfseries\centering}{}{0pt}{}
```

All of that exists only because `ctexart` is an article class with no chapters and no
sensible heading defaults. Migrating to `elegantbook` removes the need for it.

Take the preamble from **The reference standard** above — do not re-derive it.

Migration notes:

- `elegantbook.cls` must be copied into the repo (it is bundled, not on CTAN as a
  package dependency).
- Delete the hand-written `xeCJK`, `fontspec` and `\setCJKmainfont{KaiTi}` block. It was
  copied from a Chinese template and is dead weight in an English tutorial. **But check
  first whether the body actually contains Chinese** — see §4, and note that `grep -P` is
  unavailable here.
- **Audit the old preamble for functional settings, not just packages.** A package list is
  easy to carry across; a bare configuration line is easy to drop. The one missed on both
  migrations so far was

  ```latex
  \captionsetup[figure]{labelformat=empty}
  ```

  which sits on its own line with no `\usepackage` above it, and which suppresses the
  "Figure N:" prefix on captions. Losing it silently relabeled every figure in the book.

  **Superseded as of 2026-10-09 — see §0.6.** The house now wants numbered captions so
  that `\figref` resolves, so on the next migration this line should be **dropped**, along
  with the `\usepackage{caption}` above it. The paragraph still earns its place as the
  example, because a functional setting with no package header of its own is exactly the
  kind that goes missing. Keep the practice of auditing for such lines; drop only this
  instance of it. Before replacing a preamble, list its non-package lines and account for
  each one:

  ```bash
  grep -nE '^\\(renewcommand|newcommand|captionsetup|hypersetup|setlength|titleformat|patchcmd|newenvironment)' old.tex
  ```

  The same pass catches `\titleformat`, `\newgeometry`, `\fancyhead` and hand-rolled
  environment definitions, all of which the divider-page conversion also depends on.
- **Enumerate the heading levels before shifting anything.** List every heading command
  in use, and include `\paragraph` and `\subparagraph` — not just
  `\section`/`\subsection`/`\subsubsection`. The Linux recipe shifted three levels; the
  Compressed Sensing document had a fourth, and because the recipe was copied rather than
  checked, the `\paragraph` headings stayed at level five and were numbered `1.1.2.0.2`
  (the `.0.` being an unused subsubsection counter). **Compilation succeeded**, so nothing
  flagged it — it only showed up by reading a rendered page.

  ```bash
  grep -oE '^\s*\\(chapter|section|subsection|subsubsection|paragraph|subparagraph)\*?\{' *.tex \
    | sort | uniq -c
  ```

  Then shift the whole ladder, using a temporary marker so the passes do not re-convert
  each other (`subsubsection` → marker, `subsection` → `section`, marker → `subsection`,
  and so on for the deeper levels).
- **A top-level `\section` that is not a divider page is easy to miss.** Linear Algebra's
  Afterwords was a plain `\section{...}` with no divider block around it, so once the
  ladder shifted down it was absorbed into the last chapter and showed up in the table of
  contents as a subsection. Walk every `\section` and confirm which ones are dividers.
- **Divider blocks can nest `\begin{center}`.** Linear Algebra's wrap the quotation and its
  attribution inside the outer centre block. A converter that stops at the first
  `\end{center}` leaves the quotation and the closing tag behind in the body. Count nesting
  depth instead of taking the first match.
- **Each converted divider leaves a `\fontsize{12}{14}\newpage` behind.** Those two lines
  reset the font after the big divider type and started the body on a fresh page. Once the
  divider is a `\chapter{...}`, the `\newpage` pushes the whole chapter body onto a second
  page and leaves the title alone on the first. Removing them took Linear Algebra from 45
  pages to 39. **`^\newpage$` will not find them** — see §4.
- Delete all `\titleformat` / `\titlesec` / inline `\fontsize{...}\section{...}` lines.
  Convert `\section` → `\chapter` at the top level.
- `\section*{Preface}` + `\addcontentsline` becomes `\chapter*{Preface}` inside
  `\frontmatter`.
- Requires a **full** TeX Live install (`texlive-full`); a minimal install fails on
  `fontspec`/`ctex`.

Do this as its own commit, before or after the standard revision — not mixed into it.

---

## 3. Per-repo status

Updated 2026-10-09. The first row is the standard; every other row is a target brought up
to it.

| Repo | State |
| --- | --- |
| **Introduction-to-Convex-Optimization** | ⬛ **THE STANDARD** — v1.1 done; commit titles cleaned; release notes written for v1.0 and v1.1 |
| **Introduction-to-Linux** | ✅ v3.2 done; commit titles cleaned; CHANGELOG deleted. Its four old release bodies still say "see CHANGELOG" and now point at a file that is gone — they need replacing with the notes already drafted |
| **Introduction-to-Compressed-Sensing** | ✅ v2.1 done, migrated from `ctexart`, 60 pages; commit titles cleaned; tag `v2.1` re-pointed at the real v2.1 commit; release body may still be a placeholder |
| **Retracing-the-Path-of-Linear-Algebra** | ✅ v1.1 done, migrated, new TikZ cover, 38 pages; commit titles cleaned; tag and Release not yet created |
| **LaTeX-Tutorial-Template** | ✅ created and pushed 2026-10-01 — the starter kit for new tutorials |
| **Introduction-to-Information-Theory** | ⬜ started 2026-10-07 from the template; Chapter 1 drafted. No `.git` yet, deferred until the body is written. First tutorial to use numbered figure captions and `\figref` references, which became the **house standard on 2026-10-09** (see §0.6). The four finished tutorials still ship `\captionsetup[figure]{labelformat=empty}` and should be updated as each is next touched |

**Two questions still unsettled**, both raised by the Compressed Sensing and Linear
Algebra migrations and left open on purpose:

- The body size dropped from the originals' `[12pt]` to `elegantbook`'s default **10pt**,
  because the migration copied the Convex options. Decide once whether 10pt is the house
  standard or the originals should keep 12pt.
- Heading `\textbf` stripping, the table-of-contents leading, and the Preface/Afterwords
  leading were all applied to Compressed Sensing and Linear Algebra but not to Convex or
  Linux. Decide whether they are part of the standard.

The traps met while migrating — heading levels, missed top-level sections, nested divider
blocks, leftover `\newpage`s, and the lost `\captionsetup` — are collected in **§2**.

---

## 4. Environment notes

- **Network:** `api.github.com` and git-over-SSH work. `github.com` HTTPS and
  `raw.githubusercontent.com` are **unreachable** in this environment — release assets
  cannot be downloaded here.
- **LaTeX Workshop (VS Code):** the default recipe must be `latexmk -xelatex`. A recipe
  using `latexmk -pdf` **silently** falls back to pdfLaTeX — no error, same page count,
  but the text encoding degrades from `Identity-H` to `Custom`. A bare `xelatex` recipe
  skips the extra passes and leaves cross-references stale.
- **`latexmk -c`** removes auxiliary files but keeps the PDF; **`latexmk -C`** removes
  everything including the PDF.

### Chinese text renders as blank by default

`elegantbook` loads `ctex` **only when `lang=cn`**, and every tutorial here uses
`lang=en`. So `ctex`/`xeCJK` is never loaded, `\setCJKmainfont` is undefined, and any
Chinese in the body **renders as nothing** — with no error and no warning. It just
disappears, and the surrounding sentence reads as if a word were missing.

Compressed Sensing and Linear Algebra both turned out to contain Chinese. Compressed
Sensing genuinely needed it (`压缩感知` in the Preface, a Chinese bibliography entry) and
required an explicit `\usepackage{xeCJK}` plus `\setCJKmainfont{Microsoft YaHei}`. Linear
Algebra's Chinese was all in preamble comments, so it needed nothing.

Do not assume either way. Check with perl, not grep:

```bash
perl -CSD -ne 'print "$ARGV:$.: $_" if /\p{Han}/' *.tex
```

A `[一-龥]` range **byte-matches** in this locale and reports every em-dash as Chinese. A
zero from a byte-range grep is a false zero; only `\p{Han}` is trustworthy.

### Backslashes through the shell

Backslashes do not survive this shell reliably. One-liners containing `\\`, `\{`, or
`$'\r'` fail **silently** and return a plausible-looking wrong answer. Observed in one
session: `grep -c $'\r'` reporting 0 on a CRLF file; `grep -E '...\{\\textbf\{...'`
matching every line; `sed -i` converting CRLF to LF and turning a 13-line diff into 2585;
`perl -pe 's/\\version.../'` doing nothing.

**Write the logic to a script file** (`Write` tool) and run `perl script.pl <in >out`.
Prefer the `Grep` tool over `grep` for patterns with escapes. Verify counts against an
independent measure.

### The tilde is not a tilde, and `pdftotext` cannot see it

In LaTeX source, `~` is an **active character** — a non-breaking space. Writing
`$(X, Y) ~ p(x, y)$` intending "is distributed as" produces `(X,Y) p(x,y)`: the tilde
**vanishes silently**, no error, no warning. The markup is `\sim`, and the same confusion
waits in any language that uses the symbol for asymptotic equivalence.

**Do not try to confirm it with `pdftotext`.** Math symbols are only partially
extractable, and `\sim` is one of the ones that is not: the correct `\sim` came out as
two blank spaces, which reads exactly like the broken `~`. The two states are
indistinguishable from the text layer. Render the page and look — this is the same trap
as the `\captionsetup` case in §0.6, in the opposite direction: there a real layout
change looked like an extraction artifact, here a correct symbol looked like a missing
one.

### Line endings

These repos use `core.autocrlf=true` and most sources are **CRLF** in the working tree.
Two consequences, both learned the hard way:

1. **Any script that splits on `\n` must normalise CRLF first.** `split /\n/` leaves a
   trailing `\r` on every line, so `$line eq '\newpage'` is never true and the script
   reports 0 matches. Normalise at the top, restore on output:

   ```perl
   my $crlf = ($t =~ /\r\n/) ? 1 : 0;
   $t =~ s/\r\n/\n/g;
   # ... work ...
   $t =~ s/\n/\r\n/g if $crlf;
   ```

2. **Never `cp` a script's output over the source without checking it is non-empty.**
   A Perl syntax error produces an empty file, and `cp` will happily blank the source.
   Guard every write:

   ```bash
   perl script.pl < src > /tmp/out && [ -s /tmp/out ] && cp /tmp/out src || echo "aborted"
   ```

**`cat -A` does not mark the CR** in this environment, and `grep -c $'\r'` lies. Only
`tr -dc '\r' < file | wc -c` is trustworthy.

**Line-end anchors fail on CRLF as well.** Searching for `^\newpage$` in a CRLF file
returns **nothing**, because the line really ends `\newpage\r\n` and `$` never reaches the
end of the line. That reads as a confident zero — "there is no leftover `\newpage`" — when
in fact there is one after every chapter. This is how the Linear Algebra leftover was
almost missed. The same is true of the `Grep` tool, whose `$` behaves identically.

Do not trust a zero from an anchored pattern in these repos. Match on the *start* of the
following construct instead, or normalise the file first and then search.
