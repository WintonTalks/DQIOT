//
//  RobotChatViewController.m
//  WebThings
//
//  Created by machinsight on 2017/6/28.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "RobotChatViewController.h"
#import "EMICardView.h"
#import "RobotRemindView.h"
#import "iflyMSC/IFlyMSC.h"
#import "ISRDataHelper.h"
#import "IATConfig.h"

#import "RobotLeftCell.h"
#import "RobotRightCell.h"
#import "RobotContainerCell.h"
#import "RobotTextRemindCell.h"
#import "OperationFactory.h"
#import "OperationDelegate.h"
#import "CheckStringConfig.h"
#import "CheckString.h"

@interface RobotChatViewController ()<IFlySpeechRecognizerDelegate,IFlySpeechSynthesizerDelegate,UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,CAAnimationDelegate,OnCheckValueDelegate>

@property (strong,nonatomic) RobotRemindView *rmV;
/**
 识别动画父视图
 */
@property (strong, nonatomic) EMICardView *aniView;
@property (strong, nonatomic) YYAnimatedImageView *aniImgV;

//不带界面的识别对象
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
@property (nonatomic, strong) NSString *result;//识别结果
//语音合成助手
@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;

@property (nonatomic, strong) NSMutableArray <ChatModel *> *chatData;

@property (weak, nonatomic) IBOutlet UITableView *chatTableView;


@property (nonatomic,strong)UIScrollView *bottomScV;
@property (nonatomic,strong)NSMutableArray *bottomScVBtnTitleArrs;

@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@end

@implementation RobotChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVoice];
    [self initArr];
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initArr{
    _chatData = [NSMutableArray array];
    [_chatData addObject:[ChatModel getType0ModelWithStr:robot_originstr]];
//    [_chatData addObject:[ChatModel getType3ModelWithStr:@""]];
    [_iFlySpeechSynthesizer startSpeaking:robot_speakoriginstr];
    
    _bottomScVBtnTitleArrs = [NSMutableArray arrayWithObjects:@"设备开关",@"设备怎么重新启动",@"设备怎么检查设备故障", nil];
    ;
}

- (void)initVoice{
    [self initRecognizer];
    [self initSpeechSynthesizer];
    
    if (!_aniView) {
        _aniView = [[EMICardView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-78*autoSizeScaleX, 197*autoSizeScaleY)];
        _aniView.center = _bottomBtn.center;
        _aniView.hidden = YES;
        _aniView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_aniView];
        
        _aniImgV = [[YYAnimatedImageView alloc] init];
        [_aniView addSubview:_aniImgV];
        _aniImgV.sd_layout.topSpaceToView(_aniView, 0).leftSpaceToView(_aniView, 0).bottomSpaceToView(_aniView, 0).rightSpaceToView(_aniView, 0);
    }
}

- (void)initView{
    
    
    
    if (!_bottomScV) {
        _bottomScV = [[UIScrollView alloc] init];
        _bottomScV.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_bottomScV];
        _bottomScV.sd_layout.bottomSpaceToView(_bottomBtn, 13).heightIs(35).leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0);
        
        CGFloat margin = 11;
        CGFloat he = 34;
        CGFloat x = 11;
        for (int i=0; i<_bottomScVBtnTitleArrs.count; i++) {
            UIButton *btn = [[UIButton alloc] init];
            [btn setTitle:_bottomScVBtnTitleArrs[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#898A8B"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:@"DroidSansFallback" size:12.f];
            [btn withRadius:10];
            [btn borderWid:1];
            [btn borderColor:[UIColor colorWithHexString:@"#DBDCDD"]];
            [_bottomScV addSubview:btn];
            btn.sd_layout.leftSpaceToView(_bottomScV, x).topSpaceToView(_bottomScV, 0).heightIs(he).widthIs([btn fitWidth]);
            x = x + [btn fitWidth]+margin;
        }
        [_bottomScV setContentSize:CGSizeMake(x, 0)];
    }
    
    if (!_rmV) {
        _rmV = [[RobotRemindView alloc] initWithFrame:CGRectMake((screenWidth-351)/2, 122, 351, 400)];
        [self.view addSubview:_rmV];
    }
}
/**
 返回上一页

 @param sender button
 */
- (IBAction)back:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([_iFlySpeechSynthesizer isSpeaking]) {
        [_iFlySpeechSynthesizer stopSpeaking];
    }
    _iFlySpeechRecognizer = nil;
    _iFlySpeechSynthesizer = nil;
}

- (IBAction)listen:(id)sender {
    _rmV.hidden = YES;
    if (_iFlySpeechSynthesizer.isSpeaking) {
        [_iFlySpeechSynthesizer stopSpeaking];
    }
    
    [self showImg];
    
    
    [_iFlySpeechRecognizer cancel];
    
    //设置音频来源为麦克风
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //设置听写结果格式为json
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [_iFlySpeechRecognizer setParameter:nil forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    [_iFlySpeechRecognizer setDelegate:self];
    
    __block RobotChatViewController/*主控制器*/ *weakSelf = self;
//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
//    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [weakSelf.iFlySpeechRecognizer startListening];
//    });
}


//语音识别器
- (void)initRecognizer{
    _result = @"";
    if (!_iFlySpeechRecognizer) {
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        
    }
    _iFlySpeechRecognizer.delegate = self;
    IATConfig *instance = [IATConfig sharedInstance];
    
    //设置最长录音时间
    [_iFlySpeechRecognizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
    //设置后端点
    [_iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
    //设置前端点
    [_iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
    //网络等待时间
    [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
    
    //设置采样率，推荐使用16K
    [_iFlySpeechRecognizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    //设置语言
    [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
    //设置方言
    [_iFlySpeechRecognizer setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
    
    //设置是否返回标点符号
    [_iFlySpeechRecognizer setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
}


//语音合成器
- (void)initSpeechSynthesizer{
    //获取语音合成单例
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    //设置协议委托对象
    _iFlySpeechSynthesizer.delegate = self;
    //设置合成参数
    //设置在线工作方式
    [_iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD]
                                  forKey:[IFlySpeechConstant ENGINE_TYPE]];
    //设置音量，取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"50"
                                  forKey: [IFlySpeechConstant VOLUME]];
    //发音人，默认为”xiaoyan”，可以设置的参数列表可参考“合成发音人列表”
    [_iFlySpeechSynthesizer setParameter:@"xiaoqi"
                                  forKey: [IFlySpeechConstant VOICE_NAME]];
    //保存合成文件名，如不再需要，设置为nil或者为空表示取消，默认目录位于library/cache下
    [_iFlySpeechSynthesizer setParameter:nil
                                  forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
}
#pragma IFlySpeechRecognizerDelegate
- (void) onError:(IFlySpeechError *) errorCode{
    NSString *text ;
    
    if (errorCode.errorCode == 0 ) {
        if (_result.length == 0) {
            text = @"无识别结果";
        }else {
            text = @"识别成功";
            //清空识别结果
            _result = @"";
        }
    }else {
        text = [NSString stringWithFormat:@"发生错误：%d %@", errorCode.errorCode,errorCode.errorDesc];
        DQLog(@"%@",text);
    }
//    if (![text isEqualToString:@"识别成功"]) {
//        [self hideImgWithStr:text];
//    }
}

- (void) onResults:(NSArray *) results isLast:(BOOL)isLast{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    NSString * resultFromJson =  [ISRDataHelper stringFromJson:resultString];
    _result = [NSString stringWithFormat:@"%@%@", _result,resultFromJson];
    
    if (isLast){
        DQLog(@"听写结果(json)：%@测试",  self.result);
//        [self hideImgWithStr:self.result];
        [self say:_result];
        [CheckString checkValue:_result delegate:self];
        [self disShowImg];
    }
    DQLog(@"resultFromJson=%@",resultFromJson);
    DQLog(@"isLast=%d,_result=%@",isLast,_result);
}

-(void)returnValue:(ChatModel *)robotBean{
    if(robotBean){
        if([TYPE_TEXT isEqualToString:robotBean.checktype]){
            [_iFlySpeechSynthesizer startSpeaking:robotBean.data];
        }
        if (robotBean.returnmsg) {
            ChatModel *model = [ChatModel getType0ModelWithStr:robotBean.returnmsg];
            [_chatData addObject:model];
            [_iFlySpeechSynthesizer startSpeaking:robotBean.returnmsg];
        }
        [_chatData addObject:robotBean];
        [self.chatTableView reloadData];
        [self tableViewScrollToEnd];
    }
}

-(void)say:(NSString *)content{
    ChatModel *robotBean = [ChatModel getType1ModelWithStr:content];
    [_chatData addObject:robotBean];
    [self.chatTableView reloadData];
    [self tableViewScrollToEnd];
}

-(void)xiaoWeiSay:(NSString *)content{
    ChatModel *robotBean = [ChatModel getType0ModelWithStr:content];
    [_chatData addObject:robotBean];
    //机器人说话
    [_iFlySpeechSynthesizer startSpeaking:content];
    [self.chatTableView reloadData];
    [self tableViewScrollToEnd];
}

-(void)addChatModel:(ChatModel *)model{
    [_chatData addObject:model];
    [self.chatTableView reloadData];
    [self tableViewScrollToEnd];
}

- (void) onVolumeChanged: (int)volume{
    if (volume == 0) {
        _aniImgV.yy_imageURL = [[NSBundle mainBundle]URLForResource:@"start_voice" withExtension:@"gif"];
    }else if (volume <= 10) {
        _aniImgV.image = [UIImage imageNamed:@"ic_voice01"];
    }else if (volume <= 20){
        _aniImgV.image = [UIImage imageNamed:@"ic_voice02"];
    }else{
        _aniImgV.image = [UIImage imageNamed:@"ic_voice03"];
    }
}



//IFlySpeechSynthesizerDelegate协议实现
//合成结束
- (void) onCompleted:(IFlySpeechError *) error {


}
//合成开始
- (void) onSpeakBegin {

}
//合成缓冲进度
- (void) onBufferProgress:(int) progress message:(NSString *)msg {

}
//合成播放进度
- (void) onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos {

}

#pragma uitableviewdatasource && delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _chatData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatModel *robotBean = _chatData[indexPath.row];
    id<OperationDelegate> delegate = [OperationFactory factory:robotBean.checktype];
    return [delegate getTableViewCell:self tableView:tableView chatData:robotBean];
//    return [delegate getTableViewCell:sel tableview:tableView chatData:robotBean];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _chatData[indexPath.row].cellHeight;
}


#pragma 处理数据
- (void)handleDataWithStr:(NSString *)str{
    //用户语音
    ChatModel *newUserM = [ChatModel getType1ModelWithStr:str];
    [self.chatData addObject:newUserM];
    
    //机器人回复
    NSString *robotAnswer = @"我不明白你在说什么,以下是我为你百度的一些答案";
    ChatModel *newRobotM = [ChatModel getType0ModelWithStr:robotAnswer];
    [self.chatData addObject:newRobotM];
    [self.chatTableView reloadData];
    [_iFlySpeechSynthesizer startSpeaking:robotAnswer];
    
    //百度搜索
    ChatModel *newBaiduM = [ChatModel getType2ModelWithStr:str];
    [self.chatData addObject:newBaiduM];
    [self.chatTableView reloadData];
    
    [self tableViewScrollToEnd];
}

#pragma tableview滚动到最后
- (void)tableViewScrollToEnd{
    [_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_chatData.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


/**
 展示识别等待动画
 */
- (void)showImg{
    _aniView.hidden = NO;
    _aniImgV.yy_imageURL = [[NSBundle mainBundle]URLForResource:@"start_voice" withExtension:@"gif"];
    
    [UIView animateWithDuration:0.3 animations:^{
        _aniView.center = CGPointMake(screenWidth/2, screenHeight/2);
        [self setupCircleAnimationWithDirection:0];
    } completion:^(BOOL finished) {
        
    }];
}


- (void)hideImgWithStr:(NSString *)str{
    _aniImgV.yy_imageURL = [[NSBundle mainBundle]URLForResource:@"end_voice" withExtension:@"gif"];
    __block RobotChatViewController/*主控制器*/ *weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [weakSelf disShowImg];
        [weakSelf handleDataWithStr:str];
    });
    
}
/**
 影藏识别等待动画
 */
- (void)disShowImg{
    
    [UIView animateWithDuration:0.3 animations:^{
        _aniView.center = _bottomBtn.center;
        [self setupCircleAnimationWithDirection:1];
    } completion:^(BOOL finished) {
        self.aniView.hidden = YES;
    }];
}


/**
 遮罩动画

 @param direction 0，向上，1向下
 */
-(void)setupCircleAnimationWithDirection:(NSInteger)direction{
    
    CGFloat X = screenWidth-78*autoSizeScaleX;
    CGFloat Y = 197*autoSizeScaleY;
    CGRect xyF = CGRectMake(X/2, Y/2, 0, 0);
    UIBezierPath* origionPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(xyF, -_bottomBtn.frame.size.width, -_bottomBtn.frame.size.height)];
    
    
    CGFloat radius = sqrtf(X * X + Y * Y);
    UIBezierPath* finalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(xyF, -radius, -radius)];
    
    CAShapeLayer* layer = [CAShapeLayer layer];
    
    if (direction == 0) {
        layer.path = finalPath.CGPath;
        
    
    }else{
        layer.path = origionPath.CGPath;
        
    }
    
    _aniView.layer.mask = layer;
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.delegate = self;
    if (direction == 0) {
        
        animation.fromValue = (__bridge id _Nullable)(origionPath.CGPath);
        animation.toValue = (__bridge id _Nullable)(finalPath.CGPath);
    }else{
        
        animation.fromValue = (__bridge id _Nullable)(finalPath.CGPath);
        animation.toValue = (__bridge id _Nullable)(origionPath.CGPath);
    }
    
    animation.duration = 0.3;
    [layer addAnimation:animation forKey:@"path"];
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    _aniView.layer.mask = nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
