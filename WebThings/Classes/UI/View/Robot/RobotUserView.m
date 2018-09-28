//
//  RobotUserView.m
//  WebThings
//
//  Created by Henry on 2017/8/1.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "RobotUserView.h"
#import "HeadImgV.h"
@interface RobotUserView()
@property (weak, nonatomic) IBOutlet HeadImgV *headImg;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (nonatomic,strong)UserModel *user;
@end

@implementation RobotUserView
- (IBAction)call:(id)sender {
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.phone.text];
    // NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setUser:(UserModel *)user{
    _user = user;
    self.name.text = user.name;
    self.position.text = user.usertype;
    self.phone.text = user.dn;
    [self.headImg setImageWithURL:[NSURL URLWithString:appendUrl(imgUrl, user.headimg)] placeholderImage:[self.headImg defaultImageWithName:user.name]];
}

+(instancetype)viewWithUser:(UserModel *)user{
    RobotUserView *userView = [[[NSBundle mainBundle] loadNibNamed:@"RobotUserView" owner:self options:nil] lastObject];
    [userView setUser:user];
    return userView;
}

@end
