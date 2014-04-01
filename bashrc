# Homebrew
export PATH=~/.bin:/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:$PATH

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
alias rr="rbenv rehash"

# https://github.com/mxcl/homebrew/issues/14527
export PGHOST=localhost

# Don't remember why I used ./bin. Commenting for now.
#export PATH="./bin:$PATH"

# Add ./script and bundler binstubs to the PATH but only if they've been
# greenlighted: mkdir .git/this-is-okay-for-the-path
# NOTE: Add _after_ rbenv. If added before, rbenv will have preference.
export PATH="./.git/this-is-okay-for-the-path/../../vendor/bundle/bin:$PATH"
export PATH="./.git/this-is-okay-for-the-path/../../script:$PATH"

export DISPLAY=:0.0
export EDITOR="vim"
export VISUAL="vim"
export GEM_EDITOR="vim"
export CC=/usr/local/bin/gcc-4.2

# Colors ----------------------------------------------------------
export TERM=xterm-256color
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
export CLICOLOR=1

# Use vim-like keybindings
set -o vi

alias C="clear"

# ls with colors
alias ls='ls -G'
alias ll='ls -l'
alias la='ls -al'

# Serve the current directory. Defaults to port 9090.
# Usage:
#   $ serve
#   $ serve 1234
function serve {
  port="${1:-9090}"
  ruby -run -e httpd . -p $port
}

# git shortcut with useful default. When used with arguments, simply pass
# along to `git` as normal. With no arguments, show the working tree status.
# Usage:
#   $ g
#   $ g checkout my-branch
function g {
  if [[ $# > 0 ]]; then
    git "$@"
  else
    git status --short --branch
  fi
}

# git workflow aliases
alias push='git push'
alias pull='git pull'
alias fetch='git fetch --all --prune'
alias churn='git --no-pager log --name-only | grep -F .rb | sort | uniq -c | sort -nr | head'

# Quickly commit a dependency bump to git.
# Usage:
#   $ bump rails
bump()
{
  git commit -m "Bump $@ dependency"
}

# Rails
alias r='rails'

# Bundler
alias b='bundle'
alias be='bundle exec'
alias bi='bundle install --standalone'
alias bu='bundle update'
alias bo='bundle open'

# Heroku
alias h='heroku'
alias hc='heroku run console -a '
alias f='foreman'

alias pt='papertrail'

# Tests
alias sspec='git ls-files spec | selecta | xargs rspec'

# Some services
alias mem="memcached -d"
alias post="pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start"
alias post_stop="pg_ctl -D /usr/local/var/postgres stop -s -m fast"

# Remove the generated _site directory and start the Jekyll server.
alias jek="rm -rf _site && LC_ALL=en_US.UTF-8 bundle exec jekyll serve --watch --safe --drafts"
alias jekbg="jek 1>/dev/null 2>/dev/null &"

# QuickLook an image
alias ql='qlmanage -p 2>/dev/null'

# Quick way to rebuild the Launch Services database and get rid of duplicates
# in the Open With submenu.
# http://www.leancrew.com/all-this/2013/02/getting-rid-of-open-with-duplicates/
alias fixopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder'

# Load the git prompt script.
source ~/.git-prompt

# Load git autocompletion script.
source /usr/local/etc/bash_completion.d/git-completion.bash
source /usr/local/etc/bash_completion.d/hub.bash_completion.sh

# Homebrew completion
source /usr/local/Library/Contributions/brew_bash_completion.sh

# Allow <C-s> to pass through to applications (vim, reverse search through
# history, etc) instead of stopping output.
stty -ixon -ixoff
