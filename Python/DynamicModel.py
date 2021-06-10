import sys
import re
import os

# 获取文件内容
def readFileContent(path):
    f = open(path, 'r')
    lines = f.readlines()

    f.close()

    all_str = ''
    for line in lines:
        all_str = all_str + line

    return all_str


# 查找指定后缀名的文件
def findSpecFilePathList(suffixString):
    path = sys.argv[1]

    list = []
    for root, dirs, files in os.walk(path):
        for fileName in files:
            if fileName.endswith(suffixString, 0, len(fileName)):
                path = root + '/' + fileName
                list.append(path)
    return list

# 根据输入的路径获取目录
def getDir(path):
    return os.path.dirname(path)

def getInterfaceContent(content):
    reg = r'@interface.*?@end'
    return re.findall(reg, content, re.S)

def getDynamicString(interfaceContent):
    lines = interfaceContent.splitlines()
    reg = r"(\w+(?=;))"
    resultString = "@dynamic "
    for line in lines:
        ivarNameList = re.findall(reg,line)
        if len(ivarNameList) > 0:
            ivarName = ivarNameList[0]
            resultString = resultString + ivarName + ','

    resultString = replaceLastChar(resultString,";")

def getClassName(interfaceContent):
    reg = r"@interface(.+?):"
    classNameList = re.findall(reg, interfaceContent)
    if len(classNameList) > 0:
        return classNameList[0].strip()
    return ""


# 替换字符串尾部字符
def replaceLastChar(string,replaceChar):
    sList = list(string)
    sList[len(sList)-1] = replaceChar
    return "".join(sList)

# 将全新的内容写入空的文件
def writeFileContent(path,fileContent):
	f = open(path,'w')
	f.write(fileContent)
	f.close()

def writeDynamicString(path,className,DynamicString):
    f = open(path, 'r')
    reg = r"@implementation(\s+)" + className
    lines = f.readlines()
    lineNum = 0
    for lintStr in lines:
        lineNum = lineNum + 1
        list = re.findall(reg, lintStr)
        if len(list) > 0:
            break
    f.close()
    lines.insert(lineNum, DynamicString)  # 在第 findLine+1 行插入

    newContent = list2String(lines)
    print(newContent)
    writeFileContent(path,newContent)

def list2String(list):
    result = ""
    for string in list:
        try:
            result = result + string
        except:
            pass

    return result

if __name__ == '__main__':
    modelPathList = findSpecFilePathList('Model.h')
    for path in modelPathList:
        hFileContent = readFileContent(path)
        interfaceStringList = getInterfaceContent(hFileContent)
        for interfaceString in interfaceStringList:
            dynamicString = getDynamicString(interfaceString)
            className = getClassName(interfaceString)
            path = replaceLastChar(path,"m")
            # mFileContent = readFileContent(path)
            writeDynamicString(path,className,dynamicString)



