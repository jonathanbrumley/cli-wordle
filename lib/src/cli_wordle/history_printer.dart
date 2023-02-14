import "dart:math";
import '../../wordle.dart';

void printHistory(History history, int maxGuesses, void Function(String s) print) {
  final played = history.played;
  final winPercent =
      ((history.wins * 100) / max(history.played, 1))
      .floor();
  final currentStreak = history.currentStreak;
  final maxStreak = history.maxStreak;
  print('Played: $played');
  print('Win%: $winPercent');
  print('Current Streak: $currentStreak');
  print('Max Streak: $maxStreak');
  printGuessDistribution(history, maxGuesses, print);
}

void printGuessDistribution(History history, int maxGuesses, void Function(String s) print) {
  final guessDistribution = history.guessDistribution;
  print('Guess Distribution:');
  for (var i = 1; i <= maxGuesses; ++i) {
    int distribution = history.getGuessDistribution(i);
    print('\t$i:\t$distribution');
  }
}
