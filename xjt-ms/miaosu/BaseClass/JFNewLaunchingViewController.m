//
//  JFNewLaunchingViewController.m
//  miaosu
//
//  Created by Daisy  on 2019/3/4.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JFNewLaunchingViewController.h"

@interface JFNewLaunchingViewController ()
@property(nonatomic, strong)UIImageView *launchImageView;
@end

@implementation JFNewLaunchingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.launchImageView.image = [self getLaunchImage];
    [UIView animateWithDuration:2 animations:^{
        self.launchImageView.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.finishBlock) {
            self.finishBlock();
        }
    }];
}
- (UIImageView *)launchImageView
{
    if(!_launchImageView){
        _launchImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_launchImageView];
    }
    return _launchImageView;
}

- (UIImage *)getLaunchImage
{
    UIImage *image;
    //    if(JT_ScreenW==320&&JT_ScreenH==480){//iphone4
    //        image = [UIImage imageNamed:@"640x960"];
    //    }else

    if(JT_ScreenW==320&&JT_ScreenH==568){//iphone5
        image = [UIImage imageNamed:@"640x1136"];
    }else if(JT_ScreenW==375&&JT_ScreenH== 667){//iphone6
        image = [UIImage imageNamed:@"750x1334"];
    }else if(JT_ScreenW==540&&JT_ScreenH== 960){
        image = [UIImage imageNamed:@"1125x2436"];
    }else{
        image = [UIImage imageNamed:@"1242x2208"];
    }
  
    //iphonex xs 812.000000 375.000000
    return image;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
