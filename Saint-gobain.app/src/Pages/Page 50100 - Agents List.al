page 50100 "Agents List"
{
    ApplicationArea = All;
    Caption = 'Agent List';
    PageType = List;
    SourceTable = "Agent List";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Agent Number"; Rec."Agent Number")
                {
                    ToolTip = 'Specifies the value of the Agent Number field.', Comment = '%';
                }
                field("Agent Name"; Rec."Agent Name")
                {
                    ToolTip = 'Specifies the value of the Agent Name field.', Comment = '%';
                }
                field("Agent Name 2"; Rec."Agent Name 2")
                {
                    ToolTip = 'Specifies the value of the Agent Name 2 field.', Comment = '%';
                }
                field("Post Box"; Rec."Post Box")
                {
                    ToolTip = 'Specifies the value of the Post Box field.', Comment = '%';
                }
                field(Street; Rec.Street)
                {
                    ToolTip = 'Specifies the value of the Street field.', Comment = '%';
                }
                field(Postcode; Rec.Postcode)
                {
                    ToolTip = 'Specifies the value of the Postcode field.', Comment = '%';
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the value of the City field.', Comment = '%';
                }
                field(Country; Rec.Country)
                {
                    ToolTip = 'Specifies the value of the Country field.', Comment = '%';
                }
                field("Agent Name 3"; Rec."Agent Name 3")
                {
                    ToolTip = 'Specifies the value of the Agent Name 3 field.', Comment = '%';
                }
                field(Language; Rec.Language)
                {
                    ToolTip = 'Specifies the value of the Language field.', Comment = '%';
                }
                field("Last Com. Calculation"; Rec."Last Com. Calculation")
                {
                    ToolTip = 'Specifies the value of the Last Com. Calculation field.', Comment = '%';
                }
            }
        }
    }
}