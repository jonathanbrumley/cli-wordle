# CLI Wordle Version 1.0

written by Jonathan Brumley

## Build Setup

You will need to Install the Dart SDK.  Try this link.
https://dart.dev/tutorials/server/get-started
This project was tested with dart 2.19.2 on Intel MacOS.

Red/Green/Yellow colors will show best on a console with black background.

## Run

Type 'dart run lib/cli_wordle.dart' to run a development version.

## Run Tests

1. Type 'dart test' to run all tests. 
2. Type 'dart run lib/cli_wordle.dart test YYYY-MM-DD' to test behavior on a specific 
future date. (Replace YYYY-MM-DD with an actual date, such as 2023-02-17).

## Build

Type 'dart compile exe lib/cli_wordle.dart -o wordle' to build a self-contained console exe.
Then type './wordle' to run.

## Usage

See REQUIREMENTS.md

## Other

See REQUIREMENTS.md for functionality definition and decisions.
See DESIGN.md for design definition and decisions.
See words.txt for valid words checked by the word dictionary.
See keywords.txt for words which may be wordle key words.

## Known Issues

1. When testing, the program will fail if you specify a date too far in the future or before 2023-02-13.