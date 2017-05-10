#-*- encoding=utf-8 -*- 

import os

def update():
    return gitReset() and gitPull()
    # return gitPull()

def gitReset():
    command = 'git reset --hard'
    if os.system(command) != 0:
        print("%s fail !" % (command))
        return False
    return True

def gitPull():
    command = 'git fetch origin'
    if os.system(command) != 0:
        print("%s fail !" % (command))
        return False
    return True