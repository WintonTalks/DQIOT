//
//  ImageTools.m
//  taojin
//
//  Created by machinsight on 17/4/23.
//  Copyright © 2017年 machinsight. All rights reserved.
//

#import "ImageTools.h"

@implementation ImageTools
//压缩图片至1M以下
+ (NSData *)zipImage:(NSData *)imgdata{
    NSData *data;
    UIImage *img = [UIImage imageWithData:imgdata];
    
    //图片大于1M
    if (imgdata.length >= 1024*1024) {
        data = UIImageJPEGRepresentation(img, 0.5);
        //        img = [UIImage imageWithData:data];
        //        data = UIImagePNGRepresentation(img);
        
    }else{
        data = imgdata;
    }
    
    if (data.length <  1024*1024){
        return data;
    }else{
        return [self zipImage:data];
    }
}

#pragma mark - 私有方法
/**
 *  保存文件在沙盒中
 *  @param data
 */
+ (NSString *)saveImage:(NSData *)data{
    //这里将图片放在沙盒的documents文件夹中
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
    return filePath;
}
@end
