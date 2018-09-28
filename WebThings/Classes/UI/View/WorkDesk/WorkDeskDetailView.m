//
//  WorkDeskDetailView.m
//  WebThings
//
//  Created by machinsight on 2017/8/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "WorkDeskDetailView.h"
#import "CKCheckBoxButton.h"
@interface WorkDeskDetailView()<CKCheckBoxButtonDelegate>
@property (nonatomic,strong)CKCheckBoxButton *cekBtn;/**< 多选框*/

@property (nonatomic,strong)DWMsgModel *thisModel;
@end
@implementation WorkDeskDetailView

//- (instancetype)initWithCoder:(NSCoder *)aDecoder{
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        [[NSBundle mainBundle] loadNibNamed:@"WorkDeskDetailView" owner:self options:nil];
//        [self setup];
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"WorkDeskDetailView" owner:self options:nil];
        [self setup];
    }
    return self;
}



- (void)awakeFromNib

{
    [super awakeFromNib];
    
    [[NSBundle mainBundle] loadNibNamed:@"WorkDeskDetailView" owner:self options:nil];
    
    [self setup];
    
}


- (void)setup{
    [self addSubview:self.contentView];
    self.frame = CGRectMake(0, 0, screenWidth-16, 86);
    self.contentView.frame = CGRectMake(0, 0, screenWidth-16, 86);
//    if (!self.cekBtn) {
        #pragma 复选框
        self.cekBtn = [[CKCheckBoxButton alloc] initWithFrame:CGRectMake(screenWidth-16-15-23, (86-23)/2, 23, 23)];
        [self.contentView addSubview:self.cekBtn];
//        self.cekBtn.sd_layout.rightSpaceToView(self.contentView, 15).centerYEqualToView(self.contentView).widthIs(50).heightIs(50);
        self.cekBtn.rippleColor = [UIColor colorWithHexString:@"#DFEBFB"];
        self.cekBtn.isOn = YES;
        self.cekBtn.hidden = YES;
        self.cekBtn.delegate = self;
//    }
}

#pragma CKCheckBoxButtondelegate
- (void)btnClicked:(CKCheckBoxButton *)btn{
    if (_thisModel) {
        self.thisModel.isnotSelected = !btn.isOn;
    }
}

- (void)setCheckBtnHide:(BOOL)hide{
    _cekBtn.hidden = hide;
}

- (void)setViewValuesWithModel:(DWMsgModel *)model{
    self.thisModel = model;
    _titleLab.text = model.title;
    
    _contentLab.text = [NSString stringWithFormat:@"%@-%@",model.projectname,model.msg];
    
    _timeLab.text = model.cdate;
    if (model.optid == 0) {
        _xwFatherV.hidden = YES;
    }else{
        _xwFatherV.hidden = NO;
    }
    
    [self setCheckBtnHide:!model.isShowCekBtn];
}

- (void)setViewValuesWithPushModel:(PushModel *)model{
    [self setCheckBtnHide:YES];
    _titleLab.text = model.title;
    
    _contentLab.text = model.msg;
    
    _timeLab.text = model.time;
}
@end
