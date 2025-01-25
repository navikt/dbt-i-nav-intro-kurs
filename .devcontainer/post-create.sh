#!/usr/bin/env bash

pip3 install --user -r requirements.txt

npm install --prefix ~/.local/share/vscode-sqltools/ duckdb-async@0.10.2
