# filesystem
alias confirm="read -n 1 -s -r -p \"Press any key to continue\""
cdl() { cd "$@" && ls; }

# network
assasinate() { kill $(lsof -t -i:$1); }

#vim
export EDITOR=vim
alias vim="vim -S ~/.vimrc"

#git
remote_origin_url() {
  with_suffix="$(git config --get remote.origin.url)"
  echo ${with_suffix%%.git}
}
open_github() {
  open $(remote_origin_url)/blob/master/$1
}
pr() {
  open $(remote_origin_url)/pull/$(current_git_branch)
}
current_git_branch() {
  if git branch > /dev/null 2>&1
  then
    git branch | grep \* | cut -d ' ' -f2
  else
    echo "no repo"
  fi
}
get_diffed_files() {
  git status -s | grep "^[M,??,A]" | cut -c 4-
}
git_tour() {
  if [ -a ".git" ]
  then
    for file in $(get_diffed_files); do
      echo $file
      vim $file
    done
  else
    echo "no repo"
  fi
}
test_git_dirty() {
  git diff-index --quiet HEAD --
}
gbr() {
  echo "Are you sure that all important branches have been pushed to remote?"
  confirm
  git branch | grep -v "master" | xargs git branch -D
}
alias branch_commits="git rev-list --count HEAD ^master | bc"
alias gad="git add"
alias gck="git checkout"
alias git_branch_nuke="git branch --merged | grep -v \"\*\" | grep -v \"master\" | xargs -n 1 git branch -d"
alias gcm="git commit"
alias gpl="git pull"
alias dpl="dev open pr"
alias gst="git status"
alias gpsh="git push origin HEAD"
alias gpshf="git push --force-with-lease origin HEAD"
alias gcp="git cherry-pick"
gckb() {
  echo $(current_git_branch)
	if [[ $(current_git_branch) = "master" ]]
	then
    git checkout -b $1
  else
		echo 'go get master and pull first'
  fi
}
gcmf() {
	if [[ $(current_git_branch) = "master" ]]
	then
		echo 'get off master'
	else
		gad -A
		gst
		confirm
		if [[ $(branch_commits) -ge 1 ]]
		then
			git commit --amend --no-edit
		else
			git commit
		fi
		confirm
		gpshf
	fi
}
source ~/git-completion.bash

# ag
alias agf='find . | grep'
agr() {
  ag "$1"
  confirm
  ag -0 -l "$1" | AGR_FROM="$1" AGR_TO="$2" xargs -0 perl -pi -e 's/$ENV{AGR_FROM}/$ENV{AGR_TO}/g'
  echo "\n"
  ag "$2"
}
agfr() {
  find . -exec rename -n "s/$1/$2/g" {} +
  confirm
  find . -exec rename "s/$1/$2/g" {} +
  echo "\n"
  agf $2
}

# dev tools
if [[ -f /opt/dev/dev.sh ]]; then source /opt/dev/dev.sh; fi
railsql() {
  mysql -h $1.railgun -u root
}

# ps1
makePS1() {
  GREEN="\033[0;32m"
  NC="\033[0m"
  MONKEY="🐒"
  GIT_DIRTY="📝"
  GIT_CLEAN="✅"
  GIT_UNKNOWN="❓"

  DATE=$(date +%k:%M)
  DIR_NAME=$(basename $PWD)
  # TODO fix color text
  BASE="($DATE)"

  if git rev-parse --is-inside-work-tree > /dev/null 2>&1 ; then
    REPO_PATH=$(git rev-parse --show-toplevel)
    REPO_NAME=$(basename $REPO_PATH)
    CURRENT_BRANCH=$(current_git_branch)
    BASE="$BASE $REPO_NAME::$CURRENT_BRANCH"

    if test -d .git; then
      BASE="$BASE"
    else
      BASE="$BASE::$DIR_NAME"
    fi

    STATUS_MESSAGE=$(git status -s)
    if test ${#STATUS_MESSAGE} -eq 0; then
      BASE="$BASE $GIT_CLEAN"
    else
      BASE="$BASE $GIT_DIRTY"
    fi

    #if test -d .git; then
      #BASE="$BASE"
    #else
      #BASE="$BASE"
    #fi
  else
    BASE="$BASE$DIR_NAME $GIT_UNKNOWN"
  fi

  BASE="$BASE $ "

  echo "$BASE"
}
export PS1="\$(makePS1)"

#Shopify
SCRIPTS_PLATFORM=true
alias checkout1="BETA=checkout_one bin/rake dev:betas:enable"
alias checkout0="BETA=checkout_one bin/rake dev:betas:disable"
SHOW_RUNTIME_CLIENT_ERRORS=1

#Node
alias npmrefresh="rm -rf node_modules && rm package-lock.json && npm install"
