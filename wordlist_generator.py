import itertools
import string

def create_wordlist(length, chars):
    """
    Generate a wordlist based on the specified length and characters.

    Args:
        length (int): The length of each word in the wordlist.
        chars (str): The characters to include in the wordlist.

    Returns:
        A list of all possible combinations of the specified characters
        with the specified length.
    """
    wordlist = []
    for combination in itertools.product(chars, repeat=length):
        word = "".join(combination)
        wordlist.append(word)
    return wordlist

# User inputs
length = int(input("Enter the length of each word in the wordlist: "))
include_numbers = True if input("Include numbers in the wordlist? (1/0): ") == "1" else False
include_uppercase = True if input("Include uppercase letters in the wordlist? (1/0): ") == "1" else False
include_symbols = True if input("Include symbols in the wordlist? (1/0): ") == "1" else False
filename = raw_input("Enter the filename for the wordlist: ")

# Define characters to include in the wordlist
chars = string.ascii_lowercase
if include_numbers:
    chars += string.digits
if include_uppercase:
    chars += string.ascii_uppercase
if include_symbols:
    chars += string.punctuation

# Generate the wordlist
wordlist = create_wordlist(length, chars)

# Output the wordlist to a file
with open(filename, "w") as f:
    for word in wordlist:
        f.write(word + "\n")

print("Wordlist generated and saved to {}.".format(filename))
