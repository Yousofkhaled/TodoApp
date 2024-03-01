//
//  add_ViewController.m
//  ios_workshop
//
//  Created by Admin on 30/08/2023.
//

#import "add_ViewController.h"
#import "task.h"

@interface add_ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name_field;

@property (weak, nonatomic) IBOutlet UITextField *desc_field;

@property (weak, nonatomic) IBOutlet UISegmentedControl *priority_segment;

@property (weak, nonatomic) IBOutlet UISegmentedControl *state_segment;

@property (weak, nonatomic) IBOutlet UIDatePicker *date_input;

@property NSMutableArray<task*> * arr;
@property NSUserDefaults * defaults;


@end

@implementation add_ViewController

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
    
    for (int i=0;i<_arr.count;++i) {
        [_arr[i] print_task];
    }
}

- (void) save {
    NSError * error;
    NSData * archiveData = [NSKeyedArchiver archivedDataWithRootObject:_arr requiringSecureCoding:YES error:&error];
    
    [_defaults setObject:archiveData forKey:@"tasks_arr"];
}

- (IBAction)add_item:(id)sender {
    
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
    
    
    [_arr addObject:t];
    
    [self save];
    
    //[self load];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self load];
    
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
