# CLI Wordle Requirements

## Application Functionality

Application functionality will roughly match the Web version of Wordle, with 
additional functionality available for administration.  See the following Console 
UX design for specifics.

## Console UX Design

This design adapts standard Wordle to console output using colors.  Please
see color coding to the right. This design may need future adjustment for 
color-blind users.  

### 1. On Start

This is the response when Wordle is started with no options and 
a new word is available.

	Wordle for 2023-02-10

	Guess 1:	_ _ _ _ _
	Guess 2:	_ _ _ _ _
	Guess 3:	_ _ _ _ _
	Guess 4:	_ _ _ _ _
	Guess 5:	_ _ _ _ _
	Guess 6:	_ _ _ _ _

	You have 6 guesses left.
	Available letters: A B C D E F G H I J K L M N O P Q R S T U V W X Y Z

	Please guess any five letter English word:

### 2: After a Guess

Guess letters are uppercased and displayed in GREEN for correct letters, 
YELLOW for wrong placement, RED for incorrect.  In the following
example the key word is 'HOARD'.  

Similarly, the color of available letters defaults to WHITE but if the
letter has been guessed, the letter color will match the guess color, 
preferring GREEN over YELLOW if the letter shows in multiple places/guesses.

	You have 6 guesses left.
	Available letters: A B C D E F G H I J K L M N O P Q R S T U V W X Y Z

	Please guess any five letter English word:
	Clear

	Guess 1:	C L E A R		# RED RED RED YELLOW YELLOW
	Guess 2:	_ _ _ _ _           
	Guess 3:	_ _ _ _ _
	Guess 4:	_ _ _ _ _
	Guess 5:	_ _ _ _ _
	Guess 6:	_ _ _ _ _

	You have 5 guesses left.
	Available letters: A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
		
	Please guess any five letter English word:
	adore

	Guess 1:	C L E A R		# RED RED RED YELLOW YELLOW
	Guess 2:	A D O R E		# YELLOW YELLOW YELLOW GREEN RED
	Guess 3:	_ _ _ _ _
	Guess 4:	_ _ _ _ _
	Guess 5:	_ _ _ _ _
	Guess 6:	_ _ _ _ _

	You have 4 guesses left.
	Available letters: A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
			
	Please guess any five letter English word:

### 3. On Match

A full match will display per-user score distribution and time until next play. 

	You have 3 guesses left.
	Available letters: A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
			
	Please guess any five letter English word:
	Hoard

	Guess 1:	C L E A R		# RED RED RED YELLOW YELLOW
	Guess 2:	A D O R E		# YELLOW YELLOW YELLOW GREEN RED
	Guess 3:	R O A D S		# YELLOW GREEN GREEN YELLOW RED
	Guess 4:	H O A R D		# GREEN GREEN GREEN GREEN GREEN
	Guess 5:	_ _ _ _ _
	Guess 6:	_ _ _ _ _

	You guessed "HOARD" in 4 attempts!

	Played: 1
	Win%: 100
	Current Streak: 1
	Max Streak: 1
	Guess Distribution:
		1:	0
		2:	0
		3:	0
		4:	1
		5:	0
		6:	0

	Next Wordle in 11:16:42 ...

### 4. On Maximum Attempts

	You have 1 guess left.
	Available letters: A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
			
	Please guess any 5 letter English word:
	roads

	Guess 1:	C L E A R           # RED RED RED YELLOW YELLOW
	Guess 2:	A D O R E           # YELLOW YELLOW YELLOW GREEN RED
	Guess 3:	R O A D S           # YELLOW GREEN GREEN YELLOW RED
	Guess 4:	R O A D S           # YELLOW GREEN GREEN YELLOW RED
	Guess 5:	R O A D S           # YELLOW GREEN GREEN YELLOW RED
	Guess 6:	R O A D S           # YELLOW GREEN GREEN YELLOW RED

	You failed to guess "HOARD" in 6 attempts.

	Played: 1
	Win%: 0
	Current Streak: 0
	Max Streak: 0
	Guess Distribution:
		1:	0
		2:	0
		3:	0
		4:	0
		5:	0
		6:	0

	Next Wordle in 11:16:42 ...

### 5. On an Invalid Word

An invalid word (not a recognized five character English word) does not consume a guess.

	You have 4 guesses left.
	Available letters: A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
		
	Please guess any five letter English word:
	buttr

	No five letter English word matches "buttr".

	Guess 1:	C L E A R           # RED RED RED YELLOW YELLOW
	Guess 2:	A D O R E           # YELLOW YELLOW YELLOW GREEN RED
	Guess 3:	_ _ _ _ _
	Guess 4:	_ _ _ _ _
	Guess 5:	_ _ _ _ _
	Guess 6:	_ _ _ _ _

	You have 4 guesses left.
	Available letters: A B C D E F G H I J K L M N O P Q R S T U V W X Y Z

	Please guess any five letter English word:


### 6. On Attempting to Play too Soon

The game records the date/time of the last word played and you cannot play until the next word is available.

	> wordle
	Next Wordle in: 02:13:45 >
	Next Wordle in 11:16:42 ...
	Use 'wordle random' for a random practice word.

	Played: 1
	Win%: 0
	Current Streak: 0
	Max Streak: 0
	Guess Distribution:
		1:	0
		2:	0
		3:	0
		4:	0
		5:	0
		6:	0


### 7. Administration: Key Word Generation

An administrator can use included utilities to update the dictionary and generate obfuscated key words 
starting from today's date. 

## Attributes / Constraints / Preferences / Random Requirements

1. Duplicated Letters - if the guess or key word has duplicated letters, the behavior should be the same as normal Wordle.  If the guess has duplicates and the key word has only one instance, then the guess will get only one match, in the best position for that match.  From the internet: 

> “For example, if you guess 'lever' and the answer is 'eaten,' the first E in 'lever' will turn yellow and the second one will turn green. The first one is in the word but in the wrong spot, and the second one is in the correct spot. The other letters will turn gray.  Keep in mind that Wordle tells you when a letter is not duplicated, too. If you use two of the same letter in a word, and only one of them turns yellow or green, then there is only one copy of that letter in the correct Wordle answer."
2. Shared Key Words - All users try to guess the same words.  For the first release, words will be obfuscated and compiled compiled into the self-contained app.
3. Per-User Distribution - User’s distribution will be stored on the local device and associated with the user account.
4. Dictionary - 5 digit words can be generated from any reasonably complete American English dataset
5. Cross Platform - CLI Wordle should be a cross-platform codebase but we will initially deploy and test on 
one platform (Intel-based MacOS)
6. Self-Contained Packaging - small self-contained packaging (EXE file) with no runtime to install, prefer < 2 MB size for easy distribution
7. Responsive - CLI-Wordle should start quickly (< 1 second) and responses should be near instantaneous.

## Future Features (not included in MVP release)
1. Testing and EXEs for more platforms. (Windows, Linux, Newer MacOS)
2. Signing (need Apple and Windows certificates)
3. “Share”:  the ability to email or share your score
4. Better protection of key words and ability for administrators to update words without updating the app 
    (e.g. access words through a secret database via an API that withholds access until the reveal date).
5. Debug logging
6. Usage tracking
7. Better accessibility for color-blind users
8. Game instructions / help

