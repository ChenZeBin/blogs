#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os
import re
from tempfile import mkstemp
from shutil import move, copymode
from os import fdopen, remove
import json

# ROOT_PATH = "/Users/bytedance/code.byted/IESLiveKit/IESLiveKit/"
# ROOT_PATH = "/Users/bytedance/workzone/iOS/IES/IESLiveKit/IESLiveKit/"
# ROOT_PATH =  "/Users/bytedance/code.byted/MBox/AwemeMBOX/AWELive/AWELive/"
ROOT_PATH = "/Users/bytedance/Desktop/IESLiveKit"
XLIVELINK_COUNT = {}
XLIVEBIND_COUNT = {}
ALL_INFOS = {}
REPLACE_COUNT = 0
ALL_LINES = []
DELET_LIST = ['IESLiveSettings','IESLiveTracker', 'IESLiveUserService', 'HTSLiveViewHierarchyProvider','IESLiveToastFactory', 'HTSKVStore','HTSLivePluginLayoutMachineProvider','IESLiveAlertFactory', 'IESLiveRoomService','HTSLiveToolbarProvider', 'IESLiveWebImageService',   'IESLiveEnvironment','IESLiveAppInfo', 'IESLiveHTTPClient',
'IESLiveGiftModule','IESLiveEffectConflictHelper','IESLivePerfSampler','IESLiveTapAction','IESLiveDebugService','IESLivePerfSampler','IESLiveFullLinkMonitor','HTSLiveAnchorActions','IESLiveVideoEffectProcessing','HTSLiveAudienceActions','HTSLiveAppLifeCycleActions','IESLiveReference','IESLiveMTScreenCastService','IESLivePerfSampler',
'IESLiveFullLinkMonitor','HTSLiveNetworkStatusActions','HTSLiveAudienceActions','HTSLiveRoomRemoteActions','IESLiveContainerRouter','IESLiveAudienceRoomAwareness','IESLiveAudienceRoomAwareness','IESLivePushStreamLifeCycle','IESLiveEffectProcessLifyCycle','IESLiveRecoderFactory','IESLiveContainerRouter']

class StatisticsModel(object):

    def __init__(self, className):
        super(StatisticsModel, self).__init__()
        self.className = className
        self.propertyDels = {}
        self.getterDels = {}
        self.usedInstanceVariables = []
    
    def __str__(self):
        return str({
            "className": self.className,
            "propertyDels": self.propertyDels,
            "getterDels": self.getterDels,
            "usedInstanceVariables": self.usedInstanceVariables
        })
        
    __repr__ = __str__

def toDict(obj):
    return {
        "className": obj.className,
        "propertyDels": obj.propertyDels,
        "getterDels": obj.getterDels,
        "usedInstanceVariables": obj.usedInstanceVariables
    }
    
    
def matchAtInterface(line):
    match = re.match(r'@interface\s(\w+)\s*\(.*\)', line) 
    if match:
        return match.group(1)

def matchAtImplementation(line):
    match = re.match(r'@implementation\s+(\w+)', line)
    if match:
        return match.group(1)

def matchAtEnd(line):
    match = re.match(r'@end', line) 
    if match:
        return match.group(0)

def matchAtPropertyWithProtocol(line):
    match = re.match(r'@property\s*\(.+\)\s*id.*<(\w+)>\s+(\w+).*;', line) 
    if match:
        return (match.group(2),match.group(1))

def matchXLiveLink(line):
    match = re.match(r'XLiveLink\s*\(\s*(\w+)\s*,\s*(\w+)\s*\)', line) 
    if match:
        return (match.group(1),match.group(2))

def matchUseGetter(line):
    match = re.findall(r'(self\.(\w+))', line) 
    return match

def matchUseInstanceVariable(line):
    match1 = re.match(r'[^\w]+_(\w+)((\.)|(\s*=)|(\s+.+]))', line) 
    match2 = re.match(r'.*self\.(\w+)\s*=', line)
    if match1:
        return match1.group(1)
    if match2:
        return match2.group(1)

def statisticsAllClassInfo():
    for dirpath, dirnames, filenames in os.walk(ROOT_PATH):
        for filename in filenames:
            filepath = os.path.join(dirpath, filename)
            name, fileExt = os.path.splitext(filepath)
            # print(filename)
            # print(filepath)
            if fileExt in [".h", ".m", ".mm"]:
                statisticsXLiveLinkCountForFile(filepath)
                statisticsXLiveBindCountForFile(filepath)
                statisticsClassInfoForFile(filepath)
                # statisticsAllLineForFile(filepath)

def statisticsClassInfoForFile(filepath):
    with open(filepath, 'r') as f:
        currentClassInterface = None
        currentClassImplementation = None
        line = f.readline()
        lineNumber = 1
        while line:
            interfaceResult = matchAtInterface(line)
            implementationResult = matchAtImplementation(line)
            propertyWithProtocol = matchAtPropertyWithProtocol(line)
            getterWithProtocol = matchXLiveLink(line)
            if matchAtEnd(line):
                currentClassImplementation = None
                currentClassInterface = None
            elif interfaceResult:
                currentClassInterface = interfaceResult
            elif implementationResult:
                currentClassImplementation = implementationResult
            elif propertyWithProtocol and currentClassInterface:
                if currentClassInterface not in ALL_INFOS:
                    model = StatisticsModel(currentClassInterface)
                    ALL_INFOS[currentClassInterface] = model
                ALL_INFOS[currentClassInterface].propertyDels[propertyWithProtocol[0]] = propertyWithProtocol[1]                        
            elif getterWithProtocol and currentClassImplementation:
                if currentClassImplementation not in ALL_INFOS:
                    model = StatisticsModel(currentClassImplementation)
                    ALL_INFOS[currentClassImplementation] = model
                ALL_INFOS[currentClassImplementation].getterDels[getterWithProtocol[0]] = getterWithProtocol[1] 
            if currentClassImplementation:
                instanceVariable = matchUseInstanceVariable(line)
                if instanceVariable:
                    if currentClassImplementation not in ALL_INFOS:
                        model = StatisticsModel(currentClassImplementation)
                        ALL_INFOS[currentClassImplementation] = model
                    ALL_INFOS[currentClassImplementation].usedInstanceVariables.append(instanceVariable) 
            line = f.readline()
            lineNumber = lineNumber + 1
            
def replaceXLiveLinkAndProperty():
    for dirpath, dirnames, filenames in os.walk(ROOT_PATH):
        for filename in filenames:
            filepath = os.path.join(dirpath, filename)
            name, fileExt = os.path.splitext(filepath)
            if fileExt in [".h", ".m", ".mm"]:
                replaceXLiveLinkAndPropertyFile(filepath)
    print("REPLACE_COUNT: ",REPLACE_COUNT)
    

def replaceXLiveLinkAndPropertyFile(filepath):
    readAll = []
    with open(filepath, 'r') as f:
        currentClassInterface = None
        currentClassImplementation = None
        line = f.readline()
        lineNumber = 1
        while line:
            interfaceResult = matchAtInterface(line)
            implementationResult = matchAtImplementation(line)
            propertyWithProtocol = matchAtPropertyWithProtocol(line)
            getterWithProtocol = matchXLiveLink(line)
            useGetters = matchUseGetter(line)

            # if "self.settings" in line:
            #     print(line)
            #     print(interfaceResult)
            #     print(implementationResult)
            #     print(propertyWithProtocol)
            #     print(getterWithProtocol)
            #     print(useGetters)
            #     print(currentClassInterface)
            #     print(currentClassImplementation)

            if matchAtEnd(line):
                currentClassImplementation = None
                currentClassInterface = None
            elif interfaceResult:
                currentClassInterface = interfaceResult
            elif implementationResult:
                currentClassImplementation = implementationResult
            elif propertyWithProtocol and currentClassInterface and currentClassInterface in ALL_INFOS:
                propertyDels = ALL_INFOS[currentClassInterface].propertyDels
                getterDels = ALL_INFOS[currentClassInterface].getterDels
                usedInstanceVariables = ALL_INFOS[currentClassInterface].usedInstanceVariables
                if propertyWithProtocol[0] in propertyDels and propertyWithProtocol[0] in getterDels and propertyWithProtocol[0] not in usedInstanceVariables and propertyDels[propertyWithProtocol[0]] == getterDels[propertyWithProtocol[0]]:
                    if propertyWithProtocol[1] in DELET_LIST:
                        line = line.replace(line,"")
            elif getterWithProtocol and currentClassImplementation and currentClassImplementation in ALL_INFOS:
                propertyDels = ALL_INFOS[currentClassImplementation].propertyDels
                getterDels = ALL_INFOS[currentClassImplementation].getterDels
                usedInstanceVariables = ALL_INFOS[currentClassImplementation].usedInstanceVariables
                if getterWithProtocol[0] in propertyDels and getterWithProtocol[0] in getterDels and getterWithProtocol[0] not in usedInstanceVariables and propertyDels[getterWithProtocol[0]] == getterDels[getterWithProtocol[0]]:
                    if getterWithProtocol[1] in DELET_LIST:
                        line = line.replace(line,"")
                        global REPLACE_COUNT
                        REPLACE_COUNT = REPLACE_COUNT + 1
            elif useGetters and currentClassImplementation and currentClassImplementation in ALL_INFOS:
                propertyDels = ALL_INFOS[currentClassImplementation].propertyDels
                getterDels = ALL_INFOS[currentClassImplementation].getterDels
                usedInstanceVariables = ALL_INFOS[currentClassImplementation].usedInstanceVariables
                for useGetter in useGetters:
                    if useGetter[1] in propertyDels and useGetter[1] in getterDels and useGetter[1] not in usedInstanceVariables and propertyDels[useGetter[1]] == getterDels[useGetter[1]]:
                        if getterDels[useGetter[1]] in DELET_LIST:
                            replace = "XLiveLinkInline(" + getterDels[useGetter[1]] + ")"
                            if useGetter[0] in line:
                                index = line.index(useGetter[0])
                                nextChar = line[index+len(useGetter[0])]
                                if re.match("[^\w]",nextChar):
                                    line = line.replace(useGetter[0]+nextChar,replace+nextChar)
                            
            readAll.append(line)
            line = f.readline()
            lineNumber = lineNumber + 1

        with open(filepath, 'w') as f:
            f.writelines(readAll)

def statisticsXLiveLinkCountForFile(filepath):
    with open(filepath, 'r') as f:
        moduleBeginLineNum = 0
        line = f.readline()
        lineNumber = 1
        while line:
            match = re.match(r'XLiveLink *\( *(\w+) *, *(\w+) *\)', line)
            if match:
                propertyName = match.group(1)
                protocolName = match.group(2)
                if protocolName in XLIVELINK_COUNT:
                    XLIVELINK_COUNT[protocolName] = XLIVELINK_COUNT[protocolName] + 1
                else:
                   XLIVELINK_COUNT[protocolName] = 1 
            line = f.readline()
            lineNumber = lineNumber + 1


def statisticsAllLineForFile(filepath):
	# if 'IESLivePushStreamConfigService' in filepath:
	with open(filepath, 'r') as f:
		print('正在将所有文件内容整合到一个数组中.....')
		lines = f.readlines()
		global ALL_LINES
		ALL_LINES = ALL_LINES + lines;


def statisticsXLiveBindCountForFile(filepath):
    with open(filepath, 'r') as f:
        line = f.readline()
        while line:
            # print(line)
            match = re.match(r'.*XLiveBind *\( *(\w+) *, *(\w+) *\)', line)
            if match:
                # print(match)
                propertyName = match.group(1)
                protocolName = match.group(2)
                if protocolName in XLIVEBIND_COUNT:
                    XLIVEBIND_COUNT[protocolName] = XLIVEBIND_COUNT[protocolName] + 1
                else:
                   XLIVEBIND_COUNT[protocolName] = 1 
            line = f.readline()

def showXLiveLinkCountDetail():
    print(len(XLIVELINK_COUNT))
    protocols = map(lambda x: (x, XLIVELINK_COUNT[x]),list(XLIVELINK_COUNT))
    protocols.sort(key=lambda x: x[1],reverse=True)
    # print sum(map(lambda x: x[1], protocols))
    for item in protocols:
        print(item)

def showXLiveBindCountDetail():
    print(len(XLIVEBIND_COUNT))
    protocols = map(lambda x: (x, XLIVEBIND_COUNT[x]),list(XLIVEBIND_COUNT))
    protocols.sort(key=lambda x: x[1],reverse=True)
    for item in protocols:
        print('find protocols:',item[0])

    for _bind in XLIVEBIND_COUNT:
    	# print('czbTest:%s',_bind)
        DELET_LIST.append(_bind)
    print(DELET_LIST)

# 搜索provide+协议名，搜不到加入到DELET_LIST
def showProvideServiceDetail():
    print(len(XLIVEBIND_COUNT))
    # 获取所有的协议名
    protocols = map(lambda x: (x, XLIVELINK_COUNT[x]),list(XLIVELINK_COUNT))
    protocols.sort(key=lambda x: x[1],reverse=True)
    # 遍历每个协议名去全文搜索有没有provide+协议名，如果没有搜到，就可以替换
    for item in protocols:
        provideStr = '- (id<%s>)provide%s\n' % (item[0],item[0])
        print('provideStr:',provideStr)
        print('find protocols:',item[0])
        if provideStr not in ALL_LINES:
        	print('not provide method:',provideStr)
        	print('protocal:',item[0])
        	DELET_LIST.append(item[0])

def showAllClassInfos():
    print(ALL_INFOS)

def laihuole():
    statisticsAllClassInfo()
    showXLiveBindCountDetail()
    # showProvideServiceDetail()
    showXLiveLinkCountDetail()
    # showAllClassInfos()
    # 去重
    global DELET_LIST
    DELET_LIST = list(set(DELET_LIST))

    # 删除lint不过的
    DELET_LIST.remove('IESLiveBeautySyncService')

    print('delete arr:',DELET_LIST)
    replaceXLiveLinkAndProperty()

if __name__ == "__main__":
	laihuole()
    # with open("/Users/bytedance/Desktop/a.json", 'w') as f:
    #     f.write(json.dumps(ALL_INFOS, default=toDict))
    