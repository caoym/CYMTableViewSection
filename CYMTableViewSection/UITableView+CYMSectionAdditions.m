//
//  UITableView+CYMSectionAdditions.m
//  Created by caoyangmin on 15/12/3.
//

#import <objc/runtime.h>
#import "UITableView+CYMSectionAdditions.h"
#import "CYMDelegateChain.h" //@see https://github.com/caoym/CYMDelegateChain


/**
 * 持有section实例
 * 只实现numberOfSectionsInTableView
 */
@interface CYMTableViewData:NSObject<UITableViewDataSource>
    @property NSMutableDictionary* sections;
@end
@implementation CYMTableViewData

-(instancetype) init
{
    self = [super init];
    if(self){
        _sections = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sections.count;
}
@end


@implementation UITableView(CYMSectionAdditions)
-(NSInteger)addSection:(nonnull __strong CYMTableViewSection*)section reload:(BOOL)reload{
    
    CYMTableViewData*data = objc_getAssociatedObject(self, @"__cymTableViewData");
    NSInteger sectionId = 0;
    if(!data){
        data = [[CYMTableViewData alloc]init];
        objc_setAssociatedObject(self, @"__cymTableViewData", data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        //在链中插入新section,只处理numberOfSectionsInTableView
        CYMDelegateChainInsert(self.dataSource, data, self);
    }
    sectionId = data.sections.count;
    
    [section addTo:self section:sectionId reload:(BOOL)reload];
    
    [data.sections setObject:section forKey:[NSNumber numberWithLong:sectionId]] ;
    return sectionId;
}

-(void) removeAllSections{
    CYMTableViewData*data = objc_getAssociatedObject(self, @"__cymTableViewData");
    if(data){
        for (CYMTableViewSection* section in data.sections.allValues){
            [section removeFromTableView:NO];
        }
        [data.sections removeAllObjects];
        //CYMDelegateChainRemove(self.dataSource, data, self);
    }
}
@end
