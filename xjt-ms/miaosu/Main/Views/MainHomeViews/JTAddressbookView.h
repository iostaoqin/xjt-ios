//
//  JTAddressbookView.h
//  miaosu
//
//  Created by Daisy  on 2019/2/21.
//  Copyright © 2019年 Daisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol addressBookDelegate <NSObject>
-(void)closeAddressBookEvent;
-(void)submitAddressbook;
@end
@interface JTAddressbookView : UIView
@property (nonatomic, strong)UIButton *closeImg;
@property (nonatomic, strong)UILabel *nameLable;
@property (nonatomic, strong)UILabel *detailNameLable;
@property (nonatomic, strong)UILabel *lineLable;
@property (nonatomic, strong)UIButton *addressbookBtn;
@property (nonatomic, weak)id<addressBookDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
