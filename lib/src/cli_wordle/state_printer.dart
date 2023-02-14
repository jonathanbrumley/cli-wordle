import '../../wordle.dart';

void printState(WordleState state, void Function(String s) print) {
  _printGuesses(state, print);
  print('');
  if (state.isSolved) {
    _printSuccessfulAttempts(state, print);
  } else if (state.remainingGuesses == 0) {
    _printFailedAttempt(state, print);    
  } else {
    _printRemainingGuesses(state, print);
    _printAvailableLetters(state, print);
  }
}

String _colorLetter(GuessLetter guessLetter) {
  // see https://en.wikipedia.org/wiki/ANSI_escape_code
  const brightGreen = '\x1B[92m';
  const brightYellow = '\x1B[93m';
  const red = '\x1B[31m';
  const brightWhite = '\x1B[97m';
  const reset = '\x1B[0m';

  final letter = guessLetter.letter;
  switch (guessLetter.grade) {
    case Grade.correct: return '$brightGreen$letter$reset';
    case Grade.wrong_place: return '$brightYellow$letter$reset';
    case Grade.incorrect: return '$red$letter$reset';
    case Grade.unused: return '$brightWhite$letter$reset';
  }
}

void _printGuesses(WordleState state, void Function(String s) print) {
  final guesses = state.guesses;
  for (var i = 0; i < state.maxGuesses; ++i) {
    final guessNumber = i + 1;
    final guessDisplay = guesses.length > i
      ? guesses[i].map((g) => _colorLetter(g)).join(' ')
      : List<String>.filled(state.key.length, '_').join(' ');
    print('Guess $guessNumber:\t$guessDisplay');
  }  
}

void _printSuccessfulAttempts(WordleState state, void Function(String s) print) {
  final key = state.key;
  final numAttempts = state.guesses.length;
  final attemptOrAttempts = numAttempts == 1 ? 'attempt' : 'attempts';
  print('You guessed "$key" in $numAttempts $attemptOrAttempts!');  
}

void _printFailedAttempt(WordleState state, void Function(String s) print) {
  final key = state.key;
  final numAttempts = state.guesses.length;
  print('You failed to guess "$key" in $numAttempts attempts.');
}

void _printRemainingGuesses(WordleState state, void Function(String s) print) {
  final remainingGuesses = state.remainingGuesses;
  final guessOrGuesses = remainingGuesses == 1 ? 'guess' : 'guesses';
  print('You have $remainingGuesses $guessOrGuesses left.');
}

void _printAvailableLetters(WordleState state, void Function(String s) print) {
  final coloredAvailableLetters = state.availableLetters().map((g) => _colorLetter(g)).join(' ');
  print('Available letters: $coloredAvailableLetters');
}
