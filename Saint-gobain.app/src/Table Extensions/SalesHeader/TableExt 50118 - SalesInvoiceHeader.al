tableextension 50118 "SalesInvoiceHeader" extends "Sales Invoice Header" //112
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