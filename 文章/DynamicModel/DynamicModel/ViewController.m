//
//  ViewController.m
//  DynamicModel
//
//  Created by bytedance on 2021/6/7.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "FourModel.h"

struct Student {
    int iii;
};

typedef struct Student Student;

@interface ViewController ()

@property (nonatomic, assign) Student student;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    FourModel *fourModel = [FourModel new];
  
    int intArray[5] = {1, 2, 3, 4, 5};
    NSLog(@"int[]      : %s", @encode(typeof(intArray)));

    float floatArray[3] = {0.1f, 0.2f, 0.3f};
    NSLog(@"float[]    : %s", @encode(typeof(floatArray)));
    NSTextAlignment;
}




@end
