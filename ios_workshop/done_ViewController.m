//
//  done_ViewController.m
//  ios_workshop
//
//  Created by Admin on 30/08/2023.
//

#import "done_ViewController.h"
#import "task.h"
#import "edit_ViewController.h"

@interface done_ViewController ()

@property NSMutableArray<task*> * arr;
@property NSMutableArray<NSNumber*> * view_indices;

@property NSMutableArray<NSNumber*> * low_priority_view_indices;
@property NSMutableArray<NSNumber*> * medium_priority_view_indices;
@property NSMutableArray<NSNumber*> * high_priority_view_indices;

@property NSUserDefaults * defaults;

@property bool is_sort_mode;

@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation done_ViewController

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_is_sort_mode) {
        if (section == 0) {
            return @"high priority";
        }
        else if (section == 1) {
            return @"medium priority";
        }
        else if (section == 2) {
            return @"low priority";
        }
    }
    else {
        return @"all priorities";
    }
    return @"all priorities";
}

- (void) load {
    _defaults = [NSUserDefaults standardUserDefaults];
    
    NSError * error;
    NSData * savedData = [_defaults objectForKey:@"tasks_arr"];
    
    NSSet * set = [NSSet setWithArray:
                   @[[NSMutableArray class], [task class]]];
    
    _arr = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:savedData error:&error];
    
    if (_arr == nil) {
        _arr = [NSMutableArray<task*> new];
    }
    _view_indices = [NSMutableArray<NSNumber*> new];
    for (int i=0;i<_arr.count;++i) {
        if ([_arr[i].state isEqualToString:@"done"]) {
            [_view_indices addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    _low_priority_view_indices = [NSMutableArray<NSNumber*> new];
    _medium_priority_view_indices = [NSMutableArray<NSNumber*> new];
    _high_priority_view_indices = [NSMutableArray<NSNumber*> new];
    
    for (int i=0;i<_view_indices.count;++i) {
        if ([_arr[[_view_indices[i] intValue]].priority isEqualToString:@"low"]) {
            [_low_priority_view_indices addObject:[NSNumber numberWithInt:[_view_indices[i] intValue]]];
        }
        else if ([_arr[[_view_indices[i] intValue]].priority isEqualToString:@"medium"]) {
            [_medium_priority_view_indices addObject:[NSNumber numberWithInt:[_view_indices[i] intValue]]];
        }
        else if ([_arr[[_view_indices[i] intValue]].priority isEqualToString:@"high"]) {
            [_high_priority_view_indices addObject:[NSNumber numberWithInt:[_view_indices[i] intValue]]];
        }
        
    }
    
}

- (void) save {
    NSError * error;
    NSData * archiveData = [NSKeyedArchiver archivedDataWithRootObject:_arr requiringSecureCoding:YES error:&error];
    
    [_defaults setObject:archiveData forKey:@"tasks_arr"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self load];
    _table.delegate = self;
    _table.dataSource = self;
    
    _is_sort_mode = false;
    
    // Do any additional setup after loading the view.
}

- (IBAction)sort_toggle:(id)sender {
    _is_sort_mode = !_is_sort_mode; // reverse it
    [self load];
    [_table reloadData];
}

- (void) viewWillAppear:(BOOL)animated {
    [self load];
    [_table reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_is_sort_mode) {
        return 3;
    }
    else {
        return 1;
    }

    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (_is_sort_mode) {
        if (section == 0) {
            return [_high_priority_view_indices count];
        }
        else if (section == 1) {
            return [_medium_priority_view_indices count];
        }
        else if (section == 2) {
            return [_low_priority_view_indices count];
        }
    }
    else {
        return [_view_indices count];
    }
    
    //return [_arr count];
    return [_view_indices count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_3" forIndexPath:indexPath];
//    cell.textLabel.text=arr[indexPath.row].name;
    //cell.textLabel.text=_arr[indexPath.row].name;
    //cell.textLabel.text=_view_indices[indexPath.row].name;
    
    if (_is_sort_mode) {
        //NSMutableString * pr;
        if (indexPath.section == 0) {
            cell.textLabel.text=_arr[[_high_priority_view_indices[indexPath.row] intValue]].name;
            cell.imageView.image = [UIImage imageNamed:@"high"];
        }
        else if (indexPath.section == 1) {
            cell.textLabel.text=_arr[[_medium_priority_view_indices[indexPath.row] intValue]].name;
            cell.imageView.image = [UIImage imageNamed:@"medium"];
        }
        else if (indexPath.section == 2) {
            cell.textLabel.text=_arr[[_low_priority_view_indices[indexPath.row] intValue]].name;
            cell.imageView.image = [UIImage imageNamed:@"low"];
        }
    }
    else {
        cell.textLabel.text=_arr[[_view_indices[indexPath.row] intValue]].name;
        if ([_arr[[_view_indices[indexPath.row] intValue]].priority isEqualToString: @"high"]) {
            cell.imageView.image = [UIImage imageNamed:@"high"];
        }
        else if ([_arr[[_view_indices[indexPath.row] intValue]].priority isEqualToString:@"medium"]) {
            cell.imageView.image = [UIImage imageNamed:@"medium"];
        }
        else if ([_arr[[_view_indices[indexPath.row] intValue]].priority isEqualToString: @"low" ]) {
            cell.imageView.image = [UIImage imageNamed:@"low"];
        }
    }
    
    //cell.textLabel.text=_arr[[_view_indices[indexPath.row] intValue]].name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    edit_ViewController * edit_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"edit"];
    
    
    if (_is_sort_mode) {
        if (indexPath.section == 0) {
            edit_vc.my_index = [_high_priority_view_indices[indexPath.row] intValue];
        }
        else if (indexPath.section == 1) {
            edit_vc.my_index = [_medium_priority_view_indices[indexPath.row] intValue];
        }
        else if (indexPath.section == 2) {
            edit_vc.my_index = [_low_priority_view_indices[indexPath.row] intValue];
        }
    }
    else {
        edit_vc.my_index = [_view_indices[indexPath.row] intValue];
    }
    
    
    //edit_vc.my_index = [_view_indices[indexPath.row] intValue];
    
    
    [self.navigationController pushViewController:edit_vc animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"warning" message:@"do you want to delete this item?" preferredStyle:UIAlertControllerStyleAlert];

    
    UIAlertAction* ac = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        
        
    }];
    
    UIAlertAction* ac2 = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
    //         [self.monthTitle removeObjectAtIndex:indexPath.row];
            if (self->_is_sort_mode) {
                if (indexPath.section == 0) {
                    [self->_arr removeObjectAtIndex:[self->_high_priority_view_indices[indexPath.row] intValue]];
                    [self->_high_priority_view_indices removeObjectAtIndex:indexPath.row];
                    [self save];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
                }
                else if (indexPath.section == 1) {
                    [self->_arr removeObjectAtIndex:[self->_medium_priority_view_indices[indexPath.row] intValue]];
                    [self->_medium_priority_view_indices removeObjectAtIndex:indexPath.row];
                    [self save];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
                }
                else if (indexPath.section == 2) {
                    [self->_arr removeObjectAtIndex:[self->_low_priority_view_indices[indexPath.row] intValue]];
                    [self->_low_priority_view_indices removeObjectAtIndex:indexPath.row];
                    [self save];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
                }
            }
            else {
                [self->_arr removeObjectAtIndex:[self->_view_indices[indexPath.row] intValue]];
                [self->_view_indices removeObjectAtIndex:indexPath.row];
                [self save];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
            }
        }
        else if (editingStyle==UITableViewCellEditingStyleInsert)
        {
        }
        
        
    }];
    
    
    [alert addAction:ac];
    [alert addAction:ac2];
    [self presentViewController:alert animated:YES completion:nil];
    
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
////         [self.monthTitle removeObjectAtIndex:indexPath.row];
//        if (_is_sort_mode) {
//            if (indexPath.section == 0) {
//                [_arr removeObjectAtIndex:[_high_priority_view_indices[indexPath.row] intValue]];
//                [_high_priority_view_indices removeObjectAtIndex:indexPath.row];
//                [self save];
//                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
//            }
//            else if (indexPath.section == 1) {
//                [_arr removeObjectAtIndex:[_medium_priority_view_indices[indexPath.row] intValue]];
//                [_medium_priority_view_indices removeObjectAtIndex:indexPath.row];
//                [self save];
//                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
//            }
//            else if (indexPath.section == 2) {
//                [_arr removeObjectAtIndex:[_low_priority_view_indices[indexPath.row] intValue]];
//                [_low_priority_view_indices removeObjectAtIndex:indexPath.row];
//                [self save];
//                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
//            }
//        }
//        else {
//            [_arr removeObjectAtIndex:[_view_indices[indexPath.row] intValue]];
//            [_view_indices removeObjectAtIndex:indexPath.row];
//            [self save];
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
//        }
//    }
//    else if (editingStyle==UITableViewCellEditingStyleInsert)
//    {
//    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
