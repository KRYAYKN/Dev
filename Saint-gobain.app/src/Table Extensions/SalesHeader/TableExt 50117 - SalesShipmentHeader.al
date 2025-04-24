tableextension 50117 "SalesShipmentHeader" extends "Sales Shipment Header" //110
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