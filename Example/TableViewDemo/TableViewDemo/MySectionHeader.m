//
//  MySectionHeader.m
//  TableViewDemo
//
//  Created by caoyangmin on 15/12/24.
//

#import "MySectionHeader.h"


@implementation MySectionHeader
{
    UIView* _header;
}

-(instancetype) init
{
    self = [super init];
    if(self){
        self.delegate  = self;
    }
    return self;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 32)];
    label.text = @"MySectionHeader";
    return label;
}

@end

