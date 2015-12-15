//
//  MySection2.m
//  TableViewDemo
//
//  Created by caoyangmin on 15/12/15.
//

#import "MySection2.h"

@implementation MySection2

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.dataSource = self;
    }
    return self;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: cellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"MySection2 | row %ld",(long)indexPath.row];
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

@end