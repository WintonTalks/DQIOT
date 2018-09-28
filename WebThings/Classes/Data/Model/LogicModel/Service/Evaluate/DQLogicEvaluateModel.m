//
//  DQLogicEvaluateModel.m
//  WebThings
//  管理服务流子节点的父类
//  Created by Heidi on 2017/9/26.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQLogicEvaluateModel.h"
#import "DQSubEvaluateModel.h"
#import "ServiceevaluateModel.h"

@implementation DQLogicEvaluateModel

#pragma mark - Getter
- (NSString *)cellIdentifier {
//    NSInteger stateID = self.cellData.enumstateid;
//    if (stateID == 48 || stateID == 164) {  // 服务评价Cell
//        return @"DQEvaluteCell";
//    }
    return [super cellIdentifier];
}

// 当前业务展示界面的高度
- (CGFloat)cellHeight {
    
    NSInteger stateID = self.cellData.enumstateid;
    if (stateID == 48 || stateID == 164) {  // 服务评价Cell
        CGFloat height = 76 + 360 + 48;
        if (self.canEdit) {
            height += 28;   // 显示发送按钮
        }
        if (stateID == 164) {   // 新增评价
            height += 110;
        }
        else if (stateID == 48) {        // 计算人员评价文字和设备评价文字高度
            DQSubEvaluateModel *evalute = (DQSubEvaluateModel *)self.cellData;
            NSString *strPerson = evalute.evaluate.note;
            CGSize size = [AppUtils
                           textSizeFromTextString:strPerson
                           width:screenWidth - 58 - 48
                           height:1000
                           font:[UIFont systemFontOfSize:12]];
            height += size.height + 15;
            
            NSString *strDevice = evalute.evaluate.note;
            size = [AppUtils
                    textSizeFromTextString:strDevice
                    width:screenWidth - 58 - 48
                    height:1000
                    font:[UIFont systemFontOfSize:12]];
            height += size.height + 15;
        }
        return height;
    }
    return 44;
}

- (BOOL)canEdit {   // 状态为164，且为承租方，方可评价
    DQSubEvaluateModel *sub = (DQSubEvaluateModel *)self.cellData;
    return self.cellData.enumstateid == DQEnumStateEvaluateAdd && !self.cellData.isZulin
    && sub.evaluate.ID < 1;
}

// 评价View没有驳回和确认
- (BOOL)showRefuteBackButton {
    return NO;
}

- (BOOL)isClearBillColor {
    return YES;
}

- (void)createLogicModel {
    DQSubEvaluateModel *evaluate = [[DQSubEvaluateModel alloc] init];
    evaluate.enumstateid = 164;
    evaluate.title = @"服务评价";
    self.cellData = evaluate;
}

@end
