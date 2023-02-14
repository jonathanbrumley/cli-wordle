# Retrospective

## Dart

1. I thought it was very similar to Typescript, but without Javascript baggage.
The support for async/await seems more native.

2. I like the NULL safety built into the language in newer versions,
however more null-coalescing features would help. We need something like the ?.
operator, but for function calls instead of method calls.

3. Some conveniences are missing compared with Python or Kotlin. I missed Python's
ability to enumerate with index and value.

4. Google has proven they are willing to break compatibility with new versions.
This is a pro and a con.

5. I found safely parsing JSON more verbose than Typescript.

6. I am looking forward to creating some device applications and also trying
   Dart REST, gRPC, GraphQL clients.

## Wordle Design

History could be more flexible if it recorded the full game result for each
game (Date, word, numberOfGuesses). I was originally trying to avoid saving
one entry per game, and instead just saved accumulators. But I ended up saving 
one entry per game for the keywords anyway in order to prevent playing twice.

## Testing

I ran into trouble when trying to separate tests into multiple files.  Even when 
I imported the subtest file as an extra step, I ran into a weird compile error. 
That's why the test file is so long. This is definitely something to figure out.

I designed the StreamWordle class to support testing (it writes to an IOSink instead
of directly to Stdout).  But didn't get around to implementing these tests.  But it was
still worth the extra work to better understand the Dart IO library.
