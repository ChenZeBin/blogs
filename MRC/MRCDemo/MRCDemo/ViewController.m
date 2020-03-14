//
//  ViewController.m
//  MRCDemo
//
//  Created by chenzebin on 2020/3/13.
//  Copyright © 2020 chenzebin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, retain) NSString *string;
@property (nonatomic, retain) UIView *aaview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str = [[NSMutableString alloc] init];
    NSString *s = [NSString stringWithFormat:@"%s", "test"];
    self.string = s;
    self.string = str;
    self.string = [[NSString alloc] initWithString:@""];
    UIView *view = [[UIView alloc] init];
    self.aaview = view;
}

- (void)setAaview:(UIView *)aaview
{
    NSLog(@"---%ld",[aaview retainCount]);
    [aaview retain];
    NSLog(@"---%ld",[aaview retainCount]);
    
    if (_aaview != aaview) {
        [aaview release];
        _aaview = [aaview retain];
    }
}



- (void)setString:(NSString *)string
{
    NSLog(@"---%ld",[string retainCount]); // string 为 1
    [string retain];
    NSLog(@"---%ld",[string retainCount]); // string 为 1
    if (_string != string) {
        [_string release];
        _string = [string retain];
        NSLog(@"---%ld",[_string retainCount]);
    }
}


@end
