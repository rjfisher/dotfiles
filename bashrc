# Homebrew
export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:$PATH

# rbenv
eval "$(rbenv init -)"
alias rr="rbenv rehash"

# Add ./script and bundler binstubs to the PATH but only if they've been
# greenlighted: mkdir .git/this-is-okay-for-the-path
# NOTE: Add _after_ rbenv. If added before, rbenv will have preference.
export PATH="./.git/this-is-okay-for-the-path/../../vendor/bundle/bin:$PATH"
export PATH="./.git/this-is-okay-for-the-path/../../script:$PATH"

export GOPATH=$HOME/.go/
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$HOME/.cabal/bin

# Add my scripts to the front of PATH
export PATH=$HOME/.bin:$PATH

# https://github.com/mxcl/homebrew/issues/14527
export PGHOST=localhost

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_55.jdk/Contents/Home

export DISPLAY=:0.0
export EDITOR="vim"
export VISUAL="vim"
export GEM_EDITOR="vim"
# No idea why this is here.
# export CC=/usr/local/bin/gcc-4.2

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

# Deploy to production Defaults to the current branch.
# Usage:
#   $ pt-ship
#   $ pt-ship my-test-branch
function pt-ship {
  branch="${1:-`current_git_branch`}"
  cap production deploy -s branch=$branch
}

# Deploy to staging. Defaults to the current branch.
# Usage:
#   $ pt-stage
#   $ pt-stage my-test-branch
function pt-stage {
  branch="${1:-`current_git_branch`}"
  cap staging deploy -s branch=$branch
}

# Deploy to production and run migrations. Defaults to the current branch.
# Usage:
#   $ pt-ship-mig
#   $ pt-ship-mig my-test-branch
function pt-ship-mig {
  branch="${1:-`current_git_branch`}"
  cap production deploy:migrations -s branch=$branch
}

# Deploy to staging and run migrations. Defaults to the current branch.
# Usage:
#   $ pt-stage-mig
#   $ pt-stage-mig my-test-branch
function pt-stage-mig {
  branch="${1:-`current_git_branch`}"
  cap staging deploy:migrations -s branch=$branch
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

# Jump to a project using selecta
function prj {
  cd $(find ~/Sites ~/Code -maxdepth 2 -type d | selecta)
}

function vs {
  local VS=$(
    (cat .vs-last 2>/dev/null;
     git ls-files --cached --other --exclude-standard) |
    selecta)
  echo $VS > .vs-last
  vim $VS
}

function gvs {
  vim `git status --porcelain --short | cut -c 2- | grep -e M -e ? -e U | cut -c 3- | selecta`
}

# Run multiple ruby test scripts at once. Arguments will be passed through to
# the `script/exec` command if it exists. Use selecta to pick a file from
# test/ and spec/ if called with no arguments.
#
# Usage:
#   $ rbtest one_test.rb two_test.rb red_test.rb blue_test.rb ...
function rbtest {
  if [[ $# > 0 ]]; then
    if command -v script/exec >/dev/null 2>&1; then
      script/exec "$@"
    else
      echo "ruby -Ivendor/bundle -Itest -Ilib -e 'ARGV.each {|f| require \"./#{f}\" }' \"$@\"\n"
      ruby -Ivendor/bundle -Itest -Ilib -e 'ARGV.each {|f| require "./#{f}" }' "$@"
    fi
  else
    local RBTEST=$(
      (cat ~/.rbtest 2>/dev/null;
       git ls-files --cached --other --exclude-standard test spec) |
      grep .rb$ |
      selecta)
    echo $RBTEST > ~/.rbtest
    echo
    rbtest $RBTEST
  fi
}

# Run multiple ruby test scripts at once using `rbtest` and be notified on
# completion.
#
# Usage:
#   $ ntest one_test.rb two_test.rb ...
function ntest {
  if rbtest "$@"; then
    osascript -e 'display notification "(•̀ᴗ•́)و ̑̑" with title "Win" sound name "Purr"'
  else
    osascript -e 'display notification "(ಥ﹏ಥ)" with title "Fail" sound name "Basso"'
  fi
}

alias alert="osascript -e 'display notification \"ᕕ( ᐛ )ᕗ\" with title \"Done!\" sound name \"Ping\"'"

# Quickly commit a dependency bump to git.
# Usage:
#   $ bump rails
#   $ bump rails 2.3.1
function bump {
  if [[ $2 ]]; then
    git commit -m "Bump $1 dependency to $2"
  else
    git commit -m "Bump $1 dependency"
  fi
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

# Remove the generated _site directory and start the Jekyll server.
alias jek="rm -rf _site && LC_ALL=en_US.UTF-8 bundle exec jekyll serve --watch --safe --drafts"
alias jekbg="jek 1>/dev/null 2>/dev/null &"

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
