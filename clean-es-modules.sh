#!/bin/bash
find ./node_modules -type f -name '*.js' -print0 | xargs -0 sed -i '/Object\.defineProperty(exports, "__esModule", { value: true });/d'
