pageextension 50166 "Item Card" extends "Item Card"
{
    layout
    {
        addafter(Description)
        {
            field(Pallet; Rec.Pallet)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Pallet field.', Comment = '%';
            }
        }
    }

}