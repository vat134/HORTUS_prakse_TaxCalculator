page 80014 "Equipment Card"
{
    PageType = Card;
    SourceTable = "Equipment";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Info)
            {
                Caption = 'Equipment Info';

                field("Equipment ID"; Rec."Equipment ID")
                {
                    ApplicationArea = All;
                }
                field("Name"; Rec."Name")
                {
                    ApplicationArea = All;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                }
                field("Daily Rental Fee"; Rec."Daily Rental Fee")
                {
                    ApplicationArea = All;
                }

            }
            group(Details)
            {
                Caption = 'Equipment Details';

                field("Availability Status"; Rec."Availability Status")
                {
                    ApplicationArea = All;
                }
                field("Unavailable until"; Rec."Unavailable until")
                {
                    ApplicationArea = All;
                }
            }

            group(AgreementHistory)
            {
                Caption = 'Agreement History';

                part(RentalAgreements; "Rental Agreements List Page")
                {
                    SubPageLink = "Equipment ID" = field("Equipment ID");
                    ApplicationArea = All;
                }
            }
        }
    }

}

page 80017 "Rental Agreements List Page"
{
    PageType = List;
    SourceTable = "Rental Agreement";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Agreement ID"; Rec."Agreement ID")
                {
                    ApplicationArea = All;
                }
                field("Customer ID"; Rec."Customer ID")
                {
                    ApplicationArea = All;
                }
                field("Equipment ID"; Rec."Equipment ID")
                {
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}