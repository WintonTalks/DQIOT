//
//  AddHeightOperation.m
//  WebThings
//
//  Created by Henry on 2017/8/3.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "AddHeightOperation.h"
#import "RobotAddHeightCell.h"
#import "AddDeviceHighWI.h"
#import "RobotDateTime.h"
@interface AddHeightOperation()<RobotDelegate>
@property(nonatomic,weak)RobotChatViewController *robotVC;
@property(nonatomic,strong)ChatModel *chatModel;
@end
@implementation AddHeightOperation

-(UITableViewCell *)getTableViewCell:(RobotChatViewController *)vc tableView:(UITableView *)tableView chatData:(ChatModel *)chatModel{
    _robotVC = vc;
    _chatModel = chatModel;
    RobotAddHeightCell *cell = [RobotAddHeightCell cellWithTableView:tableView data:chatModel.data];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    chatModel.cellHeight = [cell height];
    cell.delegate = self;
    return cell;
}

-(void)confirm:(id)data{
    NSArray *array = data;
    if([RobotDateTime checkEmpty:array]){
        NSNumber *height = [RobotDateTime strToInt:array[2]];
        [self fetchAddHeight:_chatModel date:array[0] enddate:array[1] height:height];
        
    }else{
        [_robotVC xiaoWeiSay:@"请填写完整数据"];
    }
}

//网络请求
-(void)fetchAddHeight:(ChatModel *)chatModel date:(NSString *)date enddate:(NSString *)enddate height:(NSNumber *)height{
    UserModel *user = [AppUtils readUser];
    AddDeviceHighWI *webInterface = [[AddDeviceHighWI alloc] init];
    DeviceModel *device = chatModel.data;
    NSArray *arr = @[[NSNumber numberWithInteger:user.userid],user.type,user.usertype,[NSNumber numberWithInteger:device.projectid],[NSNumber numberWithInteger:device.deviceid],date,enddate,height];
    NSDictionary *param = [webInterface inBox:arr];
    [CKNetTools requestWithRequestType:POST WithURL:webInterface.fullUrl WithParamater:param WithProgressBlock:^(NSProgress *process) {
        
    } WithSuccessBlock:^(id returnValue) {
        NSMutableArray *arr = [webInterface unBox:returnValue];
        if ([arr[0] intValue] == 1) {
            [_robotVC xiaoWeiSay:@"新增加高单成功"];
        }else{
            [_robotVC xiaoWeiSay:@"新增加高单失败"];
        }
    } WithFailureBlock:^(NSError *error) {
        [_robotVC xiaoWeiSay:@"新增加高单失败"];
    }];
}

@end
