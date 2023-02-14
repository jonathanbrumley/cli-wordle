import 'dart:convert';

enum Grade {
    unused,
    correct,
    wrong_place,
    incorrect;

    String toJson() => name;
    static Grade fromJson(String json) => values.byName(json);
}


class GuessLetter {
    final String letter;
    Grade grade;
    GuessLetter(this.letter, this.grade);
    @override
    int get hashCode {
        return grade.hashCode + letter.hashCode << 2;
    }
    @override
    bool operator ==(Object other) {
        return other is GuessLetter && letter == other.letter && grade == other.grade;
    }
    GuessLetter.fromJson(Map<String, dynamic> json):
        letter = json['letter'] as String,
        grade = Grade.fromJson(json['grade']);

    Map toJson() => {
        'letter': letter,
        'grade': grade.toJson(),
    };
}

class WordleState {
    final String key;
    final int maxGuesses;
    final List<List<GuessLetter>> guesses;

    bool get isSolved {
        if (guesses.isEmpty) {
            return false;
        }
        final grades = guesses[guesses.length - 1];
        return grades.every((guess) => guess.grade == Grade.correct);  
    }
  
    int get remainingGuesses {
        return maxGuesses - guesses.length;
    }

    WordleState(this.key, this.maxGuesses): guesses = [] 
    {
        assert(key.toUpperCase() == key);
    }

    Map<String, dynamic> toJson() => {
        'key': key,
        'maxGuesses': maxGuesses,
        'guesses': jsonEncode(guesses),
    };

    WordleState.fromJson(Map<String, dynamic> json):
        key = json['key'] as String,
        maxGuesses = json['maxGuesses'] as int,
        guesses = decodeGuesses(json);
    
    static List<List<GuessLetter>> decodeGuesses(Map<String, dynamic> json) {
        final decodedList = jsonDecode(json['guesses']) as List;
        return decodedList.map(decodeGuess).toList();
    }

    static List<GuessLetter> decodeGuess(dynamic json) {
        final decodedGuess = json as List;
        return decodedGuess.map((s) => GuessLetter.fromJson(s)).toList();
    }
    
    @override
    int get hashCode {
        // Defining equals suggests defining hashCode too.  This is a poor implementation.
        return key.hashCode + maxGuesses.hashCode;
    }

    @override
    bool operator ==(Object other) {
        return other is WordleState 
        && key == other.key 
        && maxGuesses == other.maxGuesses 
        && guesses == other.guesses;
    }
    
    void addGuess(String guess) {
        assert(guess.length == key.length);
        assert(guess.toUpperCase() == guess);

        if (remainingGuesses > 0 && !isSolved) {
            final gradedGuess = _initializeGradedGuess(guess);
            final used = List<bool>.filled(key.length, false);
            _markCorrectLetters(guess, used, gradedGuess);
            _markWrongPlaceLetters(guess, used, gradedGuess);
            guesses.add(gradedGuess);
        }
    }
    
    List<GuessLetter> _initializeGradedGuess(String guess) {
        return List<GuessLetter>.generate(
            guess.length, 
            (i) => GuessLetter(guess[i], Grade.incorrect));
    }
    
    void _markCorrectLetters(String guess, List<bool> used, List<GuessLetter> gradedGuess) {
        for (var i = 0; i < guess.length; ++i) {
            if (!used[i] && key[i] == guess[i]) {
                gradedGuess[i].grade = Grade.correct;
                used[i] = true;
            }
        }    
    }
    
    void _markWrongPlaceLetters(String guess, List<bool> used, List<GuessLetter> gradedGuess) {
        for (var i = 0; i < guess.length; ++i) {
            if (gradedGuess[i].grade != Grade.correct) {
                for (var j = 0; j < key.length; ++j) {
                    if (!used[j] && key[j] == guess[i]) {
                        gradedGuess[i].grade = Grade.wrong_place;
                        used[j] = true;
                    }
                }
            }
        }
    }

    Iterable<GuessLetter> availableLetters() sync* {
        final firstLetterCode = 'A'.codeUnitAt(0);
        final lastLetterCode = 'Z'.codeUnitAt(0);
        for (var i = firstLetterCode; i <= lastLetterCode; ++i) {
            final letter = String.fromCharCode(i);
            yield GuessLetter(letter, _gradeAvailableLetter(letter));
        }
    }
  
    Grade _gradeAvailableLetter(String letter) {
        var grade = Grade.unused;
        for (var guess in guesses) {
            for (var guessLetter in guess) {
                if (letter == guessLetter.letter) {
                    grade = grade == Grade.correct ? grade : guessLetter.grade;
                }
            }
        }
        return grade;
    }
}
