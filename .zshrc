source /etc/zsh/zshrc.default.inc.zsh

function  uuid {
  echo "require 'securerandom'; puts SecureRandom.uuid" | irb | sed -n '3 p' | pbcopy
}