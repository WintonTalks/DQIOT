//
//  CKNetTools.m
//  AnotherAudit
//
//  Created by machinsight on 17/2/17.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "CKNetTools.h"
#import "MBProgressHUD.h"

@interface CKNetTools()

@property (nonatomic, strong) NSMutableData *receiveData;
@property (strong, nonatomic) NETProcessBlock uploadProgressBlock;
@property (strong, nonatomic) NETSuccessBlock uploadSuccessBlock;
@property (strong, nonatomic) NETFailureBlock uploadErrorBlock;

@end

@implementation CKNetTools

static AFHTTPSessionManager *manager ;
//static AFURLSessionManager *urlsession ;

// 创建静态对象 防止外部访问
static CKNetTools *_instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {  // 也可以使用一次性代码
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}

// 为了使实例易于外界访问 我们一般提供一个类方法 // 类方法命名规范 share类名|default类名|类名
+ (instancetype)sharedCKNetTools
{ //return _instance;
    // 最好用self 用Tools他的子类调用时会出现错误
    return [[self alloc]init];
}

// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}

+ (void)requestWithRequestType:(RequestType)type
                WithURL:(NSString *)url
                 WithParamater:(NSDictionary *)dic
                    WithProgressBlock:(NETProcessBlock)progressBlock
                        WithSuccessBlock:(NETSuccessBlock)successBlock
                            WithFailureBlock:(NETFailureBlock)failureBlock{
    AFHTTPSessionManager *requestmanage = [self getManegerWithType:type];
    DQLog(@"\n接口：%@\n 请求参数:%@", url, dic);
    switch (type) {
        case GET:
        {
            [requestmanage GET:url parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
                //处理请求进度
                progressBlock(downloadProgress);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                successBlock(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"网络异常" actionTitle:@"" duration:3.0];
                [t show];
                failureBlock(error);
            }];
            break;
        }
        case POST:
        {
            [requestmanage POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
                //处理请求进度
                progressBlock(uploadProgress);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    DQLog(@"\n接口返回：%@", responseObject);
                    successBlock(responseObject);
                }];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"网络异常" actionTitle:@"" duration:3.0];
                    [t show];
                    failureBlock(error);
                }];
            }];
            break;
        }
        case PUT:
        {
            [requestmanage PUT:url parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                successBlock(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"网络异常" actionTitle:@"" duration:3.0];
                [t show];
                failureBlock(error);
            }];
            break;
        }
        case DELETE:
        {
            [requestmanage DELETE:url parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                successBlock(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"网络异常" actionTitle:@"" duration:3.0];
                [t show];
                failureBlock(error);
            }];
            break;
        }
        default:
            break;
    }
}

- (void)uploadWithImage:(UIImage *)image
                WithURL:(NSString *)url
          WithParamater:(NSDictionary *)dic
      WithProgressBlock:(NETProcessBlock)progressBlock
       WithSuccessBlock:(NETSuccessBlock)successBlock
       WithFailureBlock:(NETFailureBlock)failureBlock{
//    AFHTTPSessionManager *requestmanage = [self getManegerWithType:POST];
//    [requestmanage POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        //压缩后的图片data
//        NSData *zipImgData = [ImageTools zipImage:UIImagePNGRepresentation(image)];
//        //存入沙盒返回文件路径
//        NSString *filePath = [ImageTools saveImage:zipImgData];
//        
//        NSData *sandBoxImageData = [NSData dataWithContentsOfFile:filePath];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat = @"yyyyMMddHHmmss";
//        NSString *str = [formatter stringFromDate:[NSDate date]];
//        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
//        
//        [formData appendPartWithFileData:sandBoxImageData name:@"image" fileName:fileName mimeType:@"image/png"];
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        //处理请求进度
//        progressBlock(uploadProgress);
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        successBlock(responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failureBlock(error);
//    }];
    //压缩后的图片data
    NSData *zipImgData = [ImageTools zipImage:UIImagePNGRepresentation(image)];
    //存入沙盒返回文件路径
    NSString *filePath = [ImageTools saveImage:zipImgData];
    NSInputStream *inputStream = [NSInputStream inputStreamWithFileAtPath:filePath];
    
    NSNumber *contentLength = (NSNumber *)[[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:NULL] objectForKey:NSFileSize];
    NSMutableURLRequest *request;
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.timeoutInterval = 60.f;
    [request setHTTPMethod:@"POST"];
    [request setHTTPBodyStream:inputStream];
    [request setValue:@"image/png" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[contentLength description] forHTTPHeaderField:@"Content-Length"];
    
    [MBProgressHUD showHUDAddedTo:[AppDelegate getMainView] animated:YES];
    
    NSURLConnection *task = [NSURLConnection connectionWithRequest:request delegate:self];
    
    
    
    self.uploadProgressBlock = progressBlock;
    self.uploadSuccessBlock = successBlock;
    self.uploadErrorBlock = failureBlock;
}

+ (AFHTTPSessionManager *)getManegerWithType:(int)type{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [AFHTTPSessionManager manager];
            [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            //        if(type==1){
            //申明请求的数据是json类型
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            
            // 设置超时时间
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer.timeoutInterval = 20.f;
            [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            //        }
            
//            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            NSSet *set = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", @"application/javascript", @"text/js",@"image/jpeg",
                          @"image/png",@"application/octet-stream",nil];
            manager.responseSerializer.acceptableContentTypes = set;
        });    
    return manager;
    
}

//接收到服务器回应的时候调用此方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [MBProgressHUD hideHUDForView:[AppDelegate getMainView] animated:YES];
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    DQLog(@"%@",[res allHeaderFields]);
    self.receiveData = [NSMutableData data];
}

//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receiveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [MBProgressHUD hideHUDForView:[AppDelegate getMainView] animated:YES];
    
    
    NSData  *infoData = [[NSMutableData alloc] init];
    infoData =self.receiveData;
    //    NSString *receiveStr = [[NSString alloc]initWithData:infoData encoding:NSUTF8StringEncoding];
    NSError *error;
    //将请求的url数据放到NSData对象中
    //IOS自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *InfoDic = [NSJSONSerialization JSONObjectWithData:infoData options:NSJSONReadingMutableLeaves error:&error];
    if(!error){
        self.uploadSuccessBlock(InfoDic);
    }else{
        NSLog(@"%@",error);
        
    }
    
  
}

//请求错误（失败）的时候调用（请求超时\断网\没有网\，一般指客户端错误）
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    MDSnackbar *t = [[MDSnackbar alloc] initWithText:@"网络异常" actionTitle:@"" duration:3.0];
    [t show];
    [MBProgressHUD hideHUDForView:[AppDelegate getMainView] animated:YES];
    self.uploadErrorBlock(error);

}
@end
