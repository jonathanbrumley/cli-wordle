
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'wordle.dart';

void main(List<String> arguments) async {
    final lines = File('keywords.txt').openRead().transform(utf8.decoder).transform(LineSplitter());

    final List<String> filteredWords = [];
    await for (var line in lines) {
        if (line.length == 5) {
            filteredWords.add(line.trim().toUpperCase());
        }
    }

    final now = DateTime.now().toUtc();
    var dateUtc = DateTime.utc(now.year, now.month, now.day);
    print('const keyWordMap = {');
    for (var i = 0; i < 1000; ++i) {
        final randomIndex = Random().nextInt(filteredWords.length);
        final encryptedWord = EmbeddedKeyWordStore.encrypt(filteredWords[randomIndex]);
        print('\t"$dateUtc": "$encryptedWord",');
        dateUtc = dateUtc.add(Duration(days: 1));
    }
    print('};');
}
