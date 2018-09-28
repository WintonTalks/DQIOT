//
//  ServiceScreamSection.m
//  WebThings
//
//  Created by machinsight on 2017/6/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ServiceScreamSection.h"
#import "ServiceCenterBaseModel.h"


@interface ServiceScreamSection()
@property (weak, nonatomic) IBOutlet CKRippleButton *btn;
@property (weak, nonatomic) IBOutlet UIView *lineV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (nonatomic,assign) NSInteger index;


/**是否展开*/@property(nonatomic,assign)BOOL isOpen;

/**是否完成*/@property(nonatomic,assign)BOOL isFinished;
/**
 是否可点
 */
@property(nonatomic,assign) BOOL canClick;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTopSpace;

@end

@implementation ServiceScreamSection

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"ServiceScreamSection" owner:nil options:nil] objectAtIndex:0];
    if (self) {
        self.frame = CGRectMake(0, 0, screenWidth, 53);
    }
    return self;
}
#pragma setter
- (void)setIndex:(NSInteger)index{
    _index = index;
}
- (void)setDelegate:(id<ServiceScreamSectionDelegate>)delegate{
    _delegate = delegate;
}
- (void)setIsOpen:(BOOL)isOpen{
    _isOpen = isOpen;
    if (_isOpen) {
        [self.titleLab setTextColor:[UIColor colorWithHexString:@"#000000"]];
    } else {
        [self.titleLab setTextColor:[UIColor colorWithHexString:@"#54585A"]];
    }
}

- (void)setIsFinished:(BOOL)isFinished{
    _isFinished = isFinished;
    if (_isFinished) {
        [self.btn setBackgroundColor:[UIColor clearColor]];
        [self.btn setBackgroundImage:[UIImage imageNamed:@"ic_check_circle"] forState:UIControlStateNormal];
        [self.btn setTitle:@"" forState:UIControlStateNormal];
    }else{
        
    }
}
- (void)setCanClick:(BOOL)canClick{
    _canClick = canClick;
    _btn.enabled = _canClick;
    if (_canClick) {
        [self.btn setBackgroundColor:[UIColor colorWithHexString:@"#0973E7"]];
        self.lineV.backgroundColor = [UIColor colorWithHexString:@"#0973E7"];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClicked:)];
        [self addGestureRecognizer:tapGesture];
    }else{
        [self.btn setBackgroundColor:[UIColor colorWithHexString:@"#9D9E9F"]];
        self.lineV.backgroundColor = [UIColor colorWithHexString:@"#9D9E9F"];
    }
    
}
- (void)setBtnTitle:(NSString *)title{
    [self.btn setTitle:title forState:UIControlStateNormal];
}
- (void)setLabText:(NSString *)text{
    _titleLab.text = text;
}
- (void)setIsLastSection:(BOOL)isLast{
    if (isLast) {
        self.lineV.hidden = YES;
    }
}
- (void)setIsFirstSection:(BOOL)isFirst{
    if (isFirst) {
        self.btnTopSpace.constant = 10;
    }
}

- (void)setViewValuesWithModel:(ServiceCenterBaseModel *)model{
    [self setLabText:model.flowtype];
    [self setIndex:[model returnIndex]-1];
    [self setBtnTitle:[NSString stringWithFormat:@"%ld",[model returnIndex]]];
    
    if ([model.flowtype isEqualToString:@"司机确认"]) {
        model.canclick = 1;//司机永远可以点
    }
    
    [self setCanClick:model.canclick];
    if (model.canclick) {
        //可以点的才有完成的可能性，此处这些判断都是为了不完全依赖后台，防止后台传错误数据过来
        [self setIsFinished:model.isfinish];
    }
    
    if (_index == 0) {
        [self setIsFirstSection:YES];
    }else if(_index == 9){
        [self setIsLastSection:YES];
    }
}

- (IBAction)btnClicked:(CKRippleButton *)sender {
    if ([_delegate respondsToSelector:@selector(sectionBtnClicked:)]) {
        [_delegate sectionBtnClicked:_index];
    }
}

@end
