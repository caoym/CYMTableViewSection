//
//  CYMTableViewSection.h
//  Created by caoyangmin on 15/12/3.
//

#import <UIKit/UIKit.h>

/** 
 * 封装section, 使section有独立的delegate和dataSource
 */
@interface CYMTableViewSection: NSObject{
    __weak UITableView* _tableView;
}
/**
 * section加入到TableView中
 * @param sectionId section的id，delegate和dataSource将只接收此id的事件
 *
 */
-(void)addTo:(nonnull UITableView*)tableView section:(NSInteger)sectionId reload:(BOOL)reload;
/**
 * 从TableView中移除section
 */
-(void)removeFromTableView:(BOOL)reload;

@property (nonatomic, weak, nullable) id <UITableViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id <UITableViewDelegate> delegate;

@property(assign, readonly) BOOL isAttached;

@end
