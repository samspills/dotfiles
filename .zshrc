source ~/antigen.zsh
antigen use oh-my-zsh

#antigen bundle git
antigen bundle colored-man-pages
antigen bundle colorize
#antigen bundle github
#antigen bundle jira
#antigen bundle vagrant
antigen bundle virtualenvwrapper
antigen bundle pip
antigen bundle python
antigen bundle brew
antigen bundle osx
#antigen bundle edthedev/minion
#antigen bundle emacs
#antigen bundle emacsclient

antigen theme https://github.com/VidalChavez/pygmalion.git --loc=pygmalion

antigen apply

#alias ec='emacsclient'
function ec() { emacsclient $1 & }
function jql() { jq -C "." <$* | less; }
function cowfig() {figlet "$*" | cowsay -n}
function cpcowfig() {figlet "$*" | cowsay -n | pbcopy}
function agp() {ag --py $*}
function gitsync() {rsync -t $(git diff --name-only) --relative $1}
function luigiui() {open -a "Google Chrome" $(plumb --host dev-magnezone-$1-1.rubikloudcorp.com status $2 | jq -r '.owner_public_ip' | awk ' {print "http://" $0 ":8082"} ')}
function jn() {open -a "Google Chrome" "http://localhost:$1/tree?"}
function jigh() {jig --host dev-configapi.rubikloudcorp.com $*}
function plumbh() {plumb --host dev-magnezone.rubikloudcorp.com $*}
function plumbh-log() {plumbh log $1 stdout > log && vim log}
function date() {gdate $*}
function lithium-jupyter() {scp spillsworth@lithium:/home/spillsworth/.run/current_kernel.json . && jupyter console --existing ./current_kernel.json --ssh lithium}
function saws() {aws ec2 ${1}-instances --instance-ids i-01a4312b35d89399c  --region eu-west-1}

function s3fstoken() {
    aws-vault exec --no-session --assume-role-ttl 12h ${1:-default} -- python -c 'import os; print("""s3 = s3fs.S3FileSystem(key="{}", secret="{}", token="{}")""".format(os.getenv("AWS_ACCESS_KEY_ID"), os.getenv("AWS_SECRET_ACCESS_KEY"), os.getenv("AWS_SESSION_TOKEN")))'
}
function s3atoken() {
    aws-vault exec --no-session --assume-role-ttl 12h ${1:-default} -- python -c 'import os; print("""
hadoop_conf.set("fs.s3a.aws.credentials.provider", "org.apache.hadoop.fs.s3a.TemporaryAWSCredentialsProvider")
hadoop_conf.set("fs.s3a.access.key", "{}")
hadoop_conf.set("fs.s3a.secret.key", "{}")
hadoop_conf.set("fs.s3a.session.token", "{}")
""".format(os.getenv("AWS_ACCESS_KEY_ID"), os.getenv("AWS_SECRET_ACCESS_KEY"), os.getenv("AWS_SESSION_TOKEN")))'
}

# doesn't work yet
#function emojifig() {figlet -f 3x5 $1 | sed 's/^/ /g' | awk '{if (NR == 1) {h = $0}} {print $0} END {print h}' | sed 's/#/$2/g' | sed 's/ /$3/g' | pbcopy}

export GTAGSLABEL=pygments
export EDITOR=ec

alias l='ls -lhFu'
alias tmux="tmux -2 -u"
alias zshconfig="ec ~/.zshrc"
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

bindkey -v
KEYTIMEOUT=1

setopt CORRECT

# History options
HISTSIZE=10000000
SAVEHIST=10000000
setopt inc_append_history
setopt share_history
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.

if [[ "$TERM" == "dumb" ]]
then
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    unfunction precmd
    unfunction preexec
    PS1='$ '
fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source ~/.zshenv
