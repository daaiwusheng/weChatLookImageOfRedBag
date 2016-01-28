//
//  ViewController.m
//  微信发红包看照片
//
//  Created by 王宇 on 16/1/28.
//  Copyright © 2016年 王宇. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,weak)UIImageView * imageViewOriginal;
@property(nonatomic,strong)UIImage * imageOriginal;
@property(nonatomic,weak)UIVisualEffectView * effectView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.加载图片,显示毛玻璃效果
    [self showBlurImageView];
    //2.随机获得圆形图片view,
    [self getRandomCircleImageView];
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
     [self getRandomCircleImageView];

}
-(void)getRandomCircleImageView
{
    //1.获取在imageViewOriginal的frame内的随机rect
    CGRect randomRect = [self getRandomRectInside:self.imageViewOriginal.frame  maxWidth:80 minWidth:30];
    UIImage * imageCliped = [self getNeedImageFrom:self.imageOriginal cropRect:randomRect];
    UIImageView * imageViewSmall = [UIImageView new];
    imageViewSmall.frame = randomRect;
    [imageViewSmall setImage:imageCliped];
    [self.effectView.contentView addSubview:imageViewSmall];

    imageViewSmall.clipsToBounds = YES;
    imageViewSmall.layer.masksToBounds = YES;
    imageViewSmall.layer.cornerRadius = imageViewSmall.frame.size.width*0.5;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
         [imageViewSmall removeFromSuperview];
    });

}
-(UIImage *)getNeedImageFrom:(UIImage*)image cropRect:(CGRect)rect
{
    CGSize cropSize = rect.size;
    CGFloat widthScale = image.size.width/self.imageViewOriginal.bounds.size.width;
    CGFloat heightScale = image.size.height/self.imageViewOriginal.bounds.size.height;
    
    cropSize = CGSizeMake(rect.size.width*widthScale, rect.size.height*heightScale);
    CGPoint  pointCrop = CGPointMake(rect.origin.x*widthScale, rect.origin.y*heightScale);
    
    rect = CGRectMake(pointCrop.x, pointCrop.y, cropSize.width, cropSize.height);
    
    CGImageRef subImage = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *croppedImage = [UIImage imageWithCGImage:subImage];
    CGImageRelease(subImage);
    
    
    return croppedImage;
  
}

-(void)showBlurImageView
{
    //1.设置imageView的宽高比为图片image的宽高比,避免图片走样
//    UIImage * imageOriginal = [UIImage imageNamed:@"wangyu.jpg"];
    NSString *path = [NSString stringWithFormat:@"%@/%@.jpg", [[NSBundle mainBundle] resourcePath], @"wangyu"];
    UIImage * imageOriginal = [UIImage imageWithContentsOfFile:path];
    self.imageOriginal = imageOriginal;
    CGFloat valueOfScale = imageOriginal.size.height/imageOriginal.size.width;
    UIImageView * imageViewOriginal = [UIImageView new];
    self.imageViewOriginal = imageViewOriginal;
    
    CGFloat imagViewOriginalWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat imagViewOriginalHeight = imagViewOriginalWidth*valueOfScale;
    
    imageViewOriginal.frame = CGRectMake(0, 40, imagViewOriginalWidth, imagViewOriginalHeight);
    [imageViewOriginal setImage:imageOriginal];
    [self.view addSubview:imageViewOriginal];
    //2.UIVisualEffectView 毛玻璃效果
    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView * effectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
//    effectView.alpha = 1.0;
    self.effectView = effectView;
    
    effectView.frame = imageViewOriginal.bounds;
    [imageViewOriginal addSubview:effectView];

    
    
}
-(CGRect)getRandomRectInside:(CGRect)rectFather maxWidth:(CGFloat)maxWidth minWidth:(CGFloat)minWidth
{
    CGFloat randomWidth = [self randomBetween:30 And:80];
    CGFloat randomX =[self randomBetween:20 And:rectFather.size.width-randomWidth-20];
    CGFloat randomY =[self randomBetween:20 And:rectFather.size.height-randomWidth-20];
    
    CGRect randomRect = CGRectMake(randomX, randomY, randomWidth, randomWidth);
    
    NSLog(@"%@",[NSValue valueWithCGRect:randomRect]);
    return randomRect;
}
//随机返回某个区间范围内的值
- (CGFloat) randomBetween:(CGFloat)smallerNumber And:(CGFloat)largerNumber
{
    //设置精确的位数
    int precision = 100;
    //先取得他们之间的差值
    CGFloat subtraction = largerNumber - smallerNumber;
    //取绝对值
    subtraction = ABS(subtraction);
    //乘以精度的位数
    subtraction *= precision;
    //在差值间随机
    CGFloat randomNumber = arc4random() % ((int)subtraction+1);
    //随机的结果除以精度的位数
    randomNumber /= precision;
    //将随机的值加到较小的值上
    CGFloat result = MIN(smallerNumber, largerNumber) + randomNumber;
    //返回结果
    return result;
}

@end
