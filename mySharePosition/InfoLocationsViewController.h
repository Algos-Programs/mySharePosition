//
//  InfoLocationsViewController.h
//  mySharePosition
//
//  Created by Marco Velluto on 08/03/13.
//  Copyright (c) 2013 Algos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoLocationsViewController : UITableViewController {
    
    NSMutableArray *array; //Conterrà le info della localizzione (es. Via marzabotto, 10, 20090).
    NSArray *arrayNames; //Conterrà i nomi delle info localizzazione (es. Via, N°, CAP).
 
    NSMutableArray *arrayContLocation; //conterrà il valore delle coordinate (45.00000390 - 9.9839887).
    NSArray *arrayGeoLocation; //conterrà i nomi della GeoLocalizzazione (es. Longitudine, Latitudine).
    
    NSArray *arrayCelle; //Conterrà tutte le informazioni delle celle (arrayNames e arrayGeoLocation).
    NSArray *arrayValueCelle; //Conterra tutte i valori delle celle (array e arrayContLocation);
}
@property (weak, nonatomic) IBOutlet UILabel *developedLabel;

@end
