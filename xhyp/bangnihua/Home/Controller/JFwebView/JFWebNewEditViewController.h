//
//  JFWebNewEditViewController.h
//  spendHelp
//
//  Created by Daisy  on 2019/1/4.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import "JFBaseViewControllerEdit.h"

NS_ASSUME_NONNULL_BEGIN

@interface JFWebNewEditViewController : JFBaseViewControllerEdit
@property (nonatomic, strong)NSString *url;
@property (nonatomic, copy)chageCellImgBlock imgBlock;
@property (nonatomic, strong)NSString *whereVC;
@property (nonatomic,strong)NSArray *webArr;
@end

NS_ASSUME_NONNULL_END
