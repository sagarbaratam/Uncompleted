import os
import sys
import fileinput
textToSearch = '1569321000'
textToReplace = '1570779000'
replacetxt = {"1569321000":1569321000,"sagar":1570779000}

loc = '/Users/a1455121/Desktop/Method to madness/python/inplink.txt'
tempFile = open(loc , 'r+')
for line in fileinput.input(loc):
    if replacetxt.keys() in line :
        tempFile.write( line.replace(key,value) )

tempFile.close()



