import sys
import re
import os
# 继承MTLModel
canReplaceClassList = ["MTLModel","IESLiveECommerceBaseApiModel","HTSLiveFeedRoomItem","IESLiveStampBaseModel",
                       "IESVSFansGroupEntryInfoModel","IESLiveFansGroupEntryInfo",
                       "IESLiveAnchorCommercialComponentBaseModel","IESLiveCommonGuideModel"]
# 类是Model或者Info后缀，并且继承NSObject
canReplaceSuffixClassNameList = ["Model","Info","HTSLiveFeedRoomItem"]
cannotModifyList = ["ViewModel","ClassName"]
willReplaceClassDic = {"NSObject":"IESLiveDynamicModel","MTLModel":"IESLiveDynamicMTLModel",
                       "IESLiveECommerceBaseApiModel":"IESLiveECommerceBaseApiModel","HTSLiveFeedRoomItem":"HTSLiveFeedRoomItem",
                       "IESLiveStampBaseModel":"IESLiveStampBaseModel","IESVSFansGroupEntryInfoModel":"IESVSFansGroupEntryInfoModel",
                       "IESLiveFansGroupEntryInfo":"IESLiveFansGroupEntryInfo","IESCategoryModel":"IESCategoryModel",
                       "IESLiveAnchorCommercialComponentBaseModel":"IESLiveAnchorCommercialComponentBaseModel",
                       "IESLiveCommonGuideModel":"IESLiveCommonGuideModel"}

baseTypeData = ["BOOL","NSUInteger","NSInteger","int","short","SInt32","SInt64","UInt32","UInt64",
                "long","char","id","Class","float","CGFloat","double","NSTimeInterval","int64_t","int32_t",
                "uint32_t","uint64_t","CFAbsoluteTime","dispatch_block_t","uint8_t","CFTimeInterval"]

# 结构体不能用dynamicModel
cannotReplaceClassTypeList = ["CGRect","CGPoint","CGSize"]

notOCObjcAndBaseTypeDataList = []
enumIVarList = []

headFile = '#import \"' + "IESLiveDynamicModelDefine" + '.h\"'+'\n'
# headFile = '#import <IESLiveKit/IESLiveDynamicModelDefine.h>\n'

# 名字符合可以替换，但是基类不是NSObject
baseNotNSObjectClassList = []

# 下划线变量正则
_ivarRegStr = r"(\s+)_(\w+)(\s+)"

# 修改的属性数量
propertyCount = 0

rootDir = sys.argv[1]
allPathList = []

# 获取文件内容
def readFileContent(path):
    try:
        f = open(path, 'r')
    except:
        print(path+"路径找不到，请手动看下")
        return ""
    else:
        lines = f.readlines()

        f.close()

        all_str = ''
        for line in lines:
            all_str = all_str + line

        return all_str

def getInterfaceContent(content):
    reg = r'@interface.*?@end'
    return re.findall(reg, content, re.S)


def getImpleContent(className,fileContent):
    reg = r'@implementation.*?@end'
    list = re.findall(reg, fileContent, re.S)
    if len(list) == 0:
        print("找不到"+className+"类的impl代码_1")
        return ""
    if len(list) > 0:
        for implContent in list:
            categoryList = re.findall(r"@implementation(\s+)(\w+)(\s*)\(",implContent)
            if len(categoryList) == 0:
                reg1 = r"@implementation(\s+)" + "(\w+)" + "(\s*)"
                list1 = re.findall(reg1, implContent)
                tupleObjc = list1[0]
                if len(tupleObjc) > 1:
                    if tupleObjc[1] == className:
                        return implContent


    print("找不到"+className+"类的impl代码_2")
    return ""

def getDynamicString(interfaceContent):
    lines = interfaceContent.splitlines()
    reg = r"(\w+(?=;))"
    dynamicStr = "@dynamic "
    resultString = dynamicStr
    for line in lines:
        if line.startswith('@property'):
            preRes1 = 'readonly' not in line
            preRes2 = 'struct' not in line
            preRes3 = (line.startswith('//') == False)
            if preRes1 and preRes2 and preRes3:
                ivarNameList = re.findall(reg, line)
                if len(ivarNameList) > 0:
                    ivarName = ivarNameList[0]
                    global propertyCount
                    if '*' not in line:
                        reg1 = r"@property(\s*)\(.*?\)(\s*)(\w+)"
                        classTypeList = re.findall(reg1, line)
                        if (len(classTypeList) > 0):
                            classTypeTuple = classTypeList[0]
                            if len(classTypeTuple) >= 3:
                                classType = classTypeTuple[2]

                                if classType not in cannotReplaceClassTypeList:
                                    propertyCount += 1
                                    resultString = resultString + ivarName + ','
                                    if classType not in baseTypeData:
                                        #查找枚举
                                        classTypeDefinePath = findPathList(r"typedef(\s*)NS_ENUM\((\w+),(\s*)"+classType)
                                        if len(classTypeDefinePath) <= 0:
                                            notOCObjcAndBaseTypeDataList.append(line)
                                        else:
                                            enumIVarList.append(line)



                            else:
                                print("异常情况：" + line)
                        else:
                            print("异常情况：" + line)
                    else:
                        propertyCount += 1
                        resultString = resultString + ivarName + ','

    if (len(resultString) == len(dynamicStr)):
        return ""
    else:
        resultString = replaceLastChar(resultString, ";")
        return resultString


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
    try:
        f = open(path, 'w')
    except:
        print("pa径找不到，请手动看下")
    else:
        f.write(fileContent)
        f.close()

def isHasDynamicCode(ImplCode):
    return ImplCode.find("@dynamic") != -1

def findImple(path,className):
    try:
        f = open(path, 'r')
    except:
        print("findImple打开文件失败"+className+path)
        return {}
    else:
        reg = r"@implementation(\s+)" + className
        lines = f.readlines()
        lineNum = 0
        canModify = False

        for lintStr in lines:
            lineNum = lineNum + 1
            list = re.findall(reg, lintStr)
            if len(list) > 0 and "(" not in lintStr and ")" not in lintStr: # 排除分类实现
                canModify = True
                break
        f.close()
        if canModify:
            return {"lines":lines,"lineNum":lineNum}
        else:
            return {}

def writeDynamicString(path,className,dynamicString):
    dic = findImple(path, className)
    canModify = len(dic) > 0
    if canModify:
        lines = dic["lines"]
        lineNum = dic["lineNum"]
        lines.insert(lineNum, dynamicString)  # 在第 findLine+1 行插入
        lines.insert(lineNum + 1, "\n\n")  # 在第 findLine+1 行插入
        newContent = "".join(lines)
        writeFileContent(path, newContent)
    return canModify





def modifyBaseClass(pathH, currentClass):
    try:
        f = open(pathH, 'r')
    except:
        print("替换基类失败"+currentClass+pathH)
        return False
    else:
        lines = f.readlines()
        lineNum = 0
        reg = r"@interface(\s+)(\w+)"
        for lintStr in lines:
            list = re.findall(reg,lintStr)
            if len(list) > 0:
                tupleObjc = list[0]
                if tupleObjc[1] == className:
                    break

            lineNum = lineNum + 1
        f.close()

        originString = lines[lineNum]
        newString = ""
        canModify = False
        newBaseClass = ""
        for key, value in willReplaceClassDic.items():
            if originString.find(key) != -1:
                newString = originString.replace(key, value)
                newBaseClass = value
                canModify = True
                break

        if canModify:
            tmp = lines[8]
            if "IESLiveDynamicModelDefine" not in tmp:
                lines[8] = headFile + tmp

            lines[lineNum] = newString
            newContent = "".join(lines)
            writeFileContent(pathH, newContent)

        return canModify


# 是否继承要修改的类
def isInheritCanModifyClass(interfaceString):
    # 只要继承MTLModel，就肯定可以替换
    for canReplaceClass in canReplaceClassList:
        reg = r":(\s*)" + canReplaceClass
        result = re.findall(reg, interfaceString, re.S)
        if len(result) > 0:
            return True

    # 类名后缀是Model,Info，并且继承NSObject也是可以替换的（ViewModel不可以替换）
    className = getClassName(interfaceString)
    for canReplaceSuffixClassName in canReplaceSuffixClassNameList:
        res1 = className.endswith(canReplaceSuffixClassName)

        if res1 == True:
            for cannotString in cannotModifyList:
                res2 = className.endswith(cannotString)
                if res2 == True:
                    return False
            if isInheritNSObject(interfaceString) == False:
                baseNotNSObjectClassList.append(className)
                return False
            else:
                return True



    return False

def isInheritNSObject(interfaceString):
    reg = r"@interface.*:(\s*)(\w+)"
    list = re.findall(reg,interfaceString)
    if len(list) > 0:
        tupleObjc = list[0]
        if len(tupleObjc) > 0:
            if tupleObjc[1] == "NSObject":
                return True
    return False

# 查找className类声明和实现代码的文件路径
def findClassNameHPathAndMPath(className):
    HPathReg = r"@interface(\s+)"+className+"(\s*):"
    # first is HPath,second is MPath
    pathList = []
    HPath = ""
    MPath = ""
    for path in getPathList(rootDir):
        fileContent = readFileContent(path)
        if (len(HPath) == 0):
            Hlist = re.findall(HPathReg, fileContent, re.S)
            if len(Hlist) > 0:
                HPath = path

        dic = findImple(path, className)
        if len(dic) > 0: #说明impl的代码在这个路径下
            MPath = path


        if (len(HPath) > 0) and (len(MPath) > 0):
            break;

    if len(HPath) == 0:
        print(className+"类找不到声明代码")
    if len(MPath) == 0:
        print(className+"类找不到实现代码")
    pathList.append(HPath)
    pathList.append(MPath)
    return pathList


# 查找定义内容的路径
def findPathList(regString):
    pathList = []
    for path in getPathList(rootDir):
        fileContent = readFileContent(path)
        list = re.findall(regString,fileContent,re.S)
        if len(list) > 0:
            pathList.append(path)
    return pathList

def getPathList(rootDir):
    if len(allPathList) > 0:
        return allPathList

    for root, dirs, files in os.walk(rootDir):
        for fileName in files:
            path = root + '/' + fileName
            res1 = path.endswith(".h")
            res2 = path.endswith(".m")
            res3 = res1 == False and res2 == False
            if res3 == False:
                # pb文件不需要优化
                if ".pbobjc." not in path:
                    allPathList.append(path)


    return allPathList

# 查找能替换的类
def findCanReplaceClassNameAndDynamicDic():
    dic = {}
    for path in getPathList(rootDir):
        fileContent = readFileContent(path)
        interfaceContentList = getInterfaceContent(fileContent)
        for interfaceContent in interfaceContentList:
            if isInheritCanModifyClass(interfaceContent) == True:
                className = getClassName(interfaceContent)
                dynamicStr = getDynamicString(interfaceContent)
                if len(dynamicStr) > 0:
                    dic[className] = dynamicStr

    return dic

def modifyInitSelf(path, dynamicStr, className):
    try:
        f = open(path, 'r')
    except:
        print(path+"路径找不到，请手动看下")
        return ""
    else:
        lines = f.readlines()

        f.close()

        reg = r"(\w+)"
        ivarlist = re.findall(reg, dynamicStr)
        ivarlist.remove("dynamic")

        isWillFindImpleLineNum = findImple(path,className)["lineNum"]
        enterMatch = False

        for idx,line in enumerate(lines,0):
            if (idx+1 >= isWillFindImpleLineNum):
                if enterMatch:
                    list = re.findall(_ivarRegStr, line)

                    if len(list) > 0:

                        for ivarNameTuple in list:
                            if len(ivarNameTuple) >= 3:
                                ivarName = ivarNameTuple[1]
                                if ivarName in ivarlist:
                                    willReplaceStr = "_" + ivarName
                                    line = line.replace(willReplaceStr, "self." + ivarName)

                        lines[idx] = line

                    if "return self" in line:
                        enterMatch = False
                else:
                    if line.startswith("- (instancetype)init") or line.startswith("- (id)init"):
                        enterMatch = True
                    if line.startswith("@end"):
                        break


        writeFileContent(path,"".join(lines))

def find_Ivar(path,dynamicStr):
    setTmp = set()
    try:
        f = open(path, 'r')
    except:
        print(path+"路径找不到，请手动看下")
        return ""
    else:
        lines = f.readlines()

        f.close()

        for line in lines:
            list = re.findall(_ivarRegStr, line)
            for ivarNameTuple in list:
                if len(ivarNameTuple) >= 3:
                    ivarName = ivarNameTuple[1]
                    if ivarName in dynamicStr:
                        setTmp.add(ivarName)


        if len(setTmp) > 0:
            print("**********************")
            print(path + "路径下这些下划线的变量需要手动改下：")
            print(setTmp)

def deleteHasGetterSetterIvar(implContent,dynamicStr):
    reg = r"(\w+)"
    list = re.findall(reg,dynamicStr)
    list.remove("dynamic")
    ynamicStr = "@dynamic "
    resultString = ynamicStr
    for ivarName in list:
        tmp = ivarName.replace(ivarName[0],ivarName[0].upper(),1)

        if "set"+tmp+":" not in implContent:
            resultString = resultString + ivarName + ','
    if len(resultString) == len(ynamicStr):
        return ""
    else:
        resultString = replaceLastChar(resultString, ";")
        return resultString



if __name__ == '__main__':
    successModifyClassList = []
    dic = findCanReplaceClassNameAndDynamicDic()

    #开始写入dynamic和修改继承类
    for className,dynamicStr in dic.items():
        #根据类名查找实现impl的文件路径
        pathList = findClassNameHPathAndMPath(className)
        pathImpl = pathList[1]
        implContent = getImpleContent(className,readFileContent(pathImpl))
        dynamicStr = deleteHasGetterSetterIvar(implContent,dynamicStr)
        isHasDynamicCodeResult = isHasDynamicCode(implContent)
        if isHasDynamicCodeResult == False:
            # 对指定类名写入dynamic
            writeDynamicStringResult = writeDynamicString(pathImpl, className, dynamicStr)
            if writeDynamicStringResult == True:
                # 修改继承的类
                pathInter = pathList[0]
                modifyBaseClassResult = modifyBaseClass(pathInter, className)
                if modifyBaseClassResult == False:
                    print("异常：手动检查" + className + "类的dynamic和继承类"+pathInter)
                else:
                    successModifyClassList.append(className)
                    modifyInitSelf(pathImpl, dynamicStr, className)
                    find_Ivar(pathImpl,dynamicStr)
        else:
            print(className + "类已经有dynamic代码")

    print("成功修改的类：")
    print(successModifyClassList)
    print("成功修改了"+str(propertyCount)+"个属性，"+str(len(successModifyClassList))+"个类")
    print("*****************************************************")
    print("名字符合，但是不是继承NSObject的类，可以手动看下可不可以优化：")
    print("*****************************************************")
    print(baseNotNSObjectClassList)
    print("*****************************************************")
    print("非oc和已知基础类型的属性，手动review下：")
    print(notOCObjcAndBaseTypeDataList)
    print("*****************************************************")
    print("枚举属性：")
    print(enumIVarList)
    print("Model属性动态化修改完成，有问题联系chenzebing@bytedance.com")





