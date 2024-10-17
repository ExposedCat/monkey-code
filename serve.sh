#!/bin/bash

cp -r static dist

python serve.py --root ./dist --no-browser
