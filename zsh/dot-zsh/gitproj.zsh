# Fuzzy-find any git repo under ~/git and cd into it
# Layout assumed: ~/git/<platform>/<owner>/<repo>

gitproj() {
  local root=${GIT_PROJ_ROOT:-"$HOME/git"}
  local -a repos choices
  local selection

  # Find git repos at depth: $root/<platform>/<owner>/<repo>/.git
  repos=($root/*/*/*/.git(N:h))

  if (( ${#repos} == 0 )); then
    echo "No git repos found under $root"
    return 1
  fi

  # Show paths relative to $root in fzf for nicer display
  choices=(${repos[@]#$root/})

  selection=$(printf '%s\n' "${choices[@]}" | \
    fzf --prompt="git repo > " \
    --preview 'cd '"$root"'/{} && git status -sb 2>/dev/null || echo "Not a git repo"')

  [[ -n "$selection" ]] || return 1

  cd "$root/$selection" || return 1
}
