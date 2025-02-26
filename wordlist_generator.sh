#!/bin/bash

set -e  # Exit on error
# Default settings
characters="0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()_+{}[];:,.<>?|"
min_length=6
max_length=8
output_file="wordlist.txt"
verbose=false

# Function to display usage information
usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "Options:"
  echo "  -c, --characters CHARACTERS  Specify characters (default: all printable)"
  echo "  -l, --min-length MIN_LENGTH  Set minimum word length (default: 6)"
  echo "  -L, --max-length MAX_LENGTH  Set maximum word length (default: 8)"
  echo "  -o, --output FILE            Set output file (default: wordlist.txt)"
  echo "  -v, --verbose                Enable verbose mode"
  echo "  -h, --help                   Show this help message"
  exit 1
}

# Function to validate positive integers
validate_positive_integer() {
  if ! [[ $1 =~ ^[1-9][0-9]*$ ]]; then
    echo "Error: $2 must be a positive integer." >&2
    exit 1
  fi
}

# Parse command-line options
while [[ $# -gt 0 ]]; do
  case "$1" in
    -c|--characters)
      characters="$2"
      shift 2
      ;;
    -l|--min-length)
      validate_positive_integer "$2" "Minimum length"
      min_length="$2"
      shift 2
      ;;
    -L|--max-length)
      validate_positive_integer "$2" "Maximum length"
      max_length="$2"
      shift 2
      ;;
    -o|--output)
      output_file="$2"
      shift 2
      ;;
    -v|--verbose)
      verbose=true
      shift
      ;;
    -h|--help)
      usage
      ;;
    *)
      usage
      ;;
  esac
done

# Function to estimate total words
estimate_combinations() {
  total=0
  for ((i=min_length; i<=max_length; i++)); do
    total=$((total + ${#characters} ** i))
  done
  echo "$total"
}

# Function to show progress animation
show_progress() {
  local duration=3
  local bar="█"
  echo -ne "\nGenerating Wordlist: ["
  for ((i = 0; i < 20; i++)); do
    sleep $((duration / 20))
    echo -ne "$bar"
  done
  echo "] Done!"
}

# Function to generate wordlist using an iterative approach
generate_wordlist() {
  > "$output_file"  # Clear output file

  total_words=$(estimate_combinations)
  echo "Generating Wordlist... Estimated total: $total_words words"

  show_progress  # Progress animation

  for ((length=min_length; length<=max_length; length++)); do
    awk -v chars="$characters" -v len="$length" '
    function generate(prefix, depth) {
      if (depth == len) {
        print prefix
        return
      }
      for (i = 1; i <= length(chars); i++) {
        generate(prefix substr(chars, i, 1), depth + 1)
      }
    }
    BEGIN { generate("", 0) }
    ' >> "$output_file"
  done
}

# Display improved banner
clear
echo -e "\e[1;34m"
echo "╔═════════════════════════════════════════╗"
echo "║    🚀  ADVANCED WORDLIST GENERATOR  🚀   ║"
echo "╠═════════════════════════════════════════╣"
echo "║  Min Length : $min_length                  ║"
echo "║  Max Length : $max_length                  ║"
echo "║  Output     : $output_file                 ║"
echo "║  Total Words: $(estimate_combinations)     ║"
echo "╚═════════════════════════════════════════╝"
echo -e "\e[0m"

# Run wordlist generation
generate_wordlist

echo -e "\n✅ Wordlist successfully saved to \e[1;32m$output_file\e[0m 🎉"
