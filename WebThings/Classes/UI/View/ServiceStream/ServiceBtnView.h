//
//  ServiceBtnView.h
//  WebThings
//
//  Created by machinsight on 2017/7/31.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class ServiceBtnView;
//@protocol  ServiceBtnViewDelegate<NSObject>
//- (void)sureBtnClicked:(UIButton *)sender;
//- (void)againBtnClicked:(UIButton *)sender;
//@end

@interface ServiceBtnView : UIView
//@property(nonatomic,strong)id<ServiceBtnViewDelegate> delegate;

@property (nonatomic, retain) IBOutlet UIView *contentView;

- (void)setSureTag:(NSInteger)tag1 againstTag:(NSInteger)tag2;

- (void)setAction1:(SEL)action1 Action2:(SEL)action2 target:(id)target;


//tag 1.前期沟通确认2.前期沟通驳回
    //3.设备报装确认4.设备报装驳回
    //5.现场技术交底确认6.现场技术交底驳回
    //7.安装凭证确认8.安装凭证驳回
    //9.第三方凭证确认10.第三方凭证驳回
    //11.启租单确认12.启租单驳回
//13.维保完成确认14.维保完成驳回
//15.维修完成确认16.维修完成驳回
//17.加高完成确认18.加高完成驳回
//19.停租单确认20.停租单驳回
//21.司机确认22.司机驳回
- (void)setBtnTitle1:(NSString *)title1 Width1:(CGFloat)wid1 BtnTitle2:(NSString *)title2 Width2:(CGFloat)wid2;
@end
