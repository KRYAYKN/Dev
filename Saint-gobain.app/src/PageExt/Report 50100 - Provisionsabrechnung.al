report 50100 Provisionsabrechnung
{
    ApplicationArea = All;
    // Key Sales Price:  Item No.,Sales Type,Sales Code,Starting Date,Currency Code,Variant Code,Unit of Measure Code,Minimum Quantity
    //
    // *** COSMO CONSULT ***
    //
    // Code   Unique Key     Date      USER        Description
    // ----------------------------------------------------------------------------------
    // CC01   127800.07      08.08.17  DEBER.MLAR  Create Object
    DefaultLayout = RDLC;
    PreviewMode = PrintLayout;
    RDLCLayout = 'src\Reports\Layouts\Report 50028 - Provisionsabrechnung.rdlc';

    dataset
    {
        dataitem("Agent List"; "Agent List")
        {
            DataItemTableView = sorting("Agent Number")
                                order(ascending)
                                where("Agent Number" = filter(< 99));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Agent Number", "Agent Name";
            column(CompanyInfo_Picture; CompanyInfo.Picture) { }
            column(CurrDate_; Format(Today, 0, 9)) { }
            column(CommissionCalc_Caption; CommissionCalcLbl) { }
            column(Text50001_; Text50001) { }
            column(Text50053_; Text50053) { }
            column(Text50052_; Text50052) { }
            column(Text50055_; Text50055) { }
            column(SGId2Name_; SGId2Name()) { }
            column(AgentNumber_Caption; AgentNumberLbl) { }
            column(AgentName_Caption; AgentNameLbl) { }
            column(AgentList_AgentNumber; "Agent List"."Agent Number") { }
            column(AgentList_AgentName; "Agent List"."Agent Name") { }
            column(Periode_; Periode) { }
            column(Sum_Caption; SumLbl) { }
            column(CustomerSum_Caption; CustomerSumLbl) { }
            column(AgentSum_Caption; AgentSumLbl) { }
            dataitem(CustomerLoop1; Customer)
            {
                DataItemLink = "Agent Number" = field("Agent Number");
                //DataItemLink = Agent fieldfieldNumber=FIELD(Agent Number);
                DataItemTableView = sorting("No.");

                trigger OnAfterGetRecord()
                begin
                    if not TempCustomer.GET(CustomerLoop1."No.") then begin
                        TempCustomer := CustomerLoop1;
                        TempCustomer.INSERT();
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    TempCustomer.DELETEALL();
                end;
            }
            dataitem(CustomerLoop2; Customer)
            {
                //DataItemLink = Agent fieldfieldNumber2=FIELD(Agent Number);
                DataItemLink = "Agent Number" = field("Agent Number");
                DataItemTableView = sorting("No.");

                trigger OnAfterGetRecord()
                begin
                    if not TempCustomer.GET(CustomerLoop2."No.") then begin
                        TempCustomer := CustomerLoop2;
                        TempCustomer.INSERT();
                    end;
                end;
            }
            dataitem(IntCustomer; Integer)
            {
                DataItemTableView = sorting(Number);
                PrintOnlyIfDetail = true;
                column(Text50012_; Text50012) { }
                column(SearchName_Caption; SearchNameLbl) { }
                column(Customer_No; TempCustomer."No.") { }
                column(Customer_SearchName; TempCustomer."Search Name") { }
                column(CustomerNo_Caption; CustomerNoLbl) { }
                column(CustomerName_Caption; CustomerNameLbl) { }
                column(DocNo_Caption; Text50016) { }
                column(OrdeNo_Caption; Text50017) { }
                column(No_Caption; NoLbl) { }
                column(Description_Caption; DescriptionLbl) { }
                column(Qty_Caption; QtyLbl) { }
                column(UoM_Caption; UoMLbl) { }
                column(VKto_Caption; Text50022) { }
                column(ExWorks_Caption; Text50023) { }
                column(ComP_Caption; ComPLbl) { }
                column(Com_Caption; ComLbl) { }
                column(To_Caption; ToLbl) { }
                column(ComAmount_Caption; ComAmountLbl) { }
                dataitem("Sales Invoice Header"; "Sales Invoice Header")
                {
                    DataItemTableView = sorting("No.");
                    PrintOnlyIfDetail = true;
                    dataitem("Sales Invoice Line"; "Sales Invoice Line")
                    {
                        //DataItemLink = Document fieldfieldNo.=FIELD("No.");
                        DataItemLink = "Document No." = field("No.");
                        DataItemTableView = sorting("Document No.", "Line No.");
                        column(doPrint_; doPrint) { }
                        column(CurrColor_; CurrColor) { }
                        column(SalesInvLine_SelltoCustomerNo; "Sales Invoice Line"."Sell-to Customer No.") { }
                        column(CustomerName_; CustomerName) { }
                        column(SalesInvLine_DocumentNo; "Sales Invoice Line"."Document No.") { }
                        column(SalesInvLine_OrderNo; "Sales Invoice Line"."Order No.") { }
                        column(SalesInvLine_No; "Sales Invoice Line"."No.") { }
                        column(SalesInvLine_Description; "Sales Invoice Line".Description) { }
                        column(SalesInvLine_Quantity; "Sales Invoice Line".Quantity) { }
                        column(SalesInvLine_UoM; "Sales Invoice Line"."Unit of Measure") { }
                        column(VKEXW_; VKEXW) { }
                        column(AmountEXW_; AmountEXW) { }
                        column(AgentCommisionPercent_; "Agent Commision Percent") { }
                        column(AgentComPercentSum_; "Agent Com Percent Sum") { }
                        column(AgentCommisionValue_; "Agent Commision Value") { }
                        column(AgentComValueSum_; "Agent Com Value Sum") { }
                        column(AgentComSum_; "Agent Com Sum") { }

                        trigger OnAfterGetRecord()
                        begin
                            DueDate := 0D;
                            DocumentDate := 0D;
                            ClosedAtDate := 0D;
                            bolOpen := true;
                            if "Sales Invoice Line".Type = Type::Item then begin
                                if ItemRecord.GET("No.") then
                                    if ItemRecord.Pallet then
                                        doPrint := false
                                    else
                                        if (Amount <> 0) or (Quantity <> 0) then begin
                                            DebPreisGruppe.SetRange("Asset Type", DebPreisGruppe."Asset Type"::Item);
                                            DebPreisGruppe.SETFILTER("Asset No.", '=%1', "No.");
                                            DebPreisGruppe.SETFILTER("Assign-to No.", '=%1', "Bill-to Customer No.");
                                            DebPreisGruppe.SETFILTER("Starting Date", '<=%1', "Sales Invoice Header"."Document Date");
                                            DebPreisGruppe.SETFILTER("Ending Date", '>=%1', "Sales Invoice Header"."Document Date");
                                            if DebPreisGruppe.FIND('-') then
                                                // >> CC01
                                                //IF (DebPreisGruppe."Agent1 Commission 1(Percentage" > 0) OR (DebPreisGruppe."Agent1 Amount Euro per ton" > 0) THEN BEGIN
                                                if (((DebPreisGruppe."Agent1 Commission 1(Percentage" > 0) or (DebPreisGruppe."Agent1 Amount Euro per ton" > 0)) and (TempCustomer."Agent Number" = "Agent List"."Agent Number")) or
                                                   (((DebPreisGruppe."Agent2 Commission 1(Percentage" > 0) or (DebPreisGruppe."Agent2 Amount Euro per ton" > 0)) and (TempCustomer."Agent Number2" = "Agent List"."Agent Number")) then begin
                                                    // << CC01
                                                    if CustomerRecord.GET("Sell-to Customer No.") then
                                                        CustomerName := CustomerRecord.Name;
                                                    //--------------------Prozentsatz und To-Satz ermitteln-----------------------------------------------
                                                    // >> CC01
                                                    if TempCustomer."Agent Number" = "Agent List"."Agent Number" then begin
                                                        // << CC01
                                                        "Agent Commision Percent" := DebPreisGruppe."Agent1 Commission 1(Percentage";
                                                        "Agent Commision Value" := DebPreisGruppe."Agent1 Amount Euro per ton";
                                                        // >> CC01
                                                    end else begin
                                                        "Agent Commision Percent" := DebPreisGruppe."Agent2 Commission 1(Percentage";
                                                        "Agent Commision Value" := DebPreisGruppe."Agent2 Amount Euro per ton";
                                                    end;
                                                    // << CC01
                                                    //--------------------Frachtsatz pro Tonne ermitteln und AbWerkpreis ermitteln-------------------------
                                                    SalesInvHeaderRecord.GET("Document No.");
                                                    //----------------------------Währungsumrechnung--------------------------------------------------------------------
                                                    if SalesInvHeaderRecord."Currency Factor" = 0 then
                                                        CurrFactor := 1
                                                    else
                                                        CurrFactor := SalesInvHeaderRecord."Currency Factor";
                                                    if "Unit of Measure" = 'to' then
                                                        VKEXW := ROUND(("Unit Price" - SalesInvHeaderRecord."Freight per ton") / CurrFactor, 0.01, '=')
                                                    else
                                                        VKEXW := ROUND(("Unit Price") / CurrFactor, 0.01, '=');
                                                    //--------------------Pro Zeile Provision ermitteln----------------------------------------------------
                                                    AmountEXW := ROUND(Quantity * VKEXW, 0.01, '=');
                                                    "Agent Com Percent Sum" := Round(AmountEXW / 100 * "Agent Commision Percent", 0.01, '=');
                                                    "Agent Com Value Sum" := ROUND(Quantity * "Agent Commision Value", 0.01, '=');
                                                    "Agent Com Sum" := "Agent Com Percent Sum" + "Agent Com Value Sum";
                                                    //--------------------Provision pro Debitor------------------------------------------------------------
                                                    "Deb Qty Sum" := "Deb Qty Sum" + Quantity;
                                                    "Deb Amount Sum" := "Deb Amount Sum" + AmountEXW;
                                                    "Deb Agent Percent Sum" := "Deb Agent Percent Sum" + "Agent Com Percent Sum";
                                                    "Deb Agent Value Sum" := "Deb Agent Value Sum" + "Agent Com Value Sum";
                                                    "Deb Agent Sum" := "Deb Agent Sum" + "Agent Com Sum";
                                                    //---------------------Provision pro Agent-------------------------------------------------------------
                                                    "Agent Qty Sum" := "Agent Qty Sum" + Quantity;
                                                    "Agent Amount Sum" := "Agent Amount Sum" + AmountEXW;
                                                    "Agent Percent Sum" := "Agent Percent Sum" + "Agent Com Percent Sum";
                                                    "Agent Value Sum" := "Agent Value Sum" + "Agent Com Value Sum";
                                                    "Agent Sum" := "Agent Sum" + "Agent Com Sum";
                                                    CustLedgerEntry.SETFILTER(CustLedgerEntry."Document No.", '=%1', "Document No.");
                                                    CustLedgerEntry.SETFILTER(CustLedgerEntry."Document Type", '=%1', CustLedgerEntry."Document Type"::Invoice);
                                                    CustLedgerEntry.SETFILTER(CustLedgerEntry."Customer No.", '=%1', "Bill-to Customer No.");
                                                    if CustLedgerEntry.FIND('-') then begin
                                                        DueDate := CustLedgerEntry."Due Date";
                                                        DocumentDate := CustLedgerEntry."Document Date";
                                                        ClosedAtDate := CustLedgerEntry."Closed at Date";
                                                        bolOpen := CustLedgerEntry.Open;
                                                    end;
                                                    i += 1;
                                                    doPrint := true;
                                                end else
                                                    doPrint := false;
                                        end else
                                            doPrint := false;
                            end else
                                doPrint := false;

                            // >> CC01
                            if not doPrint then
                                CurrReport.Skip();

                            if LineNo = 1 then
                                CLEAR(CompanyInfo);
                            LineNo += 1;

                            if (i mod 2 = 0) then
                                CurrColor := true
                            else
                                CurrColor := false;
                            // << CC01

                            // >> CC01
                            if ExcelExport and doPrint then begin
                                RowNo += 1;
                                EnterCell(RowNo, 1, STRSUBSTNO('%1', "Agent List"."Agent Number"), false, false, '@');
                                EnterCell(RowNo, 2, STRSUBSTNO('%1', "Agent List"."Agent Name"), false, false, '@');
                                EnterCell(RowNo, 3, STRSUBSTNO('%1', TempCustomer."No."), false, false, '@');
                                EnterCell(RowNo, 4, STRSUBSTNO('%1', TempCustomer.Name), false, false, '@');
                                EnterCell(RowNo, 5, STRSUBSTNO('%1', "Sell-to Customer No."), false, false, '@');
                                EnterCell(RowNo, 6, StrSubstNo('%1', CustomerName), false, false, '@');
                                EnterCell(RowNo, 7, STRSUBSTNO('%1', "Document No."), false, false, '@');
                                EnterCell(RowNo, 8, STRSUBSTNO('%1', "Order No."), false, false, '@');
                                EnterCell(RowNo, 9, STRSUBSTNO('%1', "No."), false, false, '@');
                                EnterCell(RowNo, 10, STRSUBSTNO('%1', Description), false, false, '@');
                                EnterCell(RowNo, 11, STRSUBSTNO('%1', Quantity), false, false, '@');
                                EnterCell(RowNo, 12, STRSUBSTNO('%1', "Unit of Measure"), false, false, '@');
                                EnterCell(RowNo, 13, StrSubstNo('%1', VKEXW), false, false, '@');
                                EnterCell(RowNo, 14, StrSubstNo('%1', AmountEXW), false, false, '@');
                                EnterCell(RowNo, 15, StrSubstNo('%1', "Agent Commision Percent"), false, false, '@');
                                EnterCell(RowNo, 16, StrSubstNo('%1', "Agent Com Percent Sum"), false, false, '@');
                                EnterCell(RowNo, 17, StrSubstNo('%1', "Agent Commision Value"), false, false, '@');
                                EnterCell(RowNo, 18, StrSubstNo('%1', "Agent Com Value Sum"), false, false, '@');
                                EnterCell(RowNo, 19, StrSubstNo('%1', "Agent Com Sum"), false, false, '@');
                                if ((DueDate > Today) or (ClosedAtDate <> 0D)) then
                                    EnterCell(RowNo, 20, Format(DueDate, 0, DateFormat), false, false, '@')
                                else
                                    EnterCell(RowNo, 20, Format(DueDate, 0, DateFormat), true, false, '@');
                                EnterCell(RowNo, 21, Format(DocumentDate, 0, DateFormat), false, false, '@');
                                EnterCell(RowNo, 22, Format(ClosedAtDate, 0, DateFormat), false, false, '@');
                                //EnterCell(RowNo,22,FORMAT(ClosedAtDate,0,DateFormat),FALSE, FALSE, 'DD/MM/YY;@');
                                EnterCell(RowNo, 23, StrSubstNo('%1', bolOpen), false, false, '@');
                            end;

                        end;
                    }

                    trigger OnPreDataItem()
                    begin
                        SETRANGE("Bill-to Customer No.", TempCustomer."No.");
                        SETRANGE("Posting Date", StartDatum, EndDatum);

                        "Deb Qty Sum" := 0;
                        "Deb Amount Sum" := 0;
                        "Deb Agent Percent Sum" := 0;
                        "Deb Agent Value Sum" := 0;
                        "Deb Agent Sum" := 0;
                        i := 0;
                    end;
                }
                dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
                {
                    DataItemTableView = sorting("No.");
                    PrintOnlyIfDetail = true;
                    dataitem(TotalInvoice; Integer)
                    {
                        DataItemTableView = sorting(Number)
                                            where(Number = const(1));
                        column(DebAgentPercentSum_; "Deb Agent Percent Sum") { }
                        column(DebAgentSum_; "Deb Agent Sum") { }
                        column(DebAgentValueSum_; "Deb Agent Value Sum") { }
                        column(DebAmountSum_; "Deb Amount Sum") { }
                        column(DebQtySum_; "Deb Qty Sum") { }
                        column(PrintTotalInv_; PrintTotalInv) { }

                        trigger OnAfterGetRecord()
                        begin
                            // >> CC01
                            if (not PrintTotalInv) or ("Deb Agent Sum" = 0) then
                                CurrReport.Skip();
                            // << CC01
                        end;

                        trigger OnPostDataItem()
                        begin
                            // >> CC01
                            PrintTotalInv := false;
                            // << CC01
                        end;
                    }
                    dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
                    {
                        //DataItemLink = Document fieldfieldNo.=FIELD(No.);
                        DataItemLink = "Document No." = field("No.");

                        DataItemTableView = sorting("Document No.", "Line No.");
                        column(doPrint_Cr; doPrint) { }
                        column(CurrColor_Cr; CurrColor) { }
                        column(SalesCrMemoLine_SelltoCustomerNo; "Sales Cr.Memo Line"."Sell-to Customer No.") { }
                        column(CustomerName_Cr; CustomerName) { }
                        column(SalesCrMemoLine_DocumentNo; "Sales Cr.Memo Line"."Document No.") { }
                        column(Rechnungsref_Cr; Rechnungsref) { }
                        column(SalesCrMemoLine_No; "Sales Cr.Memo Line"."No.") { }
                        column(SalesCrMemoLine_Description; "Sales Cr.Memo Line".Description) { }
                        column(SalesCrMemoLine_Quantity; -"Sales Cr.Memo Line".Quantity) { }
                        column(SalesCrMemoLine_UoM; "Sales Cr.Memo Line"."Unit of Measure") { }
                        column(VKEXW_Cr; -VKEXW) { }
                        column(AmountEXW_Cr; -AmountEXW) { }
                        column(AgentCommisionPercent_Cr; "Agent Commision Percent") { }
                        column(AgentComPercentSum_Cr; -"Agent Com Percent Sum") { }
                        column(AgentCommisionValue_Cr; -"Agent Commision Value") { }
                        column(AgentComValueSum_Cr; -"Agent Com Value Sum") { }
                        column(AgentComSum_Cr; -"Agent Com Sum") { }

                        trigger OnAfterGetRecord()
                        begin
                            DueDate := 0D;
                            DocumentDate := 0D;
                            ClosedAtDate := 0D;
                            if "Sales Cr.Memo Line".Type = Type::Item then begin
                                if ItemRecord.GET("No.") then
                                    if ItemRecord.Pallet then
                                        doPrint := false
                                    else
                                        if (Amount <> 0) or (Quantity <> 0) then begin
                                            //DebPreisGruppe.SETFILTER("Item No.", '=%1', "No.");
                                            DebPreisGruppe.SetRange("Asset Type", DebPreisGruppe."Asset Type"::Item);
                                            DebPreisGruppe.SetRange("Asset No.", "No.");
                                            DebPreisGruppe.SetRange("Assign-to No.", "Bill-to Customer No.");
                                            //DebPreisGruppe.SETFILTER("Sales Code", '=%1', "Bill-to Customer No.");
                                            DebPreisGruppe.SETFILTER("Starting Date", '<=%1', "Sales Cr.Memo Header"."Posting Date");
                                            DebPreisGruppe.SETFILTER("Ending Date", '>=%1', "Sales Cr.Memo Header"."Posting Date");
                                            if DebPreisGruppe.FIND('-') then
                                                // >> CC01
                                                //IF (DebPreisGruppe."Agent1 Commission 1(Percentage" > 0) OR (DebPreisGruppe."Agent1 Amount Euro per ton" > 0) THEN BEGIN
                                                if (((DebPreisGruppe."Agent1 Commission 1(Percentage" > 0) or (DebPreisGruppe."Agent1 Amount Euro per ton" > 0)) and (TempCustomer."Agent Number" = "Agent List"."Agent Number")) or
                                                   (((DebPreisGruppe."Agent2 Commission 1(Percentage" > 0) or (DebPreisGruppe."Agent2 Amount Euro per ton" > 0)) and (TempCustomer."Agent Number2" = "Agent List"."Agent Number")) then begin
                                                    // << CC01
                                                    if CustomerRecord.GET("Sell-to Customer No.") then
                                                        CustomerName := CustomerRecord.Name;
                                                    //----------------------------Prozentsatz und To-Satz ermitteln---------------------------------------------------------
                                                    // >> CC01
                                                    if TempCustomer."Agent Number" = "Agent List"."Agent Number" then begin
                                                        // << CC01
                                                        "Cr Agent Commision Percent" := DebPreisGruppe."Agent1 Commission 1(Percentage";
                                                        "Cr Agent Commision Value" := DebPreisGruppe."Agent1 Amount Euro per ton";
                                                        // >> CC01
                                                    end else begin
                                                        "Cr Agent Commision Percent" := DebPreisGruppe."Agent2 Commission 1(Percentage";
                                                        "Cr Agent Commision Value" := DebPreisGruppe."Agent2 Amount Euro per ton";
                                                    end;
                                                    // << CC01
                                                    //----------------------------Frachtsatz pro Tonne ermitteln und AbWerkPreis ermitteln -----------------------------------
                                                    SalescrMemoHeaderRecord.GET("Document No.");
                                                    //----------------------------Währungsumrechnung--------------------------------------------------------------------
                                                    if SalescrMemoHeaderRecord."Currency Factor" = 0 then
                                                        CurrFactor := 1
                                                    else
                                                        CurrFactor := SalescrMemoHeaderRecord."Currency Factor";
                                                    if "Unit of Measure" = 'to' then
                                                        VKEXW := ROUND(("Unit Price" - SalescrMemoHeaderRecord."Freight per ton") / CurrFactor, 0.01, '=')
                                                    else
                                                        VKEXW := ROUND(("Unit Price") / CurrFactor, 0.01, '=');
                                                    //----------------------------Pro Zeile Provision ------------------------------------------------------------------
                                                    AmountEXW := ROUND(Quantity * VKEXW, 0.01, '=');
                                                    "Agent Com Percent Sum" := Round(AmountEXW / 100 * "Cr Agent Commision Percent", 0.01, '=');
                                                    "Agent Com Value Sum" := ROUND(Quantity * "Cr Agent Commision Value", 0.01, '=');
                                                    "Agent Com Sum" := "Agent Com Percent Sum" + "Agent Com Value Sum";
                                                    //----------------------------Pro Debitor Provision------------------------------------------------------------
                                                    "Deb Qty Sum" := "Deb Qty Sum" - Quantity;
                                                    "Deb Amount Sum" := "Deb Amount Sum" - AmountEXW;
                                                    "Deb Agent Percent Sum" := "Deb Agent Percent Sum" - "Agent Com Percent Sum";
                                                    "Deb Agent Value Sum" := "Deb Agent Value Sum" - "Agent Com Value Sum";
                                                    "Deb Agent Sum" := "Deb Agent Sum" - "Agent Com Sum";
                                                    //----------------------------Pro Agent Provision----------------------------------------------------------------
                                                    "Agent Qty Sum" := "Agent Qty Sum" - Quantity;
                                                    "Agent Amount Sum" := "Agent Amount Sum" - AmountEXW;
                                                    "Agent Percent Sum" := "Agent Percent Sum" - "Agent Com Percent Sum";
                                                    "Agent Value Sum" := "Agent Value Sum" - "Agent Com Value Sum";
                                                    "Agent Sum" := "Agent Sum" - "Agent Com Sum";
                                                    doPrint := true;
                                                    i += 1;
                                                end else
                                                    doPrint := false;
                                        end else
                                            doPrint := false;
                            end else
                                doPrint := false;

                            // >> CC01
                            if not doPrint then
                                CurrReport.Skip();

                            if LineNo = 1 then
                                CLEAR(CompanyInfo);
                            LineNo += 1;

                            if (i mod 2 = 0) then
                                CurrColor := true
                            else
                                CurrColor := false;
                            // << CC01

                            // >> CC01
                            if ExcelExport and doPrint then begin
                                RowNo += 1;
                                EnterCell(RowNo, 1, STRSUBSTNO('%1', "Agent List"."Agent Number"), false, false, '@');
                                EnterCell(RowNo, 2, STRSUBSTNO('%1', "Agent List"."Agent Name"), false, false, '@');
                                EnterCell(RowNo, 3, STRSUBSTNO('%1', TempCustomer."No."), false, false, '@');
                                EnterCell(RowNo, 4, STRSUBSTNO('%1', TempCustomer.Name), false, false, '@');
                                EnterCell(RowNo, 5, STRSUBSTNO('%1', "Sell-to Customer No."), false, false, '@');
                                EnterCell(RowNo, 6, StrSubstNo('%1', CustomerName), false, false, '@');
                                EnterCell(RowNo, 7, STRSUBSTNO('%1', "Document No."), false, false, '@');
                                EnterCell(RowNo, 8, StrSubstNo('%1', Rechnungsref), false, false, '@');
                                EnterCell(RowNo, 9, STRSUBSTNO('%1', "No."), false, false, '@');
                                EnterCell(RowNo, 10, STRSUBSTNO('%1', Description), false, false, '@');
                                EnterCell(RowNo, 11, STRSUBSTNO('%1', -Quantity), false, false, '@');
                                EnterCell(RowNo, 12, STRSUBSTNO('%1', "Unit of Measure"), false, false, '@');
                                EnterCell(RowNo, 13, StrSubstNo('%1', -VKEXW), false, false, '@');
                                EnterCell(RowNo, 14, StrSubstNo('%1', -AmountEXW), false, false, '@');
                                EnterCell(RowNo, 15, StrSubstNo('%1', "Agent Commision Percent"), false, false, '@');
                                EnterCell(RowNo, 16, StrSubstNo('%1', -"Agent Com Percent Sum"), false, false, '@');
                                EnterCell(RowNo, 17, StrSubstNo('%1', "Agent Commision Value"), false, false, '@');
                                EnterCell(RowNo, 18, StrSubstNo('%1', -"Agent Com Value Sum"), false, false, '@');
                                EnterCell(RowNo, 19, StrSubstNo('%1', -"Agent Com Sum"), false, false, '@');
                            end;


                        end;

                        trigger OnPreDataItem()
                        begin
                            if TempCustomer.COUNT = 0 then
                                CurrReport.Break();
                            IntCustomer.SETRANGE(Number, 1, TempCustomer.COUNT);

                            "Agent Qty Sum" := 0;
                            "Agent Amount Sum" := 0;
                            "Agent Percent Sum" := 0;
                            "Agent Value Sum" := 0;
                            "Agent Sum" := 0;

                            // >> CC01
                            PrintTotalInv := true;
                            // << CC01
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        CurrReport.Language := Language;
                        Periode := StrSubstNo(Text50054, Format(StartDatum, 0, 9), Format(EndDatum, 0, 9));
                        if not CurrReport.Preview then
                            if recAgent.GET("Agent Number") then begin
                                recAgent."Last Com. Calculation" := CurrentDateTime;
                                recAgent."Com. Calc. created by" := UserId;
                                if recAgent.MODIFY() then;
                            end;
                    end;
                }
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Optionen)
                {
                    Caption = 'Options';
                    field(StartDatum; StartDatum)
                    {
                        ApplicationArea = All;
                        Caption = 'Begin Date';
                        ToolTip = 'Specifies the value of the Begin Date field.';
                    }
                    field(EndDatum; EndDatum)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                        ToolTip = 'Specifies the value of the End Date field.';
                    }
                    field(ExcelExport; ExcelExport)
                    {
                        ApplicationArea = All;
                        Caption = 'Export to Excel';
                        ToolTip = 'Specifies the value of the Export to Excel field.';
                    }
                }
            }
        }


        trigger OnOpenPage()
        begin
            StartDatum := CalcDate(Text50050, DMY2Date(1, Date2DMY(WorkDate(), 2), Date2DMY(WorkDate(), 3)));
            EndDatum := CalcDate(Text50051, DMY2Date(1, Date2DMY(WorkDate(), 2), Date2DMY(WorkDate(), 3)));
            ExcelExport := true;
        end;
    }

    labels { }

    trigger OnInitReport()
    begin
        // >> CC01
        CompanyInfo.GET();
        CompanyInfo.CALCFIELDS(Picture);
        LineNo := 0;
        // << CC01
    end;


    trigger OnPreReport()
    begin
        if (StartDatum = 0D) or (EndDatum = 0D) or (StartDatum > EndDatum) then
            Error(Text000);

        // >> CC01
        if ExcelExport then begin
            RowNo := 1;
            EnterCell(RowNo, 1, Text50010, true, false, '');
            EnterCell(RowNo, 2, Text50011, true, false, '');
            EnterCell(RowNo, 3, Text50012, true, false, '');
            EnterCell(RowNo, 4, Text50013, true, false, '');
            EnterCell(RowNo, 5, Text50014, true, false, '');
            EnterCell(RowNo, 6, Text50015, true, false, '');
            EnterCell(RowNo, 7, Text50016, true, false, '');
            EnterCell(RowNo, 8, Text50017, true, false, '');
            EnterCell(RowNo, 9, Text50018, true, false, '');
            EnterCell(RowNo, 10, Text50019, true, false, '');
            EnterCell(RowNo, 11, Text50020, true, false, '');
            EnterCell(RowNo, 12, Text50021, true, false, '');
            EnterCell(RowNo, 13, Text50022, true, false, '');
            EnterCell(RowNo, 14, Text50023, true, false, '');
            EnterCell(RowNo, 15, Text50024, true, false, '');
            EnterCell(RowNo, 16, Text50025, true, false, '');
            EnterCell(RowNo, 17, Text50026, true, false, '');
            EnterCell(RowNo, 18, Text50027, true, false, '');
            EnterCell(RowNo, 19, Text50028, true, false, '');
            EnterCell(RowNo, 20, Text50029, true, false, '');
            EnterCell(RowNo, 21, Text50030, true, false, '');
            EnterCell(RowNo, 22, Text50031, true, false, '');
            EnterCell(RowNo, 23, Text50032, true, false, '');
        end;


    end;

    var
        recAgent: Record "Agent List";
        CompanyInfo: Record "Company Information";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CustomerRecord: Record Customer;
        TempCustomer: Record Customer temporary;
        ExcelBuf: Record "Excel Buffer" temporary;
        ItemRecord: Record Item;
        recLanguage: Record Language;
        DebPreisGruppe: Record "Price List Line";
        SalescrMemoHeaderRecord: Record "Sales Cr.Memo Header";
        SalesInvHeaderRecord: Record "Sales Invoice Header";
        bolOpen: Boolean;
        CurrColor: Boolean;
        doPrint: Boolean;
        ExcelExport: Boolean;
        PrintTotalInv: Boolean;
        ClosedAtDate: Date;
        DocumentDate: Date;
        DueDate: Date;
        EndDatum: Date;
        StartDatum: Date;
        "Agent Amount Sum": Decimal;
        "Agent Commision Percent": Decimal;
        "Agent Commision Value": Decimal;
        "Agent Com Percent Sum": Decimal;
        "Agent Com Sum": Decimal;
        "Agent Com Value Sum": Decimal;
        "Agent Percent Sum": Decimal;
        "Agent Qty Sum": Decimal;
        "Agent Sum": Decimal;
        "Agent Value Sum": Decimal;
        AmountEXW: Decimal;
        "Cr Agent Commision Percent": Decimal;
        "Cr Agent Commision Value": Decimal;
        CurrFactor: Decimal;
        "Deb Agent Percent Sum": Decimal;
        "Deb Agent Sum": Decimal;
        "Deb Agent Value Sum": Decimal;
        "Deb Amount Sum": Decimal;
        "Deb Qty Sum": Decimal;
        VKEXW: Decimal;
        i: Integer;
        LineNo: Integer;
        RowNo: Integer;
        AgentNameLbl: Label 'Agent Name:';
        AgentNumberLbl: Label 'Agent Number:';
        AgentSumLbl: Label 'Agent Sum';
        ComAmountLbl: Label 'Com. Amount';
        ComLbl: Label 'Com.';
        CommissionCalcLbl: Label 'Commission Calculation';
        ComPLbl: Label 'Com. %';
        CustomerNameLbl: Label 'Name';
        CustomerNoLbl: Label 'Sell-to Customer No.';
        CustomerSumLbl: Label 'Customer Sum';
        DateFormat: Label '<Day,2>/<Month,2>/<Year,2>';
        DescriptionLbl: Label 'Description';
        NoLbl: Label 'No.';
        QtyLbl: Label 'Quantity';
        SearchNameLbl: Label 'Search Name';
        SumLbl: Label 'Sum';
        Text000: Label 'Please enter Start Date and End Date!';
        Text50001: Label 'Saint-Gobain Formula GmbH';
        Text50010: Label 'Agent No.';
        Text50011: Label 'Agent Name';
        Text50012: Label 'Customer No.';
        Text50013: Label 'Customer Name';
        Text50014: Label 'Sale to Customer No.';
        Text50015: Label 'Sale to Customer Name';
        Text50016: Label 'Document No.';
        Text50017: Label 'Order No.';
        Text50018: Label 'Item No.';
        Text50019: Label 'Item Description';
        Text50020: Label 'Amount';
        Text50021: Label 'Unit of Measure';
        Text50022: Label 'Price per Ton';
        Text50023: Label 'ExWorks';
        Text50024: Label 'Commision in %';
        Text50025: Label 'Commission (%)';
        Text50026: Label 'Euro per to';
        Text50027: Label 'Commission (to)';
        Text50028: Label 'Commission Value';
        Text50029: Label 'Due Date';
        Text50030: Label 'Document Date';
        Text50031: Label 'Cloased at date';
        Text50032: Label 'Open';
        Text50040: Label 'Commission';
        Text50050: Label 'CM-2M+1D';
        Text50051: Label 'CM-1M';
        Text50052: Label 'Page: ';
        Text50053: Label 'Date: ';
        Text50054: Label 'Periode: %1..%2';
        Text50055: Label 'Created by: ';
        ToLbl: Label '€ / to';
        UoMLbl: Label 'UoM';
        Rechnungsref: Text[30];
        Periode: Text[50];
        CustomerName: Text[100];

    procedure EnterCell(RowNo: Integer; ColumnNo: Integer; CellValue: Text[250]; Bold: Boolean; UnderLine: Boolean; NumberFormat: Text[30])
    begin
        // >> CC01
        ExcelBuf.INIT();
        ExcelBuf.VALIDATE("Row No.", RowNo);
        ExcelBuf.VALIDATE("Column No.", ColumnNo);
        ExcelBuf."Cell Value as Text" := CellValue;
        ExcelBuf.Formula := '';
        ExcelBuf.Bold := Bold;
        ExcelBuf.Underline := UnderLine;
        if NumberFormat <> '' then
            ExcelBuf.NumberFormat := NumberFormat;
        ExcelBuf.INSERT();
        // << CC01
    end;



    procedure SGId2Name() UName: Text[100]
    var
        recPerson: Record "Salesperson/Purchaser";
    begin
        recPerson.RESET();
        recPerson.SETRANGE(Code, UserId);
        if recPerson.FindFirst() then
            UName := recPerson.Name
        else
            UName := CopyStr(UserId, 1, MaxStrLen(UName));

    end;
}
