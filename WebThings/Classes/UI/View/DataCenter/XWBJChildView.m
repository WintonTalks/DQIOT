//
//  XWBJChildView.m
//  WebThings
//
//  Created by machinsight on 2017/8/23.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "XWBJChildView.h"

@interface XWBJChildView()
@property (weak, nonatomic) IBOutlet UILabel *countLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end
@implementation XWBJChildView

- (instancetype)init{
    self = [super init];
    self = [[[NSBundle mainBundle] loadNibNamed:@"XWBJChildView" owner:nil options:nil] objectAtIndex:0];
    
    if (self) {
        self.frame = CGRectMake(0, 0, (screenWidth-16)/3, 85);
    }
    return self;
}

- (void)setViewValuesWithModel:(WarningModel *)model{
    _countLab.text = [NSString stringWithFormat:@"%ld",model.num];
    _titleLab.text = model.warndesc;
}
@end
