pageextension 50167 ItemList extends "Item List"
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