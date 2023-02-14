
import 'dart:io';
import 'dart:convert';

void main(List<String> arguments) async {
    final lines = File('words.txt').openRead().transform(utf8.decoder).transform(LineSplitter());

    final List<String> filteredWords = [];
    await for (var line in lines) {
        if (line.length == 5) {
            filteredWords.add(line.trim().toUpperCase());
        }
    }
    filteredWords.sort();
    print('const wordList = [');
    for (var word in filteredWords) {
        print('\t"$word",');
    }
    print('];');
}
