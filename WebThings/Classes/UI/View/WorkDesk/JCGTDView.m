//
//  JCGTDView.m
//  WebThings
//
//  Created by machinsight on 2017/8/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "JCGTDView.h"
#import "ServiceDetailView.h"
@interface JCGTDView()
@property (weak, nonatomic) IBOutlet UILabel *xmmcLab;
@property (weak, nonatomic) IBOutlet UILabel *qrddbhLab;
@property (weak, nonatomic) IBOutlet UILabel *chuzfLab;
@property (weak, nonatomic) IBOutlet UILabel *chengzfLab;
@property (weak, nonatomic) IBOutlet UILabel *gzddLab;
@property (weak, nonatomic) IBOutlet UILabel *zbdwLab;
@property (weak, nonatomic) IBOutlet UILabel *jldwLab;
@property (weak, nonatomic) IBOutlet UILabel *yjjcsjLab;
@property (weak, nonatomic) IBOutlet UILabel *yjccsjLab;
@property (weak, nonatomic) IBOutlet UILabel *sbslLab;
@property (weak, nonatomic) IBOutlet UILabel *zjLab;
@property (weak, nonatomic) IBOutlet UILabel *cccfLab;
@property (weak, nonatomic) IBOutlet UILabel *sjgzLab;


@property (weak, nonatomic) IBOutlet UILabel *sbppLab;
@property (weak, nonatomic) IBOutlet UILabel *sbxxLab;
@property (weak, nonatomic) IBOutlet UILabel *ymjazsjLab;
@property (weak, nonatomic) IBOutlet UILabel *azgdLab;
@property (weak, nonatomic) IBOutlet UILabel *azsjLab;
@property (weak, nonatomic) IBOutlet UILabel *zljgLab;
@property (weak, nonatomic) IBOutlet UILabel *azddLab;
@property (weak, nonatomic) IBOutlet UILabel *sysjLab;

@end
@implementation JCGTDView

//- (instancetype)initWithCoder:(NSCoder *)aDecoder{
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        [[NSBundle mainBundle] loadNibNamed:@"JCGTDView" owner:self options:nil];
//        [self setup];
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"JCGTDView" owner:self options:nil];
        [self setup];
    }
    return self;
}



- (void)awakeFromNib

{
    [super awakeFromNib];
    
    [[NSBundle mainBundle] loadNibNamed:@"JCGTDView" owner:self options:nil];
    
    [self setup];
    
}


- (void)setup{
    
    [self addSubview:self.contentView];
    self.frame = CGRectMake(0, 0, screenWidth-16, 850);
    self.contentView.frame = CGRectMake(0, 0, screenWidth-16, 850);
    
    
}

- (void)setViewValuesWithModel:(DWMsgModel *)model{
    
    _xmmcLab.text = model.project.projectname;
    _qrddbhLab.text = model.project.no;
    _chuzfLab.text = model.project.provideorgname;
    _chengzfLab.text = model.project.needorgname;
    _gzddLab.text = model.project.projectaddress;
    _zbdwLab.text = model.project.contractor;
    _jldwLab.text = model.project.supervisor;
    _yjjcsjLab.text = [DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd" WithOriginStr:model.project.indate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"];
    _yjccsjLab.text = [DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd" WithOriginStr:model.project.outdate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"];
    _sbslLab.text = [NSString stringWithFormat:@"%ld",model.project.devicenum];
    _zjLab.text = [NSString stringWithFormat:@"￥%@",[AppUtils formatMoney:model.project.rent]];
    _cccfLab.text = [NSString stringWithFormat:@"￥%@",[AppUtils formatMoney:model.project.intoutprice]];
    _sjgzLab.text = [NSString stringWithFormat:@"￥%@",[AppUtils formatMoney:model.project.driverrent]];
    
    
    _xmfzrDnLab.text = model.project.dn;
    
    _zjeLab.text = [NSString stringWithFormat:@"￥%@",[AppUtils formatMoney:model.project.totalprice]];
    
    
    
    _sbppLab.text = model.project.projectDevice.brand;
    _sbxxLab.text = model.project.projectDevice.model;
    _ymjazsjLab.text = [DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd" WithOriginStr:model.project.projectDevice.beforehanddate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"];
    _azgdLab.text = [NSString stringWithFormat:@"%.0f米",model.project.projectDevice.high];
    _azsjLab.text = [DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd" WithOriginStr:model.project.projectDevice.handdate WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"];
    _zljgLab.text = [NSString stringWithFormat:@"￥%@元",[AppUtils formatMoney:model.project.projectDevice.rent]];
    _azddLab.text = model.project.projectDevice.installationsite;
    _sysjLab.text = [DateTools getpointerTimeStrWithFormat:@"yyyy/MM/dd" WithOriginStr:model.project.projectDevice.starttime WithOrignFormat:@"yyyy/MM/dd HH:mm:ss"];

}
@end
