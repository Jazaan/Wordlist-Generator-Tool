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

# Function to display a simple animation
animate() {
  local chars="/-\|"
  while :; do
    for char in ${chars}; do
      echo -ne "\rGenerating... ${char}"
      sleep 0.1
    done
  done
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

# Function to generate words recursively
generate_word() {
  local prefix="$1"
  local remaining_length="$2"

  if [ "$remaining_length" -eq 0 ]; then
    echo "$prefix" >> "$output_file"
    if [ "$verbose" = true ]; then
      echo "Generated: $prefix"
    fi
    return
  fi

  for char in $(echo "$characters" | fold -w1); do
    generate_word "$prefix$char" "$((remaining_length - 1))"
  done
}

# Clear the output file if it already exists
> "$output_file"

# Start generating words with animation
echo "╔══════════════════════════════╗"
echo "║       Wordlist Generator     ║"
echo "╚══════════════════════════════╝"

animate &  # Start the animation in the background
animation_pid=$!

generate_word "" "$min_length"

# Stop the animation
kill -TERM "${animation_pid}" 2>/dev/null
wait "${animation_pid}" 2>/dev/null

echo -e "\nWordlist generated and saved to $output_file"
