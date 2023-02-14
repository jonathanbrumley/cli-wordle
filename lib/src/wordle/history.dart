import 'dart:convert';
import 'dart:math';

final neverPlayedDate = DateTime.utc(2023, 1, 1);

class History {
    DateTime lastWordDateTime;
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
        lastWordDateTime = neverPlayedDate;
  
    History.fromJson(Map<String, dynamic> json):
        // Defend against file containing wild/invalid JSON
        lastWordDateTime = DateTime.tryParse(json['lastWordDateTime'] as String? ?? '') ?? neverPlayedDate,
        wins = json['wins'] as int? ?? 0,
        played = json['played'] as int? ?? 0,
        currentStreak = json['currentStreak'] as int? ?? 0,
        maxStreak = json['maxStreak'] as int? ?? 0,
        guessDistribution = decodeDistribution(json);

    static List<int?> decodeDistribution(Map<String, dynamic> json) {
        final decodedList = json['guessDistribution'] ?? [];
        return decodedList is Iterable
            ? decodedList.map((i) => i is int ? i : 0).toList()
            : [];
    }

    Map<String, dynamic> toJson() => {
        'lastWordDateTime': lastWordDateTime.toString(),
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

    void recordGame(DateTime keyWordDate, bool isWin, int numGuesses) {
        lastWordDateTime = keyWordDate;
        ++played;
        wins += isWin ? 1 : 0;
        currentStreak = isWin ? currentStreak + 1 : 0;
        maxStreak = max(currentStreak, maxStreak);
        if (isWin) {
            addToGuessDistribution(numGuesses);
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
