import 'package:wordle/cli_wordle.dart';
import 'package:wordle/wordle.dart';
import 'dart:io';

void main(List<String> arguments) async {
  final wordleTime = _getAndPrintWordleTime(arguments);
  final keyWordStore = EmbeddedKeyWordStore();
  final keyWord = await keyWordStore.tryRetrieveWord(wordleTime);
  if (keyWord != null) {
    final streamWordle = _buildStreamWordle(keyWord);
    await streamWordle.run();
  }
  await _printTimeToNextWordle(keyWordStore);
}

DateTime _getAndPrintWordleTime(List<String> arguments) {
  var date = 
    arguments.length > 1 && arguments[0] == 'test'
    ? DateTime.tryParse(arguments[1]) ?? DateTime.now()
    : DateTime.now();
  date = date.toUtc(); 
  print('');
  print('Wordle for ${date.toString().substring(0, 10)}');
  return date;
}

StreamWordle _buildStreamWordle(String keyWord) {
  final state = WordleState(keyWord, 6);
  final dictionary = EmbeddedResourceDictionary(5);
  final historyStore = JsonFileHistoryStore('history.json');
  final wordle = StreamWordle(state, dictionary, historyStore, stdin, stdout);
  return wordle;
}

Future<void> _printTimeToNextWordle(KeyWordStore keyWordStore) async {
  final nowTime = DateTime.now();
  final nextWordleTime = await keyWordStore.nextWordDateTime(nowTime);
  var seconds = nextWordleTime.difference(nowTime).inSeconds;
  final hours = (seconds / (60 * 60)).floor();
  seconds -= hours * 60 * 60;
  final minutes = (seconds / 60).floor();
  seconds -= minutes * 60;
  final hoursPad = hours.toString().padLeft(2, '0');
  final minutesPad = minutes.toString().padLeft(2, '0');
  final secondsPad = seconds.toString().padLeft(2, '0');
  print('Next Wordle in $hoursPad:$minutesPad:$secondsPad ...');
  print('');
}