//
//  JFDataCradNewTableViewCell.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/28.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFDataCradNewTableViewCell.h"

@implementation JFDataCradNewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}
-(void)initView{
    self.seltectedIdx  = 0;
    self.temArr  =[NSMutableArray array];
    self.leftRawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.leftRawBtn];
    self.rightRawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.rightRawBtn];
    self.sdcycleView  = [[SDCycleScrollView alloc]init];
     [self.contentView addSubview:self.sdcycleView];
    
    [self.leftRawBtn setImage:[UIImage imageNamed:@"leftImgArraw"] forState:UIControlStateNormal];
    [self.rightRawBtn setImage:[UIImage imageNamed:@"rightArrowImg"] forState:UIControlStateNormal];
    //
//    self.sdcycleView.backgroundColor   = [UIColor redColor];
    self.sdcycleView.showPageControl  = YES;
    self.sdcycleView.autoScroll  = NO;
    self.sdcycleView.pageDotColor  = [UIColor colorWithHexString:@"#DDDDDD"];
    self.sdcycleView.delegate  = self;
    self.sdcycleView.currentPageDotColor  =[UIColor colorWithHexString:@"#47A3FF"];
    self.sdcycleView.pageControlBottomOffset =  -35 *JT_ADAOTER_WIDTH;
    self.sdcycleView.pageControlDotSize = CGSizeMake(15, 15);
    self.sdcycleView.backgroundColor  =[UIColor whiteColor];
    
//    [self.leftRawBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(24, 24));
//        make.centerY.equalTo(self.contentView);
//        make.left.equalTo(self.contentView.mas_left).offset(12);
//    }];
//    [self.rightRawBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(24, 24));
//        make.centerY.equalTo(self.contentView);
//        make.right.equalTo(self.contentView.mas_right).offset(-12);
//    }];
    [self.sdcycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(48 *  JT_ADAOTER_WIDTH);
        make.top.equalTo(self.contentView.mas_top).offset(33 *JT_ADAOTER_WIDTH);
        make.right.equalTo(self.contentView.mas_right).offset(-48 *  JT_ADAOTER_WIDTH);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-30);
    }];
    [self.leftRawBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
     [self.rightRawBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    WEAKSELF;
    [self.sdcycleView  setItemDidScrollOperationBlock:^(NSInteger currentIndex) {
        weakSelf.seltectedIdx = currentIndex;
    }];
  
}
-(void)getCycleImd:(NSMutableArray *)imgArr{
    self.temArr= imgArr;
    //解析数据得到图片数组
    NSMutableArray *temArr  = [NSMutableArray array];
    [imgArr enumerateObjectsUsingBlock:^(JFThirdNewModel *cardModel, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *imgUrl = [cardModel.cardImgUrl  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//图片url里有文字
        [temArr addObject:imgUrl];
    }];
    
    _sdcycleView.imageURLStringsGroup = [temArr copy];
}
-(void)leftBtnClick{
    NSInteger temIndex;
    if (self.seltectedIdx  == 0) {
        temIndex =  self.temArr.count  - 1;
    }else{
        temIndex  = self.seltectedIdx  - 1;
    }
    [self.sdcycleView makeScrollViewScrollToIndex:temIndex];
    if ([self.cardDelegate respondsToSelector:@selector(leftEventClickIdx:)]) {
        [self.cardDelegate leftEventClickIdx:temIndex];
    }
}
-(void)rightBtnClick{
    NSInteger temInx;
    if (self.seltectedIdx   == self.temArr.count -1) {
        temInx  =  0;
    }else{
        temInx  = self.seltectedIdx + 1;
    }
     [self.sdcycleView makeScrollViewScrollToIndex:temInx];
    if ([self.cardDelegate respondsToSelector:@selector(rightEventClickIdx:)]) {
        [self.cardDelegate rightEventClickIdx:temInx];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
