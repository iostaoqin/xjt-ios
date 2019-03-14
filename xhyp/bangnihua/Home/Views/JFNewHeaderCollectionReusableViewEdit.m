//
//  JFNewHeaderCollectionReusableViewEdit.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/25.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFNewHeaderCollectionReusableViewEdit.h"

@implementation JFNewHeaderCollectionReusableViewEdit

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}
-(void)initView{
    self.headerImg  =[UIImageView new];
    self.nameLable  = [UILabel new];
    self.titleCycleView=  [SDCycleScrollView new];
    self.lineLable = [UILabel new];
    [self addSubview:self.headerImg];
    [self addSubview:self.nameLable];
    [self addSubview:self.titleCycleView];
    [self addSubview:self.lineLable]; 
    self.titleCycleView.scrollDirection  = UICollectionViewScrollDirectionVertical;
    self.titleCycleView.onlyDisplayText =  YES;
    self.titleCycleView.delegate = self;
    self.titleCycleView.titleLabelBackgroundColor  =[UIColor clearColor];
    self.titleCycleView.titleLabelTextColor  =[UIColor colorWithHexString:@"#666666"];
    self.titleCycleView.backgroundColor  = [UIColor whiteColor];
    [self.titleCycleView disableScrollGesture];//禁用滑动手势
    NSString *firstUrl = @"%E8%8A%B1%E8%8A%B1%E4%BC%98%E5%93%81%E4%BD%9C%E4%B8%BA%E4%BF%A1%E6%81%AF%E5%B9%B3%E5%8F%B0%2C%E4%B8%8D%E5%8F%82%E4%B8%8E%E4%BB%BB%E4%BD%95%E6%94%BE%E8%B4%B7%E4%B8%9A%E5%8A%A1";
    NSString *secondStr = @"%E6%8D%AE%E7%BB%9F%E8%AE%A1%2C%E5%90%8C%E6%97%B6%E7%94%B3%E8%AF%B74%E4%B8%AA%E4%BB%A5%E4%B8%8A%E8%B4%B7%E6%AC%BE%2C%E4%B8%8B%E6%AC%BE%E7%8E%87%20%E9%AB%98%E8%BE%BE99%25";
    NSString *thirdStr = @"%E6%9C%BA%E6%9E%84%E6%94%BE%E6%AC%BE%E5%89%8D%E4%B8%8D%E4%BC%9A%E5%90%91%E7%94%A8%E6%88%B7%E6%94%B6%E5%8F%96%E4%BB%BB%E4%BD%95%E8%B4%B9%E7%94%A8";
    self.titleCycleView.titlesGroup= @[[JFHSUtilsTool decodeFromPercentEscapeString:firstUrl],[JFHSUtilsTool decodeFromPercentEscapeString:secondStr],[JFHSUtilsTool decodeFromPercentEscapeString:thirdStr]];
   
    
    self.lineLable.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [self.headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.left.equalTo(self.mas_left).offset(15);
        
    }];
//    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.headerImg.mas_right).offset(7);
//         make.centerY.equalTo(self);
//    }];
    [self.titleCycleView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.headerImg.mas_right).offset(7);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.equalTo(self);
    }];
    [self.lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@1);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom);
    }];
    [self startFrameAnimation:self.headerImg imageCount:2];
}
- (void)startFrameAnimation:(UIImageView *)imageView imageCount:(int)count
{
    NSMutableArray  *arrayM = [NSMutableArray array];
    for (int i=1; i<count+1; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"notice_%d",i]];
        [arrayM addObject:image];
    }
    
    imageView.animationImages = arrayM;
    imageView.animationRepeatCount = 0;
    imageView.animationDuration = arrayM.count * 0.3;
    [imageView startAnimating];
}
@end
