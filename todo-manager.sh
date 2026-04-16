#!/bin/bash

set -euo pipefail

TODO_FILE="${TODO_FILE:-todos.txt}"

usage() {
  cat <<EOF
Usage:
  ./todo-manager.sh list
  ./todo-manager.sh add "task description"
  ./todo-manager.sh remove <id>
  ./todo-manager.sh done <id>
EOF
}

ensure_file() {
  if [ ! -f "$TODO_FILE" ]; then
    touch "$TODO_FILE"
  fi
}

next_id() {
  ensure_file

  if [ ! -s "$TODO_FILE" ]; then
    echo 1
    return
  fi

  awk -F'|' 'BEGIN { max = 0 } { if ($1 > max) max = $1 } END { print max + 1 }' "$TODO_FILE"
}

list_items() {
  ensure_file

  if [ ! -s "$TODO_FILE" ]; then
    echo "No todo items found."
    return
  fi

  while IFS='|' read -r id status task; do
    if [ "$status" = "done" ]; then
      marker="x"
    else
      marker=" "
    fi
    printf '%s. [%s] %s\n' "$id" "$marker" "$task"
  done < "$TODO_FILE"
}

add_item() {
  local task="$1"
  local id

  if [ -z "$task" ]; then
    echo "Error: task description cannot be empty."
    exit 1
  fi

  case "$task" in
    *'|'*)
      echo "Error: task description cannot contain the '|' character."
      exit 1
      ;;
  esac

  id=$(next_id)
  printf '%s|pending|%s\n' "$id" "$task" >> "$TODO_FILE"
  echo "Added todo item #$id."
}

remove_item() {
  local id="$1"
  local temp_file

  ensure_file

  if ! grep -qE "^${id}\\|" "$TODO_FILE"; then
    echo "Error: todo item with id $id not found."
    exit 1
  fi

  temp_file=$(mktemp)
  grep -vE "^${id}\\|" "$TODO_FILE" > "$temp_file"
  mv "$temp_file" "$TODO_FILE"
  echo "Removed todo item #$id."
}

mark_done() {
  local id="$1"
  local temp_file
  local found=0

  ensure_file
  temp_file=$(mktemp)

  while IFS='|' read -r current_id status task; do
    if [ "$current_id" = "$id" ]; then
      printf '%s|done|%s\n' "$current_id" "$task" >> "$temp_file"
      found=1
    else
      printf '%s|%s|%s\n' "$current_id" "$status" "$task" >> "$temp_file"
    fi
  done < "$TODO_FILE"

  if [ "$found" -eq 0 ]; then
    rm -f "$temp_file"
    echo "Error: todo item with id $id not found."
    exit 1
  fi

  mv "$temp_file" "$TODO_FILE"
  echo "Marked todo item #$id as done."
}

if [ "$#" -lt 1 ]; then
  usage
  exit 1
fi

command="$1"
shift

case "$command" in
  list)
    if [ "$#" -ne 0 ]; then
      usage
      exit 1
    fi
    list_items
    ;;
  add)
    if [ "$#" -ne 1 ]; then
      usage
      exit 1
    fi
    add_item "$1"
    ;;
  remove)
    if [ "$#" -ne 1 ]; then
      usage
      exit 1
    fi
    remove_item "$1"
    ;;
  done)
    if [ "$#" -ne 1 ]; then
      usage
      exit 1
    fi
    mark_done "$1"
    ;;
  *)
    usage
    exit 1
    ;;
esac