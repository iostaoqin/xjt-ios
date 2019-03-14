//
//  JFNewHomeEditCycleView.m
//  spendHelp
//
//  Created by Daisy  on 2019/1/8.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JFNewHomeEditCycleView.h"

@implementation JFNewHomeEditCycleView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self  =  [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}
-(void)initView{
    self.homeCycle =[[SDCycleScrollView alloc]init];
    [self addSubview:self.homeCycle];
    self.homeCycle.backgroundColor =[UIColor clearColor];
    self.homeCycle.showPageControl  = YES;
    self.homeCycle.autoScroll  = YES;
    self.homeCycle.pageControlBottomOffset = 5;
    self.homeCycle.currentPageDotImage = [UIImage imageNamed:@"newImg_cycleSelected"];
    self.homeCycle.pageDotImage = [UIImage imageNamed:@"newImg_cycleNomal"];
    [self.homeCycle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
-(void)getCycleData:(NSMutableArray *)cycleArr{
    NSMutableArray *temArr  = [NSMutableArray array];
    [cycleArr enumerateObjectsUsingBlock:^(JFEditHomemodel *cycleModel, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *imgUrl = [cycleModel.adImgUrl  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//图片url里有文字
        [temArr addObject:imgUrl];
    }];
    _homeCycle.imageURLStringsGroup = [temArr copy];
}
@end
