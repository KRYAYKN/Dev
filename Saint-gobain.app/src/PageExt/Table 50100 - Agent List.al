table 50100 "Agent List"
{
    Caption = 'Agent List';
    DataCaptionFields = "Agent Number", "Agent Name";
    DataClassification = CustomerContent;
    //DrillDownPageID = 50003;
    //LookupPageID = 50003;

    fields
    {
        field(1; "Agent Number"; Code[5])
        {
            Caption = 'Agent Number';
            Description = 'Vertreter Nummer';
            NotBlank = true;
        }
        field(2; "Agent Name"; Text[35])
        {
            Caption = 'Agent Name';
            Description = 'Vertreter Name';
        }
        field(3; "Agent Name 2"; Text[35])/*  */
        {
            Caption = 'Agent Name 2';
            Description = 'Vertreter Name 2';
        }
        field(4; "Post Box"; Text[30])
        {
            Caption = 'Post Box';
            Description = 'Postfach';
        }
        field(5; Street; Text[35])
        {
            Caption = 'Street';
            Description = 'Strasse';
        }
        field(6; Postcode; Text[30])
        {
            Caption = 'Postcode';
            Description = 'Postleitzahl';
        }
        field(7; City; Text[30])
        {
            Caption = 'City';
            Description = 'Ort';
        }
        field(8; Country; Text[30])
        {
            Caption = 'Country';
            Description = 'Land';
        }
        field(9; "Agent Name 3"; Text[35])
        {
            Caption = 'Agent Name 3';
            Description = 'Vertreter Name 3';
        }
        field(10; Language; Code[10])
        {
            Caption = 'Language';
            Description = 'Sprache für Provisionsabrechnung';
            TableRelation = Language.Code;
        }
        field(11; "Last Com. Calculation"; DateTime)
        {
            Caption = 'Last Com. Calculation';
            Description = 'Letzte Provisionsabrechnung';
            Editable = false;
        }
        field(12; "Com. Calc. created by"; Code[20])
        {
            Caption = 'Com. Calc. created by';
            Description = 'Prov. Abr. erstellt von';
            Editable = false;
            TableRelation = "Salesperson/Purchaser".Code;
        }
    }

    keys
    {
        key(PK; "Agent Number") { }
    }
}
