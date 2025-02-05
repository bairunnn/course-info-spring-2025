# Guessing Game

Let's have some fun!

We're going to play a guessing game. I'm going to choose a word randomly from the [4,000 most common words](data/count_1w_4000.csv)[1] on the internet and you have to guess what word I chose. You only have a finite number of guesses, but:

- After you tell me your guess (and how common it is), I tell you whether it's the right word or not
- If it's not right, I tell you whether my word is more or less common than your guess
- If you want, you can use a calculator, computer, or any other tool

What is the maximum number of guesses you think you'll need to find my word?

---------

_You can probably find a solution online or with AI, but **don't** (it's no fun that way). If you don't already know the answer, try to work it out. We'll see where this is applicable in lecture 3._

----------

[1] The list of the most common words is derived from https://norvig.com/ngrams/; note that "word" is a loose term here -- really it's the most common [1-grams](https://en.wikipedia.org/wiki/N-gram), but it's close enough.