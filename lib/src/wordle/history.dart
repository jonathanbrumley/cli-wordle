import 'dart:convert';
import 'dart:math';
import 'state.dart';

final neverPlayedDate = DateTime.utc(2023, 1, 1);

class History {
    final List<String> wordsPlayed;
    int wins;
    int played;
    int currentStreak;
    int maxStreak;
    final List<int?> guessDistribution;

    History():
        wins = 0,
        played = 0,
        maxStreak = 0,
        currentStreak = 0,
        guessDistribution = [],
        wordsPlayed = [];
  
    History.fromJson(Map<String, dynamic> json):
        // Defend against file containing wild/invalid JSON
        wordsPlayed = decodeWordsPlayed(json),
        wins = json['wins'] as int? ?? 0,
        played = json['played'] as int? ?? 0,
        currentStreak = json['currentStreak'] as int? ?? 0,
        maxStreak = json['maxStreak'] as int? ?? 0,
        guessDistribution = decodeDistribution(json);

    static List<String> decodeWordsPlayed(Map<String, dynamic> json) {
        final decodedList = json['wordsPlayed'] ?? [];
        return decodedList is Iterable
            ? decodedList.map((i) => i is String ? i : '').toList()
            : [];
    }

    static List<int?> decodeDistribution(Map<String, dynamic> json) {
        final decodedList = json['guessDistribution'] ?? [];
        return decodedList is Iterable
            ? decodedList.map((i) => i is int ? i : 0).toList()
            : [];
    }

    Map<String, dynamic> toJson() => {
        'wordsPlayed': wordsPlayed.toList(),
        'wins': wins,
        'played': played,
        'currentStreak': currentStreak,
        'maxStreak': maxStreak,
        'guessDistribution': guessDistribution.map((x) => x ?? 0).toList(),
    };

    int getGuessDistribution(int guesses) {
        assert(guesses > 0);
        return guessDistribution.length < guesses ? 0 : guessDistribution[guesses-1] ?? 0;
    }

    void recordGame(WordleState state) {
        wordsPlayed.add(state.key);
        ++played;
        wins += state.isSolved ? 1 : 0;
        currentStreak = state.isSolved ? currentStreak + 1 : 0;
        maxStreak = max(currentStreak, maxStreak);
        if (state.isSolved) {
            addToGuessDistribution(state.guesses.length);
        }
    }

    void addToGuessDistribution(int numGuesses) {
        if (guessDistribution.length < numGuesses) {
            guessDistribution.addAll(
                List<int>.generate(numGuesses - guessDistribution.length, (i) => 0));
        }
        guessDistribution[numGuesses - 1] = (guessDistribution[numGuesses - 1] ?? 0) + 1;
    }
}
