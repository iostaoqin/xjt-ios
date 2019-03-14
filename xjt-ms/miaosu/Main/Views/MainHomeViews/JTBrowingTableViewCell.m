//
//  JTBrowingTableViewCell.m
//  miaosu
//
//  Created by Daisy  on 2019/2/21.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTBrowingTableViewCell.h"

@implementation JTBrowingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
    
}
-(void)initView{
    self.nameLable  =[UILabel new];
    self.tipsLable  =[UILabel new];
    self.priceNameLable  =[UILabel new];
    
    
    [self.contentView addSubview:self.tipsLable];
    [self.contentView addSubview:self.nameLable];
    [self.contentView addSubview:self.priceNameLable];
    [self.contentView addSubview:self.slider];
    self.nameLable.text = @"借款金额明细";
    self.tipsLable.text = @"(温馨提示：积累良好信誉，有利于提高额度)";
    self.nameLable.textColor  =[UIColor colorWithHexString:@"#333333"];
    self.tipsLable.textColor  =[UIColor colorWithHexString:@"#999999"];
  

    self.priceNameLable.textAlignment = NSTextAlignmentCenter;
    
    self.priceNameLable.textColor  =[UIColor colorWithHexString:@"#62A7E9"];
   
    if (JT_IS_iPhone5) {
        self.nameLable.font = kFontSystem(12);
        self.tipsLable.font = kFontSystem(10);
        _priceNameLable.font  = kFontSystem(20);
    }else{
        self.nameLable.font = kFontSystem(14);
        self.tipsLable.font = kFontSystem(12);
        _priceNameLable.font  = kFontSystem(22);
    }
    [self.nameLable  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(16 *JT_ADAOTER_WIDTH);
        
    }];
    [self.tipsLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLable.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-12*JT_ADAOTER_WIDTH);
    }];
    [self.priceNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLable.mas_bottom).offset(13);
        make.left.equalTo(self.nameLable);
//        make.width.mas_equalTo(80 *JT_ADAOTER_WIDTH);
    }];
//    self.slider.backgroundColor =[UIColor redColor];
    self.slider.frame = CGRectMake(16 *JT_ADAOTER_WIDTH, 90 * JT_ADAOTER_WIDTH, JT_ScreenW-32 *JT_ADAOTER_WIDTH, 40  *JT_ADAOTER_WIDTH);
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
//    self.slider.minimumValue  = 0;
//    self.slider.value  = 1600;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)getSlideModel:(JTLoanModel *)modelSlider{
    
    self.priceNameLable.text = [NSString  stringWithFormat:@"+%ld",[modelSlider.minMount integerValue]/100];
    // 最大值要去网络请求 先模拟
    _slider.maximumValue = 5000;
    _slider.minimumValue =  [self.minValue floatValue]-100;
//    _slider.value  =  [self.maxValue floatValue]  ;
}
- (void)sliderValueChanged:(id)sender {
      UISlider *slider = (UISlider *)sender;
     [self setNewSliderValue:slider andAccuracy:100] ;
  
}
-(void)setNewSliderValue:(UISlider *)slider andAccuracy:(float)accuracy
{
    if (slider.value >=[self.maxValue floatValue]) {
        slider.value  =[self.maxValue floatValue];
    }else{
    // 滑动条的 宽
    float width = JT_ScreenW - JT_ADAOTER_WIDTH * 32 ;
    // 如： 用户想每滑动一次 增加100的量 每次滑块需要滑动的宽
    float slideWidth = width*accuracy/slider.maximumValue ;
    // 在滑动条中 滑块的位置 是根据 value值 显示在屏幕上的 那么 把目前滑块的宽 加上用户新滑动一次的宽 转换成value值
    // 根据当前value值 求出目前滑块的宽
    float currentSlideWidth =  slider.value/accuracy*slideWidth ;
    // 用户新滑动一次的宽加目前滑动的宽 得到新的 目前滑动的宽
    float newSlideWidth = currentSlideWidth+slideWidth ;
    // 转换成 新的 value值
    float value =  newSlideWidth/width*slider.maximumValue ;
    // 取整
    int d = (int)(value/accuracy) ;
        JTLog(@"个数=%d",d);
       // 5- 30 一共有25个
        
        NSString *price;
       
        if (d  ==0) {
            //个数为0的时候显示最小值
            price = self.minValue;
        }else{
          
            price  =[NSString stringWithFormat:@"%d",d*100];
        }
        JTLog(@"price=%@",price);
        if ([price integerValue] >[self.maxValue integerValue])
        {
            price  = self.maxValue;
        }
        NSDictionary *dic =@{@"price":price,@"countprice":[NSString stringWithFormat:@"%d",d]};
        
          [[NSNotificationCenter defaultCenter]postNotificationName:@"sliderNotice" object:nil userInfo:dic];
       
}
}
-(JTSlider *)slider{
    if (!_slider) {
        _slider = [[JTSlider alloc]init];
        _slider.continuous = YES;
        [_slider setThumbImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        _slider.minimumTrackTintColor  =[UIColor colorWithHexString:@"62A7E9"];
        _slider.maximumTrackTintColor  =[UIColor colorWithHexString:@"cccccc"];
        _slider.minimumValue = 0 ;
       
    }
    return _slider;
}
@end
