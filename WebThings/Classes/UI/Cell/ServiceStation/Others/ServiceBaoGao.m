//
//  ServiceBaoGao.m
//  WebThings
//
//  Created by machinsight on 2017/7/1.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ServiceBaoGao.h"
#import "EMICardView.h"
@interface ServiceBaoGao()
@property (weak, nonatomic) IBOutlet EMICardView *fatherV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fatherVWid;

@end

@implementation ServiceBaoGao

+ (id)cellWithTableView:(UITableView *)tableview{
    ServiceBaoGao *cell = [tableview dequeueReusableCellWithIdentifier:@"ServiceBaoGao"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ServiceBaoGao" owner:nil options:nil] objectAtIndex:0];
        cell.fatherVWid.constant = 245*autoSizeScaleX;
        cell.fatherVLeading.constant = 36+(screenWidth-36-245*autoSizeScaleX)/2;
    }
    
    return cell;
}

@end
