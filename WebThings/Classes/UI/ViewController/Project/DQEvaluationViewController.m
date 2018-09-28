//
//  DQEvaluationViewController.m
//  WebThings
//
//  Created by 孙文强 on 2017/10/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//  人员评价/评价

#import "DQEvaluationViewController.h"
#import "HeadImgV.h"
#import "DQEvalueStarView.h"
#import "DQMangerEvaluationCell.h"
#import "DQEvaluateListModel.h"

@interface DQEvaluationViewController ()
<UITableViewDelegate,
UITableViewDataSource,
DQEvalueStarViewDelegate,
MGSwipeTableCellDelegate>
{
    HeadImgV *_headVew;
    UILabel *_nameLabel;
    UIButton *_safixButton;
    UIButton *_noSafixButton;
    DQEvalueStarView *_qualityControl;
    DQEvalueStarView *_skillControl;
    DQEvalueStarView *_attitudeControl;
    NSIndexPath *_swipeIndexPath;
    NSInteger _pleased; //是否满意
    CGFloat _complete, _skill, _service;
}
@property (nonatomic, strong) UITextView *mTextView;
@property (nonatomic, strong) UIView *mTopView;
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *dataListArray;
@end

#define Evalua_Star_TAG  156999

@implementation DQEvaluationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(popViewController) image:ImageNamed(@"back")];

    if (self.type == KDQEvaluationDeriveStyle) {
       self.title = @"评价";
        _pleased = 3;
        _complete = 0;
        _skill = 0;
        _service = 0;
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pubLishedItemClick) title:@"提交"]; 
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        [self addEvaluationMangerView];
    } else {
       self.title = @"人员评价";
        _swipeIndexPath = nil;
        [self.view addSubview:self.mTableView];
        [self fetchEvaluationListAPI];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (IS_IOS10 && (self.type == KDQEvaluationPersonStyle)) {
        UIEdgeInsets inset = _mTableView.contentInset;
        inset.top = 0;
        _mTableView.contentInset = inset;
    }
}

#pragma mark -评价UI
- (void)addEvaluationMangerView
{
    _mTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 72, screenWidth, screenHeight-72)];
    _mTopView.backgroundColor = [UIColor whiteColor];
    _mTopView.userInteractionEnabled = true;
    [self.view addSubview:_mTopView];

    _headVew = [[HeadImgV alloc] initWithFrame:CGRectMake(16, 16, 46, 46)];
    _headVew.image = [_headVew defaultImageWithName:[self.name substringWithRange:NSMakeRange(0, 1)]];
    [_headVew borderWid:1];
    [_headVew borderColor:[UIColor colorWithHexString:@"407ee9"]];
    [_mTopView addSubview:_headVew];
    
    CGFloat width = [AppUtils textWidthSystemFontString:self.name height:20 font:[UIFont dq_mediumSystemFontOfSize:16]];
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headVew.right+16, _headVew.top+13, width, 20)];
    _nameLabel.text = self.name;
    _nameLabel.font = [UIFont dq_mediumSystemFontOfSize:16];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    [_mTopView addSubview:_nameLabel];
    
    UIView *leftLineView = [[UIView alloc] initWithFrame:CGRectMake(75, _headVew.bottom+13, 75, 1)];
    leftLineView.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    [_mTopView addSubview:leftLineView];
    
    UIView *rightLineView = [[UIView alloc] initWithFrame:CGRectMake(screenWidth-150, leftLineView.top, 75, 1)];
    rightLineView.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    [_mTopView addSubview:rightLineView];

    UILabel *fixLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftLineView.right+5, leftLineView.top-7, rightLineView.left-10-leftLineView.right, 14)];
    fixLabel.text = @"人员评价";
    fixLabel.font = [UIFont dq_regularSystemFontOfSize:14];
    fixLabel.textAlignment = NSTextAlignmentCenter;
    fixLabel.textColor = [UIColor colorWithHexString:@"#BAB9B9"];
    [_mTopView addSubview:fixLabel];

    _safixButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _safixButton.backgroundColor = [UIColor whiteColor];
    _safixButton.frame = CGRectMake(62, leftLineView.bottom+38, 111, 37);
    [_safixButton setTitle:@"满意" forState:UIControlStateNormal];
    [_safixButton setTitleColor:[UIColor colorWithHexString:COLOR_BLACK] forState:UIControlStateNormal];
    [_safixButton setTitleColor:[UIColor colorWithHexString:COLOR_ORANGE] forState:UIControlStateSelected];
    [_safixButton setImage:ImageNamed(@"icon_satisfy") forState:UIControlStateNormal];
    [_safixButton setImage:ImageNamed(@"icon_satisfy_sel") forState:UIControlStateSelected];
    _safixButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [_safixButton addTarget:self action:@selector(onSafixBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_safixButton borderColor:[UIColor colorWithHexString:@"#979797"]];
    [_safixButton borderWid:1.f];
    [_safixButton withRadius:13];
    [_mTopView addSubview:_safixButton];
    
    _noSafixButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _noSafixButton.backgroundColor = [UIColor whiteColor];
    _noSafixButton.frame = CGRectMake(_safixButton.right+30, _safixButton.top, 111, 37);
    [_noSafixButton setTitle:@"不满意" forState:UIControlStateNormal];
    [_noSafixButton setTitleColor:[UIColor colorWithHexString:COLOR_BLACK] forState:UIControlStateNormal];
    [_noSafixButton setTitleColor:[UIColor colorWithHexString:COLOR_ORANGE] forState:UIControlStateSelected];
    [_noSafixButton setImage:ImageNamed(@"icon_unsatisfy") forState:UIControlStateNormal];
    [_noSafixButton setImage:ImageNamed(@"icon_unsatisfy_sel") forState:UIControlStateSelected];
    _noSafixButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [_noSafixButton addTarget:self action:@selector(onSafixBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_noSafixButton borderColor:[UIColor colorWithHexString:@"#979797"]];
    [_noSafixButton borderWid:1.f];
    [_noSafixButton withRadius:13];
    [_mTopView addSubview:_noSafixButton];

    _qualityControl = [[DQEvalueStarView alloc] initWithFrame:CGRectMake(16, _safixButton.bottom+25, 215+40, 24) leftTitle:@"完成质量"];
    _qualityControl.delegate = self;
    _qualityControl.isNeedHalf = false;
    _qualityControl.selectedStarNumber = 0;
    _qualityControl.minSelectedNumber = 0;
    _qualityControl.tag = Evalua_Star_TAG;
    [_mTopView addSubview:_qualityControl];

    _skillControl = [[DQEvalueStarView alloc] initWithFrame:CGRectMake(_qualityControl.left, _qualityControl.bottom+12, _qualityControl.width, _qualityControl.height) leftTitle:@"专项技能"];
    _skillControl.delegate = self;
    _skillControl.isNeedHalf = false;
    _skillControl.selectedStarNumber = 0;
    _skillControl.minSelectedNumber = 0;
    _skillControl.tag = Evalua_Star_TAG+1;
    [_mTopView addSubview:_skillControl];

    _attitudeControl = [[DQEvalueStarView alloc] initWithFrame:CGRectMake(_qualityControl.left, _skillControl.bottom+11, _qualityControl.width, _qualityControl.height) leftTitle:@"服务态度"];
    _attitudeControl.delegate = self;
    _attitudeControl.isNeedHalf = false;
    _attitudeControl.selectedStarNumber = 0;
    _attitudeControl.minSelectedNumber = 0;
    _attitudeControl.tag = Evalua_Star_TAG+2;
    [_mTopView addSubview:_attitudeControl];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _attitudeControl.bottom+34, screenWidth, 8)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
    [_mTopView addSubview:lineView];
    
    _mTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, lineView.bottom, lineView.width, _mTopView.height-lineView.bottom)];
    _mTextView.backgroundColor = [UIColor whiteColor];
    [_mTextView jk_addPlaceHolder:@"请说出你对此次服务的评价"];
    _mTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    _mTextView.textColor = [UIColor colorWithHexString:COLOR_BLACK];
    _mTextView.font = [UIFont dq_regularSystemFontOfSize:13];
    _mTextView.textAlignment = NSTextAlignmentLeft;
    [_mTopView addSubview:_mTextView];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:true];
}

- (void)keyboardWillShow:(NSNotification *)note
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    _mTopView.top = -50;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)not
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    _mTopView.top = 72;
    [UIView commitAnimations];
}

//发表
- (void)pubLishedItemClick
{
  /*
   data”:{
   “projectid”:“项目id”,
   “type”:”评价类型,0-项目整体评价 1-设备评价 2-人员在项目整体中的评价 3-加高评价 4-维修评价 5-维护评价”,
   “linkid”:”关联单据id,例如,对于维修单的评价,则该字段即为维修单id”
   “workerid”:”被评价人员id,如有多个,逗号’,’隔开”,
   “pleased”:是否满意 0-不满意 1-满意””,
   “complete”:”完成质量评分,5分制”,
   “skill”:”专项技能评分,5分制”,
   “service”:”服务态度评分,5分制”,
   “assess”:”评价具体内容
   */
    
    if (!self.mTextView.text.length || _pleased == 3 || _complete == 0 || _skill == 0 || _service == 0) {
        MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"请完善评价信息!" actionTitle:@"" duration:3.0];
        [t show];
        return;
    }
    NSDictionary *dict = @{@"projectid" : @(self.projectID),
                           @"type" : @"2",
                           @"linkid" : @"",
                           @"workerid" : @(self.workerid),
                           @"pleased" : @(_pleased),
                           @"complete" : @(_complete),
                           @"skill" : @(_skill),
                           @"service" : @(_service),
                           @"assess" : [NSString stringWithFormat:@"%@",self.mTextView.text]
                           };
    [[DQProjectInterface sharedInstance] dq_getEvaluateAPI:dict success:^(id result) {
        if (result) {
            MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"评价成功!" actionTitle:@"" duration:2.0];
            [t show];
            [self.navigationController popViewControllerAnimated:true];
        }
    } failture:^(NSError *error) {

    }];
}

- (void)onSafixBtnClick:(UIButton *)sender
{
    [sender borderColor:[UIColor colorWithHexString:@"#F19E39"]];
    if (sender == _safixButton) {
        _pleased = 1;
        _safixButton.selected = true;
        _noSafixButton.selected = false;
        [_noSafixButton borderColor:[UIColor colorWithHexString:@"#979797"]];
    } else {
        _pleased = 0;
        _safixButton.selected = false;
        _noSafixButton.selected = true;
        [_safixButton borderColor:[UIColor colorWithHexString:@"#979797"]];
    }
}

#pragma mark -DQEvaluaStarControlDelegate
- (void)starsControl:(DQEvalueStarView *)starsView
      didChangeScore:(CGFloat)score
{
    switch (starsView.tag) {
        case Evalua_Star_TAG: { //完成质量
            _complete = score;
        } break;
        case Evalua_Star_TAG+1: {//专项技能
            _skill = score;
        } break;
        case Evalua_Star_TAG+2: {//服务态度
            _service = score;
        } break;
        default:
            break;
    }
}

//评价列表API
- (void)fetchEvaluationListAPI
{
    [[DQProjectInterface sharedInstance] dq_getEvaluateListAPI:self.projectID success:^(id result) {
        if (result) {
            self.dataListArray = result;
            [self.mTableView reloadData];
        }
    } failture:^(NSError *error) {
        
    }];
}

#pragma mark- 人员评价UI
- (UITableView *)mTableView
{
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 72, self.view.width-20, screenHeight-72) style:UITableViewStylePlain];
        _mTableView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        _mTableView.separatorColor = [UIColor clearColor];
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.tableFooterView = [UIView new];
        _mTableView.showsVerticalScrollIndicator = false;
        if (@available(iOS 11.0, *)) {
            _mTableView.estimatedRowHeight = 0;
            _mTableView.estimatedSectionHeaderHeight = 0;
            _mTableView.estimatedSectionFooterHeight = 0;
            _mTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _mTableView;
}

- (NSMutableArray *)dataListArray
{
    if (!_dataListArray) {
        _dataListArray = [NSMutableArray new];
    }
    return _dataListArray;
}

#pragma mark -UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 381.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8.5f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-20, 8.5)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#F3F4F5"];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DQMangerEvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MangerEvaluationCellIdentifier"];
    if (!cell) {
        cell = [[DQMangerEvaluationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MangerEvaluationCellIdentifier"];
    }
    DQEvaluateListModel *listModel = [self.dataListArray safeObjectAtIndex:indexPath.section];
    [cell configEvaluationModel:listModel];
    return cell;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
