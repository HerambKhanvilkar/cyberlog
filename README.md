### JIT vs AOT Compilation (Core Principles)
JIT (Just-In-Time Compilation):
    - Code is compiled during runtime.
    - Faster development (hot reload works). 
    - Common in Flutter debug mode.

AOT (Ahead-Of-Time Compilation):
    - Code is compiled before execution.
    - Produces optimized machine code.
    - Used in Flutter release mode for high performance.

### Dart Conditionals Used for Even/Odd Logic
Dart uses simple if–else statements to check conditions.
if (num % 2 == 0) {
   result = "The number $num is Even";
   }
else {
   result = "The number $num is Odd";
   }
Explaination
   - % gives the remainder
   - == 0 determines even number
   - else → odd number

### String Interpolation for Output Formatting
Dart allows embedding variables directly into strings using $variable.
result = "The number $number is EVEN ✔";
