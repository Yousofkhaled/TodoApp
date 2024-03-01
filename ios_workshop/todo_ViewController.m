//
//  todo_ViewController.m
//  ios_workshop
//
//  Created by Admin on 30/08/2023.
//

#import "todo_ViewController.h"
#import "task.h"
#import "add_ViewController.h"
#import "edit_ViewController.h"

@interface todo_ViewController ()

@property NSMutableArray<task*> * arr;

@property NSMutableArray<NSNumber*> * view_indices;
@property NSMutableArray<NSNumber*> * search_view_indices;
@property bool search_is_active;

@property NSUserDefaults * defaults;

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UISearchBar *search_bar;



@end

@implementation todo_ViewController

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
        if ([_arr[i].state isEqualToString:@"todo"]) {
            [_view_indices addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    _search_view_indices = [NSMutableArray<NSNumber*> new];
    if (! [_search_bar.text isEqualToString:@""]) {
        
        NSMutableString * search_string = [NSMutableString stringWithString: _search_bar.text];
        
        search_string = [NSMutableString stringWithString:[search_string lowercaseString]];
        
        //NSLog(@"inside load : |%@|", search_string);
        
        //(search bar text)comp == substr of _arr[view_indices[i]].name (0, comp.size - 1)
        
        for (int i=0;i<_view_indices.count;++i) {
            
            NSString * task_name = _arr[[_view_indices[i] intValue]].name;
            //NSLog(@"|%@|", [task_name substringToIndex:search_string.length]);
            
            if (search_string.length <= task_name.length) {
                
                
                // I am a prefix
                
                if ([search_string isEqualToString:[task_name substringToIndex:(search_string.length)]]) {
                    
                    [_search_view_indices addObject:[NSNumber numberWithInt:[_view_indices[i] intValue]]];
                }
                
                
            }
            
        }
        
    }
    
    //NSLog(@"%lu", (unsigned long)_search_view_indices.count);
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //NSLog(@"%@", searchBar.text);
    
    if ([searchText isEqualToString:@""]) {
        _search_is_active = false;
    }
    else {
        _search_is_active = true;
    }
    [self load];
    [_table reloadData];
    
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
    
    _search_bar.delegate = self;
    
    _search_is_active = false;
    
    // Do any additional setup after loading the view.
}
- (IBAction)add_item:(id)sender {
    add_ViewController * add_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"add"];
    
    [self.navigationController pushViewController:add_vc animated:YES];
}

- (void) viewWillAppear:(BOOL)animated {
    [self load];
    [_table reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    //return [_arr count];
    
    if (_search_is_active) {
        return _search_view_indices.count;
    }
    return [_view_indices count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    cell.textLabel.text=arr[indexPath.row].name;
    //cell.textLabel.text=_arr[indexPath.row].name;
    //cell.textLabel.text=_view_indices[indexPath.row].name;
    
    if (_search_is_active) {
        cell.textLabel.text=_arr[[_search_view_indices[indexPath.row] intValue]].name;
        
        if ([_arr[[_search_view_indices[indexPath.row] intValue]].priority isEqualToString: @"high"]) {
            cell.imageView.image = [UIImage imageNamed:@"high"];
        }
        else if ([_arr[[_search_view_indices[indexPath.row] intValue]].priority isEqualToString:@"medium"]) {
            cell.imageView.image = [UIImage imageNamed:@"medium"];
        }
        else if ([_arr[[_search_view_indices[indexPath.row] intValue]].priority isEqualToString: @"low" ]) {
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    edit_ViewController * edit_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"edit"];
    
    //edit_vc.my_index = [_view_indices[indexPath.row] intValue];
    if (_search_is_active) {
        edit_vc.my_index = [_search_view_indices[indexPath.row] intValue];
    }
    else {
        edit_vc.my_index = [_view_indices[indexPath.row] intValue];
    }
    
    
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
            
            if (self->_search_is_active) {
                [self->_arr removeObjectAtIndex:[self->_search_view_indices[indexPath.row] intValue]];
                [self->_search_view_indices removeObjectAtIndex:indexPath.row];
                [self save];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
            }
            else {
                [self->_arr removeObjectAtIndex:[self->_view_indices[indexPath.row] intValue]];
                [self->_view_indices removeObjectAtIndex:indexPath.row];
                [self save];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
            }
            
    ////         [self.monthTitle removeObjectAtIndex:indexPath.row];
    //        [_arr removeObjectAtIndex:[_view_indices[indexPath.row] intValue]];
    //        [_view_indices removeObjectAtIndex:indexPath.row];
    //        [self save];
    //        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
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
//
//        if (_search_is_active) {
//            [_arr removeObjectAtIndex:[_search_view_indices[indexPath.row] intValue]];
//            [_search_view_indices removeObjectAtIndex:indexPath.row];
//            [self save];
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
//        }
//        else {
//            [_arr removeObjectAtIndex:[_view_indices[indexPath.row] intValue]];
//            [_view_indices removeObjectAtIndex:indexPath.row];
//            [self save];
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
//        }
//
//////         [self.monthTitle removeObjectAtIndex:indexPath.row];
////        [_arr removeObjectAtIndex:[_view_indices[indexPath.row] intValue]];
////        [_view_indices removeObjectAtIndex:indexPath.row];
////        [self save];
////        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
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
