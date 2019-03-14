//
//  JTSliderView.m
//  miaosu
//
//  Created by Daisy  on 2019/2/21.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTSliderView.h"
#import "UIView+Additions.h"
@implementation JTSliderView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _score = 10;
        _scoreValue = 0;
        _maxValue = 3000;
        _minValue= 500;
        _clickSlider  = YES;
        self.backgroundColor = [UIColor whiteColor];
     UISlider * slider = [[UISlider alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 30)];
        slider.minimumValue  = 500;
        slider.maximumValue   = 5000;
        slider.continuous = YES;
        [slider setThumbImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
//        slider.backgroundColor  =[UIColor redColor];
        slider.minimumTrackTintColor  =[UIColor colorWithHexString:@"62A7E9"];
         slider.maximumTrackTintColor  =[UIColor colorWithHexString:@"cccccc"];
     
        [self addSubview:slider];
//        //分数标签
//        UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 74, 28)];
//        scoreLabel.text = @"+500";
//        scoreLabel.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:scoreLabel];
//        _scoreLabel = scoreLabel;
//        _scoreLabel.textColor  =[UIColor colorWithHexString:@"#62A7E9"];
//
//        if (JT_IS_iPhone5) {
//            _scoreLabel.font  = kFontSystem(20);
//        }else{
//            _scoreLabel.font  = kFontSystem(22);
//        }
//
//
//        //轨道可点击视图（轨道只设置了5pt，通过这个视图增加以下点击区域）
//        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 34*JT_ADAOTER_WIDTH, self.bounds.size.width, 30*JT_ADAOTER_WIDTH)];
//        tapView.backgroundColor =[UIColor clearColor];
//        [tapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
//        [self addSubview:tapView];
//
//        //轨道背景
//        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, self.bounds.size.width, 10)];
//        backView.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
//        backView.layer.cornerRadius = 5.0f;
//        backView.layer.masksToBounds = YES;
//        [tapView addSubview:backView];
//
//        //轨道前景
//        UIView *trackView = [[UIView alloc] initWithFrame:CGRectMake(backView.bounds.origin.x, backView.frame.origin.y, self.bounds.size.width,backView.frame.size.height )];
//        trackView.centerY = backView.centerY;
//        trackView.backgroundColor = [UIColor clearColor];
//        trackView.layer.cornerRadius = 5.f;
//        trackView.layer.masksToBounds = YES;
//        [tapView addSubview:trackView];
//        _trackView = trackView;
//
//        //滑块
//        UIImageView *thumb = [[UIImageView alloc] initWithFrame:CGRectMake(1, 34, 28*JT_ADAOTER_WIDTH, 28*JT_ADAOTER_WIDTH)];
//        [thumb setImage:[UIImage imageNamed:@"add"]];
//        thumb.userInteractionEnabled = YES;
//        thumb.contentMode = UIViewContentModeCenter;
//        [thumb addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)]];
//        [self addSubview:thumb];
//        _thumb = thumb;
    }
    
    return self;
}

- (void)setScore:(NSInteger)score
{
    _score = score;
    
    //刷新视图
    [self reloadViewWithThumbCeneterX:score / 10.0 * self.bounds.size.width];
}

//点击滑动条
- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (_clickSlider ==YES) {
        
        //刷新视图
        [self reloadViewWithThumbCeneterX:[sender locationInView:self].x];
    }
}

//滑动滑块
- (void)handlePan:(UIPanGestureRecognizer *)sender
{
    if (_clickSlider) {
        
    
    //获取偏移量
    CGFloat moveX = [sender translationInView:self].x;
    
    //重置偏移量，避免下次获取到的是原基础的增量
    [sender setTranslation:CGPointMake(0, 0) inView:self];
    
    //计算当前中心值
    CGFloat centerX = _thumb.centerX + moveX;
    
    //防止瞬间大偏移量滑动影响显示效果
    if (centerX < 10) centerX = 10;
    if (centerX > self.bounds.size.width - 10) centerX = self.bounds.size.width - 10;
    
    //刷新视图
    [self reloadViewWithThumbCeneterX:centerX];
    }
}

- (void)reloadViewWithThumbCeneterX:(CGFloat)thumbCeneterX
{
   
    JTLog(@"thumbCeneterX=%f",thumbCeneterX);
    if ((_scoreValue+1) * 500 <_maxValue ) {
    
    //更新轨道前景色
     _trackView.backgroundColor = [UIColor colorWithHexString:@"#62A7E9"];
    _trackView.frameWidth = thumbCeneterX;
    
    //更新滑块位置
    _thumb.centerX = thumbCeneterX;
    if (_thumb.centerX < 10) {
        _thumb.centerX = 10;
    }else if (_thumb.centerX > self.bounds.size.width - 10) {
        _thumb.centerX = self.bounds.size.width - 10;
    }
    _scoreLabel.centerX = _thumb.centerX;

        if (_scoreLabel.centerX < 33) {
            _scoreLabel.centerX = 33;
        }else if (_scoreLabel.centerX > self.bounds.size.width - 33) {
            _scoreLabel.centerX = self.bounds.size.width - 33;
        }
    //分数，四舍五入取整
    _score = round(thumbCeneterX / self.bounds.size.width * 10);
    JTLog(@"%zd",_score);
    //更新标签内容
        NSString *price;
    if (_score  ==0) {
        _scoreLabel.text = @"+500";
        price  = @"500";
    }else{
        if ((_score+1)*500 <=_maxValue) {
            
            _scoreLabel.text = [NSString stringWithFormat:@"+%ld", (_score+1)*500];
            price  =[NSString stringWithFormat:@"%ld",(_score+1)*500];
        }
    }
    //    //发送 通知  改变cell的值
        [[NSNotificationCenter defaultCenter]postNotificationName:@"sliderNotice" object:price];
        _scoreValue  = _score;
        JTLog(@"_scoreValue=%zd",_scoreValue);
    }else{
        _scoreValue  = 0;
    }
     JTLog(@"%f",(JT_ScreenW-  32 *JT_ADAOTER_WIDTH)/11 *_score);
}
@end
