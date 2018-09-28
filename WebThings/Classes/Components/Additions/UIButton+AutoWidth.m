//
//  UIButton+AutoWidth.m
//  WebThings
//
//  Created by machinsight on 2017/7/27.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "UIButton+AutoWidth.h"

@implementation UIButton (AutoWidth)
- (CGFloat)fitWidth{
    NSDictionary *attribute = @{NSFontAttributeName:self.titleLabel.font};
    CGSize retSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(0, self.frame.size.height) options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
//    CGRect r = self.frame;
//    r.size.width = retSize.width+30;
//    self.frame = r;
//    self.sd_layout.widthIs(retSize.width+30);
    return retSize.width+30;
}
@end
