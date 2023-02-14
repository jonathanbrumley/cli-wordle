import 'history.dart';
import 'dart:convert';
import 'dart:io';

abstract class HistoryStore {
    Future<History> loadHistory();
    Future<bool> trySaveHistory(History history);
}

class JsonFileHistoryStore extends HistoryStore {
    String path;
    JsonFileHistoryStore(this.path);

    @override
    Future<History> loadHistory() async {
        try {
            final historyJson = await File(path).readAsString();
            return History.fromJson(jsonDecode(historyJson));
        } catch (e) {
            return History();
        }
    }

    @override
    Future<bool> trySaveHistory(History history) async {
        try {
            final historyJson = jsonEncode(history.toJson());
            await File(path).writeAsString(historyJson);
            return true;
        } catch (e) {
            return false;
        }
    }
}