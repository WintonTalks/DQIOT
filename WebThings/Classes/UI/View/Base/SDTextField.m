//
//  SDTextField.m
//  SDTextFieldDemo
//
//  Created by songjc on 16/10/11.
//  Copyright © 2016年 Don9. All rights reserved.
//

#import "SDTextField.h"

@interface SDTextField ()<UITableViewDelegate,UITableViewDataSource,MDTextFieldDelegate,CAAnimationDelegate>{
    BOOL ishideAni;//是否是影藏的动画
}

@property(nonatomic,strong)EMICardView *shadowedView;
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray <CK_ID_NameModel *> *searchList;

@property(nonatomic ,assign)CGRect viewFrame;

@end

@implementation SDTextField

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.viewFrame =frame;
        
        _textfield = [[MDTextField alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_textfield setFloatingLabel:YES];
        [_textfield setHighlightLabel:YES];
        [_textfield setNormalColor:[UIColor colorWithHexString:@"818B92"]];
        [_textfield setLinenormalColor:[UIColor colorWithHexString:@"EAEBEC"]];
        [_textfield setHighlightColor:[UIColor colorWithHexString:@"3C7BE1"]];
        [_textfield setTextColor:[UIColor colorWithHexString:@"000000"]];
        [_textfield setHintColor:[UIColor colorWithHexString:@"818B92"]];
        [_textfield setEnabled:YES];
        [_textfield setAutoComplete:NO];
        [_textfield setSingleLine:NO];
        _textfield.keyboardType = UIKeyboardTypeDefault;
        
        self.heightMultiple = 1;
        
        self.cellHeight =frame.size.height;
        
        self.layer.cornerRadius = 3;
        
        self.layer.masksToBounds = YES;

        _textfield.delegate = self;
        
        [self addSubview:_textfield];
        
        [self createTableView];
        
    }

    return self;

}

+(instancetype)initWithFrame:(CGRect)frame{

    SDTextField *textField = [[SDTextField alloc]initWithFrame:frame];


    return textField;
}

#pragma mark ----设置tableView----

-(void)createTableView{
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];

    self.searchList = [NSMutableArray arrayWithCapacity:0];
    
    self.shadowedView = [[EMICardView alloc] initWithFrame:CGRectMake(1, self.frame.size.height, self.frame.size.width-2, 155)];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width-2, 155)];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#FEFFFF"];
    
    _listBackgroundColor = [UIColor colorWithHexString:@"#FEFFFF"];
    
    self.tableView.separatorStyle = NO;

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SDtableViewCell"];
    
    self.shadowedView.backgroundColor = [UIColor whiteColor];
    [self.shadowedView addSubview:self.tableView];
    
    self.shadowedView.hidden = YES;
    [self addSubview:self.shadowedView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return self.searchList.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SDtableViewCell"];
//    cell.textLabel.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.font = [UIFont fontWithName:@"DroidSansFallback" size:16];
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;

    if (self.searchList.count !=0) {
        CK_ID_NameModel *film = (CK_ID_NameModel *)self.searchList[indexPath.row];
        cell.textLabel.text = film.cname;
        
    }
    
    return cell;


}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.cid = ((CK_ID_NameModel *)self.searchList[indexPath.row]).cid;
    self.pmArr = ((CK_ID_NameModel *)self.searchList[indexPath.row]).pm;
    self.textfield.text = cell.textLabel.text;
    if ([self.textDelegate respondsToSelector:@selector(didSelectText)]) {
        [self.textDelegate didSelectText];
    }
    [self hiddenTableView];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return _cellHeight;

}

#pragma mark ---- view整体高度改变 和tableView的显示和隐藏 ----
-(void)showTableView{

    //将selfe的高度调高到包含tableview的高度
    self.frame = CGRectMake(self.viewFrame.origin.x, self.viewFrame.origin.y, self.viewFrame.size.width, self.viewFrame.size.height*(self.heightMultiple+1));
    
    [self.superview bringSubviewToFront:self];
    
    self.shadowedView.hidden = NO;
    
    ishideAni = NO;
    //动画，高度从1到155
    [ChangeAnchorPoint setAnchorPoint:CGPointMake(0, 0) forView:_shadowedView];
    CABasicAnimation* animation = [CABasicAnimation animation];
    animation.keyPath=@"transform.scale.y";
    animation.fromValue= @(0);
    animation.toValue= @(1);
    animation.duration=0.3;
    animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.removedOnCompletion=NO;//动画结束了禁止删除
    animation.fillMode= kCAFillModeForwards;//停在动画结束处
    animation.delegate = self;
    [self.shadowedView.layer addAnimation:animation forKey:@"basic"];
}

-(void)hiddenTableView{
    
    ishideAni = YES;
    //高度从155降到1
    [ChangeAnchorPoint setAnchorPoint:CGPointMake(0, 0) forView:_shadowedView];
    CABasicAnimation* animation = [CABasicAnimation animation];
    animation.keyPath=@"transform.scale.y";
    animation.fromValue= @(1);
    animation.toValue= @(0);
    animation.duration=0.3;
    animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.removedOnCompletion=NO;//动画结束了禁止删除
    animation.fillMode= kCAFillModeForwards;//停在动画结束处
    animation.delegate = self;
    [self.shadowedView.layer addAnimation:animation forKey:@"basic"];
    
}


#pragma mark--- textField的代理方法 ----
- (void)textFieldDidBeginEditing:(MDTextField *)textField{
    [self handleTFValueChanged:textField];
}

- (void)textFieldDidChange:(MDTextField *)textField{
    [self handleTFValueChanged:textField];
}

- (void)handleTFValueChanged:(MDTextField *)textField{
    if (self.textfield.text.length == 0) {
        
        
        //        [self hiddenTableView];
        
        if (self.searchList!= nil) {
            [self.searchList removeAllObjects];
        }
        //过滤数据
        self.searchList= [NSMutableArray arrayWithArray:self.dataArray];
        
        if (self.searchList.count !=0) {
            self.heightMultiple = 3;
            [self showTableView];
            
            [[[self superview] superview] bringSubviewToFront:[self superview]];//将rightView送到最前面
            
        }else{
            
            [self hiddenTableView];
            
            [[[self superview] superview] sendSubviewToBack:[self superview]];//将rightView发送回底层
            
        }
    }else{
        NSString *searchString = self.textfield.text;
        NSPredicate *preicate = [NSPredicate predicateWithFormat:@"cname CONTAINS[c] %@", searchString];
        if (self.searchList!= nil) {
            [self.searchList removeAllObjects];
        }
        //过滤数据
        self.searchList= [NSMutableArray arrayWithArray:[self.dataArray filteredArrayUsingPredicate:preicate]];
        
        if (self.searchList.count !=0) {
            self.heightMultiple = 3;
            [self showTableView];
            
            [[[self superview] superview] bringSubviewToFront:[self superview]];//将rightView送到最前面
        }else{
            
            [self hiddenTableView];
            
            [[[self superview] superview] sendSubviewToBack:[self superview]];//将rightView发送回底层
            
        }
    }
    //刷新表格
    [self.tableView reloadData];
}

-(void)textFieldDidEndEditing:(MDTextField *)textField{

    [self hiddenTableView];
    
    [[[self superview] superview] sendSubviewToBack:[self superview]];//将rightView发送回底层

}

-(BOOL)textFieldShouldReturn:(MDTextField *)textField{
    [self.textfield resignFirstResponder];
    
    if (self.frame.size.height != self.viewFrame.size.height) {
        
        [self hiddenTableView];

        [[[self superview] superview] sendSubviewToBack:[self superview]];//将rightView发送回底层
    }

    return YES;

}



#pragma mark ---属性相关---

-(void)setListBackgroundColor:(UIColor *)listBackgroundColor{

    _listBackgroundColor = listBackgroundColor;
    
    self.tableView.backgroundColor = listBackgroundColor;


}

-(void)setHeightMultiple:(int)heightMultiple{

    _heightMultiple = heightMultiple;
    
    
}

-(void)setCellHeight:(CGFloat)cellHeight{

    _cellHeight = cellHeight;


}

#pragma animationDelegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (ishideAni) {
        self.shadowedView.hidden = YES;
        self.frame = self.viewFrame;
    }
    [ChangeAnchorPoint setDefaultAnchorPointforView:_shadowedView];
}
@end
