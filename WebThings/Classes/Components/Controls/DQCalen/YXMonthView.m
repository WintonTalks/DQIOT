//
//  YXMonthView.m
//  Calendar
//
//  Created by Vergil on 2017/7/6.
//  Copyright © 2017年 Vergil. All rights reserved.
//

#import "YXMonthView.h"

@interface YXMonthView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionV;

@end

@implementation YXMonthView

- (instancetype)initWithFrame:(CGRect)frame Date:(NSDate *)date {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _currentDate = date;
        [self setCollectionView];
    }
    return self;
}

//MARK: - settingView
- (void)setCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake((self.width - 1) / 7, dayCellH);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, dayCellH) collectionViewLayout:layout];
    _collectionV.scrollEnabled = NO;
    _collectionV.delegate = self;
    _collectionV.dataSource = self;
    _collectionV.backgroundColor = [UIColor whiteColor];
    [self addSubview:_collectionV];
    
    [_collectionV registerClass:[YXDayCell class] forCellWithReuseIdentifier:@"YXDayCell"];
     
     //registerNib:[UINib nibWithNibName:@"YXDayCell" bundle:nil] forCellWithReuseIdentifier:@"YXDayCell"];
    
}


//MARK: - setMethod

- (void)setEventArray:(NSArray *)eventArray {
    _eventArray = eventArray;
    [_collectionV reloadData];
}

- (void)setType:(CalendarType)type {
    _type = type;
    [_collectionV reloadData];
}

//MARK: - dateMethod

//获取cell的日期 (日 -> 六   格式,如需修改星期排序只需修改该函数即可)
- (NSDate *)dateForCellAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_type == CalendarType_Month) {
        NSCalendar *myCalendar = [NSCalendar currentCalendar];
        NSDate *firstOfMonth = [[YXDateHelpObject manager] GetFirstDayOfMonth:_currentDate];
        NSInteger ordinalityOfFirstDay = [myCalendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:firstOfMonth];
        NSDateComponents *dateComponents = [NSDateComponents new];
        dateComponents.day = (1 - ordinalityOfFirstDay) + indexPath.item;
        return [myCalendar dateByAddingComponents:dateComponents toDate:firstOfMonth options:0];
    } else {
        return [[YXDateHelpObject manager] getEarlyOrLaterDate:_currentDate LeadTime:indexPath.row - 6 Type:2];
    }
    
}

//MARK: - collectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_type == CalendarType_Week) {
        return 7;
    } else {
        return [[YXDateHelpObject manager] getRows:_currentDate] * 7;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YXDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXDayCell" forIndexPath:indexPath];
    NSDate *cellDate = [self dateForCellAtIndexPath:indexPath];
    cell.type = _type;
    cell.eventArray = _eventArray;
    cell.selectDate = _selectDate;
    cell.currentDate = _currentDate;
    cell.cellDate = cellDate;
    return cell;
    
}

//MARK: - collectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectDate = [self dateForCellAtIndexPath:indexPath];
    if (_sendSelectDate) {
        _sendSelectDate(_selectDate);
    }
    [_collectionV reloadData];
}

@end
