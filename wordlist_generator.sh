#!/bin/bash

set -e  # Exit on error

# Default settings
characters="0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()_+{}[];:,.<>?|"
min_length=6
max_length=8
output_file="wordlist.txt"
verbose=false
cpu_cores=$(nproc)  # Detect number of CPU cores for parallel execution

# Function to display usage information
usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "Options:"
  echo "  -c, --characters CHARACTERS  Specify characters to include in the wordlist (default: a-z0-9)"
  echo "  -l, --min-length MIN_LENGTH  Specify minimum word length (default: 6)"
  echo "  -L, --max-length MAX_LENGTH  Specify maximum word length (default: 8)"
  echo "  -o, --output FILE            Specify the output file (default: wordlist.txt)"
  echo "  -v, --verbose                Enable verbose mode"
  echo "  -h, --help                   Display this help message"
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

# Function to display a simple progress animation
animate() {
  local pid=$1
  local spin='-\|/'
  while kill -0 "$pid" 2>/dev/null; do
    for i in {0..3}; do
      printf "\rGenerating... [%c]" "${spin:$i:1}"
      sleep 0.1
    done
  done
  printf "\r\033[K"  # Clear the animation line
}

# Optimized function to generate words iteratively
generate_wordlist() {
  > "$output_file"  # Clear previous output file

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
    ' | xargs -P "$cpu_cores" -I {} echo {} >> "$output_file"
  done
}

# Display the new stylish banner
clear
echo -e "\e[1;32m"  # Set color to green
echo "┌───────────────────────────────────────────┐"
echo "│       🔥 Wordlist Generator 🔥           │"
echo "├───────────────────────────────────────────┤"
echo "│ Min Length  : $min_length                 │"
echo "│ Max Length  : $max_length                 │"
echo "│ Output File : $output_file                │"
echo "│ CPU Cores   : $cpu_cores                  │"
echo "└───────────────────────────────────────────┘"
echo -e "\e[0m"  # Reset color

# Start the generator
generate_wordlist &
pid=$!
animate $pid  # Show spinner while generating
wait $pid  # Wait for completion

echo -e "\n✅ Wordlist generated and saved to \e[1;34m$output_file\e[0m"
