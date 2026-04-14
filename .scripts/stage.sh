#!/bin/bash
# Stage files via git update-index (workaround for git add failing silently on WSL/NTFS)

cd "$(git rev-parse --show-toplevel)"

stage_files() {
    for f in "$@"; do
        git update-index --add "$f" && echo "  Staged: $f" || echo "  Failed: $f"
    done
}

# --- Mode 1: files passed as arguments ---
if [ "$#" -gt 0 ]; then
    stage_files "$@"
    exit 0
fi

# --- Mode 2: interactive selection ---
MODIFIED=$(git ls-files -m)
NEW=$(git ls-files --others --exclude-standard)

if [ -z "$MODIFIED" ] && [ -z "$NEW" ]; then
    echo "Nothing to stage."
    exit 0
fi

# Build numbered list (read line-by-line to preserve filenames with spaces)
mapfile -t FILES < <({ git ls-files -m; git ls-files --others --exclude-standard; } | grep -v '^$')

echo "Files available to stage:"
for i in "${!FILES[@]}"; do
    echo "  $((i+1)). ${FILES[$i]}"
done

# Selection loop
while true; do
    echo ""
    read -p "Select files to stage (e.g. 1,3 or 2-4 or 1,3-5): " input

    # Parse selection into indices
    selected=()
    IFS=',' read -ra parts <<< "$input"
    for part in "${parts[@]}"; do
        part="${part// /}"
        if [[ "$part" =~ ^([0-9]+)-([0-9]+)$ ]]; then
            for ((n=${BASH_REMATCH[1]}; n<=${BASH_REMATCH[2]}; n++)); do
                selected+=("$n")
            done
        elif [[ "$part" =~ ^[0-9]+$ ]]; then
            selected+=("$part")
        else
            echo "  Invalid token: '$part', skipping."
        fi
    done

    # Resolve to filenames
    chosen=()
    for n in "${selected[@]}"; do
        if [ "$n" -ge 1 ] && [ "$n" -le "${#FILES[@]}" ]; then
            chosen+=("${FILES[$((n-1))]}")
        else
            echo "  Out of range: $n, skipping."
        fi
    done

    if [ "${#chosen[@]}" -eq 0 ]; then
        echo "No valid files selected. Try again."
        continue
    fi

    echo ""
    echo "Will stage:"
    for f in "${chosen[@]}"; do
        echo "  $f"
    done

    echo ""
    read -p "Confirm? [y/N/r(etry)/a(bort)] " confirm
    case "$confirm" in
        [Yy])
            stage_files "${chosen[@]}"
            break
            ;;
        [Rr])
            echo "Re-selecting..."
            continue
            ;;
        [Aa]|*)
            echo "Aborted."
            exit 0
            ;;
    esac
done
