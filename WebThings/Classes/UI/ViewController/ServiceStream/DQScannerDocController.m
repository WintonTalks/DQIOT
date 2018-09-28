//
//  DQScannerDocController.m
//  WebThings
//  扫描文档
//  Created by Heidi on 2017/10/9.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQScannerDocController.h"
#import <AVFoundation/AVFoundation.h>
#import <Vision/Vision.h>

#import "CVPixelBufferUtils.h"

#import "AVCamPreviewView.h"
//#import "DQClipView.h"

#import "DQClipImageController.h"

typedef NS_ENUM(uint8_t, MOVRotateDirection)
{
    MOVRotateDirectionNone = 0,
    MOVRotateDirectionCounterclockwise90,
    MOVRotateDirectionCounterclockwise180,
    MOVRotateDirectionCounterclockwise270,
    MOVRotateDirectionUnknown
};

@interface DQScannerDocController ()
<AVCaptureVideoDataOutputSampleBufferDelegate>
{
    UIView *_topActionBtnView;      // 关闭和闪光灯按钮
    UIView *_topFinishBtnView;      // 重拍和完成按钮
    UIButton *_btnTakePhoto;        // 拍照按钮
    
    UIImageView *_highlightView;    // 展示摄像头视频
    
    AVCaptureSession *_captureSession;
    NSUInteger _counter;
    
    UIButton *_btnChoosed;     // 右下角已选好的
    UILabel *_lblBadge;             // 角标，已选几张图
    NSMutableArray *_arrayImages;   // 已选择的图片
    CGRect _rectRecognized;         // 已识别的区域
    
    BOOL _isLightON;    // 闪光灯开启
}

@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) NSMutableDictionary<NSString *, VNDetectedObjectObservation *> *lastObsercationsDic;

@property (nonatomic, strong) VNSequenceRequestHandler *sequenceHandler;
@property (nonatomic, strong) AVCamPreviewView *preView;
@property (nonatomic, strong) UIImage *capturedImage;

@end

@implementation DQScannerDocController

#pragma mark - Init
- (void)initSubViews {
    CGFloat width = screenWidth;
    
    self.preView = [[AVCamPreviewView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.preView];

    _highlightView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _highlightView.contentMode = UIViewContentModeScaleAspectFit;
    _highlightView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_highlightView];
    
    // 操作过程中的按钮层
    _topActionBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, width, 64)];
    [self.view addSubview:_topActionBtnView];
    
    UIButton *btnCancel = [self
                           buttonWithTitle:nil
                           icon:@"icon_close_white"
                           sel:@selector(onCancelClick)
                           frame:CGRectMake(0, 0, 58, 64)];
    [_topActionBtnView addSubview:btnCancel];

    UIButton *btnFlash = [self
                          buttonWithTitle:nil
                          icon:@"icon_flash"
                          sel:@selector(onFlashLightClick)
                          frame:CGRectMake(width - 58, 0, 58, 64)];
    [_topActionBtnView addSubview:btnFlash];
    
    // 拍照按钮
    _btnTakePhoto = [self
                     buttonWithTitle:nil
                     icon:@"icon_takephoto"
                     sel:@selector(onTakePhotoClick)
                     frame:CGRectMake(width/2.0 - 40, self.view.frame.size.height - 104, 80, 80)];
    [self.view addSubview:_btnTakePhoto];
    
    _btnChoosed = [self buttonWithTitle:nil
                                   icon:nil sel:@selector(onReTakeClick)
                                  frame:CGRectMake(width - 56, screenHeight - 56, 40, 40)];
    _btnChoosed.layer.cornerRadius = 5.0;
    _btnChoosed.backgroundColor = [UIColor colorWithHexString:COLOR_LINE];
    [self.view addSubview:_btnChoosed];
    _btnChoosed.hidden = YES;
    
    _lblBadge = [[UILabel alloc] initWithFrame:
                 CGRectMake(width - 23, _btnChoosed.frame.origin.y - 7, 14, 14)];
    _lblBadge.backgroundColor = [UIColor colorWithHexString:COLOR_RED];
    _lblBadge.font = [UIFont systemFontOfSize:10];
    _lblBadge.textColor = [UIColor whiteColor];
    _lblBadge.layer.cornerRadius = 7.0;
    _lblBadge.layer.masksToBounds = YES;
    _lblBadge.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_lblBadge];
    _lblBadge.hidden = YES;
}

// 创建button
- (UIButton *)buttonWithTitle:(NSString *)title
                         icon:(NSString *)iconName
                          sel:(SEL)sel
                        frame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title.length > 0) {
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if (iconName.length > 0) {
        [button setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    }
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    button.frame = frame;
    
    return button;
}

// 初始化捕捉视频
- (void)initCapture {
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo]  error:nil];
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    //captureOutput.minFrameDuration = CMTimeMake(1, 10);
    
    dispatch_queue_t queue = dispatch_queue_create("cameraQueue", NULL);
    self.queue = queue;
    [captureOutput setSampleBufferDelegate:self queue:queue];
    
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:captureInput];
    [_captureSession addOutput:captureOutput];
    
    self.preView.session = _captureSession;
}

- (void)startClip {
//    [_clipView setClipImage:_highlightView.image];
    
    CGFloat width = _highlightView.frame.size.width;
    CGFloat height = _highlightView.frame.size.height;
    
    DQClipImageController *ctl = [[DQClipImageController alloc] init];
    ctl.image = self.capturedImage;
    ctl.clipRect = CGRectMake(_rectRecognized.origin.x * width,
                              width * _rectRecognized.origin.y,
                              width * _rectRecognized.size.width,
                              height * _rectRecognized.size.height);
    ctl.clipFinished = ^(id result1, id result2) {
        [self doFinishAnimationWithImage:result1 rect:[result2 CGRectValue]];
    };
    [self.navigationController pushViewController:ctl animated:NO];
}

- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // 为媒体数据设置一个CMSampleBuffer的Core Video图像缓存对象
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // 锁定pixel buffer的基地址
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // 得到pixel buffer的基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // 得到pixel buffer的行字节数
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // 得到pixel buffer的宽和高
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // 创建一个依赖于设备的RGB颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphics context）对象
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // 根据这个位图context中的像素数据创建一个Quartz image对象
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // 解锁pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // 释放context和颜色空间
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // 用Quartz image创建一个UIImage对象image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // 释放Quartz image对象
    CGImageRelease(quartzImage);
    
    return (image);
}

#pragma mark -
- (void)startCapture {
    [_captureSession startRunning];
    
//    _highlightView.hidden = NO;
//    _topFinishBtnView.hidden = YES;
//    _topActionBtnView.hidden = NO;
//    _btnTakePhoto.hidden = NO;
}

- (void)stopCapture {
    [_captureSession stopRunning];
    
//    _topFinishBtnView.hidden = NO;
//    _topActionBtnView.hidden = YES;
//    _btnTakePhoto.hidden = YES;
//    _highlightView.hidden = YES;
}

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _arrayImages = [NSMutableArray arrayWithCapacity:0];
    
    [self initSubViews];
    [self initCapture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self startCapture];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self stopCapture];
    [super viewWillDisappear:animated];
}

#pragma mark AVCaptureSession6 delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (_counter  % 10 != 0) {
        _counter ++;
        return;
    }
    _counter = 0;
    
    CVPixelBufferRef rotateBuffer = [CVPixelBufferUtils rotateBuffer:sampleBuffer withConstant:MOVRotateDirectionCounterclockwise270];
    
    [self detectTextWithPixelBuffer:rotateBuffer];      // 找文字
    self.capturedImage = [[self imageFromSampleBuffer:sampleBuffer] yy_imageByRotateRight90];
    
    CVBufferRelease(rotateBuffer);
}

#pragma mark -
// 使用pixelBuffer进行文字检测
- (void)detectTextWithPixelBuffer:(CVPixelBufferRef)pixelBuffer
{
    void (^ VNRequestCompletionHandler)(VNRequest *request, NSError * _Nullable error) = ^(VNRequest *request, NSError * _Nullable error)
    {
        if (nil == error) {
            
            size_t width = CVPixelBufferGetWidth(pixelBuffer);
            size_t height = CVPixelBufferGetHeight(pixelBuffer);
            CGSize size = CGSizeMake(width, height);
            void (^UIGraphicsImageDrawingActions)(UIGraphicsImageRendererContext *rendererContext) = ^(UIGraphicsImageRendererContext *rendererContext)
            {
                //vision框架使用的坐标是为 0 -》 1， 原点为屏幕的左下角（跟UIKit不同），向右向上增加，其实就是Opengl的纹理坐标系。
                CGAffineTransform  transform = CGAffineTransformIdentity;
                transform = CGAffineTransformScale(transform, size.width, -size.height);
                transform = CGAffineTransformTranslate(transform, 0, -1);
                
                CGFloat minX = 0.0;
                CGFloat minY = 0.0;
                CGFloat maxX = 0.0;
                CGFloat maxY = 0.0;
                
                for (VNTextObservation *textObservation in request.results)
                {
                    //                    [[UIColor redColor] setStroke];
                    //                    [[UIBezierPath bezierPathWithRect:CGRectApplyAffineTransform(textObservation.boundingBox, transform)] stroke];
                    CGRect rect = textObservation.boundingBox;
                    if (minX == 0.0) {
                        minX = rect.origin.x;
                    }
                    if (minY == 0.0) {
                        minY = rect.origin.y;
                    }
                    if (rect.origin.x > 0.0 && rect.origin.x < minX) {
                        minX = rect.origin.x;
                    }
                    if (maxX < rect.origin.x) {
                        maxX = rect.origin.x;
                    }
                    if (rect.origin.y > 0.0 && rect.origin.y < minY) {
                        minY = rect.origin.y;
                    }
                    if (maxY < rect.origin.y) {
                        maxY = rect.origin.y;
                    }
                }
                _rectRecognized = CGRectMake(minX, minY, maxX, maxY);

                UIBezierPath *path = [UIBezierPath
                                      bezierPathWithRect:_rectRecognized];
                path.lineWidth = 4.0;
                [[UIColor colorWithHexString:COLOR_LINE alpha:0.5] setFill];
                [[UIColor colorWithHexString:COLOR_BLUE] setStroke];
                [path applyTransform:transform];
                [path stroke];
            };
            
            UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size];
            UIImage *overlayImage = [renderer imageWithActions:UIGraphicsImageDrawingActions];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _highlightView.image = overlayImage;
            });
        }
    };
    
    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCVPixelBuffer:pixelBuffer options:@{}];
    VNDetectTextRectanglesRequest *request = [[VNDetectTextRectanglesRequest alloc] initWithCompletionHandler:VNRequestCompletionHandler];
    
    request.reportCharacterBoxes = YES;
    
    [handler performRequests:@[request] error:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

- (void)doFinishAnimationWithImage:(UIImage *)image rect:(CGRect)rect {
    if (image) {
        [_arrayImages addObject:image];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
        
        // 设置图片数量角标数字
        NSString *str = [NSString stringWithFormat:@"%ld", [_arrayImages count]];
        if ([_arrayImages count] > 9) {
            _lblBadge.frame = CGRectMake(screenWidth - 29, _btnChoosed.frame.origin.y - 7, 22, 14);
        }
        else if ([_arrayImages count] > 99) {
            str = @"99+";
        }
        _lblBadge.text = str;
        
        // 做图片动画
        UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
        imgView.frame = CGRectMake(0, 0, screenWidth, image.size.width * screenHeight/image.size.height);
        [self.view addSubview:imgView];
        
        [self.view bringSubviewToFront:imgView];
        
        [UIView animateWithDuration:0.6 animations:^{
            imgView.frame = _btnChoosed.frame;
        } completion:^(BOOL finished) {
            if (finished) {
                _btnChoosed.hidden = NO;
                _lblBadge.hidden = NO;
                imgView.hidden = YES;
                [imgView removeFromSuperview];
                _btnChoosed.hidden = NO;
                [_btnChoosed setBackgroundImage:image forState:UIControlStateNormal];
                
                [self startCapture];
            }
        }];
    }
}

- (void)createPDFFile
{
    // 1. 创建PDF上下文
    /*
     1) path 保存pdf文件的路径
     2) bounds 大小如果指定CGRectZero，则建立612 * 792大小的页面
     3) documentInfo 文档信息
     */
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [array[0] stringByAppendingPathComponent:@"123.pdf"];
    
    UIGraphicsBeginPDFContextToFile(path, CGRectZero, NULL);
    
    // 2. 创建PDF内容
    /*
     
     pdf中是分页的，要一个页面一个页面的创建
     使用 UIGraphicsBeginPDFPage 方法可以创建一个PDF的页面
     */
    for (NSInteger i = 0; i < [_arrayImages count]; i++) {
        // 1) 创建PDF页面，每个页面的装载量是有限的
        // 在默认的页面大小里面，可以装2张图片
        // 每添加了两张图片之后，需要新建一个页面
        if (i % 2 == 0) {
            UIGraphicsBeginPDFPage();
        }
        
        // 2) 将Image添加到PDF文件
        NSString *fileName = [NSString stringWithFormat:@"NatGeo%02ld.png", i + 1];
        UIImage *image = [UIImage imageNamed:fileName];
        
        [image drawInRect:CGRectMake(0, (i % 2) * 396, 612, 396)];
    }
    
    // 3. 关闭PDF上下文
    UIGraphicsEndPDFContext();
    
    NSLog(@"Get document path: %@",NSHomeDirectory());
}


#pragma mark - Button clicks
// 取消按钮
- (void)onCancelClick {
    [self.navigationController popViewControllerAnimated:YES];
}

// 拍照
- (void)onTakePhotoClick {
    [self stopCapture];
    [self startClip];
}

// 闪光灯按钮
- (void)onFlashLightClick {
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (_isLightON) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                _isLightON = YES;
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                _isLightON = NO;
            }
            [device unlockForConfiguration];
        }
    }

}

// 重拍
- (void)onReTakeClick {
    [self startCapture];
}

// 完成
- (void)onDoneClick {
    
}

@end
