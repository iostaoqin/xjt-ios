//
//  JTGuideView.m
//  miaosu
//
//  Created by Daisy  on 2019/3/4.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTGuideView.h"
#import "SDCycleScrollView.h"
#define EDC_GUIDE_COUNT 4//引导页数目
@interface JTGuideView()<UIScrollViewDelegate,SDCycleScrollViewDelegate>
@property (nonatomic, strong)UIScrollView *guideScrollView;
@property (nonatomic, strong)UIButton *guideButton;
@property (nonatomic, strong)SDCycleScrollView *pictureCycleSView;
@end
@implementation JTGuideView
-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        NSArray *imageArray = @[@"introduction_1",@"introduction_2",@"introduction_3",@"introduction_4"];
        //        self.pictureCycleSView.frame = self.frame;
        _pictureCycleSView = [SDCycleScrollView cycleScrollViewWithFrame:self.frame imageNamesGroup:imageArray];
        [self addSubview:self.pictureCycleSView];
        _pictureCycleSView.backgroundColor = [UIColor clearColor];
        _pictureCycleSView.autoScroll = NO;
        _pictureCycleSView.infiniteLoop = NO;
        _pictureCycleSView.delegate = self;
        
//        _pictureCycleSView.showPageControl  = YES;
        _pictureCycleSView.pageDotColor = [UIColor whiteColor];
        _pictureCycleSView.currentPageDotColor = [UIColor colorWithHexString:@"#62A7E9"];
        _pictureCycleSView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        if (JT_IS_IHPONEX) {
            
            _pictureCycleSView.pageControlBottomOffset  = 30.0f;
        }
    }
    return self;
}
/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    if (index == EDC_GUIDE_COUNT - 1) {
         [self.guideButton removeFromSuperview];
        [self addGuidbtn];
    }else{
        [self.guideButton removeFromSuperview];
    }
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
}
-(void)addGuidbtn{
    CGFloat font;
    if (JT_IS_iPhone5) {
        font = 16;
    }else{
        font = 18;
    }
   _guideButton =[self.pictureCycleSView buttonCreateGradientWithCornerRadius:6 btnWidth:315* JT_ADAOTER_WIDTH btnHeight:46* JT_ADAOTER_WIDTH startLocationColor:@"#10ACDC" endLocationColor:@"#00D4C7"];
    [self.pictureCycleSView addSubview:_guideButton];
    [_guideButton setTitle:@"开启" forState:UIControlStateNormal];
    _guideButton.titleLabel.font = kFontSystem(font);
    [_guideButton  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(315* JT_ADAOTER_WIDTH, 46* JT_ADAOTER_WIDTH));
        make.centerX.equalTo(self.pictureCycleSView);
        make.top.equalTo(self.pictureCycleSView.mas_bottom).offset(-JT_SAFEBOTTOM_HEIGHT -60 *JT_ADAOTER_WIDTH);
    }];
    [_guideButton addTarget:self action:@selector(nextPageClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)nextPageClick{
    if ([self.guideDelagte respondsToSelector:@selector(OnButtonClick)]) {
        [self.guideDelagte OnButtonClick];
    }
}

@end
