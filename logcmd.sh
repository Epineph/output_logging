#!/bin/bash

# Use the LOG_PATH environment variable if set; default to /logs if not.
LOG_PATH="${LOG_PATH:-/logs}"
COMBINED_PATH="$LOG_PATH/combined"
STDOUT_PATH="$LOG_PATH/stdout"
STDERR_PATH="$LOG_PATH/stderr"

# Create necessary directories.
mkdir -p "$COMBINED_PATH" "$STDOUT_PATH" "$STDERR_PATH"
DATE_DIR=$(date +%Y-%m-%d)
mkdir -p "$COMBINED_PATH/$DATE_DIR" "$STDOUT_PATH/$DATE_DIR" "$STDERR_PATH/$DATE_DIR"

# Define log filenames based on the current timestamp.
TIMESTAMP=$(date +%Y%m%d%H%M%S)
COMBINED_FILE="$COMBINED_PATH/$DATE_DIR/$TIMESTAMP.log"
STDOUT_FILE="$STDOUT_PATH/$DATE_DIR/$TIMESTAMP-stdout.log"
STDERR_FILE="$STDERR_PATH/$DATE_DIR/$TIMESTAMP-stderr.log"

# Execute the command and log outputs.
"$@" > >(tee -a "$STDOUT_FILE" | tee -a "$COMBINED_FILE") 2> >(tee -a "$STDERR_FILE" >&2 | tee -a "$COMBINED_FILE")

