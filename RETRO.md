# Retrospective

## Retro 2023-02-14 (Happy Valentine's Day)

### Dart

1. I thought it was very similar to Typescript, but without Javascript baggage.
The support for async/await seems more native.

2. I really don't like the file name lower casing / underscore conventions. I
understand why the designers did this because Dart allows functions as top-level
types.  However, this makes it confusing how to name and structure files. 
With one class per file, it's weird that the file name is different from the 
class name. So I ended upputting multiple classes in a file in a few cases, 
and I wasn't entirely happy with that either.  Standards and conventions are 
great, and Dart seems to lack a standard in this case. In Typescript, I prefer
to name the file after the class and use the same casing.

3. I like the NULL safety built into the language, however more null-coalescing 
features would help. We need something like the ?. operator, but for function
calls instead of method calls.

4. Some conveniences are missing compared with Python or Kotlin. I missed Python's
ability to enumerate with parallel index and value. Maybe Dart will add this with
support for tuple/record types.

5. Google has proven they are willing to break compatibility with new versions.
This is a pro and a con.

6. Safely parsing JSON was more verbose than I have done in Typescript. But it's
not as bad as C# because Dart doesn't require an explicit cast if you have already
checked the type.  (This is awesome!!)

7. I am looking forward to creating some device applications and also trying
   Dart REST, gRPC, GraphQL clients.

### Things to Improve

1. History could be more flexible if it recorded the full game result for each
game (Date, word, numberOfGuesses). I was originally trying to avoid saving
one entry per game, and instead just saved accumulators. But I ended up saving 
one entry per game for the keywords anyway in order to prevent playing twice.

2. With the way I generated key words, there is a possibility (actually a good chance)
of a word duplicate within the ~3 years of words.  I need to re-generate
the words and fix this by doing a random shuffle rather than a random index.

3. I ran into trouble when trying to separate tests into multiple files. Even when 
I imported the subtest file as an extra step, I ran into a weird compile error. 
That's why the test file is so long. This is definitely something to figure out.

4. I designed the StreamWordle class to support testing (it writes to an IOSink instead 
of directly to Stdout).  But I didn't get around to implementing these tests. Still 
it was worth the extra work to better understand the Dart IO package.

5. Currently cli_wordle files import wordle files with a backwards relative path,
which is ugly I think the solution is to create a standalone package.yaml file for the 
wordle files. This is definitely something to figure out.

### Take-Home Interviews

I have interviewed a lot of candidates in the past and never had the opportunity to give
a take-home interview.  As an interviewer, it was always hard to get enough information from
an in-person interview, and candidates would sometimes flunk just because they were
nervous, which I hated.  From the interviewee perspective, I spent a lot more time on this
than an in-person interview (partly because I chose to use this as an opportunity to learn
Dart), but it was a lot of fun and I learned a lot.  