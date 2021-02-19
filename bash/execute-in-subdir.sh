#!/bin/bash
# execute-in-subdir 'command1 && command2'

ls -1 --directory */ | xargs --replace={} sh -c "cd '{}' && $*"
