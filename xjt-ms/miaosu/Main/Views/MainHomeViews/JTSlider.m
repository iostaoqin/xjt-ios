//
//  rrr.m
//  miaosu
//
//  Created by Daisy  on 2019/2/28.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTSlider.h"
#define thumbBound_x 10
#define thumbBound_y 20
@implementation JTSlider
//-(instancetype)initWithFrame:(CGRect)frame{
//    if (self =[super initWithFrame:frame]) {
//        [self initView];
//    }
//    return self;
//}
//-(void)initView{
//
//    self.continuous = YES;
//    [self setThumbImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
//    self.minimumTrackTintColor  =[UIColor colorWithHexString:@"62A7E9"];
//    self.maximumTrackTintColor  =[UIColor colorWithHexString:@"cccccc"];
//[self addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
//}
- (CGRect)trackRectForBounds:(CGRect)bounds {
    return CGRectMake(0, 0, self.bounds.size.width, 10);
}
-(CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value{
    
    rect.origin.x=rect.origin.x -10;
    
    rect.size.width=rect.size.width +20;
     _lastBounds = rect;
    return CGRectInset([super thumbRectForBounds:bounds trackRect:rect value:value],10,10);
}

//解决滑块不灵敏
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *result = [super hitTest:point withEvent:event];
    if (point.x < 0 || point.x > self.bounds.size.width){
        
        return result;
        
    }
    if ((point.y >= -thumbBound_y) && (point.y < _lastBounds.size.height + thumbBound_y)) {
        float value = 0.0;
        value = point.x - self.bounds.origin.x;
        value = value/self.bounds.size.width;
        
        value = value < 0? 0 : value;
        value = value > 1? 1: value;
        
        value = value * (self.maximumValue - self.minimumValue) + self.minimumValue;
        [self setValue:value animated:YES];
    }
    return result;
    
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    BOOL result = [super pointInside:point withEvent:event];
    if (!result && point.y > -10) {
        if ((point.x >= _lastBounds.origin.x - thumbBound_x) && (point.x <= (_lastBounds.origin.x + _lastBounds.size.width + thumbBound_x)) && (point.y < (_lastBounds.size.height + thumbBound_y))) {
            result = YES;
        }
        
    }
    return result;
}
//// slider变动时改变label值
//- (void)sliderValueChanged:(id)sender {
//    UISlider *slider = (UISlider *)sender;
//    JTLog(@"%f",slider.value);
//
//    float accuracy = 500;
//    float width =JT_ScreenW -32*JT_ADAOTER_WIDTH;
//    // 如： 用户想每滑动一次 增加500的量 每次滑块需要滑动的宽
//    float slideWidth = width*accuracy/slider.maximumValue ;
//    // 在滑动条中 滑块的位置 是根据 value值 显示在屏幕上的 那么 把目前滑块的宽 加上用户新滑动一次的宽 转换成value值
//    // 根据当前value值 求出目前滑块的宽
//    float currentSlideWidth =  slider.value/accuracy*slideWidth ;
//    // 用户新滑动一次的宽加目前滑动的宽 得到新的 目前滑动的宽
//    float newSlideWidth = currentSlideWidth+slideWidth ;
//    // 转换成 新的 value值
//    float value =  newSlideWidth/width*slider.maximumValue ;
//    // 取整
//     int d = (int)(value/accuracy) ;
//    NSString *stringFloat = [NSString stringWithFormat:@"%f", self.minimumValue];
//    NSInteger a  = [stringFloat integerValue] +(d -1)*100;
//    NSDictionary *dic =@{@"price":[NSString stringWithFormat:@"%ld",a],@"countprice":[NSString stringWithFormat:@"%d",d]};
//    JTLog(@"%d",d);
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"sliderNotice" object:nil userInfo:dic];
//}
@end
