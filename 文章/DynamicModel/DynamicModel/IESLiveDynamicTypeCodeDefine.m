//
//  IESLiveDynamicTypeCodeDefine.m
//  DynamicModel
//
//  Created by bytedance on 2021/6/25.
//

#import "IESLiveDynamicTypeCodeDefine.h"
#import <UIKit/UIKit.h>

char * const kPointRefCode = "^";
char * const kOCObjcCode = "@";
char * const kBoolCode = @encode(bool); // B
char * const kCharCode = @encode(char); // c
char * const kUnsignedCharCode = @encode(unsigned char); // C
char * const kShortCode = @encode(short); // s
char * const kUnsignedShortCode = @encode(unsigned short); // S
char * const kSInt32Code = @encode(SInt32); // int、long i
char * const kUInt32Code = @encode(UInt32); // I
char * const kSInt64Code = @encode(SInt64); // long long q
char * const kUInt64Code = @encode(UInt64); // Q
char * const k32LongCode = "l"; //l 32位下的long int64
char * const k32ULongCode = "L"; //L 32位下的unsigned long
char * const kFloatCode = @encode(float); // f
char * const kDoubleCode = @encode(double); // d
char * const kCharRefCode = @encode(char *); // * char * 拥有自己的编码 *。这在概念上是很好理解的，因为 C 的字符串被认为是一个实体，而不是指针。
char * const kClassCode = @encode(Class); // #
char * const kStructCode = "{"; // 结构体
char * const kCGRectCode = @encode(CGRect);
char * const kCGPointCode = @encode(CGPoint);
char * const kCGSizeCode = @encode(CGSize);
char * const kUIEdgeInsetsCode = @encode(UIEdgeInsets);
char * const kNSRangeCode = @encode(NSRange);


const int kIESLiveSetMethodLenNotIncloudIvarName = 4;
const int kIESLiveSetMethodLen = 3;
