//
//  UITableView+CYMSectionAdditions.h
//
//  Created by caoyangmin on 15/12/3.
//

#import <UIKit/UIKit.h>
#import "CYMTableViewSection.h"

@interface UITableView(CYMSectionAdditions)

/**
 * 添加section，返回section id
 */
-(NSInteger)addSection:(nonnull __strong CYMTableViewSection*)section reload:(BOOL)reload;
/**
 * 移除所有section
 * 因为sectionid是递增的，移除单个section会导致其他sectionid变化，所以不提供移除单个section的方法
 */
-(void) removeAllSections;
@end
