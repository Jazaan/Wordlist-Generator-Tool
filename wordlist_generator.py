import itertools
import string

def create_wordlist(length, chars, format):
    """
    Generate a wordlist based on the specified length, characters, and format.

    Args:
        length (int): The length of each word in the wordlist.
        chars (str): The characters to include in the wordlist.
        format (str): The format of each word in the wordlist, where
                      'L' represents a lowercase letter, 'U' represents
                      an uppercase letter, 'D' represents a digit, and
                      'S' represents a symbol.

    Returns:
        A list of all possible combinations of the specified characters
        with the specified length and format.
    """
    wordlist = []
    for combination in itertools.product(chars, repeat=length):
        word = ""
        for i, char_type in enumerate(format):
            if char_type == "L":
                word += combination[i].lower()
            elif char_type == "U":
                word += combination[i].upper()
            elif char_type == "D":
                word += str(combination[i])
            elif char_type == "S":
                word += combination[i]
        wordlist.append(word)
    return wordlist

# User inputs
length = int(input("Enter the length of each word in the wordlist: "))
include_numbers = input("Include numbers in the wordlist? (y/n): ")
include_uppercase = input("Include uppercase letters in the wordlist? (y/n): ")
include_symbols = input("Include symbols in the wordlist? (y/n): ")
format = input("Enter the format of each word in the wordlist (e.g. LLDDSS): ")
output_file = input("Enter the filename for the wordlist: ")

# Define characters to include in the wordlist
chars = string.ascii_lowercase
if include_numbers.lower() == "y":
    chars += string.digits
if include_uppercase.lower() == "y":
    chars += string.ascii_uppercase
if include_symbols.lower() == "y":
    chars += string.punctuation

# Generate the wordlist
wordlist = create_wordlist(length, chars, format)

# Output the wordlist to a file
with open(output_file, "w") as f:
    for word in wordlist:
        f.write(word + "\n")

print(f"Wordlist generated and saved to {output_file}.")
