using TravelService from '../../srv/travel-service';
using from '../../db/schema';
using from '../../db/master-data';
using from './value-helps';




//
// annotatios that control the fiori layout
//

annotate TravelService.Travel with @(
    UI: {
    
        Identification        : [
            {
                $Type : 'UI.DataFieldForAction',
                Action: 'TravelService.acceptTravel',
                Label : '{i18n>AcceptTravel}'
            },
            {
                $Type : 'UI.DataFieldForAction',
                Action: 'TravelService.rejectTravel',
                Label : '{i18n>RejectTravel}'
            },
            {
                $Type : 'UI.DataFieldForAction',
                Action : 'TravelService.deductDiscount',
                Label : '{i18n>Deductdiscount}',
            },
        ],
        HeaderInfo            : {
            TypeName      : '{i18n>Travel}',
            TypeNamePlural: '{i18n>Travels}',
            Title         : {
                $Type: 'UI.DataField',
                Value: Description
            },
            Description   : {
                $Type: 'UI.DataField',
                Value: TravelID
            }
        },
        PresentationVariant   : {
            Text          : 'Default',
            Visualizations: ['@UI.LineItem'],
            SortOrder     : [{
                $Type     : 'Common.SortOrderType',
                Property  : TravelID,
                Descending: true
            }]
        },
        SelectionFields       : [
            to_Agency_AgencyID,
            to_Customer_CustomerID,
            TravelStatus_code,
            BeginDate,
            EndDate,
        ],
        LineItem              : [
            {
                $Type : 'UI.DataFieldForAction',
                Action: 'TravelService.acceptTravel',
                Label : '{i18n>AcceptTravel}'
            },
            {
                $Type : 'UI.DataFieldForAction',
                Action: 'TravelService.rejectTravel',
                Label : '{i18n>RejectTravel}'
            },
            {
                Value            : TravelID,
                ![@UI.Importance]: #High
            },
            {
                Value            : to_Customer_CustomerID,
                ![@UI.Importance]: #High
            },
            {Value: BeginDate},
            {Value: EndDate},
            {Value: BookingFee},
            {Value: TotalPrice},
            {
                $Type            : 'UI.DataField',
                Value            : TravelStatus_code,
                Criticality      : TravelStatus.criticality,
                ![@UI.Importance]: #High
            },
            {
                $Type : 'UI.DataFieldForAction',
                Inline: true,
                Action : 'TravelService.deductDiscount',
                Label : '{i18n>Deductdiscount}',
            },
            {
                $Type : 'UI.DataFieldForAnnotation',
                Target : '@UI.DataPoint#Progress',
                Label : '{i18n>ProgressOfTravel}',
            },
            {
                $Type : 'UI.DataFieldForAnnotation',
                Target : 'to_Agency/@Communication.Contact#contact',
                Label : '{i18n>AgencyID}',
            },
        ],
        Facets                : [
            {
                $Type : 'UI.CollectionFacet',
                Label : '{i18n>GeneralInformation}',
                ID    : 'Travel',
                Facets: [{ // travel details
                    $Type : 'UI.ReferenceFacet',
                    ID    : 'TravelData',
                    Target: '@UI.FieldGroup#TravelData',
                    Label : '{i18n>GeneralInformation}'
                }]
            },
            { // booking list
                $Type : 'UI.ReferenceFacet',
                Target: 'to_Booking/@UI.PresentationVariant',
                Label : '{i18n>Bookings}'
            }
        ],
        FieldGroup #TravelData: {Data: [
            {Value: to_Agency_AgencyID},
            {Value: to_Customer_CustomerID},
            {Value: Description},
            {
                $Type : 'UI.DataField',
                Value : BeginDate,
            },
            {
                $Type : 'UI.DataField',
                Value : EndDate,
            },
        ]},
        FieldGroup #DateData  : {Data: [
            {
                $Type: 'UI.DataField',
                Value: BeginDate
            },
            {
                $Type: 'UI.DataField',
                Value: EndDate
            }
        ]},
        SelectionVariant #canceled: {
            $Type           : 'UI.SelectionVariantType',
            ID              : 'canceled',
            Text            : '{i18n>Canceled}',
            Parameters      : [

            ],
            FilterExpression: '',
            SelectOptions   : [{
                $Type       : 'UI.SelectOptionType',
                PropertyName: TravelStatus_code,
                Ranges      : [{
                    $Type : 'UI.SelectionRangeType',
                    Sign  : #I,
                    Option: #EQ,
                    Low   : 'X',
                }, ],
            }, ],
        },
        SelectionVariant#open  : {
            $Type : 'UI.SelectionVariantType',
            ID : 'open',
            Text : '{i18n>Open2}',
            Parameters : [

            ],             
            FilterExpression : '',
            SelectOptions : [
                {
                    $Type : 'UI.SelectOptionType',
                    PropertyName : TravelStatus_code,
                    Ranges : [
                        {
                            $Type : 'UI.SelectionRangeType',
                            Sign : #I,
                            Option : #EQ,
                            Low : 'O',
                        },
                    ],
                },
            ],
        },
        SelectionVariant #accepted: {
            $Type           : 'UI.SelectionVariantType',
            ID              : 'accepted',
            Text            : '{i18n>Accepted}',
            Parameters      : [

            ],
            FilterExpression: '',
            SelectOptions   : [{
                $Type       : 'UI.SelectOptionType',
                PropertyName: TravelStatus_code,
                Ranges      : [{
                    $Type : 'UI.SelectionRangeType',
                    Sign  : #I,
                    Option: #EQ,
                    Low   : 'A',
                }, ],
            }, ],
        }
    },
    UI.DataPoint #Progress : {
        Value : Progress,
        Visualization : #Progress,
        TargetValue : 100,
    },
    UI.SelectionPresentationVariant #tableView : {
        $Type              : 'UI.SelectionPresentationVariantType',
        PresentationVariant: ![@UI.PresentationVariant],
        SelectionVariant   : {
            $Type        : 'UI.SelectionVariantType',
            SelectOptions: [],
        },
        Text               : '{i18n>Open}',
    },
    UI.SelectionPresentationVariant #tableView1: {
        $Type              : 'UI.SelectionPresentationVariantType',
        PresentationVariant: {
            $Type         : 'UI.PresentationVariantType',
            Visualizations: ['@UI.LineItem#tableView', ],
        },
        SelectionVariant   : {
            $Type        : 'UI.SelectionVariantType',
            SelectOptions: [{
                $Type       : 'UI.SelectOptionType',
                PropertyName: TravelStatus_code,
                Ranges      : [{
                    $Type : 'UI.SelectionRangeType',
                    Sign  : #I,
                    Option: #EQ,
                    Low   : 'A',
                }, ],
            }],
        },
        Text               : '{i18n>Accepted}',
    },
    UI.SelectionPresentationVariant #tableView2: {
        $Type              : 'UI.SelectionPresentationVariantType',
        PresentationVariant: {
            $Type         : 'UI.PresentationVariantType',
            Visualizations: ['@UI.LineItem#tableView1', ],
        },
        SelectionVariant   : {
            $Type        : 'UI.SelectionVariantType',
            SelectOptions: [{
                $Type       : 'UI.SelectOptionType',
                PropertyName: TravelStatus_code,
                Ranges      : [{
                    $Type : 'UI.SelectionRangeType',
                    Sign  : #I,
                    Option: #EQ,
                    Low   : 'X',
                }, ],
            }],
        },
        Text               : '{i18n>Canceled}',
    },
     UI.LineItem #tableView : [ 
        { 
            $Type : 'UI.DataFieldForAction', 
            Action : 'TravelService.rejectTravel', 
            Label : '{i18n>RejectTravel}', 
        }, 
        { 
            $Type : 'UI.DataField', 
            Value : Description, 
        }, 
        { 
            $Type : 'UI.DataField', 
            Value : LastChangedAt, 
        }, 
        { 
            $Type : 'UI.DataField', 
            Value : TravelID, 
        }, 
        { 
            $Type : 'UI.DataField', 
            Value : to_Customer_CustomerID, 
        },
        {
                $Type            : 'UI.DataField',
                Value            : TravelStatus_code,
                Criticality      : TravelStatus.criticality,
                ![@UI.Importance]: #High
        },
    ],
    UI.LineItem #tableView1 : [ 
        {
            $Type: 'UI.DataField', 
            Value: Description, 
        }, 
        { 
            $Type: 'UI.DataField', 
            Value: LastChangedAt, 
        }, 
        { 
            $Type: 'UI.DataField', 
            Value: TravelID, 
        }, 
        { 
            $Type: 'UI.DataField', 
            Value: to_Agency_AgencyID, 
        }, 
        { 
            $Type: 'UI.DataField', 
            Value: to_Customer_CustomerID, 
        },
        {
                $Type            : 'UI.DataField',
                Value            : TravelStatus_code,
                Criticality      : TravelStatus.criticality,
                ![@UI.Importance]: #High
        },
    ],
    UI.LineItem #tableView2 : [
        {
            $Type: 'UI.DataField', 
            Value: Description, 
        }, 
        { 
            $Type: 'UI.DataField', 
            Value: LastChangedAt, 
        }, 
        { 
            $Type: 'UI.DataField', 
            Value: TravelID, 
        }, 
        { 
            $Type: 'UI.DataField', 
            Value: to_Agency_AgencyID, 
        }, 
        { 
            $Type: 'UI.DataField', 
            Value: to_Customer_CustomerID, 
        },
        {
            $Type            : 'UI.DataField',
            Value            : TravelStatus_code,
            Criticality      : TravelStatus.criticality,
            ![@UI.Importance]: #High
        },
    ],
    UI.SelectionPresentationVariant #tableView3 : {
        $Type : 'UI.SelectionPresentationVariantType',
        PresentationVariant : {
            $Type : 'UI.PresentationVariantType',
            Visualizations : [
                '@UI.LineItem#tableView2',
            ],
        },
        SelectionVariant : {
            $Type : 'UI.SelectionVariantType',
            SelectOptions : [
                {
                    $Type : 'UI.SelectOptionType',
                    PropertyName : TravelStatus_code,
                    Ranges : [
                        {
                            $Type : 'UI.SelectionRangeType',
                            Sign : #I,
                            Option : #EQ,
                            Low : 'O',
                        },
                    ],
                },
            ],
        },
        Text : '{i18n>Open2}',
    },
    UI.DataPoint #TotalPrice : {
        $Type : 'UI.DataPointType',
        Value : TotalPrice,
        Title : '{i18n>Totalprice}',
    },
    UI.HeaderFacets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'TotalPrice',
            Target : '@UI.DataPoint#TotalPrice',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'BookingFee',
            Target : '@UI.DataPoint#BookingFee',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'TravelStatus_code',
            Target : '@UI.DataPoint#TravelStatus_code',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'Progress',
            Target : '@UI.DataPoint#progress',
        },
    ],
    UI.DataPoint #BookingFee : {
        $Type : 'UI.DataPointType',
        Value : BookingFee,
        Title : '{i18n>Bookingfee}',
    },
    UI.FieldGroup #PricingDetails : {
        $Type : 'UI.FieldGroupType',
        Data : [
        ],
    },
    UI.DataPoint #TravelStatus_code : {
        $Type : 'UI.DataPointType',
        Value : TravelStatus_code,
        Title : '{i18n>Travelstatuscode}',
    },
    UI.DataPoint #progress : {
        $Type : 'UI.DataPointType',
        Value : Progress,
        Title : 'Progress',
        TargetValue : 100,
        Visualization : #Progress,
        Description : '{i18n>Progress}',
    },
);

annotate TravelService.Booking with @(
    UI: {
        Identification                : [{Value: BookingID}, ],
        HeaderInfo                    : {
            TypeName      : '{i18n>Bookings}',
            TypeNamePlural: '{i18n>Bookings}',
            Title         : {Value: to_Customer.LastName},
            Description   : {Value: BookingID}
        },
        PresentationVariant           : {
            Visualizations: ['@UI.LineItem'],
            SortOrder     : [{
                $Type     : 'Common.SortOrderType',
                Property  : BookingID,
                Descending: false
            }]
        },
        SelectionFields               : [],
        LineItem                      : [
            {
                Value: to_Carrier.AirlinePicURL,
                Label: '  '
            },
            {Value: BookingID},
            {Value: BookingDate},
            {Value: to_Customer_CustomerID},
            {Value: to_Carrier_AirlineID},
            {
                Value: ConnectionID,
                Label: '{i18n>FlightNumber}'
            },
            {Value: FlightDate},
            {Value: FlightPrice},
            {Value: BookingStatus_code},
        {
            $Type : 'UI.DataFieldForAnnotation',
            Target : '@UI.Chart#TotalSupplPrice',
            Label : '{i18n>Totalsupplprice}',
        },
        ],
        Facets                        : [
            {
                $Type : 'UI.CollectionFacet',
                Label : '{i18n>GeneralInformation}',
                ID    : 'Booking',
                Facets: [
                    { // booking details
                        $Type : 'UI.ReferenceFacet',
                        ID    : 'BookingData',
                        Target: '@UI.FieldGroup#GeneralInformation',
                        Label : '{i18n>Booking}'
                    },
                    { // flight details
                        $Type : 'UI.ReferenceFacet',
                        ID    : 'FlightData',
                        Target: '@UI.FieldGroup#Flight',
                        Label : '{i18n>Flight}'
                    }
                ]
            },
            { // supplements list
                $Type : 'UI.ReferenceFacet',
                Target: 'to_BookSupplement/@UI.PresentationVariant',
                Label : '{i18n>BookingSupplements}'
            }
        ],
        FieldGroup #GeneralInformation: {Data: [
            {Value: BookingID},
            {Value: BookingDate, },
            {Value: to_Customer_CustomerID},
            {Value: BookingDate, },
            {Value: BookingStatus_code}
        ]},
        FieldGroup #Flight            : {Data: [
            {Value: to_Carrier_AirlineID},
            {Value: ConnectionID},
            {Value: FlightDate},
            {Value: FlightPrice}
        ]},
    },
    UI.DataPoint #TotalSupplPrice : {
        Value : TotalSupplPrice,
        MinimumValue : 0,
        MaximumValue : 120,
    },
    UI.Chart #TotalSupplPrice : {
        ChartType : #Bullet,
        Measures : [
            TotalSupplPrice,
        ],
        MeasureAttributes : [
            {
                DataPoint : '@UI.DataPoint#TotalSupplPrice',
                Role : #Axis1,
                Measure : TotalSupplPrice,
            },
        ],
    },
    UI.DataPoint #TotalSupplPrice1 : {
        Value : TotalSupplPrice,
        MinimumValue : {$edmJson: {$Path: '/SupplementScope/MinimumValue'}},
        MaximumValue : {$edmJson: {$Path: '/SupplementScope/MaximumValue'}},
        TargetValue: {$edmJson: {$Path: '/SupplementScope/TargetValue'}},
        CriticalityCalculation : {
            Type : 'UI,CriticalityCalculation',
            ImprovementDirection : #Maximize,
            ToleranceRangeLowValue : {$edmJson: {$Path: '/SupplementScope/ToleranceRangeLowValue'}},
            DeviationRangeLowValue : {$edmJson: {$Path: '/SupplementScope/DeviationRangeLowValue'}}
        }
    },
    UI.Chart #TotalSupplPrice1 : {
        ChartType : #Bullet,
        Title : 'TotalSupplPrice',
        Measures : [
            TotalSupplPrice,
        ],
        MeasureAttributes : [
            {
                DataPoint : '@UI.DataPoint#TotalSupplPrice1',
                Role : #Axis1,
                Measure : TotalSupplPrice,
            },
        ],
        Description : '{i18n>Totalsupplements}'
    },
    UI.HeaderFacets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'TotalSupplPrice',
            Target : '@UI.Chart#TotalSupplPrice1',
        },
    ],
);

annotate TravelService.BookingSupplement with @UI: {
    Identification     : [{Value: BookingSupplementID}],
    HeaderInfo         : {
        TypeName      : '{i18n>BookingSupplement}',
        TypeNamePlural: '{i18n>BookingSupplements}',
        Title         : {Value: BookingSupplementID},
        Description   : {Value: BookingSupplementID}
    },
    PresentationVariant: {
        Text          : 'Default',
        Visualizations: ['@UI.LineItem'],
        SortOrder     : [{
            $Type     : 'Common.SortOrderType',
            Property  : BookingSupplementID,
            Descending: false
        }]
    },
    LineItem           : [
        {Value: BookingSupplementID},
        {
            Value: to_Supplement_SupplementID,
            Label: '{i18n>ProductID}'
        },
        {
            Value: Price,
            Label: '{i18n>ProductPrice}'
        }
    ],
};

annotate TravelService.Flight with @UI: {PresentationVariant #SortOrderPV: { // used in the value help for ConnectionId in Bookings
SortOrder: [{
    Property  : FlightDate,
    Descending: true
}]}};
annotate TravelService.TravelAgency with @(
    Communication.Contact #contact : {
        $Type : 'Communication.ContactType',
        fn : Name,
        tel : [
            {
                $Type : 'Communication.PhoneNumberType',
                type : #work,
                uri : PhoneNumber,
            },
        ],
        adr : [
            {
                $Type : 'Communication.AddressType',
                type : #work,
                street : Street,
                locality : City,
                code : PostalCode,
                country : CountryCode_code,
            },
        ],
    }
);

annotate TravelService.Travel with {
    Description @UI.MultiLineText : true
                @UI.Placeholder  : '{i18n>DescrPlcehlder}'
};

annotate TravelService.Booking with {
    ConnectionID @(
        Common.ValueList : {
            CollectionPath : 'Flight',
            Label : '',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    ValueListProperty : 'AirlineID',
                    LocalDataProperty : to_Carrier_AirlineID,
                },
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : ConnectionID,
                    ValueListProperty : 'ConnectionID',
                },
                {
                    $Type : 'Common.ValueListParameterInOut',
                    ValueListProperty : 'FlightDate',
                    LocalDataProperty : FlightDate,
                },
                {
                    $Type : 'Common.ValueListParameterInOut',
                    ValueListProperty : 'Price',
                    LocalDataProperty : FlightPrice,
                },
                {
                    $Type : 'Common.ValueListParameterInOut',
                    ValueListProperty : 'CurrencyCode_code',
                    LocalDataProperty : CurrencyCode_code,
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'to_Airline/Name',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'PlaneType',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'MaximumSeats',
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'OccupiedSeats',
                },
            ],
            PresentationVariantQualifier : 'SortOrderPV',
        },
        Common.ValueListWithFixedValues : true,
)};

