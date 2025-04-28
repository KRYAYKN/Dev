#if not CLEAN25
tableextension 50129 "Sales Price" extends "Price List Line"
{
    fields
    {
        field(50001; "Agent1 Commission 1(Percentage"; Decimal)
        {
            Caption = 'Agent1 Commission 1(Percentage';
            DataClassification = CustomerContent;

        }
        field(50002; "Agent1 Commission 2(Percentage"; Decimal)
        {
            Caption = 'Agent1 Commission 2(Percentage';
            DataClassification = CustomerContent;

        }
        field(50003; "Agent1 Amount Euro per ton"; Decimal)
        {
            Caption = 'Agent1 Amount Euro per ton';
            DataClassification = CustomerContent;
        }
        field(50004; "Agent2 Commission 1(Percentage"; Decimal)
        {
            Caption = 'Agent2 Commission 1(Percentage';
            DataClassification = CustomerContent;

        }
        field(50005; "Agent2 Commission 2(Percentage"; Decimal)
        {
            Caption = 'Agent2 Commission 2(Percentage';
            DataClassification = CustomerContent;

        }
        field(50006; "Agent2 Amount Euro per ton"; Decimal)
        {
            Caption = 'Agent2 Amount Euro per ton';
            DataClassification = CustomerContent;

        }
        //    AKDEV_UPG
        field(50010; "Item Description"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Asset No.")));
            Caption = 'Item Description';
            Editable = false;
            FieldClass = FlowField;


        }
    }

}
#endif