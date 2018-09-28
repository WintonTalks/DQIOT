//
//  RobotIVECell.m
//  WebThings
//
//  Created by Henry on 2017/8/2.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "RobotIVECell.h"

CGFloat height;

@interface RobotIVECell()
@property (weak, nonatomic) IBOutlet UIView *body;

@end

@implementation RobotIVECell

+(instancetype)cellWithTableView:(UITableView *)tableView data:(id)data{
    RobotIVECell *cell = [tableView dequeueReusableCellWithIdentifier:@"RobotIVECell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RobotIVECell" owner:nil options:nil] lastObject];
        NSArray *ives = data;
        height = 0;
        for(int i=0;i<ives.count;i++){
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor colorWithHexString:@"404040"];
            
            CGFloat height = [AppUtils textHeightSystemFontString:label.text height:[cell bodyWidth] font:label.font];
            
            CGRect rect = CGRectMake(0, height, [cell bodyWidth],height+6);
            height = height+height+6+12;
            label.frame = rect;
            label.text = ives[i];
            [cell addLabel:label];
        }
        height = height+80;
    }
    return cell;
}

- (CGFloat)cellHeight{
    return height;
}

-(CGFloat)bodyWidth{
    return _body.bounds.size.width;
}

-(void)addLabel:(UILabel *)label{
    [self.body addSubview:label];
}
@end
