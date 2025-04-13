codeunit 66603 "Sales Test"
{
    Subtype = Test;


    [Test]
    procedure Deneme()
    begin
        //[Scenario #0001] verification of Sales Order
        // [GIVEN] Given Some State 
        CreateCustomer();
        CreateItem();
        CreateLocation();
        CreateSalesOrder();
        // [WHEN] When Some Action
        PostSalesOrder();
        // [THEN] Then Expected Output 
        MatchSalesOrderWithPostedRecords();
    end;

    local procedure CreateCustomer()
    begin
        LibSales.CreateCustomer(Customer);
    end;

    local procedure CreateItem()
    begin
        LibInv.CreateItem(Item);
    end;

    local procedure CreateLocation()
    begin
        LibWhse.CreateLocation(Location);
    end;

    local procedure CreateSalesOrder()
    begin
        LibSales.CreateSalesDocumentWithItem(SalesHeader, SalesLine, SalesHeader."Document Type"::Order,
        Customer."No.", Item."No.", 5, Location.Code, WorkDate());
    end;

    local procedure PostSalesOrder()
    begin
        LibSales.PostSalesDocument(SalesHeader, true, true);
    end;

    local procedure MatchSalesOrderWithPostedRecords()
    begin
        SalesInvHeader.SetRange("External Document No.", SalesHeader."External Document No.");
        SalesInvHeader.FindFirst();
        LibAssert.AreEqual(SalesInvHeader."Sell-to Customer No.", SalesHeader."Sell-to Customer No.", 'Data not matched.');
    end;

    var
        Customer: Record Customer;
        Item: Record Item;
        Location: Record Location;
        SalesHeader: Record "Sales Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesLine: Record "Sales Line";
        LibSales: Codeunit "Library - Sales";
        LibInv: Codeunit "Library - Inventory";
        LibWhse: Codeunit "Library - Warehouse";
        LibAssert: Codeunit Assert;
}