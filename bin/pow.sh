#! /bin/sh

cd `dirname $0`

POW_ROOT=`dirname $(pwd -P)`
POW_BIN="$POW_ROOT/bin/`basename $0`"
NODE_PATH="$POW_ROOT/node_modules:$NODE_PATH"

export NODE_PATH POW_BIN
exec "$POW_ROOT/bin/node" "$POW_ROOT/lib/command.js"

