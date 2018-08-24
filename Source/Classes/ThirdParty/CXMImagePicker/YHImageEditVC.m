//
//  YHImageEditVC.m
//  YHImageCropDemo
//
//  Created by 张长弓 on 2018/1/18.
//  Copyright © 2018年 张长弓. All rights reserved.
//

#import "YHImageEditVC.h"
#import "YHCropView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface YHImageEditVC ()<YHDCropViewDelegate>

@property (nonatomic, weak) id <YHDPhotoEditVCDelegate>delegate;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) YHCropView *cropView;

@end

@implementation YHImageEditVC

- (instancetype)initWithImage:(UIImage *)aImage delegate:(id<YHDPhotoEditVCDelegate>)aDelegate {
    self = [super init];
    if (self) {
        _image = aImage;
        _delegate = aDelegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.title = @"图片裁剪";
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"选取" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick:)];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    rightBtnItem.tintColor = UIColor.redColor;
    // 编辑处 view
    self.cropView = [[YHCropView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.cropView.delegate = self;
    [self.view addSubview:self.cropView];
    [self setNav];
    self.cropView.image = self.image;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // 禁用返回手势
    self.fd_interactivePopDisabled = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // 开启返回手势
    self.fd_interactivePopDisabled = NO;
}

- (void)setNav {
    UIButton * but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [but addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [UIImage imageNamed:@"ret"];
    but.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 24);
    [but setImage:image  forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:but];
}


#pragma mark - Click Events
- (void)leftBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClick:(id)sender {
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(yhdOptionalPhotoEditVC:didFinishCroppingImage:)]) {
        [self.delegate yhdOptionalPhotoEditVC:self didFinishCroppingImage:self.cropView.croppedImage];
    }
}

#pragma mark - Delegates

- (void)mmtdOptionalDidBeginingTailor:(YHCropView *)cropView {
//    [self showHUDWithText:@"请稍候..."];
}

- (void)mmtdOptionalDidFinishTailor:(YHCropView *)cropView {
//    [self hideHUD];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
