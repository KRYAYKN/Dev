tableextension 50119 "SalesCrMemoHeader" extends "Sales Cr.Memo Header" //114
{
    fields
    {

        field(50000; "Freight per ton"; Decimal)
        {
            Caption = 'Freight per ton';
            DataClassification = ToBeClassified;
        }
        field(50001; "Agent Number"; Code[5])
        {
            Caption = 'Agent Number';
            DataClassification = ToBeClassified;
        }
    }
}