//
//  edit_ViewController.m
//  ios_workshop
//
//  Created by Admin on 30/08/2023.
//

#import "edit_ViewController.h"
#import "task.h"

@interface edit_ViewController ()

@property task * t;
@property (weak, nonatomic) IBOutlet UIButton *edit_button;

//def
@property NSMutableArray<task*> * arr;
@property NSUserDefaults * defaults;

@property (weak, nonatomic) IBOutlet UITextField *name_field;
@property (weak, nonatomic) IBOutlet UITextField *desc_field;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priority_segment;

@property (weak, nonatomic) IBOutlet UISegmentedControl *state_segment;

@property (weak, nonatomic) IBOutlet UIDatePicker *date_input;

@end

@implementation edit_ViewController

-(void) helper {
    
        
    NSLog(@"here");
    
    task * t = [task new];
    
    /*
     @property NSString * name;
     @property NSString * desc;
     @property NSString * priority;
     @property NSString * state;
     @property NSDate * date;
     */
    
    t.name = _name_field.text;
    t.desc = _desc_field.text;
    
    NSArray <NSString * >* values = @[@"low", @"medium", @"high"];
    t.priority = values[(int)_priority_segment.selectedSegmentIndex];
    
    NSArray <NSString * >* values2 = @[@"todo", @"in_progress", @"done"];
    t.state = values2[(int)_state_segment.selectedSegmentIndex];
    
    t.date = _date_input.date;
    
//    NSLog(@"%@", t.name);
//    NSLog(@"%@", t.desc);
//    NSLog(@"%@", t.priority);
//    NSLog(@"%@", t.state);
//    NSLog(@"%@", t.date);
    
    
    //[_arr addObject:t];
    _arr[_my_index] = t;
    
    [self save];
    
    //[self load];
}

- (IBAction)save_edit:(id)sender {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"warning" message:@"do you want to edit?" preferredStyle:UIAlertControllerStyleAlert];
    
    __block bool go_out = false;
    
    UIAlertAction* ac = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        go_out = true;
        
    }];
    
    UIAlertAction* ac2 = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self helper];
        
    }];
    
    
    [alert addAction:ac];
    [alert addAction:ac2];
    [self presentViewController:alert animated:YES completion:nil];
//
//    if (go_out)
//        return;
//
//    NSLog(@"here");
//
//    task * t = [task new];
//
//    /*
//     @property NSString * name;
//     @property NSString * desc;
//     @property NSString * priority;
//     @property NSString * state;
//     @property NSDate * date;
//     */
//
//    t.name = _name_field.text;
//    t.desc = _desc_field.text;
//
//    NSArray <NSString * >* values = @[@"low", @"medium", @"high"];
//    t.priority = values[(int)_priority_segment.selectedSegmentIndex];
//
//    NSArray <NSString * >* values2 = @[@"todo", @"in_progress", @"done"];
//    t.state = values2[(int)_state_segment.selectedSegmentIndex];
//
//    t.date = _date_input.date;
//
////    NSLog(@"%@", t.name);
////    NSLog(@"%@", t.desc);
////    NSLog(@"%@", t.priority);
////    NSLog(@"%@", t.state);
////    NSLog(@"%@", t.date);
//
//
//    //[_arr addObject:t];
//    _arr[_my_index] = t;
//
//    [self save];
//
//    //[self load];
    
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
}

- (void) save {
    NSError * error;
    NSData * archiveData = [NSKeyedArchiver archivedDataWithRootObject:_arr requiringSecureCoding:YES error:&error];
    
    [_defaults setObject:archiveData forKey:@"tasks_arr"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self load];
    
    _t = _arr[_my_index];
    
    _name_field.text = _t.name;
    _desc_field.text = _t.desc;
    
    NSArray <NSString * >* values = @[@"low", @"medium", @"high"];
    
    //int idx;
    for (int i=0;i<3;++i) {
        if ([_t.priority isEqualToString:values[i]]) {
            //idx = i;
            _priority_segment.selectedSegmentIndex = i;
            
            printf ("pr id : %d\n", i);
        }
    }
    
    NSArray <NSString * >* values2 = @[@"todo", @"in_progress", @"done"];
    //int idx;
    for (int i=0;i<3;++i) {
        if ([_t.state isEqualToString:values2[i]]) {
            //idx = i;
            _state_segment.selectedSegmentIndex = i;
            
            printf ("state id : %d\n", i);
            break;
        }
        
        [_state_segment setEnabled:NO forSegmentAtIndex:i];
    }
    
    _date_input.date = _t.date;
    
    if ([_t.state isEqualToString:@"done"]) {
        
        /*
         @property (weak, nonatomic) IBOutlet UITextField *name_field;
         @property (weak, nonatomic) IBOutlet UITextField *desc_field;
         @property (weak, nonatomic) IBOutlet UISegmentedControl *priority_segment;

         @property (weak, nonatomic) IBOutlet UISegmentedControl *state_segment;

         @property (weak, nonatomic) IBOutlet UIDatePicker *date_input;
         */
        
        [_name_field setEnabled:NO];
        [_desc_field setEnabled:NO];
        [_priority_segment setEnabled:NO];
        [_state_segment setEnabled:NO];
        [_date_input setEnabled:NO];
        
        [_edit_button setEnabled:NO];
    }
    
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
