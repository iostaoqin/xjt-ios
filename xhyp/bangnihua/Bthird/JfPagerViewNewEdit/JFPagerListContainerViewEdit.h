//
//  JXPagingListContainerView.h
//  JXPagingView
//
//  Created by jiaxin on 2018/8/27.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JFPagerMainTableViewEdit;
@class JFPagerListContainerViewEdit;
@class JXPagerListContainerCollectionView;

@protocol JXPagerListContainerCollectionViewGestureDelegate <NSObject>
- (BOOL)pagerListContainerCollectionViewGestureRecognizerShouldBegin:(JXPagerListContainerCollectionView *)collectionView gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
@end

@interface JXPagerListContainerCollectionView: UICollectionView<UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL isNestEnabled;
@property (nonatomic, weak) id<JXPagerListContainerCollectionViewGestureDelegate> gestureDelegate;
@end

@protocol JFPagerListContainerViewEditDelegate <NSObject>

- (NSInteger)numberOfRowsInListContainerView:(JFPagerListContainerViewEdit *)listContainerView;

- (UIView *)listContainerView:(JFPagerListContainerViewEdit *)listContainerView listViewInRow:(NSInteger)row;

- (void)listContainerView:(JFPagerListContainerViewEdit *)listContainerView willDisplayCellAtRow:(NSInteger)row;

@end


@interface JFPagerListContainerViewEdit : UIView

@property (nonatomic, strong, readonly) JXPagerListContainerCollectionView *collectionView;
@property (nonatomic, weak) id<JFPagerListContainerViewEditDelegate> delegate;
@property (nonatomic, weak) JFPagerMainTableViewEdit *mainTableView;

- (instancetype)initWithDelegate:(id<JFPagerListContainerViewEditDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (void)reloadData;

@end


