#!/usr/bin/env bash
#
# install.sh -- Install agents-workspace + agency-agents skills into your AI tools
#
# Always downloads GitHub main.zip (never installs from the local working tree).
# Installs skills from templates/skills and boot policy from templates/AGENTS.md
# inside the archive to OpenCode, Claude Code, Antigravity, and Copilot.
#
# Boot policy is installed to each tool's global instruction file, upserted between
# <!-- agents-workspace:start --> and <!-- agents-workspace:end --> markers so
# existing user content outside the block is preserved.
#
# Usage:
#   ./install.sh [--opencode|--claude|--copilot|--all] [--division <list>] [--list] [--help]
#
# Install directly:
#   curl -sL https://raw.githubusercontent.com/wcgomes/agents-workspace/main/tools/install.sh | bash

set -euo pipefail

REPO_URL="https://github.com/wcgomes/agents-workspace/archive/refs/heads/main.zip"
REPO_NAME="agents-workspace-main"
AGENCY_REPO_URL="https://github.com/msitarzewski/agency-agents/archive/refs/heads/main.zip"
AGENCY_REPO_NAME="agency-agents-main"
ALL_TOOLS=(opencode claude copilot antigravity)
MARKER_START="<!-- agents-workspace:start -->"
MARKER_END="<!-- agents-workspace:end -->"

if [[ -t 1 && -z "${NO_COLOR:-}" && "${TERM:-}" != "dumb" ]]; then
  C_GREEN='\033[0;32m'
  C_YELLOW='\033[1;33m'
  C_RED='\033[0;31m'
  C_CYAN='\033[0;36m'
  C_BOLD='\033[1m'
  C_RESET='\033[0m'
else
  C_GREEN=''; C_YELLOW=''; C_RED=''; C_CYAN=''; C_BOLD=''; C_RESET=''
fi

ok()   { printf "${C_GREEN}[OK]${C_RESET}  %s\n" "$*"; }
warn() { printf "${C_YELLOW}[!!]${C_RESET}  %s\n" "$*"; }
err()  { printf "${C_RED}[ERR]${C_RESET} %s\n" "$*" >&2; }
info() { printf "${C_CYAN}[--]${C_RESET}  %s\n" "$*"; }

usage() {
  cat <<EOF
Usage: install.sh [options]

Options:
  --opencode          Install only for OpenCode
  --claude            Install only for Claude Code
  --copilot           Install only for Copilot
  --all               Install to all detected tools (default)
  --division <list>   Comma-separated agency-agents divisions to install
  --no-agency         Skip agency-agents installation
  --list              List available skills without installing
  --help              Show this help

Installs for each selected tool:
  - Skills from templates/skills (global skill dirs)
  - Boot policy from templates/AGENTS.md (global instruction files, marker-upsert)

Global boot policy destinations:
  OpenCode      ~/.config/opencode/AGENTS.md
  Claude Code   ~/.claude/CLAUDE.md
  Copilot       ~/.copilot/instructions/agents-workspace.instructions.md
  Antigravity   ~/.gemini/GEMINI.md

Examples:
  install.sh              # Interactive mode
  install.sh --all         # Install to all detected tools
  install.sh --claude      # Install only for Claude Code
  install.sh --all --no-agency  # Install all without agency-agents
  install.sh --list         # List available skills
  install.sh --opencode --division engineering,security

Install directly:
  curl -sL https://raw.githubusercontent.com/wcgomes/agents-workspace/main/tools/install.sh | bash
EOF
  exit 0
}

detect_opencode()    { [[ -d "${HOME}/.config/opencode" ]] || command -v opencode >/dev/null 2>&1; }
detect_claude()      { [[ -d "${HOME}/.claude" ]] || command -v claude >/dev/null 2>&1; }
detect_copilot()    { [[ -d "${HOME}/.copilot" ]] || command -v code >/dev/null 2>&1; }
detect_antigravity(){ [[ -d "${HOME}/.gemini/antigravity" ]] || command -v gemini >/dev/null 2>&1; }

is_detected() {
  case "$1" in
    opencode)    detect_opencode    ;;
    claude)      detect_claude      ;;
    copilot)    detect_copilot     ;;
    antigravity) detect_antigravity ;;
    *)           return 1 ;;
  esac
}

tool_label() {
  case "$1" in
    opencode)    printf "%-12s  %s" "OpenCode"    "~/.config/opencode/skills"     ;;
    claude)      printf "%-12s  %s" "Claude Code"  "~/.claude/skills"              ;;
    copilot)     printf "%-12s  %s" "Copilot"     "~/.copilot/skills"            ;;
    antigravity) printf "%-12s  %s" "Antigravity"  "~/.gemini/antigravity/skills"   ;;
  esac
}

# Global boot-policy file per tool (docs-aligned).
boot_policy_dest() {
  case "$1" in
    opencode)    echo "${HOME}/.config/opencode/AGENTS.md" ;;
    claude)      echo "${HOME}/.claude/CLAUDE.md" ;;
    copilot)     echo "${HOME}/.copilot/instructions/agents-workspace.instructions.md" ;;
    antigravity) echo "${HOME}/.gemini/GEMINI.md" ;;
    *)           return 1 ;;
  esac
}

# Ensure template body is wrapped in managed markers.
ensure_marked_block() {
  local src="$1"
  local out="$2"
  local body
  body="$(cat "$src")"

  if grep -qF "$MARKER_START" <<<"$body" && grep -qF "$MARKER_END" <<<"$body"; then
    printf '%s\n' "$body" > "$out"
  else
    {
      printf '%s\n' "$MARKER_START"
      printf '%s\n' "$body"
      printf '%s\n' "$MARKER_END"
    } > "$out"
  fi
}

# Upsert managed block into dest. Returns: created | updated | appended | replaced
upsert_marked_block() {
  local dest="$1"
  local block_file="$2"
  local dest_dir
  dest_dir="$(dirname "$dest")"
  mkdir -p "$dest_dir"

  if [[ ! -f "$dest" ]]; then
    cp "$block_file" "$dest"
    echo "created"
    return 0
  fi

  if grep -qF "$MARKER_START" "$dest" && grep -qF "$MARKER_END" "$dest"; then
    local tmp
    tmp="$(mktemp)"
    awk -v start="$MARKER_START" -v end="$MARKER_END" -v bf="$block_file" '
      BEGIN {
        while ((getline line < bf) > 0) {
          block = block line ORS
        }
        close(bf)
        mode = "before"
      }
      index($0, start) && mode == "before" {
        printf "%s", block
        mode = "skip"
        next
      }
      index($0, end) && mode == "skip" {
        mode = "after"
        next
      }
      mode != "skip" { print }
    ' "$dest" > "$tmp"
    mv "$tmp" "$dest"
    echo "updated"
    return 0
  fi

  {
    printf '\n'
    cat "$block_file"
  } >> "$dest"
  echo "appended"
}

# Install boot policy for one tool. Prints "ok" or "skip".
install_boot_policy() {
  local tool="$1"
  local template="$2"
  local dest block_file status
  dest="$(boot_policy_dest "$tool")" || return 1

  block_file="$(mktemp)"
  ensure_marked_block "$template" "$block_file"

  # Copilot expects *.instructions.md with applyTo frontmatter.
  if [[ "$tool" == "copilot" ]]; then
    local copilot_block
    copilot_block="$(mktemp)"
    {
      printf '%s\n' '---'
      printf '%s\n' "name: 'agents-workspace'"
      printf '%s\n' "description: 'Agents Workspace boot policy (managed by install.sh)'"
      printf '%s\n' "applyTo: '**'"
      printf '%s\n' '---'
      cat "$block_file"
    } > "$copilot_block"
    # Dedicated managed file — full replace is safe.
    mkdir -p "$(dirname "$dest")"
    cp "$copilot_block" "$dest"
    rm -f "$block_file" "$copilot_block"
    echo "replaced"
    return 0
  fi

  status="$(upsert_marked_block "$dest" "$block_file")"
  rm -f "$block_file"
  echo "$status"
}

# Ensure all agent .md files have "mode: subagent" in their frontmatter.
ensure_subagent_mode() {
  local agents_dir="$1"
  [[ -d "$agents_dir" ]] || return 0
  local count=0
  for f in "$agents_dir"/*.md; do
    [[ -f "$f" ]] || continue
    head -1 "$f" | grep -q '^---$' || continue
    if awk '
      BEGIN { found=0 }
      /^---$/ { n++; if(n==2) exit found }
      n==1 && /^mode:/ { found=1 }
      END { exit !found }
    ' "$f" 2>/dev/null; then
      continue
    fi
    awk '
      BEGIN { n=0 }
      /^---$/ {
        n++
        if (n == 2) {
          print "mode: subagent"
          print ""
        }
      }
      { print }
    ' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
    (( count++ )) || true
  done
  if (( count > 0 )); then
    info "Added mode: subagent to $count agent(s)"
  fi
}

install_opencode_ours() {
  local src="$1"
  local dest_base="${HOME}/.config/opencode/skills"
  local count=0
  mkdir -p "$dest_base"
  for skill_dir in "$src"/*/SKILL.md; do
    [[ -f "$skill_dir" ]] || continue
    local name; name="$(basename "$(dirname "$skill_dir")")"
    mkdir -p "$dest_base/$name"
    cp -f "$skill_dir" "$dest_base/$name/SKILL.md"
    (( count++ )) || true
  done
  echo "$count"
}

install_claude_ours() {
  local src="$1"
  local dest_base="${HOME}/.claude/skills"
  local count=0
  mkdir -p "$dest_base"
  for skill_dir in "$src"/*/SKILL.md; do
    [[ -f "$skill_dir" ]] || continue
    local name; name="$(basename "$(dirname "$skill_dir")")"
    mkdir -p "$dest_base/$name"
    cp -f "$skill_dir" "$dest_base/$name/SKILL.md"
    (( count++ )) || true
  done
  echo "$count"
}

install_copilot_ours() {
  local src="$1"
  local dest_base="${HOME}/.copilot/skills"
  local count=0
  mkdir -p "$dest_base"
  for skill_dir in "$src"/*/SKILL.md; do
    [[ -f "$skill_dir" ]] || continue
    local name; name="$(basename "$(dirname "$skill_dir")")"
    mkdir -p "$dest_base/$name"
    cp -f "$skill_dir" "$dest_base/$name/SKILL.md"
    (( count++ )) || true
  done
  echo "$count"
}

install_antigravity_ours() {
  local src="$1"
  local dest_base="${HOME}/.gemini/antigravity/skills"
  local count=0
  mkdir -p "$dest_base"
  for skill_dir in "$src"/*/SKILL.md; do
    [[ -f "$skill_dir" ]] || continue
    local name; name="$(basename "$(dirname "$skill_dir")")"
    mkdir -p "$dest_base/$name"
    cp -f "$skill_dir" "$dest_base/$name/SKILL.md"
    (( count++ )) || true
  done
  echo "$count"
}

install_agency_tool() {
  local tool="$1"
  local agency_dir="$2"
  local divisions="$3"
  local success=true
  local division_args=()
  if [[ -n "$divisions" ]]; then
    division_args=("--division" "$divisions")
  fi

  local -a install_cmd=()
  case "$tool" in
    antigravity)
      if [[ -d "$agency_dir/integrations/antigravity" ]]; then
        info "Running convert.sh for $tool..."
        if "$agency_dir/scripts/convert.sh" --tool antigravity 2>/dev/null; then
          info "Running install.sh for $tool..."
          install_cmd=("$agency_dir/scripts/install.sh" --tool antigravity --no-interactive)
          [[ ${#division_args[@]} -gt 0 ]] && install_cmd+=("${division_args[@]}")
          "${install_cmd[@]}" 2>/dev/null || success=false
        else
          success=false
        fi
      fi
      ;;
    opencode)
      info "Running convert.sh for $tool..."
      if "$agency_dir/scripts/convert.sh" --tool opencode 2>&1 | grep -v "^$" > /dev/null; then
        info "Running install.sh for $tool..."
        install_cmd=("$agency_dir/scripts/install.sh" --tool opencode --no-interactive)
        [[ ${#division_args[@]} -gt 0 ]] && install_cmd+=("${division_args[@]}")
        "${install_cmd[@]}" 2>/dev/null || success=false
        if [[ -d ".opencode/agents" && -n "$(ls -A .opencode/agents 2>/dev/null)" ]]; then
          ensure_subagent_mode ".opencode/agents"
          info "Moving agents to global location..."
          mkdir -p "${HOME}/.config/opencode/agents"
          mv .opencode/agents/*.md "${HOME}/.config/opencode/agents/" 2>/dev/null || true
          rm -rf .opencode/agents
          rmdir .opencode 2>/dev/null || true
        fi
      else
        warn "convert.sh failed for $tool"
        success=false
      fi
      ;;
    copilot)
      info "Running install.sh for $tool..."
      install_cmd=("$agency_dir/scripts/install.sh" --tool copilot --no-interactive)
      [[ ${#division_args[@]} -gt 0 ]] && install_cmd+=("${division_args[@]}")
      "${install_cmd[@]}" 2>/dev/null || success=false
      ;;
    claude)
      info "Running install.sh for $tool..."
      install_cmd=("$agency_dir/scripts/install.sh" --tool claude-code --no-interactive)
      [[ ${#division_args[@]} -gt 0 ]] && install_cmd+=("${division_args[@]}")
      "${install_cmd[@]}" 2>/dev/null || success=false
      ;;
  esac

  if $success; then
    return 0
  else
    return 1
  fi
}

list_skills() {
  local src="$1"
  local count=0
  echo ""
  echo "Available skills:"
  echo ""
  for skill_dir in "$src"/*/SKILL.md; do
    [[ -f "$skill_dir" ]] || continue
    local name; name="$(basename "$(dirname "$skill_dir")")"
    echo "  - $name"
    (( count++ )) || true
  done
  echo ""
  echo "Total: $count skills"
  echo ""
}

interactive_select() {
  declare -a selected=()
  declare -a detected_map=()
  local t i

  for t in "${ALL_TOOLS[@]}"; do
    if is_detected "$t" 2>/dev/null; then
      selected+=(1); detected_map+=(1)
    else
      selected+=(0); detected_map+=(0)
    fi
  done

  while true; do
    echo ""
    echo "  +--------------------------------------------------+"
    echo "  |  ${C_BOLD}Skills Installer${C_RESET}                                   |"
    echo "  +--------------------------------------------------+"
    echo "  |  System scan: [*] = detected on this machine    |"
    echo "  |  Agency-agents installed by default            |"
    echo "  |  Use --no-agency to skip                     |"
    echo "  |                                                  |"
    i=0
    for t in "${ALL_TOOLS[@]}"; do
      local num=$(( i + 1 ))
      local label; label="$(tool_label "$t")"
      local dot chk
      if [[ "${detected_map[$i]}" == "1" ]]; then
        dot="${C_GREEN}[*]${C_RESET}"
      else
        dot="${C_DIM}[ ]${C_RESET}"
      fi
      if [[ "${selected[$i]}" == "1" ]]; then
        chk="${C_GREEN}[x]${C_RESET}"
      else
        chk="${C_DIM}[ ]${C_RESET}"
      fi
      printf "  |  %s  %s)  %s  %-28s|\n" "$chk" "$num" "$dot" "$label"
      (( i++ )) || true
    done
    echo "  |                                                  |"
    echo "  +--------------------------------------------------+"
    echo "  |  [1-${#ALL_TOOLS[@]}] toggle   [a] all   [n] none   |"
    echo "  |  [d] detected   [q] quit   [Enter] install        |"
    echo "  +--------------------------------------------------+"
    echo ""
    printf "  >> "
    read -r input </dev/tty

    case "$input" in
      q|Q) echo ""; ok "Aborted."; exit 0 ;;
      a|A) for (( j=0; j<${#ALL_TOOLS[@]}; j++ )); do selected[$j]=1; done ;;
      n|N) for (( j=0; j<${#ALL_TOOLS[@]}; j++ )); do selected[$j]=0; done ;;
      d|D) for (( j=0; j<${#ALL_TOOLS[@]}; j++ )); do selected[$j]="${detected_map[$j]}"; done ;;
      "")
        local any=false
        for s in "${selected[@]}"; do [[ "$s" == "1" ]] && any=true && break; done
        if $any; then
          SELECTED_TOOLS=()
          i=0
          for t in "${ALL_TOOLS[@]}"; do
            [[ "${selected[$i]}" == "1" ]] && SELECTED_TOOLS+=("$t")
            (( i++ )) || true
          done
          break
        else
          warn "Nothing selected -- pick a tool or press q to quit."
          sleep 1
        fi ;;
      *)
        local toggled=false
        for num in $input; do
          if [[ "$num" =~ ^[0-9]+$ ]]; then
            local idx=$(( num - 1 ))
            if (( idx >= 0 && idx < ${#ALL_TOOLS[@]} )); then
              if [[ "${selected[$idx]}" == "1" ]]; then
                selected[$idx]=0
              else
                selected[$idx]=1
              fi
              toggled=true
            fi
          fi
        done
        if ! $toggled; then
          err "Invalid. Enter 1-${#ALL_TOOLS[@]}, or a command."
          sleep 1
        fi ;;
    esac

    local lines=$(( ${#ALL_TOOLS[@]} + 12 ))
    for (( l=0; l<lines; l++ )); do printf '\033[1A\033[2K'; done
  done
}

main() {
  local selected_tool="all"
  local interactive_mode="auto"
  local list_only=false
  local selected_tools=()
  local explicit_all=false
  local skip_agency=false
  local divisions=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --opencode)    selected_tools+=("opencode");    shift ;;
      --claude)      selected_tools+=("claude");       shift ;;
      --copilot)     selected_tools+=("copilot");     shift ;;
      --all)         selected_tool="all";             explicit_all=true; shift ;;
      --no-agency)   skip_agency=true;                shift ;;
      --division)
        if [[ -n "${2:-}" ]]; then
          divisions="$2"; shift 2
        else
          err "--division requires a comma-separated list of divisions"
          usage
        fi ;;
      --list)        list_only=true;                  shift ;;
      --help|-h)    usage ;;
      *)             err "Unknown option: $1"; usage ;;
    esac
  done

  local tmp_dir
  tmp_dir="$(mktemp -d)"
  local tmp_zip="${tmp_dir}/archive.zip"
  trap "rm -rf '$tmp_dir'" EXIT

  info "Downloading agents-workspace..."
  if ! curl -sL "$REPO_URL" -o "$tmp_zip" 2>/dev/null; then
    err "Failed to download agents-workspace archive."
    exit 1
  fi

  if ! unzip -q "$tmp_zip" -d "$tmp_dir" 2>/dev/null; then
    err "Failed to extract agents-workspace archive."
    exit 1
  fi

  local src="${tmp_dir}/${REPO_NAME}/templates/skills"
  local agents_template="${tmp_dir}/${REPO_NAME}/templates/AGENTS.md"
  if [[ ! -d "$src" ]]; then
    err "Skills directory not found in agents-workspace archive."
    exit 1
  fi
  if [[ ! -f "$agents_template" ]]; then
    err "Boot policy template not found: templates/AGENTS.md"
    exit 1
  fi

  if [[ "$list_only" == "true" ]]; then
    list_skills "$src"
    exit 0
  fi

  if $explicit_all; then
    for t in "${ALL_TOOLS[@]}"; do
      if is_detected "$t" 2>/dev/null; then
        selected_tools+=("$t")
      fi
    done
  elif [[ ${#selected_tools[@]} -gt 0 ]]; then
    :
  elif [[ "$interactive_mode" == "auto" && -t 0 && -t 1 ]]; then
    interactive_select
  else
    for t in "${ALL_TOOLS[@]}"; do
      if is_detected "$t" 2>/dev/null; then
        selected_tools+=("$t")
      fi
    done
  fi

  if [[ ${#selected_tools[@]} -eq 0 ]]; then
    err "No tools selected or detected."
    echo ""
    info "Run with --opencode, --claude, --copilot, or --all to force install."
    info "Available tools: ${ALL_TOOLS[*]}"
    exit 1
  fi

  echo ""
  echo "=============================================="
  echo "  Installing our skills..."
  echo "=============================================="
  echo ""

  local our_count_opencode=0
  local our_count_claude=0
  local our_count_copilot=0
  local our_count_antigravity=0
  local boot_status_opencode=""
  local boot_status_claude=""
  local boot_status_copilot=""
  local boot_status_antigravity=""

  for t in "${selected_tools[@]}"; do
    case "$t" in
      opencode)    our_count_opencode=$(install_opencode_ours "$src")    ;;
      claude)      our_count_claude=$(install_claude_ours "$src")      ;;
      copilot)    our_count_copilot=$(install_copilot_ours "$src")     ;;
      antigravity) our_count_antigravity=$(install_antigravity_ours "$src")   ;;
    esac
  done

  echo ""
  echo "=============================================="
  echo "  Installing boot policy (global)..."
  echo "=============================================="
  echo ""

  for t in "${selected_tools[@]}"; do
    local status dest_disp
    status="$(install_boot_policy "$t" "$agents_template")"
    case "$t" in
      opencode)    boot_status_opencode="$status" ;;
      claude)      boot_status_claude="$status" ;;
      copilot)     boot_status_copilot="$status" ;;
      antigravity) boot_status_antigravity="$status" ;;
    esac
    dest_disp="$(boot_policy_dest "$t" | sed "s|^${HOME}|~|")"
    ok "boot policy ($status) -> $dest_disp"
  done

  local agency_tmp_zip="${tmp_dir}/agency.zip"

  if $skip_agency; then
    info "Skipping agency-agents installation (--no-agency)"
  else
    info "Downloading agency-agents..."
    if ! curl -sL "$AGENCY_REPO_URL" -o "$agency_tmp_zip" 2>/dev/null; then
      warn "Failed to download agency-agents archive."
    else
      if ! unzip -q "$agency_tmp_zip" -d "$tmp_dir" 2>/dev/null; then
        warn "Failed to extract agency-agents archive."
      else
        local agency_dir="${tmp_dir}/${AGENCY_REPO_NAME}"
        if [[ ! -d "$agency_dir" ]]; then
          warn "agency-agents directory not found."
        else
          echo ""
          echo "=============================================="
          echo "  Installing agency-agents..."
          echo "=============================================="
          echo ""

          local agency_failed=()
          for t in "${selected_tools[@]}"; do
            install_agency_tool "$t" "$agency_dir" "$divisions" || agency_failed+=("$t")
          done

          if [[ ${#agency_failed[@]} -gt 0 ]]; then
            echo ""
            warn "Some agency-agents installs failed: ${agency_failed[*]}"
          fi
        fi
      fi
    fi
  fi

  echo ""
  echo "=============================================="
  echo "  Summary"
  echo "=============================================="
  echo ""

  echo "  skills:"
  for t in "${selected_tools[@]}"; do
    local count=0
    local dest=""
    case "$t" in
      opencode)
        count="$our_count_opencode"
        dest="~/.config/opencode/skills/"
        ;;
      claude)
        count="$our_count_claude"
        dest="~/.claude/skills/"
        ;;
      copilot)
        count="$our_count_copilot"
        dest="~/.copilot/skills/"
        ;;
      antigravity)
        count="$our_count_antigravity"
        dest="~/.gemini/antigravity/skills/"
        ;;
    esac
    ok "$count skills -> $dest"
  done

  echo ""
  echo "  boot policy (global, marker-upsert):"
  for t in "${selected_tools[@]}"; do
    local bdest bstatus="?"
    bdest="$(boot_policy_dest "$t" | sed "s|^${HOME}|~|")"
    case "$t" in
      opencode)    bstatus="$boot_status_opencode" ;;
      claude)      bstatus="$boot_status_claude" ;;
      copilot)     bstatus="$boot_status_copilot" ;;
      antigravity) bstatus="$boot_status_antigravity" ;;
    esac
    ok "${bstatus:-?} -> $bdest"
  done

  if $skip_agency; then
    :
  else
    echo ""
    echo "  agency-agents (via install.sh):"
    echo "    (check tool output above for counts)"
  fi
  echo ""
}

main "$@"
