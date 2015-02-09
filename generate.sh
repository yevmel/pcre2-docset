#!/usr/bin/env bash

PCRE2_HOME=$1
if [ ! -d "$PCRE2_HOME" ]; then
    PCRE2_HOME=$(pwd)
fi

echo "[i] PCRE2_HOME=$PCRE2_HOME"

_DOCSET_NAME="pcre2.docset"
_DOCS_PATH="$_DOCSET_NAME/Contents/Resources/Documents/"

mkdir -p "$PCRE2_HOME/$_DOCS_PATH"
cp $PCRE2_HOME/doc/html/* "$PCRE2_HOME/$_DOCS_PATH"
cp $PCRE2_HOME/LICENSE $_DOCSET_NAME

_DB="$PCRE2_HOME/.docset/Contents/Resources/docSet.dsidx"

sqlite3 "$_DB" "CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);"
sqlite3 "$_DB" "CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);"

for filename in `ls $PCRE2_HOME/doc/html | grep pcre2_`; do
    _NAME="${filename%.*}"
    _TYPE="Function"
    _PATH="${_NAME}.html"
    _SQL="INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES ('$_NAME', '$_TYPE', '$_PATH')"

    sqlite3 "$_DB" "$_SQL"
done
