//
//  IVECell.m
//  WebThings
//
//  Created by machinsight on 2017/8/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "IVEView.h"

@implementation IVEView

//- (instancetype)initWithCoder:(NSCoder *)aDecoder{
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        [[NSBundle mainBundle] loadNibNamed:@"IVEView" owner:self options:nil];
//        [self setup];
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"IVEView" owner:self options:nil];
        [self setup];
    }
    return self;
}



- (void)awakeFromNib

{
    [super awakeFromNib];
    
    [[NSBundle mainBundle] loadNibNamed:@"IVEView" owner:self options:nil];
    
    [self setup];
    
}


- (void)setup{
    [self addSubview:self.contentView];
    self.frame = CGRectMake(0, 0, screenWidth-16, 105);
    self.contentView.frame = CGRectMake(0, 0, screenWidth-16, 105);
    
}


- (void)setViewValuesWithModel:(DWMsgModel *)model{
    for (int i = 0; i<model.ivedata.count; i++) {
        if (i == 0) {
            _firstLab.text = model.ivedata[i].msg;
        }else if(i == 1){
            _secondLab.text = model.ivedata[i].msg;
        }else if(i == 2){
            _thirdLab.text = model.ivedata[i].msg;
        }
    }
}

- (void)setViewValuesWithPushModel:(PushModel *)model{
    for (int i = 0; i<model.ivedata.count; i++) {
        if (i == 0) {
            _firstLab.text = model.ivedata[i];
        }else if(i == 1){
            _secondLab.text = model.ivedata[i];
        }else if(i == 2){
            _thirdLab.text = model.ivedata[i];
        }
    }
}
@end
