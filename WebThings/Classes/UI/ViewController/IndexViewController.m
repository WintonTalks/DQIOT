//
//  IndexViewController.m
//  WebThings
//
//  Created by machinsight on 2017/5/31.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "IndexViewController.h"
#import "ZLPhotoActionSheet.h"
#import "ZLDefine.h"
#import "ZLCollectionCell.h"
#import <Photos/Photos.h>
#import "ZLShowGifViewController.h"
#import "ZLShowVideoViewController.h"
#import "ZLPhotoModel.h"
#import "EMICardView.h"

@interface IndexViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;
@property (nonatomic, strong) NSMutableArray<UIImage *> *lastSelectPhotos;
@property (nonatomic, strong) NSArray *arrDataSources;
@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    EMICardView *cardView = [[EMICardView alloc] initWithFrame:CGRectMake(50, 100, 200, 200)];
    cardView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:cardView];
    
    MDCFlatButton *btn = [[MDCFlatButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [btn setTitle:@"选择照片" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setContent:(NSString *)str{
    _lab.text = str;
}
    
- (void)next{
    [self showWithPreview:YES];
}
    
- (void)showWithPreview:(BOOL)preview
{
    ZLPhotoActionSheet *actionSheet = [self getPas];
    [actionSheet showPreviewAnimated:YES];
}
    
- (ZLPhotoActionSheet *)getPas
{
        ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
        actionSheet.sortAscending = NO;
        actionSheet.allowSelectImage = YES;
        actionSheet.allowSelectGif = NO;
        actionSheet.allowSelectVideo = NO;
        actionSheet.allowTakePhotoInLibrary = NO;
        //设置照片最大预览数
        actionSheet.maxPreviewCount = 20;
        //设置照片最大选择数
        actionSheet.maxSelectCount = kNUMBER_MAXPHOTO;
        actionSheet.cellCornerRadio = 0;
        actionSheet.sender = self;
        
        NSMutableArray *arr = [NSMutableArray array];
        for (PHAsset *asset in self.lastSelectAssets) {
            if (asset.mediaType == PHAssetMediaTypeImage && ![[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
                [arr addObject:asset];
            }
        }
        actionSheet.arrSelectedAssets = nil;
        
        weakify(self);
        [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
            strongify(weakSelf);
            strongSelf.arrDataSources = images;
            strongSelf.lastSelectAssets = assets.mutableCopy;
            strongSelf.lastSelectPhotos = images.mutableCopy;
//            [strongSelf.collectionView reloadData];
            DQLog(@"image:%@", images);
        }];

        
        return actionSheet;
    }
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
