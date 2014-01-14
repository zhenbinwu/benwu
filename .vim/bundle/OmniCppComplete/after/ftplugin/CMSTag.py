#!/usr/bin/python
# encoding: utf-8

# File        : CMSTag.py
# Author      : Ben Wu
# Contact     : benwu@fnal.gov
# Date        : 2014 Jan 13
#
# Description : This script aims to read the BulidFile.xml and generate the
# corresponding tags for the module

import os
import re
import subprocess
import glob


class GetFileList(object):
    def __init__(self):
        self.outfile = open("./include.list", "w+")

    def ReadXML(self):
        file = open("./BuildFile.xml", "r")
        for line_ in file.readlines():
            line = line_.strip()
            #print line
            m = re.match(r"<use   name=\"(.*)\"/>", line)
            if m != None and m.group(1) != None:
                self.GetInterface(m.group(1))

        self.GetIncList(os.environ['PWD'].strip('%s/src' % os.environ['CMSSW_BASE']))

    def GetInterface(self, module):
        if module == "root" or module == "boost":
            return
        #out = subprocess.Popen("git cms-addpkg %s/interface" % module, shell=True, stdout=subprocess.PIPE)
        out = subprocess.Popen("echo %s/interface" % module, shell=True, stdout=subprocess.PIPE)
        for line in out.stdout.readlines():
            self.GetIncList(line.rstrip())

    def GetIncList(self, module):
        base=os.environ['CMSSW_BASE']
        #print ("%s/src/%s" % (home, module))
        flist=glob.glob("%s/src/%s/*h" % (base, module))
        print flist
        for file_ in flist:
            #print file_
            self.outfile.write("%s\r" % file_)


if __name__ == "__main__":
    a = GetFileList()
    a.ReadXML()
#ctags --sort=foldcase --c++-kinds=+p --fields=+iaSm --extra=+q -L cscope.files
