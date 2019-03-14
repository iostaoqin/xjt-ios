//
//  JFHomeNewEditTableViewCell.m
//  spendHelp
//
//  Created by Daisy  on 2018/12/25.
//  Copyright © 2018年 Daisy. All rights reserved.
//

#import "JFHomeNewEditTableViewCell.h"

@implementation JFHomeNewEditTableViewCell

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
    self.bgView = [UIView new];
    [self.contentView addSubview:self.bgView];
    self.bgView.backgroundColor  =[UIColor whiteColor];
    self.bgView.layer.cornerRadius = 10;
    self.bgView.layer.shadowColor =[UIColor colorWithHexString:@"cccccc"].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(2, 5); self.bgView.layer.shadowOpacity = 0.5f; self.bgView.layer.shadowRadius = 5.0f;
    
    
    self.hotImg       =[UIImageView new];
    self.logoImg      =[UIImageView new];
    self.priceImg     =[UIImageView new];
    self.nameLable    =[UILabel new];
    self.lineLable    =[UILabel new];
    self.applyBtn     =[UIButton new];
    self.applyLable   =[UILabel new];
    self.rateLable    =[UILabel new];
    self.referenceRateLable =[UILabel new];
    self.priceAccountLable   =[UILabel new];
    self.applyNameLable   =[UILabel new];
    
    self.priceNameLable =[UILabel new];
    [self.bgView addSubview:self.logoImg];
    [self.bgView addSubview:self.hotImg];
    [self.bgView addSubview:self.priceImg];
    [self.bgView addSubview:self.lineLable];
    [self.bgView addSubview:self.nameLable];
    [self.bgView addSubview:self.applyLable];
    //    [self.bgView addSubview:self.applyBtn];
    [self.bgView addSubview:self.rateLable];
    [self.bgView addSubview:self.referenceRateLable];
    [self.bgView addSubview:self.priceAccountLable];
    [self.bgView addSubview:self.priceNameLable];
    [self.bgView addSubview:self.applyNameLable];
    //
    
    //
    self.nameLable.font = kFontSystem(14);
    self.nameLable.textColor  = [UIColor colorWithHexString:@"333333"];
    
    
    self.priceAccountLable.font = kFontSystem(14);
    self.priceAccountLable.textColor  = [UIColor colorWithHexString:@"#FF4D4F"];
    //
    
    self.rateLable.font = kFontSystem(14);
    self.rateLable.textColor  = [UIColor colorWithHexString:@"#FF4D4F"];
    //
 
    self.applyLable.text  = [JFHSUtilsTool decodeFromPercentEscapeString:@"%E5%8F%AF%E8%B4%B7%E9%A2%9D%E5%BA%A6"];
    self.applyLable.font = kFontSystem(12);
    self.applyLable.textColor  = [UIColor colorWithHexString:@"#666666"];
    //
    self.referenceRateLable.text  = [JFHSUtilsTool decodeFromPercentEscapeString:@"%E5%8F%82%E8%80%83%E6%9C%88%E5%88%A9%E7%8E%87"];
    self.referenceRateLable.font = kFontSystem(12);
    self.referenceRateLable.textColor  = [UIColor colorWithHexString:@"#666666"];
    //price
    self.priceImg.image= [UIImage imageNamed:@"img_price_new"];
    self.lineLable.backgroundColor =  [UIColor  colorWithHexString:@"#EEEEEE"];
    
    self.priceNameLable.textColor =  [UIColor  colorWithHexString:@"#333333"];
    
    self.priceNameLable.font = kFontSystem(12);
    //
    self.applyNameLable.textColor =  [UIColor  colorWithHexString:@"#999999"];
    
    self.applyNameLable.font = kFontSystem(12);
    //
    //渐变
    self.applyBtn.layer.cornerRadius  = 5;
    self.applyBtn.layer.masksToBounds  = YES;
    //增加一个父视图    t阴影
    self.showView = [UIView  new];
    [self.bgView addSubview: self.showView];
    self.showView.layer.shadowColor = [UIColor redColor].CGColor;
    self.showView.layer.shadowOffset  =  CGSizeMake(1, 1);
    self.showView.layer.shadowOpacity  = 0.35f;
    self.showView.layer.shadowRadius  = 5.0f;
    self.showView.clipsToBounds  = NO;
    [self.showView addSubview:self.applyBtn];
    
    
    
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 70 * JT_ADAOTER_WIDTH, 28  * JT_ADAOTER_WIDTH);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.5),@(1.0)];//渐变点
    [gradientLayer setColors:@[(id)[[UIColor colorWithHexString:@"#FF304E"] CGColor],(id)[UIColor colorWithHexString:@"#FF4927"].CGColor]];//渐变数组
    [self.applyBtn.layer addSublayer:gradientLayer];
    
    
    
    [self.applyBtn setTitle:@"一键申请" forState:UIControlStateNormal];
    self.applyBtn.titleLabel.font  = kFontSystem(14);
    [self.applyBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    //
    
    
    
    self.logoImg.layer.cornerRadius  = 5;
    self.logoImg.layer.masksToBounds   = YES;
    
    [self makeConstraints];
    self.applyBtn.enabled  = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hongbaoActionNotice) name:@"hongbaoAction" object:nil];
}
-(void)makeConstraints{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(8);
        make.right.equalTo(self.contentView.mas_right).offset(-8);
        make.height.equalTo(self.contentView);
    }];
    
    [self.logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(55, 55));
        make.top.equalTo(self.bgView.mas_top).offset(12);
        make.left.equalTo(self.bgView.mas_left).offset(10);
        
    }];
    
    [self.hotImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.top.equalTo(self.bgView);
    }];
    
    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(10);
        make.left.equalTo(self.logoImg.mas_right).offset(12);
    }];
    
    [self.priceAccountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLable.mas_left);
        make.top.equalTo(self.nameLable.mas_bottom).offset(8);
    }];
    [self.rateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceAccountLable.mas_right).offset(33);
        make.top.equalTo(self.priceAccountLable);
    }];
    [self.applyLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceAccountLable);
        make.top.equalTo(self.priceAccountLable.mas_bottom).offset(6);
    }];
    [self.referenceRateLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rateLable.mas_left);
        make.top.equalTo(self.applyLable.mas_top);
    }];
    [self.lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.equalTo(self.bgView.mas_left).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
        make.top.equalTo(self.applyLable.mas_bottom).offset(8);
    }];
    [self.priceImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.left.equalTo(self.logoImg.mas_left);
        make.top.equalTo(self.lineLable.mas_bottom).offset(9);
        //        make.bottom.equalTo(self.bgView.mas_bottom).offset(-8);
    }];
    [self.priceNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.bottom.equalTo(self.priceImg);
        make.top.equalTo(self.lineLable.mas_bottom).offset(8);
        make.left.equalTo(self.priceImg.mas_right).offset(3);
    }];
    
    [self.applyNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lineLable.mas_right);
        make.top.equalTo(self.nameLable.mas_top);
    }];
    [self.applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70 * JT_ADAOTER_WIDTH, 28  * JT_ADAOTER_WIDTH));
        make.right.equalTo(self.lineLable.mas_right);
        make.top.equalTo(self.applyNameLable.mas_bottom).offset(14);
    }];
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.applyBtn);
    }];
}

-(void)getGiveData:(JFGiveModel *)giveModel{
    
    self.nameLable.text = giveModel.name;
    self.rateLable.text  = giveModel.interestRate;
    if ([giveModel.hot isEqualToString:@"1"]||[giveModel.imgIdStr isEqualToString:@"1"]) {
        if ([giveModel.hot isEqualToString:@"1"]) {
            self.hotImg.image  = [UIImage imageNamed:@"img_new_otherHot"];
        }else{
            self.hotImg.image  = [UIImage imageNamed:@"img_new"];
        }
    }else{
        self.hotImg.image  = [UIImage imageNamed:@""];
    }
    
    //    if ([giveModel.imgIdStr isEqualToString:@"1"]&&[giveModel.hot isEqualToString:@"0"]) {
    //         self.hotImg.image  = [UIImage imageNamed:@"img_new"];
    //    }else if ([giveModel.imgIdStr isEqualToString:@"0"]&&[giveModel.hot isEqualToString:@"1"]){
    //        self.hotImg.image  = [UIImage imageNamed:@"img_new_otherHot"];
    //    }else{
    //       self.hotImg.image  = [UIImage imageNamed:@""];
    //    }
    //抢红包做动画
    if ([giveModel.name isEqualToString:home_grab_redEnvelope]) {
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"hongbaoDefaults"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.logoImg sd_setImageWithURL:[NSURL URLWithString:giveModel.logo] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            self.logoImg.transform = CGAffineTransformMakeScale(1, 1);
//            [self actionEvent];
            
            
        }];
    }else{
        [self.logoImg sd_setImageWithURL:[NSURL URLWithString:giveModel.logo] completed:nil];
    }
    
    //单位为分换算成  万元
    float min=  [giveModel.minAmount floatValue] /1000000;
    float max  =[giveModel.maxAmount floatValue] /1000000;
    self.priceAccountLable.text  = [NSString stringWithFormat:@"%.1f-%.1f万",min,max];
    self.priceNameLable.text  = giveModel.desc1;
    float applyCount = [giveModel.applyCnt floatValue]/10000;
    NSString *tempStr = [NSString stringWithFormat:@"%.1f",applyCount];
    self.applyNameLable.text  = [NSString stringWithFormat:@"%@万人已申请",[NSString stringWithFormat:@"%@",@(tempStr.floatValue)]];
}
-(void)actionEvent{
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         self.logoImg.transform = CGAffineTransformMakeScale(0.3, 0.3);
                     } completion:^(BOOL finished) {
                         //完成后的一些操作
                         //
                         [UIView animateWithDuration:0.5 animations:^{
                             
                             self.logoImg.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL finished) {
                          
                             [self actionEvent];
                         }];
                     }];
}
#pragma mark  - 界面消失之后  范fan
-(void)hongbaoActionNotice{
    NSString *str = [[NSUserDefaults standardUserDefaults]valueForKey:@"hongbaoDefaults"];
    if ([str isEqualToString:@"1"]) {
        
//        self.logoImg.transform = CGAffineTransformMakeScale(1, 1);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
