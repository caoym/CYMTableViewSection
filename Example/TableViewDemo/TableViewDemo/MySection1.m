//
//  MySection1.m
//  TableViewDemo
//
//  Created by caoyangmin on 15/12/15.
//

#import "MySection1.h"

@implementation MySection1

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
    cell.textLabel.text = [NSString stringWithFormat:@"MySection1 | row %ld",(long)indexPath.row];
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

@end