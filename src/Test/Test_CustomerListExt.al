codeunit 66111 "Customer List Ext Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    [Test]
    procedure TestOpenCustomerList()
    var
        CustomerList: TestPage "Customer List";
    begin
        // [SCENARIO] Customer List page can be opened

        // [WHEN] The Customer List page is opened
        CustomerList.OpenView();

        // [THEN] No errors occur (implicit test)
        CustomerList.Close();
    end;

    [Test]
    procedure TestCustomerExists()
    var
        Customer: Record Customer;
    begin
        // [SCENARIO] At least one customer exists

        // [WHEN] We check if customer table has records
        // [THEN] No error occurs if at least one customer exists
        Customer.FindFirst();
    end;
}