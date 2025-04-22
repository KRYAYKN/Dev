pageextension 50110 PriceListLines extends "Price List Lines"
{
    layout
    {
        addafter("Asset Type")
        {
            field("Item Description"; Rec."Item Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item Description field.', Comment = '%';
            }
        }
        addlast(content)
        {
            group("Agent1 Commission")
            {
                field("Agent1 Commission 1(Percentage"; Rec."Agent1 Commission 1(Percentage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Agent1 Commission 1(Percentage field.';
                }
                field("Agent1 Commission 2(Percentage"; Rec."Agent1 Commission 2(Percentage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Agent1 Commission 2(Percentage field.';
                }
                field("Agent1 Amount Euro per ton"; Rec."Agent1 Amount Euro per ton")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Agent1 Amount Euro per ton field.';
                }


            }
            group("Agent2 Commission")
            {
                field("Agent2 Commission 1(Percentage"; Rec."Agent2 Commission 1(Percentage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Agent2 Commission 1(Percentage field.';
                }
                field("Agent2 Commission 2(Percentage"; Rec."Agent2 Commission 2(Percentage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Agent2 Commission 2(Percentage field.';
                }
                field("Agent2 Amount Euro per ton"; Rec."Agent2 Amount Euro per ton")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Agent2 Amount Euro per ton field.';
                }
            }
        }
    }
}