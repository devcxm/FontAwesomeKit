#import "IconMapViewController.h"
#import "FontAwesomeKit.h"
#import "IconMapCell.h"

@interface IconMapViewController ()

@property (strong, nonatomic) NSMutableArray *icons;

@property (strong, nonatomic) NSString *iconGroup;
@property (strong, nonatomic) NSMutableArray *originIcons;

@end

@implementation IconMapViewController

- (void)awakeFromNib
{
    self.tabBarItem.image = [[FAKFontAwesome tableIconWithSize:30] imageWithSize:CGSizeMake(30, 30)];
    self.tabBarItem.title = @"Icon Map";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.icons = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self segmentChanged:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.icons count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IconMapCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IconMapCell" forIndexPath:indexPath];
    FAKIcon *icon = self.icons[indexPath.row];
    [cell configureCellWithIcon:icon];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FAKIcon *icon = self.icons[indexPath.row];

    //added by skyfox
    NSString *code = [NSString stringWithFormat:@"\n%@ *%@Icon = [%@ %@IconWithSize:30];\n[%@Icon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];\nUIImage *%@IconImage = [%@Icon imageWithSize:CGSizeMake(30, 30)];",self.iconGroup,icon.iconName,self.iconGroup,icon.iconName,icon.iconName,icon.iconName,icon.iconName];
    NSLog(@"\n\n\n===================Code Autogeneration ===================\n%@\n\n==========================================================\n",code);
    //end
    
}
//added by skyfox
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self searchResult:searchText];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void)searchResult:(NSString*)keyword{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", @"iconName", keyword];
    
    NSMutableArray  *filteredArray = [NSMutableArray arrayWithArray:[self.icons filteredArrayUsingPredicate:pred]];
    self.icons = filteredArray;
    
    if ([keyword isEqualToString:@""] || [self.icons count]==0) {
        self.icons = _originIcons;
    }
    [self.collectionView reloadData];
}
//end
- (IBAction)segmentChanged:(UISegmentedControl *)sender
{
    [self.icons removeAllObjects];
    NSArray *groups = @[@"FAKFontAwesome",@"FAKFoundationIcons",@"FAKZocial",@"FAKIonIcons", @"FAKOcticons"];
    if (sender.selectedSegmentIndex == 0) {
        [self loadFontAwesome];
    } else if (sender.selectedSegmentIndex == 1) {
        [self loadFoundation];
    } else if (sender.selectedSegmentIndex == 2) {
        [self loadZocial];

    } else if (sender.selectedSegmentIndex == 3) {
        [self loadIonIcons];
    } else if (sender.selectedSegmentIndex == 4) {
        [self loadOcticons];
    }
    if (!sender) {
        [self loadFontAwesome];

    }
    self.iconGroup = groups[sender.selectedSegmentIndex];
    self.originIcons = [self.icons mutableCopy];
    [self.collectionView reloadData];
}

- (void)loadFontAwesome
{
    NSDictionary *allIcons = [FAKFontAwesome allIcons];
    NSArray *keys = [[allIcons allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *key in keys) {
        [self.icons addObject:[FAKFontAwesome iconWithCode:[allIcons objectForKey:key] size:50]];
    }
}

- (void)loadFoundation
{
    NSDictionary *allIcons = [FAKFoundationIcons allIcons];
    NSArray *keys = [[allIcons allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *key in keys) {
        [self.icons addObject:[FAKFoundationIcons iconWithCode:[allIcons objectForKey:key] size:50]];
    }
}

- (void)loadZocial
{
    NSDictionary *allIcons = [FAKZocial allIcons];
    NSArray *keys = [[allIcons allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *key in keys) {
        [self.icons addObject:[FAKZocial iconWithCode:[allIcons objectForKey:key] size:40]];
    }
}

- (void)loadIonIcons
{
    NSDictionary *allIcons = [FAKIonIcons allIcons];
    NSArray *keys = [[allIcons allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *key in keys) {
        [self.icons addObject:[FAKIonIcons iconWithCode:[allIcons objectForKey:key] size:50]];
    }
}

- (void)loadOcticons
{
    NSDictionary *allIcons = [FAKOcticons allIcons];
    NSArray *keys = [[allIcons allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *key in keys) {
        [self.icons addObject:[FAKOcticons iconWithCode:[allIcons objectForKey:key] size:48]];
    }
}

@end
