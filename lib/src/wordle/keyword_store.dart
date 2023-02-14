import 'keywords.dart';

abstract class KeyWordStore {
    Future<String?> tryRetrieveWord(DateTime currentTimeUtc);
    Future<DateTime> nextWordDateTime(DateTime currentTimeUtc);
}

class EmbeddedKeyWordStore extends KeyWordStore {
    EmbeddedKeyWordStore();

    @override
    Future<String?> tryRetrieveWord(DateTime currentTime) async {
        final currentTimeUtc = currentTime.toUtc();
        final startTime = DateTime.utc(currentTimeUtc.year, currentTimeUtc.month, currentTimeUtc.day);     
        final word = keyWordMap[startTime.toString()];
        return word == null ? null : decrypt(word);
    }

    @override
    Future<DateTime> nextWordDateTime(DateTime currentTime) async {
        final currentTimeUtc = currentTime.toUtc();
        final startTime = DateTime.utc(currentTimeUtc.year, currentTimeUtc.month, currentTimeUtc.day);
        return startTime.add(Duration(days: 1));
    }

    static String encrypt(String word) {
        return word
            .split('')
            .toList()
            .reversed
            .map((c) => String.fromCharCode(c.codeUnitAt(0) + 35))
            .join();
    }

    static String decrypt(String encrypted) {
        return encrypted
            .split('')
            .toList()
            .reversed
            .map((c) => String.fromCharCode(c.codeUnitAt(0) - 35))
            .join();
    }
}
