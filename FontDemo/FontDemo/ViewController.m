//
//  ViewController.m
//  FontDemo
//
//  Created by 陈泽槟 on 2018/12/6.
//  Copyright © 2018 陈泽槟. All rights reserved.
//

#import "ViewController.h"
#import <QuickLook/QuickLook.h>
#import <CoreText/CoreText.h>

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *importButton;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.importButton];
    [self.view addSubview:self.tableView];
    self.textView.text = @"wps真牛逼！";
    [self.textView setFrame:CGRectMake(0, 20, self.view.frame.size.width, 100)];
    [self.importButton setFrame:CGRectMake(40, 330, 300, 44)];
    [self.tableView setFrame:CGRectMake(0, 384, self.view.frame.size.width, self.view.frame.size.height - 384)];
}
#pragma mark - Event
- (void)refreshDis {
    
    [self.textView resignFirstResponder];
    
    //step6. 获取沙盒里所有文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
    self.datasource = [[NSMutableArray alloc] init];
    for (NSString *file in fileList)
    {
        NSLog(@"文件:%@",file);
       
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDir = [documentPaths objectAtIndex:0];
        NSString *path = [NSString stringWithFormat:@"%@/%@",documentDir,file];
        NSArray *arr = [[self class] fontName:path];
        for (NSString *name in arr) {
             [self.datasource addObject:name];
        }
    }

    //step6. 刷新列表, 显示数据
    [self.tableView reloadData];
}

+ (NSArray *)fontName:(NSString *)path {
    NSString *pathExtension = [path pathExtension];
    if ([pathExtension isEqualToString:@"ttc"]) {
        return [self customFontArrayWithPath:path size:17.f];
    } else if ([pathExtension isEqualToString:@"ttf"] || [pathExtension isEqualToString:@"otf"]) {
        return @[[self customFontWithPath:path]];
    } else {
        return @[@"不是字体文件"];
    }
}

+ (NSString *)customFontWithPath:(NSString*)path {
    
    NSURL *fontUrl = [NSURL fileURLWithPath:path];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(fontRef, NULL);
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    CGFontRelease(fontRef);
    return fontName;
}

+ (NSArray<NSString *>*)customFontArrayWithPath:(NSString*)path size:(CGFloat)size
{
    CFStringRef fontPath = CFStringCreateWithCString(NULL, [path UTF8String], kCFStringEncodingUTF8);
    CFURLRef fontUrl = CFURLCreateWithFileSystemPath(NULL, fontPath, kCFURLPOSIXPathStyle, 0);
    CFArrayRef fontArray =CTFontManagerCreateFontDescriptorsFromURL(fontUrl);
    CTFontManagerRegisterFontsForURL(fontUrl, kCTFontManagerScopeNone, NULL);
    NSMutableArray *customFontArray = [NSMutableArray array];
    for (CFIndex i = 0 ; i < CFArrayGetCount(fontArray); i++){
        CTFontDescriptorRef  descriptor = CFArrayGetValueAtIndex(fontArray, i);
        CTFontRef fontRef = CTFontCreateWithFontDescriptor(descriptor, size, NULL);
        NSString *fontName = CFBridgingRelease(CTFontCopyName(fontRef, kCTFontPostScriptNameKey));
        [customFontArray addObject:fontName];
    }
    return customFontArray;
}

- (BOOL)registerFont:(NSString *)fontPath
{
    NSData *dynamicFontData = [NSData dataWithContentsOfFile:fontPath];
    if (!dynamicFontData)
    {
        return NO;
    }
    CFErrorRef error;
    CGDataProviderRef providerRef = CGDataProviderCreateWithCFData((__bridge CFDataRef)dynamicFontData);
    CGFontRef font = CGFontCreateWithDataProvider(providerRef);
    if (! CTFontManagerRegisterGraphicsFont(font, &error))
    {
        //注册失败
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        NSLog(@"Failed to load font: %@", errorDescription);
        CFRelease(errorDescription);
        return NO;
    }
    CFRelease(font);
    CFRelease(providerRef);
    return YES;
}

#pragma mark - UITableViewDelegate&&UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    cell.textLabel.text = self.datasource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.textView.font = [UIFont fontWithName:self.datasource[indexPath.row] size:17];
}

#pragma mark - getter
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
    }
    return _textView;
}

- (UIButton *)importButton {
    if (!_importButton) {
        _importButton = [[UIButton alloc] init];
        [_importButton setTitle:@"导入+取消键盘" forState:UIControlStateNormal];
        [_importButton setBackgroundColor:[UIColor redColor]];
        [_importButton addTarget:self action:@selector(refreshDis) forControlEvents:UIControlEventTouchUpInside];
    }
    return _importButton;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [[NSMutableArray alloc] init];
    }
    return _datasource;
}

@end
