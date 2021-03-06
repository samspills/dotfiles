export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:$PATH
export TERM="screen-256color"
export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -t"

export GOPATH="/usr/local/Cellar/go/1.8/"
export GOBIN=$GOPATH/bin
#export PATH=$PATH:$GOPATH/bin

export TEXBIN="/Library/TeX/texbin"
export PATH=/usr/local/opt/sqlite/bin:$PATH
export PATH=/usr/local/src/anaconda3/bin:$PATH:$GOBIN:$TEXBIN:~/.local/bin
export PATH=/usr/local/share/dotnet:$PATH

export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export PYSPARK_DRIVER_PYTHON="ipython"
