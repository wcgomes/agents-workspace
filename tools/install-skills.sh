#!/usr/bin/env bash
#
# install-skills.sh -- Install agents-workspace + agency-agents skills into your AI tools
#
# Downloads the latest versions and installs skills to OpenCode, Claude Code,
# Antigravity, and Copilot.
#
# Usage:
#   ./install-skills.sh [--opencode|--claude|--copilot|--all] [--list] [--help]
#
# Install directly:
#   curl -sL https://raw.githubusercontent.com/wcgomes/agents-workspace/main/tools/install-skills.sh | bash

set -euo pipefail

REPO_URL="https://github.com/wcgomes/agents-workspace/archive/refs/heads/main.zip"
REPO_NAME="agents-workspace-main"
AGENCY_REPO_URL="https://github.com/msitarzewski/agency-agents/archive/refs/heads/main.zip"
AGENCY_REPO_NAME="agency-agents-main"
ALL_TOOLS=(opencode claude copilot antigravity)

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
Usage: install-skills.sh [options]

Options:
  --opencode      Install only for OpenCode
  --claude        Install only for Claude Code
  --copilot       Install only for Copilot
  --all           Install to all detected tools (default)
  --with-agency   Also install agency-agents (recommended)
  --list          List available skills without installing
  --help          Show this help

Examples:
  install-skills.sh              # Interactive mode
  install-skills.sh --all         # Install to all detected tools
  install-skills.sh --claude      # Install only for Claude Code
  install-skills.sh --all --with-agency   # Install all + agency-agents
  install-skills.sh --list         # List available skills

Install directly:
  curl -sL https://raw.githubusercontent.com/wcgomes/agents-workspace/main/tools/install-skills.sh | bash
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
  local success=true

  case "$tool" in
    antigravity)
      if [[ -d "$agency_dir/integrations/antigravity" ]]; then
        info "Running convert.sh for $tool..."
        if "$agency_dir/scripts/convert.sh" --tool antigravity 2>/dev/null; then
          info "Running install.sh for $tool..."
          "$agency_dir/scripts/install.sh" --tool antigravity --no-interactive 2>/dev/null || success=false
        else
          success=false
        fi
      fi
      ;;
    opencode)
      info "Running convert.sh for $tool..."
      if "$agency_dir/scripts/convert.sh" --tool opencode 2>&1 | grep -v "^$" > /dev/null; then
        info "Running install.sh for $tool..."
        "$agency_dir/scripts/install.sh" --tool opencode --no-interactive 2>/dev/null || success=false
        if [[ -d ".opencode/agents" && -n "$(ls -A .opencode/agents 2>/dev/null)" ]]; then
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
      "$agency_dir/scripts/install.sh" --tool copilot --no-interactive 2>/dev/null || success=false
      ;;
    claude)
      info "Running install.sh for $tool..."
      "$agency_dir/scripts/install.sh" --tool claude-code --no-interactive 2>/dev/null || success=false
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
    echo "  |  Use --with-agency to also install agency-agents |"
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
  local install_agency=false

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --opencode)    selected_tools+=("opencode");    shift ;;
      --claude)      selected_tools+=("claude");       shift ;;
      --copilot)     selected_tools+=("copilot");     shift ;;
      --all)         selected_tool="all";             explicit_all=true; shift ;;
      --with-agency) install_agency=true;             shift ;;
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

  local src="${tmp_dir}/${REPO_NAME}/skills"
  if [[ ! -d "$src" ]]; then
    err "Skills directory not found in agents-workspace archive."
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

  for t in "${selected_tools[@]}"; do
    case "$t" in
      opencode)    our_count_opencode=$(install_opencode_ours "$src")    ;;
      claude)      our_count_claude=$(install_claude_ours "$src")      ;;
      copilot)    our_count_copilot=$(install_copilot_ours "$src")     ;;
      antigravity) our_count_antigravity=$(install_antigravity_ours "$src")   ;;
    esac
  done

  local agency_tmp_zip="${tmp_dir}/agency.zip"

  if $install_agency; then
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
            install_agency_tool "$t" "$agency_dir" || agency_failed+=("$t")
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

  echo "  install-skills.sh:"
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

  if $install_agency; then
    echo ""
    echo "  agency-agents (via install.sh):"
    echo "    (check tool output above for counts)"
  fi
  echo ""
}

main "$@"
