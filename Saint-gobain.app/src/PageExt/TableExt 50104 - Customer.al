tableextension 50104 Customer extends Customer
{

    fields
    {
        modify("Primary Contact No.")
        {
            trigger OnAfterValidate()
            var
                Cont: Record Contact;
            begin
                if CurrFieldNo = Rec.FieldNo("Primary Contact No.") then
                    if Rec."Primary Contact No." <> '' then
                        if Cont.Get(Rec."Primary Contact No.") then
                            if Cont.Type = Cont.Type::Person then
                                Rec."Primary Contact Department" := Cont."Job Title";
            end;
        }
        // Standart tabloda olmayan özel alanlar
        field(50100; "Primary Contact Department"; Text[30])
        {
            Caption = 'Primary Contact Department';
            DataClassification = CustomerContent;
            Description = 'STD1.10';
        }
        field(50101; "Area"; Code[10])
        {
            Caption = 'Area';
            DataClassification = CustomerContent;
            Description = 'BPB MG/AB';
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('AREA'));//AKDEV_UPG HARDCODED WHY?
        }
        field(50102; Application; Code[10])
        {
            Caption = 'Application';
            DataClassification = CustomerContent;
            Description = 'BPB MG/AB';
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('APPLICATION'));//AKDEV_UPG HARDCODED WHY?
        }
        field(50103; "Agent Number"; Code[5])
        {
            Caption = 'Agent Number';
            DataClassification = CustomerContent;
            Description = 'BPB AB';
            TableRelation = "Agent List"."Agent Number";
        }
        field(50104; "Agent Number2"; Code[5])
        {
            Caption = 'Agent Number 2';
            DataClassification = CustomerContent;
            Description = 'BPB AB';
            TableRelation = "Agent List"."Agent Number";
        }
        field(50105; RSM; Code[30])
        {
            Caption = 'RSM';
            DataClassification = CustomerContent;
            Description = 'SGF201109003';
            //AKDEV_UPGTableRelation = "User Setup"."User ID" WHERE("RSM" = CONST(true));
        }
        field(50106; Preference; Boolean)
        {
            Caption = 'Preference';
            DataClassification = CustomerContent;
            Description = 'BPB MG/AB';
        }
        field(50107; "Don't print pallet"; Boolean)
        {
            Caption = 'Don''t print pallet';
            DataClassification = CustomerContent;
            Description = 'BPB PL';
        }
        field(50108; "Additional Agreement"; Boolean)
        {
            Caption = 'Additional Agreement';
            DataClassification = CustomerContent;
            Description = 'BPB MG';
        }
        field(50109; "SIF Code"; Text[30])
        {
            Caption = 'SIF Code';
            DataClassification = CustomerContent;
            Description = 'BPB AB';
        }
        field(50110; "Credit risk"; Option)
        {
            Caption = 'credit risk';
            DataClassification = CustomerContent;
            Description = 'BPB AB';
            OptionCaption = 'Niedrig,Mittel,Hoch';
            OptionMembers = Niedrig,Mittel,Hoch;
        }
        field(50111; "Date Created"; Date)
        {
            Caption = 'Date Created';
            DataClassification = CustomerContent;
            Description = 'BPB MG/AB';
        }
        field(50112; "Credit Rating Agency"; Decimal)
        {
            Caption = 'Credit Rating Agency';
            DataClassification = CustomerContent;
            Description = 'SGF201109004';

            trigger OnValidate()
            begin
                "Difference CL to CR" := "Requested Credit Limit (LCY)" - "Credit Rating Agency";
            end;
        }
        field(50113; "Payment Terms"; Text[100])
        {
            CalcFormula = lookup("Payment Terms".Description where(Code = field("Payment Terms Code")));
            Caption = 'Payment Terms';
            Description = 'SGF MG 2010-08-18';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50114; "Previous Payment Term Code"; Code[10])
        {
            Caption = 'Previous Payment Term Code';
            DataClassification = CustomerContent;
            Description = 'SGF201109004';
            Editable = false;
        }
        field(50115; "Previous Payment Term"; Text[100])
        {
            CalcFormula = lookup("Payment Terms".Description where(Code = field("Previous Payment Term Code")));
            Caption = 'Previous Payment Term';
            Description = 'SGF201109004';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50116; "Previous Credit Limit (LCY)"; Integer)
        {
            Caption = 'Previous Credit Limit (LCY)';
            DataClassification = CustomerContent;
            Description = 'SGF201109004';
            Editable = false;
        }
        field(50117; "Approved by FD"; Boolean)
        {
            Caption = 'Approved by FD';
            DataClassification = CustomerContent;
            Description = 'TB001 NG 13.10.10: various modifications for process management';
        }
        field(50118; "Approved by CD"; Boolean)
        {
            Caption = 'Approved by CD';
            DataClassification = CustomerContent;
            Description = 'TB001 NG 13.10.10: various modifications for process management';
        }
        field(50119; "Approved by MD"; Boolean)
        {
            Caption = 'Approved by MD';
            DataClassification = CustomerContent;
            Description = 'TB001 NG 13.10.10: various modifications for process management';
        }
        field(50120; "Difference CL to CR"; Decimal)
        {
            Caption = 'Difference CL to CR';
            DataClassification = CustomerContent;
            Description = 'SGF201109004';
            Editable = false;
        }
        field(50121; "Compliance checked"; Boolean)
        {
            Caption = 'Compliance checked';
            DataClassification = CustomerContent;
            Description = 'SGF MG 2010-10-18';
        }
        field(50122; "Print Regular Statements"; Boolean)
        {
            Caption = 'Print Regular Statements';
            DataClassification = CustomerContent;
            Description = 'SGF MG 2011-03-10';
        }
        field(50123; "Paym. in Advance not accepted"; Boolean)
        {
            Caption = 'Paym. in Advance not accepted';
            DataClassification = CustomerContent;
            Description = 'SGF201109004';
        }
        field(50124; "Requested Credit Limit (LCY)"; Decimal)
        {
            Caption = 'Requested Credit Limit (LCY)';
            DataClassification = CustomerContent;
            Description = 'SGF201109004';

            trigger OnValidate()
            begin
                "Difference CL to CR" := "Requested Credit Limit (LCY)" - "Credit Rating Agency";
            end;
        }
        field(50125; "Requested Payment Term Code"; Code[10])
        {
            Caption = 'Requested Payment Term Code';
            DataClassification = CustomerContent;
            Description = 'SGF201109004';
            TableRelation = "Payment Terms".Code;
        }
        field(50126; "Requested Payment Term"; Text[100])
        {
            CalcFormula = lookup("Payment Terms".Description where(Code = field("Requested Payment Term Code")));
            Caption = 'Requested Payment Term';
            Description = 'SGF201109004';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50127; "Credit Rating Agency asked"; Boolean)
        {
            Caption = 'Credit Rating Agency asked';
            DataClassification = CustomerContent;
            Description = 'SGF201109004';
        }
        field(50128; "Credit Rating Agency Date"; Date)
        {
            Caption = 'Credit Rating Agency Date';
            DataClassification = CustomerContent;
            Description = 'SGF201109004';
        }
        field(50129; "Place of Delivery"; Text[50])
        {
            Caption = 'Place of Delivery';
            DataClassification = CustomerContent;
            Description = 'SGF201109001';
        }
        field(50130; "Combining of Orders"; Boolean)
        {
            Caption = 'Combining of Orders';
            DataClassification = CustomerContent;
            Description = 'SGF201111001';
        }
        field(50131; "Count Sales Invoice Lines"; Integer)
        {
            CalcFormula = count("Sales Invoice Line" where("Sell-to Customer No." = field("No.")));
            Caption = 'Count Sales Invoice Lines';
            Description = 'SGF202002002';
            FieldClass = FlowField;
        }
        field(50132; "Statement Receiver E-Mail"; Text[250])
        {
            Caption = 'Statement Receiver E-Mail';
            DataClassification = CustomerContent;
            Description = 'SGF202412001';
        }
        field(50133; "TCustomer Entry Date"; Date)
        {
            Caption = 'Kundenanlagedatum';
            DataClassification = CustomerContent;
            Description = 'BPB MG/AB';
        }
        field(50134; TApplication; Code[10])
        {
            Caption = 'TApplication';
            DataClassification = CustomerContent;
            Description = 'BPB MG/AB';
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('APPLICATION'));
        }
        field(50135; TArea; Code[10])
        {
            Caption = 'TArea';
            DataClassification = CustomerContent;
            Description = 'BPB MG/AB';
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('AREA'));
        }
        field(50136; Tpreference; Boolean)
        {
            Caption = 'Preference';
            DataClassification = CustomerContent;
            Description = 'BPB MG/AB';
        }
        field(50137; "Tdon't print pallet"; Boolean)
        {
            Caption = 'Paletten nicht drucken';
            DataClassification = CustomerContent;
            Description = 'BPB PL';
        }
        field(50138; "TAdditional Agreement"; Boolean)
        {
            Caption = 'Zusatzvereinbarung';
            DataClassification = CustomerContent;
            Description = 'BPB MG';
        }
        field(50139; "TSIF Code"; Text[30])
        {
            Caption = 'TSIF Code';
            DataClassification = CustomerContent;
            Description = 'BPB AB';
        }
        field(50140; "Tcredit risk"; Option)
        {
            Caption = 'credit risk';
            DataClassification = CustomerContent;
            Description = 'BPB AB';
            OptionCaption = 'Niedrig,Mittel,Hoch';
            OptionMembers = Niedrig,Mittel,Hoch;
        }
        field(50141; "No. Entries for Avis"; Integer)
        {
            Caption = 'No. Entries for Avis';
            DataClassification = CustomerContent;
            Description = 'DYNPMT';
        }
        field(50142; "SEPA Type"; Option)
        {
            Caption = 'SEPA Type';
            DataClassification = CustomerContent;
            Description = 'DYNPMT';
            OptionCaption = 'CORE,B2B';
            OptionMembers = CORE,B2B;
        }
        field(50143; "Mandate Delegation Code"; Code[10])
        {
            Caption = 'Mandate Delegation Code';
            DataClassification = CustomerContent;
            Description = 'DYNPMT';
            //AKDEV_UPGTableRelation = "Mandate Delegation";
        }
        field(50144; "Allow Paym. to third parties"; Boolean)
        {
            Caption = 'Allow Paym. to third parties';
            DataClassification = CustomerContent;
            Description = 'DYNPMT';
        }
        field(50145; "Pay-by Customer No."; Code[20])
        {
            Caption = 'Pay-by Customer No.';
            DataClassification = CustomerContent;
            Description = 'DYNPMT';
            TableRelation = Customer."No." where("Allow Paym. to third parties" = const(true));
        }
        //AKDEV_UPG++
        /* field(50146; "CBA - Transfer Messages"; Integer)
        {
            BlankZero = true;
            CalcFormula = Count("CBA - Error Log" WHERE(TableNo = CONST(Database::Customer),
                                                         PrimaryKeyCode = FIELD("No.")));
            Caption = 'Anzalhl CrefoDynamics Meldungen';
            Description = 'CCCBA';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50147; "CBA - First Transfer Error"; Text[250])
        {
            CalcFormula = Lookup("CBA - Error Log".ErrorText WHERE(TableNo = CONST(18),
                                                                    PrimaryKeyCode = FIELD("No.")));
            Caption = 'Erste CrefoDynamics Meldung';
            Description = 'CCCBA';
            Editable = false;
            FieldClass = FlowField;
        } */
        //AKDEV_UPG--
        field(50148; "CAS - Traffic Light"; Blob)
        {
            Caption = 'Identifiziert';
            DataClassification = CustomerContent;
            Description = 'CCCAS';
            Subtype = Bitmap;
        }
        field(50149; "CAS - Traffic Light 2"; Blob)
        {
            Caption = 'Adresse überwacht';
            DataClassification = CustomerContent;
            Description = 'CCCAS';
            Subtype = Bitmap;
        }
        field(50150; "CWA - Traffic Light"; Blob)
        {
            Caption = 'Ampel Bonität';
            DataClassification = CustomerContent;
            Description = 'CCCWA';
            Subtype = Bitmap;
        }
        field(50151; "CZE - Traffic Light"; Blob)
        {
            Caption = 'Ampel Zahlungsverhalten';
            DataClassification = CustomerContent;
            Description = 'CCCZE';
            Subtype = Bitmap;
        }
    }

    trigger OnAfterModify()
    begin
        // TB001 - Ödeme şartları değişikliğini kaydet
        if Rec."Payment Terms Code" <> xRec."Payment Terms Code" then
            Rec."Previous Payment Term Code" := xRec."Payment Terms Code";

        // TB001 - Kredi limiti değişikliğini kaydet
        if Rec."Credit Limit (LCY)" <> xRec."Credit Limit (LCY)" then
            Rec."Previous Credit Limit (LCY)" := Round(xRec."Credit Limit (LCY)", 1, '<');
    end;
}
