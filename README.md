<div align="center">

# LaTeX Tutorial Template

Everything needed to start a new tutorial.

</div>

---

Copy this folder, rename four things, and start writing.

## 1. Copy and rename

```bash
cp -r LaTeX-Tutorial-Template "My-New-Tutorial"
cd "My-New-Tutorial"
```

Then rename the source file to your title. The name has to match exactly, because
`.latexmkrc` and `.gitignore` both refer to it:

| Now | Becomes |
| --- | --- |
| `tutorial.tex` | `<Your Title>.tex` |
| `README-template.md` | `README.md` |
| `cover.tex` | stays `cover.tex` |

## 2. Point the config files at the new name

Open `.latexmkrc` and `.gitignore` and replace the placeholder in each:

```
.latexmkrc :  @default_files = ("<Your Title>.tex");
.gitignore :  <Your Title>.pdf
```

**Never use `*.pdf` in `.gitignore`.** `cover.pdf` is a source file and has to stay in the
repository. Only the built book goes in, by its exact name.

## 3. Fill in the title page

The top of `<Your Title>.tex`:

```latex
\title{...}
\author{...}          % usually the GitHub name, Oct0pu5
\date{...}            % release or revision date
\version{1.0}
\extrainfo{``<a quotation, printed at the foot of the title page>''}
```

## 4. Draw the cover

`cover.tex` is a TikZ drawing that compiles on its own. The skeleton there is an empty
canvas with a frame and coordinate axes; put something in the middle that represents your
subject.

The three covers that exist are worth looking at first:

| Tutorial | Cover |
| --- | --- |
| Convex Optimization | contour ellipses with two convergence paths, labelled GD and FISTA |
| Compressed Sensing | the measurement equation Y = ΦΨᵀX as a diagram |
| Linear Algebra | a grid sheared by a matrix, with the standard basis and the columns of A |

```bash
xelatex cover.tex      # produces cover.pdf
```

Keep the aspect ratio near 1.45. The title page scales the image to the full page width, so
a much taller or wider drawing will not fit with the title below it.

## 5. Write the README

`README-template.md` has the structure filled in, with guidance comments that do not
render. Rename it to `README.md`, then delete the comments as you go.

The section worth real effort is **Contents**. Give every chapter three to five lines of
honest description. It is what a reader uses to decide whether to read on, and the easiest
section to write badly.

## 6. Build

```bash
latexmk
```

One command. It picks XeLaTeX and runs as many passes as the cross-references need.

A **full** TeX Live installation is required, not a minimal one, because `elegantbook`
loads `ctex` and `fontspec`.

---

## What is in here

| File | Purpose |
| --- | --- |
| `tutorial.tex` | the document skeleton: preface, one chapter with its overview, afterwords |
| `cover.tex` | the cover drawing, compiles standalone |
| `README-template.md` | README template with guidance, renamed to `README.md` when you start |
| `.latexmkrc` | makes a bare `latexmk` build correctly |
| `.gitignore` | the twelve build artifacts, plus the built PDF |
| `elegantbook.cls` | the document class. **It must travel with the repository** — it is not installed on the system |
| `CLAUDE.md` | the revision guide, for working on an existing tutorial rather than a new one |
| `LICENSE` | CC BY-SA 4.0 |

---

## Revising an existing tutorial

The body prose is written by hand. `CLAUDE.md` is for working on what is already there:
restructuring, copyediting, and bringing a document up to the standard.

Copy it into the repository you are revising:

```bash
cp CLAUDE.md "/path/to/Some-Tutorial/CLAUDE.md"
```

It records the standard every tutorial conforms to, the ten-step revision procedure, how to
measure whether new prose matches the author's voice, and every trap the migrations have hit
so far — the lost `\captionsetup`, the missed `\paragraph` level, the leftover `\newpage`
after each chapter, the Chinese that renders as blank. With it sitting in the repository,
those rules load automatically and do not have to be restated.

---

## License

Released under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/). See
[LICENSE](LICENSE).
