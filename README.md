# Wordlist-Generator-Tool
This is a Python script that generates a wordlist based on user-specified inputs for length, characters, and format. The wordlist can be used for a variety of purposes, such as password cracking, security testing, or data analysis.

The tool prompts the user for the following inputs:

Length of each word in the wordlist
Characters to include in the wordlist (letters, numbers, and/or symbols)
Format of each word in the wordlist (e.g. LLDDSS, where L represents a lowercase letter, D represents a digit, and S represents a symbol)
Filename for the output wordlist
The tool uses the itertools module to generate all possible combinations of the specified characters with the specified length and format. The resulting wordlist is then output to a file with the specified filename.

This tool is useful for anyone who needs to generate a large number of words for a specific purpose. It can save time and effort compared to manually creating a wordlist or using an existing one that may not meet specific requirements.
