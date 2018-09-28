//
//  DQDeriveManagerCell.m
//  WebThings
//
//  Created by 孙文强 on 2017/10/2.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "DQDeriveManagerCell.h"
#import "DQProjectUserTitleView.h"
#import "DQDeriveManamentTitleView.h"
#import "JKPhotoBrowser.h"
#import "NewDeviceScrollView.h"
#import "DQAddProjectModel.h"
#import "DQDerivePhotoAlumView.h"
#import "DQManageTitleRowView.h"

@interface DQDeriveManagerCell()
<DQProjectUserTitleViewDelegate,
JKPhotoManagerDelegate,
NewDeviceScrollViewDelegate,
DQDeriveManamentTitleViewDelegate>
{
    DQDeriveManamentTitleView *_deriveTitleView;
    DQProjectUserTitleView *_projectView;
    UIImageView *_badgeView;
    UILabel *_jfLabel;
    UIButton *_editFixButton; //编辑
    NSInteger _workID;
    DQManageTitleRowView *_phoneRowView;
    DQManageTitleRowView *_numberRowView;
    DQManageTitleRowView *_projectRowView;
    DQManageTitleRowView *_personRowView;
    DQManageTitleRowView *_typeWorkRowView;
    DQManageTitleRowView *_remarkRowView;
    DQManageTitleRowView *_timeRowView;
}
@property (nonatomic, strong) NewDeviceScrollView *downPullView;
@property (nonatomic, strong) DQDerivePhotoAlumView *photoAlumView;
@end

@implementation DQDeriveManagerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView withRadius:8.f];
        [self addMangerInfoCellWithView];
        [self addThePhotoView];
        if ([self isZuLin] && ![self isCEO]){
            _downPullView = [[NewDeviceScrollView alloc] initWithFrame:CGRectMake(screenWidth-20-6-93, 41, 93, 101)];
            _downPullView.tag = 9527;
            _downPullView.delegate = self;
            _downPullView.hidden = true;
            [self addSubview:_downPullView];
        }
    }
    return self;
}

- (void)addMangerInfoCellWithView
{
    CGFloat width = screenWidth-20;
    _deriveTitleView = [[DQDeriveManamentTitleView alloc] initWithFrame:CGRectMake(0, 0, width, 70)];
    _deriveTitleView.delegate = self;
    [self.contentView addSubview:_deriveTitleView];

    //icon_Badge
    _badgeView = [[UIImageView alloc] initWithImage:ImageNamed(@"icon_Badge")];
    _badgeView.frame = CGRectMake(85, _deriveTitleView.bottom, 24, 30);
    [self.contentView addSubview:_badgeView];
    
    NSString *text = @"大器信用分：500分";
    CGFloat jfwidth = [AppUtils textWidthSystemFontString:text height:16 font:[UIFont dq_semiboldSystemFontOfSize:16]];
    _jfLabel = [[UILabel alloc] initWithFrame:CGRectMake(_badgeView.right+16, _badgeView.top+7, jfwidth, 16)];
    _jfLabel.text = text;
    _jfLabel.font = [UIFont dq_semiboldSystemFontOfSize:16];
    _jfLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    _jfLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_jfLabel];
    
    _projectView = [[DQProjectUserTitleView alloc] initWithFrame:CGRectMake(0, _badgeView.bottom, _deriveTitleView.width, 83) manageInfoViewType:KDQProjectManageBottomNormalStyle];
    _projectView.delegate = self;
    _projectView.userInteractionEnabled = true;
    [self.contentView addSubview:_projectView];
 
    _phoneRowView = [[DQManageTitleRowView alloc] initWithFrame:CGRectMake(0, _projectView.bottom, width, 30)];
    _numberRowView = [[DQManageTitleRowView alloc] initWithFrame:CGRectMake(0, _projectView.bottom+30, width, 30)];
    _projectRowView = [[DQManageTitleRowView alloc] initWithFrame:CGRectMake(0, _projectView.bottom+60, width, 30)];
    _personRowView = [[DQManageTitleRowView alloc] initWithFrame:CGRectMake(0, _projectView.bottom+90, width, 30)];
    _typeWorkRowView = [[DQManageTitleRowView alloc] initWithFrame:CGRectMake(0, _projectView.bottom+120, width, 30)];
    _timeRowView = [[DQManageTitleRowView alloc] initWithFrame:CGRectMake(0, _projectView.bottom+150, width, 30)];
    _remarkRowView = [[DQManageTitleRowView alloc] initWithFrame:CGRectMake(0, _projectView.bottom+180, width, 30)];
    [self.contentView addSubview:_phoneRowView];
    [self.contentView addSubview:_numberRowView];
    [self.contentView addSubview:_projectRowView];
    [self.contentView addSubview:_personRowView];
    [self.contentView addSubview:_typeWorkRowView];
    [self.contentView addSubview:_timeRowView];
    [self.contentView addSubview:_remarkRowView];
}

//创建视图
-(void)addThePhotoView
{
    NSString *text = @"证件";
    UIFont *font = [UIFont dq_mediumSystemFontOfSize:14];
    CGFloat width = [AppUtils textWidthSystemFontString:text height:18 font:font];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, _projectView.bottom+210+6, width, 18)];
    titleLabel.text = text;
    titleLabel.font = font;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor colorWithHexString:@"#BAB9B9"];
    [self.contentView addSubview:titleLabel];
    
    _photoAlumView = [[DQDerivePhotoAlumView alloc] initWithFrame:CGRectMake(titleLabel.right+44, titleLabel.top, screenWidth-(titleLabel.right+44+11)-20, 30) type:KDQDerivePhotoAlumRightStyle];
    _photoAlumView.userInteractionEnabled = true;
    [self.contentView addSubview:_photoAlumView];
}

- (void)setIndexMangerPath:(NSIndexPath *)indexMangerPath
{
   _photoAlumView.indexPath = indexMangerPath;
}

#pragma mark- NewDeviceScrollViewDelegate
- (void)didSelectValue:(id)value
              withSelf:(NewDeviceScrollView *)sender

             witnIndex:(NSInteger)index
{
    [_downPullView disshow];
    DQAddProjectModel *addModel = (DQAddProjectModel *)value;
    _deriveTitleView.infoAuth = addModel.brand;
    
    BOOL deriveAuth = [addModel.brand isEqualToString:@"允许"];
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(didFixUserOperAuth:deriveWorkID:isAuth:)]) {
        [self.mDelegate didFixUserOperAuth:self deriveWorkID:_workID isAuth:deriveAuth];
    }
}

#pragma mark -DQDeriveManamentTitleViewDelegate
///编辑司机操作
- (void)didDeriveInfoEditclicked:(DQDeriveManamentTitleView *)manageView
{
    [self.mDelegate didPushEditDeriveClicked:self index:self.indexMangerPath.section];
}

//操作权限
- (void)didDerivePullStackView:(DQDeriveManamentTitleView *)manageView
{
    [_downPullView setData:[NSMutableArray arrayWithArray:[self createPullViewData]]];
    [_downPullView showWithFatherV:self];
}

/**
 赋值
 @param model model
 */
- (void)configDeriveManagerData:(DriverModel *)model projectName:(NSString *)projectName
{
    //司机信息设置
    [_deriveTitleView configDriveTitleData:model];
    [_phoneRowView configKeyTitle:@"电话" value:model.dn];
    [_numberRowView configKeyTitle:@"身份证" value:model.idcard];
    [_projectRowView configKeyTitle:@"所属项目" value:projectName];
    [_personRowView configKeyTitle:@"人员编号" value:model.no];
    [_typeWorkRowView configKeyTitle:@"工种" value:model.workcategory];
    [_timeRowView configKeyTitle:@"进入项目时间" value:[NSDate verifyDateForYMD:model.entertime]];
    [_remarkRowView configKeyTitle:@"备注" value:model.notes];
    _workID = model.workerid;
    [self reloadAlumbPhotoData:model.photoList];
}

//刷新回调的相册图片
- (void)reloadAlumbPhotoData:(NSArray *)photoList
{
    CGFloat photoHeight = 0;//引入图片的计算高度
    NSInteger count = photoList.count%2==0 ? photoList.count/2 : photoList.count/2+1;
    if (count > 0) {
        photoHeight = count*80+20;
        _photoAlumView.height = photoHeight;
    }
    [_photoAlumView configAlubmPhoto:photoList];
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_photoAlumView layoutIfNeeded];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [_downPullView disshow];
}

#pragma mark -DQProjectUserTitleViewDelegate
- (void)didProjectUserMentView:(DQProjectUserTitleView *)titleView
                          type:(DQProjectUserTitleViewType)type
{ //司机cell考勤、培训、上传、评价
    [_downPullView disshow];
    switch (type) {
        case KDQProjectUserAttendanceStyle:{//考勤
            [self.mDelegate didDeriveMentClick:self index:1];
        } break;
        case KDQProjectUserQualificationStyle:{//资质上传
            [self.mDelegate didDeriveMentClick:self index:2];
        } break;
        case KDQProjectUserTrainingStyle:{//培训
            [self.mDelegate didDeriveMentClick:self index:3];
        } break;
        case KDQProjectUserEvaluationStyle:{//评价
            [self.mDelegate didDeriveMentClick:self index:4];
        } break;
        default:
            break;
    }
}

- (NSArray *)createPullViewData
{
    DQAddProjectModel *addModel1 = [DQAddProjectModel new];
    addModel1.brand = @"允许";
    DQAddProjectModel *addModel2 = [DQAddProjectModel new];
    addModel2.brand = @"禁止";
    return @[addModel1,addModel2];
}

- (BOOL)isZuLin {
    if ([[AppUtils readUser].type  isEqualToString:@"租赁商"]) {
        return YES;
    }
    return NO;
}

- (BOOL)isCEO {
    if ([[AppUtils readUser].usertype isEqualToString:@"CEO"]) {
        //CEO只能看看，无操作权限
        return YES;
    }
    return NO;
}

@end
