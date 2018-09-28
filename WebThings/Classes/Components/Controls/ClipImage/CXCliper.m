//
//  CXCliper.m
//  CXCliper
//
//  Created by 柴炫炫 on 16/5/10.
//  Copyright © 2016年 柴炫炫. All rights reserved.
//

/*
 CGContextFillRects(context, (CGRectMake(0,  0,  w,  h1),
 CGRectMake(0,  h1, w1, h),
 CGRectMake(x2, h1, w2, h),
 CGRectMake(0,  y2, w,  h2), nil), 4);
 */


#import "CXCliper.h"


/*!
 *  转换成弧度
 *
 *  param  : 角度
 *  return : 弧度
 */

//static inline float radians (double degrees) {
//    return degrees * M_PI / 180;
//}

#define kOffset         20
#define kCornerLine_w   10


@interface CXCliper () {
    UIImageView *_imageView;    // 裁剪图片
    CGRect      _clipRect;      // 裁剪位置
    CGPoint     _startPoint;    // 点击位置
}

@end


@implementation CXCliper

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {}
    return self;
}

-(instancetype)initWithImageView:(UIImageView *)imageView
{
    CGRect frame = imageView.bounds;
    
    if (self = [super initWithFrame:frame])
    {
        [imageView addSubview:self];
        [imageView setUserInteractionEnabled:YES];
        
        self.backgroundColor = [UIColor clearColor];
        self.multipleTouchEnabled = NO;
        
        // 设置裁剪区域
        _clipRect = CGRectMake((frame.size.width-MIN(frame.size.width, frame.size.height))/2,
                               (frame.size.height-MIN(frame.size.width, frame.size.height))/2,
                               MIN(frame.size.width, frame.size.height),
                               MIN(frame.size.width, frame.size.height));
        
        // 设置裁剪图片
        _imageView = imageView;
        
        // 初始化点击位置
        _startPoint = CGPointZero;
        
        // 网格框填充颜色
        _gridFillColor = [UIColor clearColor];
        // 网格框边框颜色
        _gridBorderColor = [UIColor clearColor];
        
        // 是否显示阴影区域
        _showShadow = YES;
        // 阴影区域颜色
        _shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.65];
        
        // 是否显示网格边角
        _showGridCorner = YES;
        // 网格边角样式
        _gridCornerStyle = GridCornerStyleCircle;
        // 网格边角颜色
        _gridCornerColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.85];
        
        // 是否显示网格线
        _showGridLine = YES;
        // 网格线宽度
        _gridLineWidth = 1.0f;
        // 网格边角线宽度
        _gridCornerWidth = 3.0f;
        // 网格边角线高度
        _gridCornerHeight = 10.0f;
        // 网格边角半径
        _gridCornerRadius = 5.0f;
        // 网格线颜色
        _gridLineColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.65];
        
        // 网格框水平方向个数
        _gridHorizontalCount = 3;
        // 网格框垂直方向个数
        _gridVerticalCount = 3;
    }
    
    return self;
}


#pragma mark-SET Methods

/*阴影区域颜色*/

-(void)setShowShadow:(BOOL)showShadow
{
    _showShadow = showShadow;
    [self setNeedsDisplay];
}

-(void)setShadowColor:(UIColor *)shadowColor
{
    _shadowColor = shadowColor;
    [self setNeedsDisplay];
}

/* 网格框颜色 */

-(void)setGridFillColor:(UIColor *)gridFillColor
{
    _gridFillColor = gridFillColor;
    [self setNeedsDisplay];
}

-(void)setGridBorderColor:(UIColor *)gridBorderColor
{
    _gridBorderColor = gridBorderColor;
    [self setNeedsDisplay];
}

/*网格框边角*/

-(void)setShowGridCorner:(BOOL)showGridCorner
{
    _showGridCorner = showGridCorner;
    [self setNeedsDisplay];
}

-(void)setGridCornerStyle:(GridCornerStyle)gridCornerStyle
{
    _gridCornerStyle = gridCornerStyle;
    [self setNeedsDisplay];
}

-(void)setGridCornerColor:(UIColor *)gridCornerColor
{
    _gridCornerColor = gridCornerColor;
    [self setNeedsDisplay];
}

-(void)setGridCornerRadius:(CGFloat)gridCornerRadius
{
    _gridCornerRadius = gridCornerRadius;
    [self setNeedsDisplay];
}

-(void)setGridCornerWidth:(CGFloat)gridCornerWidth
{
    _gridCornerWidth = gridCornerWidth;
    [self setNeedsDisplay];
}

-(void)setGridCornerHeight:(CGFloat)gridCornerHeight
{
    _gridCornerHeight = gridCornerHeight;
    [self setNeedsDisplay];
}

/*网格线*/

-(void)setShowGridLine:(BOOL)showGridLine
{
    _showGridLine = showGridLine;
    [self setNeedsDisplay];
}

-(void)setGridLineColor:(UIColor *)gridLineColor
{
    _gridLineColor = gridLineColor;
    [self setNeedsDisplay];
}

-(void)setGridLineWidth:(CGFloat)gridLineWidth
{
    _gridLineWidth = gridLineWidth;
    [self setNeedsDisplay];
}

/*网格框数量*/

-(void)setGridHorizontalCount:(CGFloat)gridHorizontalCount
{
    _gridHorizontalCount = gridHorizontalCount;
    [self setNeedsDisplay];
}

-(void)setGridVerticalCount:(CGFloat)gridVerticalCount
{
    _gridVerticalCount = gridVerticalCount;
    [self setNeedsDisplay];
}


#pragma mark - Check Clear Color

-(BOOL)isClearColor:(UIColor *)color
{
    CGFloat red, green, blue, alpha;
    
    if ([color getRed:&red green:&green blue:&blue alpha:&alpha])
    {
        return (alpha == 0.0f);
    }
    else
    {
        return YES;
    }
}


#pragma mark-DrawRect-重绘

-(void)drawRect:(CGRect)rect
{
    /* 获取当前画布 */
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /* 绘制阴影区域 */
    
    if (_showShadow)
    {
        // 设置阴影颜色
        CGContextSetFillColorWithColor(context, _shadowColor.CGColor);
        
        // 上 | 左 | 右 | 下
        CGContextFillRect(context, CGRectMake(0, 0, rect.size.width, _clipRect.origin.y));
        CGContextFillRect(context, CGRectMake(0, _clipRect.origin.y, _clipRect.origin.x, _clipRect.size.height));
        CGContextFillRect(context, CGRectMake(_clipRect.origin.x+_clipRect.size.width, _clipRect.origin.y, rect.size.width-_clipRect.origin.x-_clipRect.size.width, _clipRect.size.height                    ));
        CGContextFillRect(context, CGRectMake(0, _clipRect.origin.y+_clipRect.size.height, rect.size.width, rect.size.height-_clipRect.origin.y-_clipRect.size.height));
    }
    
    /* 绘制网格框颜色 */
    
    if (_gridFillColor)
    {
        CGContextSetFillColorWithColor(context, _gridFillColor.CGColor);
        CGContextFillRect(context, _clipRect);
    }
    
    if (_gridBorderColor)
    {
        CGContextSetStrokeColorWithColor(context, _gridBorderColor.CGColor);
        CGContextSetLineWidth(context, _gridLineWidth);
        
        // 上 : -
        CGContextMoveToPoint(context, _clipRect.origin.x, _clipRect.origin.y);
        CGContextAddLineToPoint(context, _clipRect.origin.x + _clipRect.size.width, _clipRect.origin.y);
        
        // 左 : |
        CGContextMoveToPoint(context, _clipRect.origin.x, _clipRect.origin.y);
        CGContextAddLineToPoint(context, _clipRect.origin.x, _clipRect.origin.y + _clipRect.size.height);
        
        // 右 : |
        CGContextMoveToPoint(context, _clipRect.origin.x + _clipRect.size.width, _clipRect.origin.y);
        CGContextAddLineToPoint(context, _clipRect.origin.x + _clipRect.size.width, _clipRect.origin.y + _clipRect.size.height);
        
        // 下 : -
        CGContextMoveToPoint(context, _clipRect.origin.x, _clipRect.origin.y + _clipRect.size.height);
        CGContextAddLineToPoint(context, _clipRect.origin.x + _clipRect.size.width, _clipRect.origin.y + _clipRect.size.height);
    }
    
    /*  绘制网格
     
     1.<画线描述>:                        |  2.<点描述>:
     线1: 点(x:1,y:0)-点(x:1,y:3)-竖  |  (0,0)   (1,0)   (2,0)   (3,0)
     线2: 点(x:2,y:0)-点(x:2,y:3)-竖  |  (0,1)   (1,1)   (2,1)   (3,1)
     线3: 点(x:0,y:1)-点(x:3,y:1)-行  |  (0,2)   (1,2)   (2,2)   (3,2)
     线4: 点(x:1,y:2)-点(x:3,y:2)-行  |  (0,3)   (1,3)   (2,3)   (3,3)   */
    
    if (_showGridLine && (_gridHorizontalCount >= 2 || _gridVerticalCount >= 2))
    {
        // 设置一笔画颜色
        CGContextSetStrokeColorWithColor(context, _gridLineColor.CGColor);
        CGContextSetLineWidth(context, _gridLineWidth);
        
        // 线 : |
        if (_gridHorizontalCount >= 2)
        {
            for (int i = 1; i < _gridHorizontalCount; i++)
            {
                CGContextMoveToPoint(context, _clipRect.origin.x+(_clipRect.size.width/_gridHorizontalCount)*i, _clipRect.origin.y);
                CGContextAddLineToPoint(context, _clipRect.origin.x+(_clipRect.size.width/_gridHorizontalCount)*i, _clipRect.origin.y+_clipRect.size.height);
            }
        }
        
        // 线 : -
        if (_gridVerticalCount >= 2)
        {
            for (int i = 1; i < _gridVerticalCount; i++)
            {
                CGContextMoveToPoint(context, _clipRect.origin.x, _clipRect.origin.y+(_clipRect.size.height/_gridVerticalCount)*i);
                CGContextAddLineToPoint(context, _clipRect.origin.x+_clipRect.size.width, _clipRect.origin.y+(_clipRect.size.height/_gridVerticalCount)*i);
            }
        }
        
        CGContextStrokePath(context);
    }
    
    // 绘制网格边角
    
    if (_showGridCorner)
    {
        switch (_gridCornerStyle)
        {
            case GridCornerStyleCircle:
            {
                // 设置四角颜色
                CGContextSetFillColor(context, CGColorGetComponents(_gridCornerColor.CGColor));
                
                // 左上
                CGContextMoveToPoint(context, _clipRect.origin.x, _clipRect.origin.y);
                CGContextAddArc(context, _clipRect.origin.x, _clipRect.origin.y, _gridCornerRadius, -M_PI, M_PI, 0);
                CGContextFillPath(context);
                // 右上
                CGContextMoveToPoint(context, _clipRect.origin.x+_clipRect.size.width, _clipRect.origin.y);
                CGContextAddArc(context, _clipRect.origin.x+_clipRect.size.width, _clipRect.origin.y, _gridCornerRadius, -M_PI, M_PI, 0);
                CGContextFillPath(context);
                // 左下
                CGContextMoveToPoint(context, _clipRect.origin.x, _clipRect.origin.y+_clipRect.size.height);
                CGContextAddArc(context, _clipRect.origin.x, _clipRect.origin.y+_clipRect.size.height, _gridCornerRadius, -M_PI, M_PI, 0);
                CGContextFillPath(context);
                // 右下
                CGContextMoveToPoint(context, _clipRect.origin.x+_clipRect.size.width, _clipRect.origin.y+_clipRect.size.height);
                CGContextAddArc(context, _clipRect.origin.x+_clipRect.size.width, _clipRect.origin.y+_clipRect.size.height, _gridCornerRadius, -M_PI, M_PI, 0);
                CGContextFillPath(context);
            }
                break;
                
            case GridCornerStyleLine:
            {
                // 设置四角颜色及宽度
                CGContextSetStrokeColorWithColor(context, _gridCornerColor.CGColor);
                CGContextSetLineWidth(context, _gridLineWidth);
                
                // 角标一_左上 : '|'
                CGContextMoveToPoint(context, _clipRect.origin.x, _clipRect.origin.y);
                CGContextAddLineToPoint(context, _clipRect.origin.x, _clipRect.origin.y+_gridCornerHeight);
                // 角标一_左上 : '-'
                CGContextMoveToPoint(context, _clipRect.origin.x, _clipRect.origin.y);
                CGContextAddLineToPoint(context, _clipRect.origin.x+_gridCornerHeight, _clipRect.origin.y);
                
                // 角标二_右上 : '|'
                CGContextMoveToPoint(context, _clipRect.origin.x+_clipRect.size.width, _clipRect.origin.y);
                CGContextAddLineToPoint(context, _clipRect.origin.x+_clipRect.size.width, _clipRect.origin.y+_gridCornerHeight);
                // 角标二_右上 : '-'
                CGContextMoveToPoint(context, _clipRect.origin.x+_clipRect.size.width, _clipRect.origin.y);
                CGContextAddLineToPoint(context, _clipRect.origin.x+_clipRect.size.width-_gridCornerHeight, _clipRect.origin.y);
                
                // 角标三_左下 : '|'
                CGContextMoveToPoint(context, _clipRect.origin.x, _clipRect.origin.y+_clipRect.size.height);
                CGContextAddLineToPoint(context, _clipRect.origin.x, _clipRect.origin.y+_clipRect.size.height-_gridCornerHeight);
                // 角标三_左下 : '-'
                CGContextMoveToPoint(context, _clipRect.origin.x, _clipRect.origin.y+_clipRect.size.height);
                CGContextAddLineToPoint(context, _clipRect.origin.x+_gridCornerHeight, _clipRect.origin.y+_clipRect.size.height);
                
                // 角标四_右下 : '-'
                CGContextMoveToPoint(context, _clipRect.origin.x+_clipRect.size.width, _clipRect.origin.y+_clipRect.size.height);
                CGContextAddLineToPoint(context, _clipRect.origin.x+_clipRect.size.width-_gridCornerHeight, _clipRect.origin.y+_clipRect.size.height);
                // 角标四_右下 : '|'
                CGContextMoveToPoint(context, _clipRect.origin.x+_clipRect.size.width, _clipRect.origin.y+_clipRect.size.height);
                CGContextAddLineToPoint(context, _clipRect.origin.x+_clipRect.size.width, _clipRect.origin.y+_clipRect.size.height-_gridCornerHeight);
            }
                break;
        }
    }
    
    // 根据 Context 绘制角标
    CGContextStrokePath(context);
}


#pragma mark-Touch Methds

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _startPoint = [touch locationInView:self];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _startPoint = CGPointZero;
    [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    // Rect 左
    if (point.x < 0)
    {
        point.x = 0;
        
        // Rect 左上
        if (point.y < 0)
        {
            point.y = 0;
        }
        // Rect 左下
        else if (point.y > self.frame.size.height)
        {
            point.y = self.frame.size.height;
        }
    }
    // Rect 右
    else if (point.x > self.frame.size.width)
    {
        point.x = self.frame.size.width;
        
        // Rect 右上
        if (point.y < 0)
        {
            point.y = 0;
        }
        // Rect 右下
        else if (point.y > self.frame.size.height)
        {
            point.y = self.frame.size.height;
        }
    }
    else
    {
        // Rect 上
        if (point.y < 0)
        {
            point.y = 0;
        }
        // Rect 下
        else if (point.y > self.frame.size.height)
        {
            point.y = self.frame.size.height;
        }
    }
    
    float x1 = .0f, x2 = .0f, y1 = .0f, y2 = .0f;
    
    // 左
    if (fabs(_startPoint.x - _clipRect.origin.x) < 20)
    {
        // 左上角
        if (fabsf((float)(_startPoint.y - _clipRect.origin.y)) < 20)
        {
            x1 = point.x - _startPoint.x;
            y1 = point.y - _startPoint.y;
        }
        // 左下角
        else if(fabs((float)(_startPoint.y - _clipRect.origin.y) - _clipRect.size.height) < 20)
        {
            x1 = point.x - _startPoint.x;
            y2 = point.y - _startPoint.y;
        }
        // 左中部
        else if(_startPoint.y > _clipRect.origin.y &&
                _startPoint.y < _clipRect.origin.y + _clipRect.size.height)
        {
            x1 = point.x - _startPoint.x;
        }
    }
    // 右
    else if(fabs(_startPoint.x - _clipRect.origin.x - _clipRect.size.width) < 20)
    {
        // 右上角
        if (fabsf((float)(_startPoint.y - _clipRect.origin.y)) < 20)
        {
            x2 = point.x - _startPoint.x;
            y1 = point.y - _startPoint.y;
        }
        // 右下角
        else if(fabs((float)(_startPoint.y - _clipRect.origin.y) - _clipRect.size.height) < 20)
        {
            x2 = point.x - _startPoint.x;
            y2 = point.y - _startPoint.y;
        }
        // 右中部
        else if(_startPoint.y > _clipRect.origin.y &&
                _startPoint.y < _clipRect.origin.y + _clipRect.size.height)
        {
            x2 = point.x - _startPoint.x;
        }
    }
    // 上
    else if(fabs(_startPoint.y-_clipRect.origin.y) < 20)
    {
        // 上中
        if (_startPoint.x > _clipRect.origin.x &&
            _startPoint.x < _clipRect.size.width)
        {
            y1 = point.y - _startPoint.y;
        }
    }
    // 下
    else if(fabs(_startPoint.y - _clipRect.origin.y - _clipRect.size.height) < 20)
    {
        // 下中
        if (_startPoint.x > _clipRect.origin.x &&
            _startPoint.x < _clipRect.size.width)
        {
            y2 = point.y - _startPoint.y;
        }
    }
    // 正中
    else if((_startPoint.x > _clipRect.origin.x &&
             _startPoint.x < _clipRect.origin.x + _clipRect.size.width)&&
            (_startPoint.y > _clipRect.origin.y &&
             _startPoint.y < _clipRect.origin.y + _clipRect.size.height))
    {
        _clipRect.origin.x += (point.x - _startPoint.x);
        _clipRect.origin.y += (point.y - _startPoint.y);
        
        if (_clipRect.origin.x < 0)
        {
            _clipRect.origin.x = 0;
        }
        else if(_clipRect.origin.x > self.bounds.size.width - _clipRect.size.width)
        {
            _clipRect.origin.x = self.bounds.size.width - _clipRect.size.width;
        }
        
        if (_clipRect.origin.y < 0)
        {
            _clipRect.origin.y = 0;
        }
        else if(_clipRect.origin.y > self.bounds.size.height - _clipRect.size.height)
        {
            _clipRect.origin.y = self.bounds.size.height - _clipRect.size.height;
        }
    }
    else
    {
        return;
    }
    
    [self ChangeclipEDGE_x1:x1 x2:x2 y1:y1 y2:y2];  // 根据变化量重绘剪切区域
    [self setNeedsDisplay];                         // 通知重绘
    _startPoint = point;                            // 记录点击位置
}

#pragma mark-休整剪切区域 -> Touch Moved Method : 根据变化量动态调整视图显示

- (CGRect)ChangeclipEDGE_x1:(float)x1 x2:(float)x2 y1:(float)y1 y2:(float)y2
{
    _clipRect.origin.x    += x1;
    _clipRect.size.width  -= x1;
    _clipRect.origin.y    += y1;
    _clipRect.size.height -= y1;
    _clipRect.size.width  += x2;
    _clipRect.size.height += y2;
    
    if (_clipRect.size.width < 60)
    {
        if (x1 > 0.f)
        {
            _clipRect.origin.x -= 60.0 - _clipRect.size.width;
        }
        
        _clipRect.size.width = 60;
    }
    else if(_clipRect.size.height < 60)
    {
        if (y1 > 0.f)
        {
            _clipRect.origin.y -= 60.0 - _clipRect.size.height;
        }
        
        _clipRect.size.height = 60;
    }
    
    return _clipRect;
}


#pragma mark-获取剪切图片

- (UIImage *)getClipImage
{
    // 计算图片的'实际尺寸'与'缩放比'
    float scale = (_imageView.image.size.width * _imageView.image.scale) / _imageView.frame.size.width;
    
    CGRect clipCGRect = CGRectMake(_clipRect.origin.x * scale,
                                   _clipRect.origin.y * scale,
                                   _clipRect.size.width * scale,
                                   _clipRect.size.height * scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(_imageView.image.CGImage, clipCGRect);
    UIImage *clipImage = [[UIImage alloc] initWithCGImage:imageRef];
    
    return clipImage;
}

- (CGRect)getClipRect {
    return _clipRect;
}

- (void)setClipRect:(CGRect)rect {
    _clipRect = rect;
}

@end

