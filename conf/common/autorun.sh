#!/bin/bash

cd /local/content/cdecurate/bin;
find ../filecache -mtime +2 -exec rm {} \;
