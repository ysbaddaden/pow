#! /usr/bin/env bash

# detects the correct path of current script
cd `dirname $0`
POW_ROOT=`dirname $(pwd -P)`

POW_BIN="$POW_ROOT/bin/`basename $0`"
NODE_PATH="$POW_ROOT/node_modules:$NODE_PATH"

export NODE_PATH POW_BIN

# loads user config if available
if [ -f ~/.powconfig ] ; then
  source ~/.powconfig
fi

# loads RVM if available
if [ -f ~/.rvm/scripts/rvm ] ; then
  source ~/.rvm/scripts/rvm
elif [ -f /usr/local/rvm/scripts/rvm ] ; then
  source /usr/local/rvm/scripts/rvm
fi

# kills any running instance
PID=`ps x | awk -F " " "{ if ( \\$5 == \\"node\\" && \\$6 == \\"$POW_ROOT/lib/command.js\\" ) print \\$1 }"`
[ "$PID" == "" ] || kill $PID

# starts instance
exec "node" "$POW_ROOT/lib/command.js" $*

