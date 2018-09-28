//
//  ZLPhotoBrowser.m
//  多选相册照片
//
//  Created by long on 15/11/27.
//  Copyright © 2015年 long. All rights reserved.
//

#import "ZLPhotoBrowser.h"
#import "ZLPhotoBrowserCell.h"
#import "ZLPhotoManager.h"
#import "ZLPhotoModel.h"
#import "ZLThumbnailViewController.h"
#import "ZLDefine.h"

@implementation ZLImageNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        
    }
    return self;
}

- (UIImage *)imageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (NSMutableArray<ZLPhotoModel *> *)arrSelectedModels
{
    if (!_arrSelectedModels) {
        _arrSelectedModels = [NSMutableArray array];
    }
    return _arrSelectedModels;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = self.previousStatusBarStyle;
    //    [self setNeedsStatusBarAppearanceUpdate];
}

//BOOL dismiss = NO;
//- (UIStatusBarStyle)previousStatusBarStyle
//{
//    if (!dismiss) {
//        return UIStatusBarStyleLightContent;
//    } else {
//        return self.previousStatusBarStyle;
//    }
//}

@end


@interface ZLPhotoBrowser ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<ZLAlbumListModel *> *arrayDataSources;

@property (nonatomic, strong) UIView *placeholderView;

@property (nonatomic,strong) UITableView *tableView;
@end

@implementation ZLPhotoBrowser

- (UIView *)placeholderView
{
    if (!_placeholderView) {
        _placeholderView = [[UIView alloc] initWithFrame:self.view.bounds];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
        imageView.image = GetImageWithName(@"defaultphoto.png");
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.center = CGPointMake(kViewWidth/2, kViewHeight/2-90);
        [_placeholderView addSubview:imageView];
        
        UILabel *placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kViewHeight/2-40, kViewWidth, 20)];
        placeholderLabel.text = GetLocalLanguageTextValue(ZLPhotoBrowserNoPhotoText);
        placeholderLabel.textAlignment = NSTextAlignmentCenter;
        placeholderLabel.textColor = [UIColor darkGrayColor];
        placeholderLabel.font = [UIFont systemFontOfSize:15];
        [_placeholderView addSubview:placeholderLabel];
        
        _placeholderView.hidden = YES;
        [self.view addSubview:_placeholderView];
    }
    return _placeholderView;
}

- (NSMutableArray<ZLAlbumListModel *> *)arrayDataSources
{
    if (!_arrayDataSources) {
        ZLImageNavigationController *nav = (ZLImageNavigationController *)self.navigationController;
        _arrayDataSources = [NSMutableArray arrayWithArray:[ZLPhotoManager getPhotoAblumList:nav.allowSelectVideo allowSelectImage:nav.allowSelectImage]];
    }
    return _arrayDataSources;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:COLOR_BG];
    self.tableView = [[UITableView alloc] init];
    self.title = GetLocalLanguageTextValue(ZLPhotoBrowserPhotoText);
    self.tableView.frame = CGRectMake(0, 10, screenWidth, screenHeight-10);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }
    
    self.navigationItem.backBarButtonItem = [UIBarButtonItem itemWithTarget:self action:nil title:@"返回"];
    [self initNavBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)initNavBtn
{
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
////    CGFloat width = GetMatchValue(GetLocalLanguageTextValue(ZLPhotoBrowserCancelText), 16, YES, 44);
//    btn.frame = CGRectMake(screenWidth-47, 0, 33, 44);
//    btn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [btn setTitle:GetLocalLanguageTextValue(ZLPhotoBrowserCancelText) forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(navRightBtn_Click) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(navRightBtn_Click) title:@"取消"]; 
}

- (void)navRightBtn_Click
{
    ZLImageNavigationController *nav = (ZLImageNavigationController *)self.navigationController;
    if (nav.cancelBlock) {
        nav.cancelBlock();
    }
    [nav dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.arrayDataSources.count == 0) {
        self.placeholderView.hidden = NO;
    } else {
        self.placeholderView.hidden = YES;
    }
    return self.arrayDataSources.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZLPhotoBrowserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZLPhotoBrowserCell"];
    
    if (!cell) {
        cell = [[kZLPhotoBrowserBundle loadNibNamed:@"ZLPhotoBrowserCell" owner:self options:nil] lastObject];
    }
    
    ZLAlbumListModel *albumModel = self.arrayDataSources[indexPath.row];
    
    ZLImageNavigationController *nav = (ZLImageNavigationController *)self.navigationController;
    cell.cornerRadio = nav.cellCornerRadio;
    
    cell.model = albumModel;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self pushThumbnailVCWithIndex:indexPath.row animated:YES];
}

- (void)pushThumbnailVCWithIndex:(NSInteger)index animated:(BOOL)animated
{
    ZLAlbumListModel *model = self.arrayDataSources[index];
    
    ZLThumbnailViewController *tvc = [[ZLThumbnailViewController alloc] initWithNibName:@"ZLThumbnailViewController" bundle:kZLPhotoBrowserBundle];
    tvc.albumListModel = model;
    
    [self.navigationController showViewController:tvc sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
