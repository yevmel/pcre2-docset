#!/usr/bin/env bash

PCRE2_HOME=$1
if [ ! -d "$PCRE2_HOME" ]; then
    PCRE2_HOME=$(pwd)
fi

echo "[i] PCRE2_HOME=$PCRE2_HOME"
for filename in `ls $PCRE2_HOME/doc/html | grep pcre2_`; do
    _NAME="${filename%.*}"
    _TYPE="Function"
    _PATH="${_NAME}.html"
    _SQL="INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES ('$_NAME', '$_TYPE', '$_PATH')"
    _DB="$PCRE2_HOME/.docset/Contents/Resources/docSet.dsidx"

    sqlite3 "$_DB" "$_SQL"
done
