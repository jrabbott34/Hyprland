# Fish shell config

# ── Aliases ────────────────────────────────────────────────────────────────────
alias c='clear'
alias ff='fastfetch'

# ── Fastfetch on terminal launch ───────────────────────────────────────────────
# Only run in interactive sessions, not scripts
if status is-interactive
    fastfetch
end
