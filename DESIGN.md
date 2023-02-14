# CLI Wordle Design

## Programming language: Dart

1. We want to build self-contained EXEs.  JDK 7 can do this, or C# with 
Visual Studio (Full) 2019.  But I suspect these tools will create pretty 
large EXEs.  Visual Studio is not free.  I’m not sure if Typescript or 
Python can do this without a runtime.
2. I have never tried Dart but I know it’s lightweight and want to learn 
it.  It looks like it can natively create console self-contained EXEs for 
multiple platforms.  I suspect a Dart self-contained EXE is small.

## Dictionary Implementation: Prebuild and Inhale

The program will need to check that input words are valid 5 letter English words.
In addition, the program will need to generate shared key words from this
dictionary.

There are ~153,000 five letter words in the English language.  I cannot find
a way to include resources in a Dart self-contained executable, but a quick and 
reasonable implementation is to prebuild a five letter data set as 
a const List of String by starting with the word list here: 
https://raw.githubusercontent.com/dwyl/english-words/master/words_alpha.txt
The total list size will be less than 2 MB, which seems reasonable if the Dart
compiler can handle it.

If this doesn't work, an alternative is to use the Oxford Dictionary API for 
word validation.

## Shared Key Word Dataset

Assuming we store only a few years of dates and times, we can pre-generate
obfuscated words/dates and include these words in the app, similar to the 
dictionary. This approach would require redistributing the app to change the 
words, but it's a simple approach for this small project.

An alternative would be to store words on a shared Google Drive which the app
can access using HTML GET.

The best alternative approach to prevent word revealing and tampering would be to hide
key words behind an API that only allows access on the day the word is first
available for guessing.

Words can be simply obfuscated by reversing and offsetting each character. 

We want to use a reduced word list for generating the key word dataset.  The
normal dataset has a lot of very obscure words, and for guess words we can use a common
English word list, such as the one at https://www.mit.edu/~ecprice/wordlist.10000.
Words should be reviewed and filtered to eliminate proper names and bad words.


## Storage Formats

History will be stored in a local user file.  The format can be JSON because
it's a simple way to store nested objects and lists with properties.  Also,
I want to practice using JSON in Dart.

The 5-letter Dictionary can just be stored concisely as line-delimited words for
inhale.

The key word set is just date times and obfuscated strings, so CSV is a concise 
format for inhale.

## JSON Serialization

The history store, and tests will use Json serialization for game state and history.
Dart has libraries to generate Json serialization but in this simple case 

## Code Structure

The dictionary, guess word storage, and score distribution have many 
possible implementations which could change with user feedback.  So we will 
abstract for this using interfaces (abstract classes in Dart).  
1. Dictionary (EmbeddedResourceDictionary)
2. KeyWordSet (EmbeddedKeyWordSet)
3. HistoryStore (JsonFileHistoryStore)

Other concrete classes:
1. GuessLetter - holds a letter and a grade for that letter
2. WordleState - this encapsulates the game state independent of interface 
   (CLI, Web page, etc.)
3. History - can be updated with game results and serialized to/from JSON
4. StreamWordle - inputs guesses and outputs responses according to design

Functions:
1. printState() - prints Wordle state
2. printHistory() - prints Wordle history
3. The main() method (in bin/wordle.dart) will handle the command 
line arguments, configure and run StreamIOWordle.
4. Additional main() functions in bin/gendictionary.dart and bin/genkeywords.dart
   for building application resources.

## File Naming / Package Organization

Classes will be placed in files and folders using dart conventions.
Files will contain one main class per file along with any helper classes and types.
Interfaces with just one default implementation will contain both. (These
can be partitioned if and when implementations ship in different packages.)

See: https://dart.dev/guides/libraries/create-library-packages

The lib organization will support future form factors other than CLI.
1. 'lib/src/wordle': Interfaces, stable game mechanics, default implementations 
   (e.g. WordleState, GuessLetter, History, HistoryStore) which should be reusable 
   for different form factors.
2. 'lib/src/cli_wordle': console specific implementation, including main function, 
   Stream-specific IO, GoogleDrive implementation.

## Error Handling ## 

In some systems components can communicate localized error strings to higher 
levels in the code through exception handling and/or side return values. The 
error strings will often contain guidance on how to fix the problem.  This 
system will use try methods and exception handling for unexpected file not 
found.  To keep this app simple, the StreamIO implementation will respond to 
exceptions with hardcoded output or default behavior (for instance, don't update
history if history is not found).

## No Logging or User Tracking ##

At this time the system will not use any sort of shared debug log or console 
logging.  This is a potential future feature. Similarly, user tracking could 
be added later, mainly in CLI-specific code.

## Comments and Clean Code ##

Code will roughly follow Robert Martin’s “Clean Code” conventions of short 
functions with self-explanatory names and implementations. Comments are used 
for anything obscure, including key words, e.g. // See ‘Google Drive API’

## Regression Tests ##

All tests need to be deterministic and reasonably quick.  All tests should be 
validated for failure against a stubbed implementation before implementation 
is coded to pass.

We won’t use mocks but will use some hardcoded file and Google Drive locations.
1. Game mechanics test
    * Test WordleState using various guess inputs and compare vs. expected JSON
    * Test a bad and good guess at position 1, 3, and 6.
    * Test for correct, incorrect, and wrong placement in positions 1, 4, 5
    * Test for duplicate letters in the guess and in the key, match behavior with 
        Wordle
2. History test
    * Test adding three results (1 success, 6 success, Fail), and compare
      vs expected JSON
3. HistoryStore test
    * Create new distribution, update with multiple attempts, store, retrieve, 
      query back statistics
4. EmbeddedResourceDictionary tests
    * check for valid words
    * check for invalid words
5. Keyword Store Test
    * Verify availability of words for specific dates
6. Stream Wordle Test
    * Tests will need to build StreamWordle with test input/output streams
    * Run a few input scenarios - enough to test all print paths

## Manual Tests

Manual smoke testing will verify all command line inputs against UX spec with 
actual Google Drive location.

## Tech Debt

1. Spacing may be inconsistent in some files (2 vs 4 character indents).
