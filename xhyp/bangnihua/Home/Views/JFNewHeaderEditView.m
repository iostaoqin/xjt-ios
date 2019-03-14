//
//  JFNewHeaderEditView.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/25.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFNewHeaderEditView.h"

static NSInteger secondsCountDown= 0;
@implementation JFNewHeaderEditView

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}
-(void)initView{
    self.latestArray = [NSMutableArray array];
//    
    self.hotImg  = [UIImageView new];
    self.latestLable  = [UILabel new];
    self.countHotLable  = [UILabel new];
    self.actionImg  = [UIImageView new];
    self.actionBGImg =[UIImageView new];
//    self.hoursLable  = [UILabel new];
//    self.minitLable  = [UILabel new];
//    self.secondsLable  = [UILabel new];
    
    [self addSubview:self.hotImg];
    [self addSubview:self.latestLable];
    [self addSubview:self.countHotLable];
    [self addSubview:self.actionImg];
    [self addSubview:self.actionBGImg];
//    [self addSubview:self.hoursLable];
//    [self addSubview:self.minitLable];
//    [self addSubview:self.secondsLable];
    
    
    //
    self.latestLable.textColor   = [UIColor colorWithHexString:@"ffffff"];
    self.latestLable.font  = kFontSystem(18);
    self.latestLable.text  = @"最新口子";
    //
    self.countHotLable.font   = kFontSystem(12);
    self.countHotLable.textColor   = [UIColor colorWithHexString:@"ffffff"];
//    self.countHotLable.text = @"3家";
    self.countHotLable.backgroundColor =[UIColor colorWithHexString:@"#FF493B"];
    self.countHotLable.layer.cornerRadius  = 9;
    self.countHotLable.layer.masksToBounds  = YES;
    self.countHotLable.textAlignment  = NSTextAlignmentCenter;
    //
    self.hotImg.image = [UIImage imageNamed:@"img_hot"];
    //
    self.hoursLable  = self.secondsLable = [self creatLable];
    //
    self.minitLable =  self.secondsLable = [self creatLable];
    //
    self.secondsLable = [self creatLable];
   
//
    self.actionBGImg.image =[UIImage imageNamed:@"newImgActionHomeWhite"];
    //
//    self.actionBGImg.backgroundColor = [UIColor redColor];
    self.actionBGImg.frame  = CGRectMake(0, 0, 50*JT_ADAOTER_WIDTH, 100*JT_ADAOTER_WIDTH);
//    [self.actionBGImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(50  *JT_ADAOTER_WIDTH, 100*JT_ADAOTER_WIDTH));
//        make.left.top.equalTo(self);
//    }];
    CGSize size = CGSizeMake(32, 24);
    [self.hotImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.left.equalTo(self.mas_left).offset(JT_ADAOTER_WIDTH * 20);
        make.centerY.equalTo(self).offset(JT_STATUS_BAR_HEIGHT/2);
//        make.top.equalTo(self.mas_top).offset(JT_STATUS_BAR_HEIGHT  + 30 * JT_ADAOTER_WIDTH);
    }];
    [self.latestLable mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.equalTo(self).offset(JT_STATUS_BAR_HEIGHT/2);
//        make.top.equalTo(self.mas_top).offset(JT_STATUS_BAR_HEIGHT  + 28 * JT_ADAOTER_WIDTH);
        make.left.equalTo(self.hotImg.mas_right).offset(6);
    }];
    [self.countHotLable mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.equalTo(self).offset(JT_STATUS_BAR_HEIGHT/2);
        make.size.mas_equalTo(CGSizeMake(41, 18));
        make.left.equalTo(self.latestLable.mas_right).offset(5);
    }];
    [self.hoursLable mas_makeConstraints:^(MASConstraintMaker *make) {
         make.size.mas_equalTo(size);
         make.centerY.equalTo(self).offset(JT_STATUS_BAR_HEIGHT/2);
        make.left.equalTo(self.countHotLable.mas_right).offset(8);
    }];
    UILabel *firstPoint  = [self creatPointLable];
    [firstPoint mas_makeConstraints:^(MASConstraintMaker *make) {
          make.size.mas_equalTo(CGSizeMake(10, 24));
        make.left.equalTo(self.hoursLable.mas_right).offset(2);
        make.centerY.equalTo(self).offset(JT_STATUS_BAR_HEIGHT/2);
        
    }];
    [self.minitLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
         make.centerY.equalTo(self).offset(JT_STATUS_BAR_HEIGHT/2);
        make.left.equalTo(firstPoint.mas_right).offset(2);
    }];
    UILabel *SecondPoint = [self creatPointLable];
    [SecondPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10, 24));
        make.left.equalTo(self.minitLable.mas_right).offset(2);
         make.centerY.equalTo(self).offset(JT_STATUS_BAR_HEIGHT/2);
    }];
    [self.secondsLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
        make.centerY.equalTo(self).offset(JT_STATUS_BAR_HEIGHT/2);
        make.left.equalTo(SecondPoint.mas_right).offset(2);
    }];
    [self.actionImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(JT_STATUS_BAR_HEIGHT/2);
        make.size.mas_equalTo(CGSizeMake(44  * JT_ADAOTER_WIDTH, 18 * JT_ADAOTER_WIDTH));
        make.left.equalTo(self.secondsLable.mas_right).offset(15);
    }];
    [self startFrameAnimation:self.actionImg imageCount:3];
//     [self actionImgEvent];
    [self startLodingAnimation];
    //初始化
    self.hoursLable.text = @"00";
    self.minitLable.text = @"00";
    self.secondsLable.text = @"00";
    self.countHotLable.text= @"0家";
}
-(UILabel  *)creatLable{
    UILabel *lable =  [[UILabel alloc]init];
    lable.font  = kFontSystem(20);
    lable.textColor   = [UIColor colorWithHexString:@"ffffff"];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.backgroundColor  = [UIColor colorWithHexString:@"#333333"];
    lable.layer.cornerRadius  =  5;
    lable.layer.masksToBounds  =  YES;
    [self addSubview:lable];
    return lable;
}
-(UILabel  *)creatPointLable{
    UILabel *lable =  [[UILabel alloc]init];
    lable.font  = kFontSystem(22);
    lable.text = @":";
    lable.textColor   = [UIColor colorWithHexString:@"ffffff"];
    lable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lable];
    return lable;
}
-(void)getLatestData:(NSMutableArray *)latestArray{
    if (_countTimer) {
        //关掉倒计时
        [_countTimer invalidate];
    }

    [latestArray enumerateObjectsUsingBlock:^(JFEditHomemodel *latestModel, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *count  = latestModel.timeStr;
        NSString *latestH = [count substringWithRange:NSMakeRange(0, 2)];
        //获取当前时间(h)
        NSDate *date=[NSDate date];
        NSDateFormatter *format1=[[NSDateFormatter alloc] init];
        [format1 setDateFormat:@"HH:mm"];
        NSString *dateStr;
        dateStr=[format1 stringFromDate:date];
        NSString *hour = [dateStr substringWithRange:NSMakeRange(0, 2)];
        //先比较
        if ([latestH integerValue] > [hour integerValue]) {
            [self getcountMinit:latestModel];
            *stop = YES;
        }
    }];
    [self.latestArray removeAllObjects];
    self.latestArray = latestArray;
}
-(void)actionImgEvent{
     [self.actionBGImg setTransform:(CGAffineTransformMakeTranslation(0,0))];
    [UIView animateWithDuration:1.5 animations:^{
        [self.actionBGImg setTransform:(CGAffineTransformMakeTranslation(JT_ScreenW,0))];
    } completion:^(BOOL finished) {
        if (finished) {
            
        [self.actionBGImg setTransform:(CGAffineTransformMakeTranslation(-JT_ScreenW,0))];
            [self  actionImgEvent];
        }
    }];
}
- (void)startLodingAnimation

{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startAnimation) object:self];
    [UIView animateWithDuration:1.5 animations:^{
        self.actionBGImg.mj_x = SCREEN_WIDTH;
    } completion:^(BOOL finished) {
        self.actionBGImg.mj_x = -self.actionBGImg.mj_w;
        [self performSelector:@selector(startLodingAnimation) withObject:self afterDelay:0.1];
    }];
}
-(void)getcountMinit:(JFEditHomemodel *)timeModel{
    NSString *count  = timeModel.timeStr;
    NSString *latestH = [count substringWithRange:NSMakeRange(0, 2)];
    //获取当前时间(h)
    NSDate *date=[NSDate date];
    NSDateFormatter *format1=[[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"HH:mm"];
    NSString *dateStr;
    dateStr=[format1 stringFromDate:date];
    NSString *hour = [dateStr substringWithRange:NSMakeRange(0, 2)];
    NSString *minite = [dateStr substringWithRange:NSMakeRange(3, 2)];
    //先比较
    if ([latestH integerValue] > [hour integerValue]) {
        //遍历到后台返回的时间 大于当前的时间 则用此时间倒计时
        self.countHotLable.text  = [NSString stringWithFormat:@"%@家",timeModel.num];
         //后台返回 的 HH:mm 减去当前时间 得到x倒计时的时间 转为成S 来计数
        //1h--60m--3600s
        NSInteger  currentS = ([hour integerValue]) *3600 + [minite integerValue] * 60 ;
        NSInteger  serviceS = [latestH integerValue] *3600;
        NSInteger count  = serviceS - currentS;
        if (count >0) {
            secondsCountDown = count;
            [self countdownTimer];
        }
        return;
    }
}
#pragma mark  -  倒计时
-(void)countdownTimer{
   
    _countTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
   
}
-(void)countDownAction{
    //倒计时
    secondsCountDown --;
    [self showCount:secondsCountDown];
}
#pragma mark  - 显示倒计时
-(void)showCount:(NSInteger)countDownNumber{
    WEAKSELF;
    //设置倒计时显示的时间
    NSString *strH =[NSString  stringWithFormat:@"%02ld",countDownNumber /3600];//小时
    NSString *strM =  [NSString stringWithFormat:@"%02ld",(countDownNumber % 3600)/60];//分钟
    NSString *strS  = [NSString stringWithFormat:@"%02ld",countDownNumber % 60];//f秒
    self.hoursLable.text = strH;
    self.minitLable.text = strM;
    self.secondsLable.text = strS;
    //当倒计时计数为0 的时候 重复之前的动作
    if (countDownNumber ==0) {
       static NSInteger countNumber = 0;
        [self.latestArray enumerateObjectsUsingBlock:^(JFEditHomemodel *latestModel, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *count  = latestModel.timeStr;
            NSString *latestH = [count substringWithRange:NSMakeRange(0, 2)];
            //获取当前时间(h)
            NSDate *date=[NSDate date];
            NSDateFormatter *format1=[[NSDateFormatter alloc] init];
            [format1 setDateFormat:@"HH:mm"];
            NSString *dateStr;
            dateStr=[format1 stringFromDate:date];
            NSString *hour = [dateStr substringWithRange:NSMakeRange(0, 2)];
            countNumber ++;
            //先比较
            if ([latestH integerValue] > [hour integerValue]) {
                [self getcountMinit:latestModel];
                 JTLog(@"走了几次countDownNumber ==0");
                *stop = YES;
            }
        }];
        if (countNumber ==  self.latestArray.count) {
            JTLog(@"countNumber = %zd",countNumber);
            //为0之后
            self.hoursLable.text = @"00";
            self.minitLable.text = @"00";
            self.secondsLable.text = @"00";
            self.countHotLable.text= @"0家";
            //关掉倒计时
            [weakSelf.countTimer invalidate];
        }
    }
}
/**
 icon宝箱动画
 */
- (void)startFrameAnimation:(UIImageView *)imageView imageCount:(int)count
{
    NSMutableArray  *arrayM = [NSMutableArray array];
    NSString *filePath;
    for (int i=1; i<count+1; i++) {
        filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"arrow%i",i] ofType:@"png"];
        [arrayM addObject:[UIImage imageWithContentsOfFile:filePath]];
    }
    imageView.animationImages = arrayM;
    imageView.animationRepeatCount = 0;
    imageView.animationDuration = arrayM.count * 0.5;
    [imageView startAnimating];
}
@end
