# Advent Of Code

* Generate `solutions` with structure conventions
  * Automatically downloads `questions` from AOC website
* Implement `programs` to solve each `part` of a problem.
* Run `programs` againts `questions` to get `results` for each `part`
* Test `results` of predefined `examples` to validate `answers`
* [TODO] Submit `answers` to AOC website

### Setup

#### Set your name

Generators need a name to keep everyone's solutions separate.  They will have
a format like `solution-files-$AOC_USERNAME` when you use generators.

* Copy `_setup.overrides-example` to `_setup.overrides`
* Update `AOC_USERNAME` to whatever name you like

#### Set your cookie

This will allow downloading your personalized question input into your
`question-files` folder.

* Log into your AOC account (I use my personal github)
* Right click on webpage, inspect
* Click on network tab
* Look for Request header called `cookie`
* Edit `_setup.overrides`
* Update `AOC_COOKIE` with value

Can we make this a bookmarklet?

### Structure

Problems have somewhat consistent structure, so we have generators that
 stub out solution folders for you.

## Code Generators

Generators are called with `<day>` and `<year>` as arguments.

```
sh rust-generate.sh 1 2019
sh racket-generate.sh 5 2020
```

Generated solutions have standard conventions.  These are mostly just to
 ensure that you can run and test against question/result/answer files
 without a lot of effort.

| File | From | Use |
| ---- | ---- | --- |
| Makefile | lang-files | Common build/run activities.  Calls program-test.sh. |
| example.question | example-files | Example files manually created to test part of the problem. |
| example.question.example.answer | example-files | Answer file to verify your program is working as intended. |
| official.question | question-files | Question downloaded from the website.  Unique to your account. |
| program-run.sh | lang-files | Language specific way to run your program. |
| program-test.sh | lang-files | Controls how programs are run and tested against answer files.  Intended be langauge inspecific.  This is probably the easiest place to customize problem specific idiosyncrycies. |
| program.\*
src/program.\* | lang-files | Source files for your program. |


## Makefile conventions

So far, all generators will build and run your problem against the official
 questions, if you run `make`.  These should take care of building if required.

```
make
```

This will run the `official.question` against the `part1` and `part2` parts.

If anyone has created `example.question` file for you to use, then that will also
 available as a target.

```
make example
```

This will run `example.question` against the `example` part.

Under the hood, the scripts just look for files with names like `some_target.question`
 and run it against your program.
 
The scripts write your program's stdout to a `result` file.
 
If there are matching `answer` files, then the scripts will diff them and report of 
 any differences.

## Example files

Most of the problems have simple examples to help you understand what they are
 asking you to do.  These examples can be put into a file and saved in the
 example-files folders.  Generators will sync examples into solutions.  This
 may not help you, but it will help everyone after you.

