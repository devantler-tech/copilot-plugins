#!/usr/bin/env bash
set -euo pipefail

# Sync skills from upstream into plugin directories.
# Reads skills-manifest.json and uses `npx skills add` to download each skill,
# then copies the result into the target plugin's skills/ directory.

MANIFEST="skills-manifest.json"
STAGING=".agents/skills"

if [ ! -f "$MANIFEST" ]; then
  echo "::error::$MANIFEST not found"
  exit 1
fi

# Ensure staging directory exists
mkdir -p "$STAGING"

# Track whether anything changed
changed=0

for plugin in $(jq -r '.plugins | keys[]' "$MANIFEST"); do
  echo "=== Plugin: $plugin ==="
  target_dir="plugins/$plugin/skills"
  mkdir -p "$target_dir"

  for entry in $(jq -c ".plugins[\"$plugin\"][]" "$MANIFEST"); do
    skill=$(echo "$entry" | jq -r '.skill')
    source=$(echo "$entry" | jq -r '.source')

    echo "  Syncing $skill from $source..."

    # Download skill to staging area
    npx skills add "$source@$skill" -y --agent github-copilot 2>&1 | sed 's/^/    /'

    # Source may land in .agents/skills/<skill>/
    src="$STAGING/$skill"
    dest="$target_dir/$skill"

    if [ ! -d "$src" ]; then
      echo "    ⚠ Skill directory $src not found after download, skipping"
      continue
    fi

    # Copy to plugin directory (overwrite existing)
    mkdir -p "$dest"
    if ! diff -rq "$src/" "$dest/" > /dev/null 2>&1; then
      rm -rf "$dest"
      cp -r "$src" "$dest"
      echo "    ✓ Updated $dest"
      changed=1
    else
      echo "    · No changes"
    fi
  done
done

# Clean up staging area
rm -rf "$STAGING"

if [ "$changed" -eq 1 ]; then
  echo ""
  echo "Skills updated. Review changes and commit."
else
  echo ""
  echo "All skills are up to date."
fi
