import 'package:wordle/wordle.dart';
import 'package:wordle/cli_wordle.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as Path;
import 'dart:convert';
import 'dart:io';
import 'package:uuid/uuid.dart';

void main() async {
  testState();
  testHistory();
  await testDictionary();
}

void testState() {
  group('State', () {
    test('New', () {
      var state = WordleState('HARDY', 6);
      state = WordleState.fromJson(state.toJson());
      expect(state.key, equals('HARDY'));
      expect(state.maxGuesses, equals(6));
      expect(state.guesses.length, equals(0));
      expect(state.remainingGuesses, equals(6));
      expect(state.availableLetters().length, equals(26));
      expect(state.availableLetters().every((l) => l.grade == Grade.unused), equals(true));
      expect(state.isSolved, equals(false));
    });
    test('Invalid guess #1 is correctly graded', () {
      var state = WordleState('HOARD', 6);
      state.addGuess('HARDY');
      state = WordleState.fromJson(state.toJson());
      expect(state.remainingGuesses, equals(5));
      expect(state.guesses.length, equals(1));
      expect(state.guesses[0][0].letter, equals('H'));
      expect(state.guesses[0][0].grade, equals(Grade.correct));
      expect(state.guesses[0][1].letter, equals('A'));
      expect(state.guesses[0][1].grade, equals(Grade.wrong_place));
      expect(state.guesses[0][2].letter, equals('R'));
      expect(state.guesses[0][2].grade, equals(Grade.wrong_place));
      expect(state.guesses[0][3].letter, equals('D'));
      expect(state.guesses[0][3].grade, equals(Grade.wrong_place));
      expect(state.guesses[0][4].letter, equals('Y'));
      expect(state.guesses[0][4].grade, equals(Grade.incorrect));
      expect(state.availableLetters().length, equals(26));
      expect(state.availableLetters().toList()[0], equals(GuessLetter('A', Grade.wrong_place)));
      expect(state.availableLetters().toList()[1], equals(GuessLetter('B', Grade.unused)));
      expect(state.availableLetters().toList()[3], equals(GuessLetter('D', Grade.wrong_place)));
      expect(state.availableLetters().toList()[24], equals(GuessLetter('Y', Grade.incorrect)));
      expect(state.isSolved, equals(false));
    });
    test('Invalid guess #2 is correctly graded', () {
      var state = WordleState('CHEEZ', 6);
      state.addGuess('KEESH');
      state = WordleState.fromJson(state.toJson());
      expect(state.remainingGuesses, equals(5));
      expect(state.guesses.length, equals(1));
      expect(state.guesses[0][0].letter, equals('K'));
      expect(state.guesses[0][0].grade, equals(Grade.incorrect));
      expect(state.guesses[0][1].letter, equals('E'));
      expect(state.guesses[0][1].grade, equals(Grade.wrong_place));
      expect(state.guesses[0][2].letter, equals('E'));
      expect(state.guesses[0][2].grade, equals(Grade.correct));
      expect(state.guesses[0][3].letter, equals('S'));
      expect(state.guesses[0][3].grade, equals(Grade.incorrect));
      expect(state.guesses[0][4].letter, equals('H'));
      expect(state.guesses[0][4].grade, equals(Grade.wrong_place));
      expect(state.isSolved, equals(false));
    });
    test('Invalid guess #3 is correctly graded', () {
      var state = WordleState('HAAAA', 6);
      state.addGuess('AAAAH');
      state = WordleState.fromJson(state.toJson());
      expect(state.remainingGuesses, equals(5));
      expect(state.guesses.length, equals(1));
      expect(state.guesses[0][0].letter, equals('A'));
      expect(state.guesses[0][0].grade, equals(Grade.wrong_place));
      expect(state.guesses[0][1].letter, equals('A'));
      expect(state.guesses[0][1].grade, equals(Grade.correct));
      expect(state.guesses[0][2].letter, equals('A'));
      expect(state.guesses[0][2].grade, equals(Grade.correct));
      expect(state.guesses[0][3].letter, equals('A'));
      expect(state.guesses[0][3].grade, equals(Grade.correct));
      expect(state.guesses[0][4].letter, equals('H'));
      expect(state.guesses[0][4].grade, equals(Grade.wrong_place));
      expect(state.isSolved, equals(false));
    });
    test('Remaining guesses is 0, retain guesses', () {
      var state = WordleState('HAAAA', 6);
      state.addGuess('AAAAH');
      state.addGuess('YODEL');
      state.addGuess('FEARS');
      state.addGuess('ONESY');
      state.addGuess('FENCY');
      state.addGuess('SUPER');
      state = WordleState.fromJson(state.toJson());
      expect(state.remainingGuesses, equals(0));
      expect(state.guesses.length, equals(6));
      expect(state.guesses[1][0].letter, equals('Y'));
      expect(state.guesses[1][0].grade, equals(Grade.incorrect));
      expect(state.guesses[1][1].letter, equals('O'));
      expect(state.guesses[1][1].grade, equals(Grade.incorrect));
      expect(state.guesses[1][2].letter, equals('D'));
      expect(state.guesses[1][2].grade, equals(Grade.incorrect));
      expect(state.guesses[1][3].letter, equals('E'));
      expect(state.guesses[1][3].grade, equals(Grade.incorrect));
      expect(state.guesses[1][4].letter, equals('L'));
      expect(state.guesses[1][4].grade, equals(Grade.incorrect));
      expect(state.availableLetters().toList()[0], equals(GuessLetter('A', Grade.correct)));
      expect(state.availableLetters().toList()[1], equals(GuessLetter('B', Grade.unused)));
      expect(state.availableLetters().toList()[2], equals(GuessLetter('C', Grade.incorrect)));
      expect(state.isSolved, equals(false));
    });
    test('Solved in 3', () {
      var state = WordleState('HAAAA', 6);
      state.addGuess('AAAAH');
      state.addGuess('YAHAA');
      state.addGuess('HAAAA');
      state = WordleState.fromJson(state.toJson());
      expect(state.remainingGuesses, equals(3));
      expect(state.guesses.length, equals(3));
      expect(state.guesses[2][0].letter, equals('H'));
      expect(state.guesses[2][0].grade, equals(Grade.correct));
      expect(state.guesses[2][1].letter, equals('A'));
      expect(state.guesses[2][1].grade, equals(Grade.correct));
      expect(state.guesses[2][2].letter, equals('A'));
      expect(state.guesses[2][2].grade, equals(Grade.correct));
      expect(state.guesses[2][3].letter, equals('A'));
      expect(state.guesses[2][3].grade, equals(Grade.correct));
      expect(state.guesses[2][4].letter, equals('A'));
      expect(state.guesses[2][4].grade, equals(Grade.correct));
      expect(state.availableLetters().toList()[0], equals(GuessLetter('A', Grade.correct)));
      expect(state.availableLetters().toList()[1], equals(GuessLetter('B', Grade.unused)));      
      expect(state.availableLetters().toList()[7], equals(GuessLetter('H', Grade.correct)));
      expect(state.availableLetters().toList()[24], equals(GuessLetter('Y', Grade.incorrect)));
      expect(state.isSolved, equals(true));
    });
  });
}

void testHistory() {
  group('History', () {
    final saveLoad = (History h) => History.fromJson(jsonDecode(jsonEncode(h.toJson())));
    test('New', () {
      var history = History();
      history = saveLoad(history);
      expect(history.lastWordDateTime, equals(DateTime.utc(2023, 1, 1)));
      expect(history.wins, equals(0));
      expect(history.played, equals(0));
      expect(history.currentStreak, equals(0));
      expect(history.maxStreak, equals(0));
      expect(history.getGuessDistribution(1), equals(0));
      expect(history.getGuessDistribution(3), equals(0));
      expect(history.getGuessDistribution(6), equals(0));
    });
    test('Record one win', () {
      var history = History();
      history = saveLoad(history);
      final dt = DateTime.now();
      history.recordGame(dt, true, 3);
      history = saveLoad(history);
      expect(history.lastWordDateTime, equals(dt));
      expect(history.wins, equals(1));
      expect(history.played, equals(1));
      expect(history.currentStreak, equals(1));
      expect(history.maxStreak, equals(1));
      expect(history.getGuessDistribution(1), equals(0));
      expect(history.getGuessDistribution(3), equals(1));
    });
    test('Record one fail', () {
      var history = History();
      history = saveLoad(history);
      final dt = DateTime.now();
      history.recordGame(dt, false, 6);
      history = saveLoad(history);
      expect(history.lastWordDateTime, equals(dt));
      expect(history.wins, equals(0));
      expect(history.played, equals(1));
      expect(history.currentStreak, equals(0));
      expect(history.maxStreak, equals(0));
      expect(history.getGuessDistribution(1), equals(0));
      expect(history.getGuessDistribution(3), equals(0));
      expect(history.getGuessDistribution(6), equals(0));
    });
    test('Record one fail, then win streak', () {
      var history = History();
      history = saveLoad(history);
      history.recordGame(DateTime.utc(2023,3,1), false, 6);
      history = saveLoad(history);
      history.recordGame(DateTime.utc(2023,3,2), true, 3);
      history = saveLoad(history);
      history.recordGame(DateTime.utc(2023,3,3), true, 4);
      history = saveLoad(history);
      history.recordGame(DateTime.utc(2023,3,4), true, 3);
      history = saveLoad(history);
      expect(history.lastWordDateTime, equals(DateTime.utc(2023,3,4)));
      expect(history.wins, equals(3));
      expect(history.played, equals(4));
      expect(history.currentStreak, equals(3));
      expect(history.maxStreak, equals(3));
      expect(history.getGuessDistribution(1), equals(0));
      expect(history.getGuessDistribution(3), equals(2));
      expect(history.getGuessDistribution(4), equals(1));
    });    
    test('Record win streak, then fail, then win', () {
      var history = History();
      history = saveLoad(history);
      history.recordGame(DateTime.utc(2023,3,1), true, 3);
      history = saveLoad(history);
      history.recordGame(DateTime.utc(2023,3,2), true, 4);
      history = saveLoad(history);
      history.recordGame(DateTime.utc(2023,3,3), true, 3);
      history = saveLoad(history);
      history.recordGame(DateTime.utc(2023,3,4), false, 6);
      history = saveLoad(history);
      history.recordGame(DateTime.utc(2023,3,5), true, 4);
      history = saveLoad(history);
      expect(history.lastWordDateTime, equals(DateTime.utc(2023,3,5)));
      expect(history.wins, equals(4));
      expect(history.played, equals(5));
      expect(history.currentStreak, equals(1));
      expect(history.maxStreak, equals(3));
      expect(history.getGuessDistribution(1), equals(0));
      expect(history.getGuessDistribution(3), equals(2));
      expect(history.getGuessDistribution(4), equals(2));
    });
  });
}

Future<void> testHistoryStore() async {
  group('History Store', () {
    test('Not found', () async {
      final path = createTempPath('wordle-history');
      final store = JsonFileHistoryStore(path);
      final history = await store.loadHistory();
      expect(history.lastWordDateTime, equals(DateTime.utc(2023, 1, 1)));
      expect(history.wins, equals(0));
      expect(history.played, equals(0));
      expect(history.currentStreak, equals(0));
      expect(history.maxStreak, equals(0));
      expect(history.getGuessDistribution(1), equals(0));
      expect(history.getGuessDistribution(3), equals(0));
      expect(history.getGuessDistribution(6), equals(0));
      await File(path).delete();    
    });
    test('Save and Load', () async {
      final path = createTempPath('wordle-history');
      final store = JsonFileHistoryStore(path);
      var history = await store.loadHistory();
      history.recordGame(DateTime.utc(2023,3,1), true, 3);
      history.recordGame(DateTime.utc(2023,3,2), true, 4);
      history.recordGame(DateTime.utc(2023,3,3), true, 3);
      history.recordGame(DateTime.utc(2023,3,4), false, 6);
      history.recordGame(DateTime.utc(2023,3,5), true, 4);
      final saveSuccess = await store.trySaveHistory(history);
      expect(saveSuccess, equals(true));
      history = await store.loadHistory();
      expect(history.lastWordDateTime, equals(DateTime.utc(2023,3,5)));
      expect(history.wins, equals(4));
      expect(history.played, equals(5));
      expect(history.currentStreak, equals(1));
      expect(history.maxStreak, equals(3));
      expect(history.getGuessDistribution(1), equals(0));
      expect(history.getGuessDistribution(3), equals(2));
      expect(history.getGuessDistribution(4), equals(2));
      await File(path).delete();
    });
  });
}

Future<void> testDictionary() async {
  group('Dictionary', () {
    test('Valid word', () async {
      final dictionary = EmbeddedResourceDictionary(5);
      final normalizedWord = await dictionary.tryValidateAndNormalizeWord('HARDY');
      expect(normalizedWord, equals('HARDY'));
    });
    test('Valid word needing normalization', () async {
      final dictionary = EmbeddedResourceDictionary(5);
      final normalizedWord = await dictionary.tryValidateAndNormalizeWord('   heaps  ');
      expect(normalizedWord, equals('HEAPS'));
    });
    test('Word wrong length', () async {
      final dictionary = EmbeddedResourceDictionary(5);
      final normalizedWord = await dictionary.tryValidateAndNormalizeWord('caterpillar');
      expect(normalizedWord, equals(null));
    });    
    test('Word not in dictionary', () async {
      final dictionary = EmbeddedResourceDictionary(5);
      final normalizedWord = await dictionary.tryValidateAndNormalizeWord('aaaaa');
      expect(normalizedWord, equals(null));
    });
  });
}

Future<void> testKeywords() async {
  group('Key Words', () {
    test('Word found', () async {
      final store = EmbeddedKeyWordStore();
      final word = await store.tryRetrieveWord(DateTime.utc(2023,2,13));
      expect(word, equals('AMEND'));
    });
    test('Next time', () async {
      final store = EmbeddedKeyWordStore();
      final nextTime = await store.nextWordDateTime(DateTime.utc(2023,2,14));
      expect(nextTime, equals(DateTime.utc(2023,2,15)));
    });
    test('Word does not exist', () async {
      final store = EmbeddedKeyWordStore();
      final word = await store.tryRetrieveWord(DateTime.utc(2023,2,12));
      expect(word, equals(null));
    });
    test('Obfuscation 1', () {
      final word = 'AMEND';
      final encryptedWord = EmbeddedKeyWordStore.encrypt(word);
      expect(word, isNot(equals(encryptedWord)));
      expect(EmbeddedKeyWordStore.decrypt(encryptedWord), equals(word));
    });
    test('Obfuscation 2', () {
      final word = 'YODEL';
      final encryptedWord = EmbeddedKeyWordStore.encrypt(word);
      expect(word, isNot(equals(encryptedWord)));
      expect(EmbeddedKeyWordStore.decrypt(encryptedWord), equals(word));
    });
  });
}

String createTempPath(String prefix) {
  final tempDirectoryPath = Directory.systemTemp.path;
  final id = Uuid().v4();
  return Path.join(tempDirectoryPath, '$prefix-$id');
}
