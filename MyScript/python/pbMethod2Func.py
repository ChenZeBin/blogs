#!/user/bin/env python3
# coding=UTF-8
import sys
import re
import os 

 # 获取文件内容
def readFileContent(path):
	f = open(path,'r')
	lines = f.readlines()
	f.close()

	all_str = ''
	for line in lines:
  		all_str = all_str + line

	return all_str;

# 将全新的内容写入空的文件
def writeFileContent(path,fileContent):
	f = open(path,'w')
	f.write(fileContent)
	f.close()

# 替换为函数
def transformExtensionRegistry(str):
  new_str = """+ (GPBExtensionRegistry*)extensionRegistry {
  // This is called by +initialize so there is no need to worry
  // about thread safety and initialization of registry.
  static GPBExtensionRegistry* registry = nil;
  return IESLiveGPBExtensionRegistry(registry);
}"""
  return re.sub(r'\+ \(GPBExtensionRegistry\*\)extensionRegistry {.*?\[registry addExtensions:\[HTSLiveCommonRoot extensionRegistry\]\];\n(\s+)\}\n(\s+)return registry;\n}',new_str,str,1,re.S)

def transformFileDescriptor(str):
	mmmstr1 = r'if \(!descriptor\) \{\n(\s+)GPB_DEBUG_CHECK_RUNTIME_VERSIONS\(\);\n(\s+)descriptor = \[\[GPBFileDescriptor alloc\] initWithPackage:@"([\w+/.]+)"\n(\s+)objcPrefix:@"(\w+)"\n(\s+)syntax:GPBFileSyntaxProto3];\n(\s+)\}\n(\s+)return descriptor;'
	mmmstr2 = r'if \(!descriptor\) \{\n(\s+)GPB_DEBUG_CHECK_RUNTIME_VERSIONS\(\);\n(\s+)descriptor = \[\[GPBFileDescriptor alloc\] initWithPackage:@"([\w+/.]+)"\n(\s+)syntax:GPBFileSyntaxProto3];\n(\s+)\}\n(\s+)return descriptor;'
	list1 = re.findall(mmmstr1,str,re.S)
	list2 = re.findall(mmmstr2,str,re.S)

	resultStr = str
	for tup in list1:
		mStr1 = tup[2]
		mStr2 = tup[4]
		replace_str = 'return IESLiveFileDescriptor2(descriptor,@"%s",@"%s");' % (mStr1,mStr2)
		resultStr = re.sub(mmmstr1,replace_str,resultStr,1,re.S)

	for tup in list2:
		mStr1 = tup[2]
		replace_str = 'return IESLiveFileDescriptor1(descriptor,@"%s");' % (mStr1)
		resultStr = re.sub(mmmstr2,replace_str,resultStr,1,re.S)

	return resultStr

def transformWorker(str):
    regularStr1 = r'\[GPBEnumDescriptor allocDescriptorForName:(\w+)\((\w+)\)\n(\s+)valueNames:valueNames\n(\s+)values:values\n(\s+)count:\(uint32_t\)\(sizeof\(values\) \/ sizeof\(int32_t\)\)\n(\s+)enumVerifier:(\w+)\n(\s+)extraTextFormatInfo:extraTextFormatInfo\];'
    regularStr2 = r'\[GPBEnumDescriptor allocDescriptorForName:(\w+)\((\w+)\)\n(\s+)valueNames:valueNames\n(\s+)values:values\n(\s+)count:\(uint32_t\)\(sizeof\(values\) \/ sizeof\(int32_t\)\)\n(\s+)enumVerifier:(\w+)\];'
    replaceStr1 = 'IESLiveCreateWorker1(GPBNSStringifySymbol(%s),valueNames,(uint32_t)(sizeof(values) / sizeof(int32_t)),values,%s,extraTextFormatInfo);'
    replaceStr2 = 'IESLiveCreateWorker2(GPBNSStringifySymbol(%s),valueNames,(uint32_t)(sizeof(values) / sizeof(int32_t)),values,%s);'

    resultStr = __transformWorker(regularStr1,replaceStr1,str)
    resultStr = __transformWorker(regularStr2,replaceStr2,resultStr)

    return resultStr

def __transformWorker(regularStr,replaceStr,str):
  list1 = re.findall(regularStr,str,re.S)
  resultStr = str
  for tup in list1:
        mStr1 = tup[1]
        mStr2 = tup[6]
        replace_str = replaceStr % (mStr1,mStr2)
        resultStr = re.sub(regularStr,replace_str,resultStr,1,re.S)

  return resultStr

def transformLocalDescriptor(str):
	mmmstr1 = r'\[GPBDescriptor allocDescriptorForClass:\[(\w+) class\]\n(\s+)rootClass:\[(\w+) class\]\n(\s+)file:(\w+)\(\)\n(\s+)fields:(\w+)\n(\s+)fieldCount:\(uint32_t\)\(sizeof\((\w+)\) \/ sizeof\((\w+)\)\)\n(\s+)storageSize:sizeof\((\w+)\)\n(\s+)flags:(\w+)\];'
	list1 = re.findall(mmmstr1,str,re.S)
	resultStr = str
	for tup in list1:
		msgClass = tup[0]
		rootClass = tup[2]
		mfile = tup[4]+'()'
		mfiles = tup[6]
		storageSize = tup[11]
		flags = tup[13]
		replace_str = 'IESLiveCreateLocalDescriptor([%s class],[%s class],%s,%s,(uint32_t)(sizeof(%s) / sizeof(GPBMessageFieldDescription)),sizeof(%s),%s);' % (msgClass,rootClass,mfile,mfiles,mfiles,storageSize,flags)
		resultStr = re.sub(mmmstr1,replace_str,resultStr,1,re.S)
	

	mmmstr2 = r'\[GPBDescriptor allocDescriptorForClass:\[(\w+) class\]\n(\s+)rootClass:\[(\w+) class\]\n(\s+)file:(\w+)\(\)\n(\s+)fields:NULL\n(\s+)fieldCount:0\n(\s+)storageSize:sizeof\((\w+)\)\n(\s+)flags:(\w+)\];'
	list2 = re.findall(mmmstr2,resultStr,re.S)
	for tup in list2:
		msgClass = tup[0]
		rootClass = tup[2]
		mfile = tup[4]+'()'
		mfiles = 'NULL'
		storageSize = tup[8]
		flags = tup[10]
		replace_str = 'IESLiveCreateLocalDescriptor([%s class],[%s class],%s,%s,0,sizeof(%s),%s);' % (msgClass,rootClass,mfile,mfiles,storageSize,flags)
		resultStr = re.sub(mmmstr2,replace_str,resultStr,1,re.S)

	return resultStr

def insertHeaderFile(str):
	if '#import "IESLivePBUtil.h"' in str:
		return str
		
	new_str = """#import "IESLivePBUtil.h"\n#pragma clang diagnostic push"""

	return re.sub(r'#pragma clang diagnostic push',new_str,str)

def structOptimize(str):
	# 最外层字符
	theOutermostLayerRegularStr = r'static GPBMessageFieldDescription fields\[\] = \{.*?};'
	theOutermostLayerStrList = re.findall(theOutermostLayerRegularStr,str,re.S)

	result = str;
	for theOutermostLayerStr in theOutermostLayerStrList:
		theInnermostLayerRegularRegularStr = r'.name = "(\w+)",\n(\s+).dataTypeSpecific.className = ([\w+/\(/\)]+),\n(\s+).number = (\w+),\n(\s+).hasIndex = (\w+),\n(\s+).offset = ([\(\w+/\)\w+/\(\w+)/,/ \w+\)]+).*?\n(\s+).flags = (.*?),\n(\s+).dataType = (\w+),'
		theInnermostLayerRegularStrList = re.findall(theInnermostLayerRegularRegularStr,theOutermostLayerStr,re.S)
	
		for theInnermostLayerRegularStrTup in theInnermostLayerRegularStrList:
			errorStr = '// Stored in _has_storage_ to save space'
			# print(theInnermostLayerRegularStrTup)
			if errorStr in theInnermostLayerRegularStrTup:
				# print('YES')
				theInnermostLayerRegularStrTup.remove(errorStr)
			name = theInnermostLayerRegularStrTup[0]
			className = theInnermostLayerRegularStrTup[2]
			number = theInnermostLayerRegularStrTup[4]
			hasIndex = theInnermostLayerRegularStrTup[6]
			offset = theInnermostLayerRegularStrTup[8]
			offset = offset.strip(',')
			offset = offset.strip(',  // Stored in _has_storage_ to save space')
			flags = theInnermostLayerRegularStrTup[10]
			dataType = theInnermostLayerRegularStrTup[12]
			theOutermostLayerReplaceStr = '"%s", %s, %s, %s, %s, %s, %s' % (name,className,number,hasIndex,offset,flags,dataType)



			result = re.sub(theInnermostLayerRegularRegularStr,theOutermostLayerReplaceStr,result,1,re.S)
	return result


if __name__ == '__main__':

	path = os.getcwd() + '/IESLiveKit'
	
	for root, dirs, files in os.walk(path):
		 
   		for fileName in files:
			if fileName.endswith('HTSLiveAudioBackgroundViewModel.m', 0, len(fileName)):
				path = root + '/' + fileName
				fileContent = readFileContent(path)

				IESLiveMakeEventStrReg = r'IESLiveMakeEvent\(.*?\}\);'
				IESLiveMakeEventStr = re.findall(IESLiveMakeEventStrReg, fileContent, re.S)
				print(IESLiveMakeEventStr)


   			# if fileName.endswith('.pbobjc.m',0,len(fileName)):
			   #
   			# 	if "LiveCommon.pbobjc" not in fileName:
			   #
	  			# 	path = root + '/' + fileName
		   		# 	fileContent = readFileContent(path)
		   		# 	newFileContent = fileContent
			   #
	   			# 	newFileContent = transformExtensionRegistry(fileContent)
				# 	newFileContent = insertHeaderFile(newFileContent)
				# 	newFileContent = transformFileDescriptor(newFileContent)
				# 	newFileContent = transformWorker(newFileContent)
				# 	newFileContent = transformLocalDescriptor(newFileContent)
				# 	newFileContent = structOptimize(newFileContent)
			   #
				#
		   		# 	writeFileContent(path,newFileContent)



    	
