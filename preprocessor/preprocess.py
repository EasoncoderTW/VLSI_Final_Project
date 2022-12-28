#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys


def parse(line):
    backupLen = len(line)
    # remove leading spaces
    line = line.lstrip() 
    # leading space len for alignment
    leadSpaceLen = backupLen - len(line) 
    # remove trailing newline
    line = line.strip('\n')
    res = line.split('#', 1)
    str = ''
    code = res[0].rstrip()
    if code == 'ret':
        code = 'jalr x0, 0(ra)'
    if(len(res) == 2): # contains '#' in line
        comments = '#' + res[1]
        str = ' ' * leadSpaceLen + comments
        if(code): # comment + code
            str += '\n'
            str += ' ' * leadSpaceLen + code
            # remove trailing spaces
            # str += '\n' # Minor improve readability

    else:   # code only
        str = ' ' * leadSpaceLen + code
    return str

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print(f'Usage: python3 ./{sys.argv[0]} $fileIn $fileOut')
        sys.exit()
    fi = open(sys.argv[1], 'r')
    fo = open(sys.argv[2], 'w')
    Lines = fi.readlines()
    for line in Lines:
        print(parse(line), file=fo)