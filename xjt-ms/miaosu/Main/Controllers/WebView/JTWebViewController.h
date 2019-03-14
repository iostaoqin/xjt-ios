//
//  JTWebViewController.h
//  Flower
//
//  Created by Daisy  on 2019/1/25.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTWebViewController : JTBaseViewController
@property (nonatomic, strong)NSString *url;
@property (nonatomic, strong)NSString *showtype;
@property (nonatomic, strong)NSDictionary *dic;
@end

NS_ASSUME_NONNULL_END
