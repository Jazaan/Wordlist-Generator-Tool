#!/bin/bash

set -e  # Exit script on error

# Default settings
characters="0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()_+{}[];:,.<>?|"
min_length=6
max_length=8
output_file="wordlist.txt"
verbose=false

# Check if 'pv' is installed for progress tracking
if ! command -v pv &> /dev/null; then
  echo "Error: 'pv' is not installed. Install it using: sudo apt install pv"
  exit 1
fi

# Function to display usage information
usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "Options:"
  echo "  -c, --characters CHARACTERS  Specify characters for the wordlist (default: all printable chars)"
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

# Function to estimate total wordlist size
estimate_total_combinations() {
  total=0
  for ((length=min_length; length<=max_length; length++)); do
    total=$((total + ${#characters} ** length))
  done
  echo "$total"
}

# Optimized function to generate words iteratively with progress
generate_wordlist() {
  > "$output_file"  # Clear previous output file

  total_combinations=$(estimate_total_combinations)
  
  echo -e "\nGenerating Wordlist... Estimated total: $total_combinations words\n"

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
    ' | pv -l -s "$total_combinations" >> "$output_file"
  done
}

# Display banner
clear
echo -e "\e[1;32m"  # Set color to green
echo "┌──────────────────────────────────────────────┐"
echo "│       🚀 Advanced Wordlist Generator        │"
echo "├──────────────────────────────────────────────┤"
echo "│ Min Length  : $min_length                              │"
echo "│ Max Length  : $max_length                              │"
echo "│ Output File : $output_file                             │"
echo "│ Total Words : $(estimate_total_combinations)           │"
echo "└──────────────────────────────────────────────┘"
echo -e "\e[0m"  # Reset color

# Start wordlist generation with progress
generate_wordlist

echo -e "\n✅ Wordlist generated and saved to \e[1;34m$output_file\e[0m"
