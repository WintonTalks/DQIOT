//
//  DQTextFieldArrowForCell.h
//  WebThings
//
//  Created by winton on 2017/10/13.
//  Copyright © 2017年 machinsight. All rights reserved.
//  右边编辑文字+箭头cell

#import "DQTextFiledInfoCell.h"

@interface DQTextFieldArrowForCell : DQTextFiledInfoCell

/** 整个cell 都是textField */
@property (nonatomic, assign) BOOL isFullTextField;

/** 设置cell末尾的指示图片 */
@property (nonatomic, copy) NSString *arrowImageName;

@end
