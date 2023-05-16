# filesystem
alias nuke="ls -A1 | xargs rm -rf"
alias confirm="read -n 1 -s -r -p \"Press any key to continue\""
cdl() { cd "$@" && ls; }

#other?
alias todo="vim /Users/duncanuszkay/todo.txt"
alias imgcat="source ~/imgcat.sh"

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
  open -a ~/../../Applications/Google\ Chrome.app "$(remote_origin_url)/blob/master/$1"
}
pr() {
  open -a ~/../../Applications/Google\ Chrome.app "$(remote_origin_url)/pull/$(current_git_branch)"
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
alias shopify-cli="/Users/duncanuszkay/src/github.com/Shopify/shopify-app-cli/bin/shopify"
railsql() {
  mysql -h $1.railgun -u root
}
alias scripts-cli="shopify-cli script"
export PATH=/Users/duncanuszkay/src/github.com/Shopify/wabt/build:$PATH

# ps1
makePS1() {
  echo "$"
}
export PS1="\$(makePS1)"

# tabletop
export TABLETOP_SAVED_OBJECTS_FOLDER="/Users/duncanuszkay/Library/Tabletop Simulator/Saves/Saved Objects"

#Go
export GOPATH=$HOME
export PATH=$GOPATH/bin:$PATH

export MAGICK_HOME="/usr/local/bin/magick"
export DYLD_LIBRARY_PATH="$MAGICK_HOME/lib/"
export PATH="$MAGICK_HOME/bin:$PATH"

#Rust
export PATH="$HOME/.cargo/bin:$PATH"
if [ -e /Users/duncanuszkay/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/duncanuszkay/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

#Shopify
alias shopify="shopify-cli"
#shopify-cli load-dev /Users/duncanuszkay/src/github.com/Shopify/shopify-cli
PLATFORM_LOCAL="http://script-service.myshopify.io"
ENGINE_LOCAL="http://localhost:8000"
SCRIPTS_PLATFORM=true
alias runplatform="SCRIPT_PROXY_BYPASS=1 DISABLE_SHOPIFY_INTERNAL_API_INTERCEPTOR=1 dev rails"
alias pubvanity="cd /Users/duncanuszkay/src/github.com/Shopify/temp-delete/vanitytest && SHOPIFY_APP_CLI_LOCAL_PARTNERS=1 shopify-cli deploy vanity_pricing vanitytest --api-key=development-storefront-key"
alias pubdiscount="cd /Users/duncanuszkay/src/github.com/Shopify/temp-delete/discounttest && SHOPIFY_APP_CLI_LOCAL_PARTNERS=1 shopify-cli deploy discount_pricing discounttest --api-key=development-storefront-key"
alias pubdiscountl="SHOPIFY_APP_CLI_LOCAL_PARTNERS=1 shopify-cli deploy discount_pricing discounttest --api-key=development-storefront-key"
alias local-as-pect="npx /Users/duncanuszkay/src/github.com/Shopify/as-pect/packages/cli/bin/asp"
alias cdiscount="shopify-cli create script --extension_point=discount"
alias checkout1="BETA=checkout_one bin/rake dev:betas:enable"
alias checkout0="BETA=checkout_one bin/rake dev:betas:disable"
SHOW_RUNTIME_CLIENT_ERRORS=1
deploy_module() {
  asc script.ts -b output.wasm --use abort= --runtime none
  response=$(curl http://localhost:8000/module/ -F bytecode=@output.wasm -F schema=@script.schema --silent)
  export PLAYGROUND_CURRENT_MODULE=$(echo $response | sed 's/{ "hash": "\(.*\)" }/\1/')
  echo $PLAYGROUND_CURRENT_MODULE
}
call_module() {
  curl http://localhost:8000/module/$(echo $PLAYGROUND_CURRENT_MODULE) --data-ascii $1
}

#Node
alias npmrefresh="rm -rf node_modules && rm package-lock.json && npm install"

#UWaterloo
alias cslinux="ssh dmuszkay@linux.student.cs.uwaterloo.ca"
alias ugs="ssh dmuszkay@ugster403.student.cs.uwaterloo.ca"
tocslinux() {
  scp $1 dmuszkay@linux.student.cs.uwaterloo.ca:$2
}
fromcslinux() {
  scp dmuszkay@linux.student.cs.uwaterloo.ca:$1 $2
}

#Wasm
export PATH=$PATH:/Users/duncanuszkay/src/github.com/Shopify/wasmtime/wasmtime/target/release
export PATH=$PATH:/Users/duncanuszkay/src/github.com/Shopify/binaryen/bin

#Graal
export GRAALVM_HOME=/Users/duncanuszkay/src/github.com/Shopify/graal-shopify/sdk/mxbuild/darwin-amd64/GRAALVM_CE_JAVA8_BGRAALVM-NATIVE-CLANG_BGRAALVM-NATIVE-CLANG++_BGRAALVM-NATIVE-LD_BGU_BLLI_BNATIVE-IMAGE-CONFIGURE_GU_LIBPOLY_LLP_NIC_RBY_RBYL_SLG/graalvm-ce-java8-20.0.0-dev/Contents/Home
#export GRAALVM_HOME=/Users/duncanuszkay/src/github.com/Shopify/graal-shopify/vm/mxbuild/darwin-amd64/GRAALVM_TOOLCHAIN_ONLY_BASH_JAVA8_ATS_BJS_BNATIVE-IMAGE_BNATIVE-IMAGE-CONFIGURE_BPOLYGLOT_COV_INS_JS_LG_LIBPOLY_NI_NIL_POLY_PRO_RBY_RBYL_RGX_SNATIVE-IMAGE-AGENT_VVM/graalvm-toolchain-only-bash-java8-19.3.0-dev/Contents/Home

# MongoDB
export PATH=$PATH:~/mongodb/bin

# patchwork
alias server_a="LOG=trace RUST_BACKTRACE=1 PORT=8601 PEER_PORT=8602 cargo run"
alias server_b="LOG=trace RUST_BACKTRACE=1 PORT=8602 PEER_PORT=8601 cargo run"
alias server_a_q="RUST_BACKTRACE=1 PORT=8601 PEER_PORT=8602 cargo run"
alias server_b_q="RUST_BACKTRACE=1 PORT=8602 PEER_PORT=8601 cargo run"

# rust
alias cfix="cargo fix --allow-dirty && cargo fmt"

# ejson
EJSON_KEYDIR=/opt/ejson/keys
export EJSON_KEYDIR=$EJSON_KEYDIR
