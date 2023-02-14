import 'package:collection/collection.dart';
import 'wordlist.dart';

abstract class Dictionary {
    Future<String?> tryValidateAndNormalizeWord(String word);
}

class EmbeddedResourceDictionary extends Dictionary {
    int wordLength;
    EmbeddedResourceDictionary(this.wordLength);
    @override
    Future<String?> tryValidateAndNormalizeWord(String word) async {
        var normalizedWord = word.trim().toUpperCase();
        if (normalizedWord.length != wordLength) {
            return null;
        }
        final index = binarySearch(wordList, normalizedWord);
        return index == -1 ? null : normalizedWord;
    }
}
