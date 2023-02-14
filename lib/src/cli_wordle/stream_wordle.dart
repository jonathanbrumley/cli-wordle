import 'dart:io';
import 'dart:convert';
import 'package:wordle/wordle.dart';
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
        printState(state, print);
        print('');
        _printPrompt();
        await for (var line in lines) {

            print('');
            var word = await dictionary.tryValidateAndNormalizeWord(line);
            if (word == null) {
                print('No five letter English word matches "$line".');
            } else {
                state.addGuess(word);
                printState(state, print);
                print('');
            }
            if (state.isSolved || state.remainingGuesses == 0) {
                break;
            }
            _printPrompt();
        }
        await tryUpdateHistory();
    }

    Future<void> tryUpdateHistory() async {
        final history = await historyStore.loadHistory();
        history.recordGame(DateTime.now(), state.isSolved, state.guesses.length);
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



