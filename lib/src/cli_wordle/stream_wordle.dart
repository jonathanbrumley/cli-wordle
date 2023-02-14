import 'dart:io';
import 'dart:convert';
import '../../wordle.dart';
import 'state_printer.dart';
import 'history_printer.dart';

class StreamWordle {
    WordleState state;
    Dictionary dictionary;
    HistoryStore historyStore;
    Stream<List<int>> input;
    IOSink output;

    StreamWordle(
        this.state, this.dictionary, this.historyStore, this.input, this.output
    );

    void print(String s) => output.write('$s\n');

    Future<void> run() async {
        final lines = stdin.transform(utf8.decoder).transform(const LineSplitter());
        print('');
        final history = await historyStore.loadHistory();
        if (!_tryFindWordInHistory(history)) {
            printState(state, print);
            print('');
            _printPrompt();
            await for (var line in lines) {
                if (await _tryCompleteWithGuess(line)) {
                    break;
                }
                _printPrompt();
            }
            await _tryUpdateHistory(history);
        }
    }

    bool _tryFindWordInHistory(History history) {
        bool found = history.wordsPlayed.contains(state.key);
        if (found) {
            print('You have already played this Wordle.');
            print('');
            printHistory(history, state.maxGuesses, print);
            print('');
        }
        return found;
    }

    Future<bool> _tryCompleteWithGuess(String guess) async {
        print('');
        var word = await dictionary.tryValidateAndNormalizeWord(guess);
        if (word == null) {
            print('No five letter English word matches "$guess".');
        } else {
            state.addGuess(word);
            printState(state, print);
            print('');
        }
        return (state.isSolved || state.remainingGuesses == 0);
    }

    Future<void> _tryUpdateHistory(History history) async {
        history.recordGame(state);
        bool isSaved = await historyStore.trySaveHistory(history);
        if (isSaved) {
            printHistory(history, state.maxGuesses, print);
            print('');
        } else {
            print('Failed to update game history.');
        }
    }

    void _printPrompt() {
        print('Please guess any five letter English word:');
    }
}



