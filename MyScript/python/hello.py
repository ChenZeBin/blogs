#!/user/bin/env python3
import sys
import re

 # 获取文件内容
def readFileContent(path):
  f = open(path,'r')
  lines = f.readlines()
  f.close()

  all_str = ''
  for line in lines:
      all_str = all_str + line

  return all_str;


def transformWorker(str):
    regularStr1 = r'\[GPBEnumDescriptor allocDescriptorForName:(\w+)\((\w+)\)\n(\s+)valueNames:valueNames\n(\s+)values:values\n(\s+)count:\(uint32_t\)\(sizeof\(values\) \/ sizeof\(int32_t\)\)\n(\s+)enumVerifier:(\w+)\n(\s+)extraTextFormatInfo:extraTextFormatInfo\];'
    regularStr2 = r'\[GPBEnumDescriptor allocDescriptorForName:(\w+)\((\w+)\)\n(\s+)valueNames:valueNames\n(\s+)values:values\n(\s+)count:\(uint32_t\)\(sizeof\(values\) \/ sizeof\(int32_t\)\)\n(\s+)enumVerifier:(\w+)\];'
    replaceStr1 = 'IESLiveCreateWorker1(GPBNSStringifySymbol(%s),valueNames,values,%s,extraTextFormatInfo)'
    replaceStr2 = 'IESLiveCreateWorker2(GPBNSStringifySymbol(%s),valueNames,values,%s)'

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


if __name__ == '__main__':


  beginLine = '  if (!descriptor) {\n'
  endLine = '  return descriptor;\n'

  all_str = ''

  # BattleRivalsRecommendApi.pbobjc.m
  file = 'BattleRivalsRecommendApi.pbobjc.m'
  fo = open(file,'r')
  print("文件名为: ", fo.name)
  infor = fo.readlines()
  fo.close();

  for line in infor:
  	all_str = all_str + line

  # print(all_str)
  print('-----')

  all_str = readFileContent(file)

  # str2 = r'\[GPBEnumDescriptor allocDescriptorForName:(\w+)\((\w+)\)\n(\s+)valueNames:valueNames\n(\s+)values:values\n(\s+)count:\(uint32_t\)\(sizeof\(values\) \/ sizeof\(int32_t\)\)\n(\s+)enumVerifier:(\w+)\n(\s+)extraTextFormatInfo:extraTextFormatInfo\];'
  # str3 = r'\[GPBEnumDescriptor allocDescriptorForName:(\w+)\((\w+)\)\n(\s+)valueNames:valueNames\n(\s+)values:values\n(\s+)count:\(uint32_t\)\(sizeof\(values\) \/ sizeof\(int32_t\)\)\n(\s+)enumVerifier:(\w+)\];'

  # list1 = re.findall(str2,all_str,re.S)
  # list2 = re.findall(str3,all_str,re.S)
  
  

  # print(list2)
  # for tup in list2:
  #   mStr1 = tup[1]
  #   mStr2 = tup[6]
  #   replace_str = 'IESLiveCreateWorker2(GPBNSStringifySymbol(%s),valueNames,values,%s)' % (mStr1,mStr2)
  #   resultStr = re.sub(str3,replace_str,resultStr,1,re.S)

  # resultStr = transformWorker(all_str)

  mmmstr1 = r'if \(!descriptor\) \{\n(\s+)GPB_DEBUG_CHECK_RUNTIME_VERSIONS\(\);\n(\s+)descriptor = \[\[GPBFileDescriptor alloc\] initWithPackage:@"([\w+/.]+)"\n(\s+)objcPrefix:@"(\w+)"\n(\s+)syntax:GPBFileSyntaxProto3];\n(\s+)\}\n(\s+)return descriptor;'
  mmmstr2 = r'if \(!descriptor\) \{\n(\s+)GPB_DEBUG_CHECK_RUNTIME_VERSIONS\(\);\n(\s+)descriptor = \[\[GPBFileDescriptor alloc\] initWithPackage:@"([\w+/.]+)"\n(\s+)syntax:GPBFileSyntaxProto3];\n(\s+)\}\n(\s+)return descriptor;'
  list1 = re.findall(mmmstr1,all_str,re.S)

  for tup in list1:
    print(tup)
    mStr1 = tup[2]

    replace_str = 'return IESLiveFileDescriptor1(descriptor,@"%s");' % mStr1
    resultStr = re.sub(mmmstr2,replace_str,all_str,1,re.S)


  willWriteStr = resultStr
  fo2 = open(file,'w')
  print("文件名为: ", fo2.name)
  infor2 = fo2.write(willWriteStr)
  fo2.close();




      