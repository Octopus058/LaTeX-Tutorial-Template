<!--
README template. Every comment like this one is guidance and will not render.
Delete them as you fill the file in.

Three things before you start:

  1. Write one line per paragraph. Do not wrap at 80 columns. Wrapping is harmless in a
     markdown file, but release bodies on GitHub are rendered in comment mode, where a
     single newline becomes a hard line break. Text written for this file cannot be pasted
     into a Release without being unwrapped first.

  2. Keep the sections in this order. All three finished tutorials use the same shape, and
     readers of one will recognise the others.

  3. Contents is where the work is. Give each chapter three to five real lines.
-->

<div align="center">

# Title of the Tutorial

One sentence: what this is, who it is for, and how far it goes.

</div>

---

## About

<!--
Two or three paragraphs.

  Paragraph 1: what the tutorial is, and the order it goes in.
  Paragraph 2: whose course or book it follows, and what it adds.
  Paragraph 3: what it optimises for, intuition or rigour.

Compare the finished ones: Convex Optimization goes "from the geometry of convex sets to
the algorithms people actually run"; Compressed Sensing goes "from signal transforms to
sparse recovery"; Linear Algebra says it follows Strang's MIT course.
-->

This tutorial ... It starts from ... and works up to ...

It mainly follows ... , and adds ... beyond that.

<!-- If the Preface recommends anything to read or watch alongside the text, say so here. -->

## Who this is for

<!--
Prerequisites, and what is not required. One line saying "no prior exposure is assumed"
lowers the barrier a lot.
-->

You should be comfortable with ... That is the only hard prerequisite. No prior exposure
to ... is assumed.

## Contents

<!--
Three to five lines per chapter. Say what the chapter covers and why it sits where it
does. Do not just list the section headings.

This is the section a reader uses to decide whether to keep reading, and the one most
often written badly.
-->

### 1. Chapter title

<!-- Three to five lines: what it covers, and where it sits in the argument. -->

### 2. Chapter title

### 3. Chapter title

### Afterwords

<!-- If the afterword is just closing thoughts, one line is enough. -->

Closing thoughts.

## What this tutorial does not cover

<!--
Draw the boundary yourself. Three entries is about right.

This section buys trust: a reader who knows what is missing will not go looking for it
here, and will not be disappointed when it is not here.
-->

- **Topic not covered** — ...
- **Topic not covered** — ...
- **Topic not covered** — ...

## Building the PDF

<!--
Three short paragraphs: requirements, command, cleanup. Do not put the page count here;
it changes.
-->

You need a TeX distribution with XeLaTeX. A **full** TeX Live installation is required
rather than a minimal one. The document class is bundled in this repository, so there is
nothing extra to install.

```bash
latexmk
```

A `.latexmkrc` is included, so `latexmk` selects XeLaTeX automatically and runs as many
passes as the cross-references need.

```bash
latexmk -c    # remove auxiliary files, keep the PDF
latexmk -C    # remove everything, including the PDF
```

The output is `Title of the Tutorial.pdf`.

<!--
Optional: a Repository layout section. Linear Algebra's README dropped it; Convex
Optimization and Compressed Sensing kept it. Either is fine.
-->

## Repository layout

```
Title of the Tutorial.tex   the tutorial itself
cover.tex, cover.pdf        the cover drawing and its render
elegantbook.cls             document class
assets/                     figures used in the text
.latexmkrc, .gitignore      build configuration
```

## Acknowledgements

<!--
Thanks to a course lecturer or a textbook author. Delete the section if there is nobody
to thank.
-->

## License

This tutorial is released under
[CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/). See [LICENSE](LICENSE).
