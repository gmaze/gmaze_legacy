#!/bin/sh
#
#  Created by Guillaume Maze on 2008-10-28.
#
echo "Content-type: text/xml"
qstat -u gmaze -f -xml | \
awk '
{
        print $0

}'
