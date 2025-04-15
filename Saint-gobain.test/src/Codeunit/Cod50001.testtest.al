codeunit 66602 "Customer List Ext Tests2"
{
    Subtype = Test;

    [Test]
    [HandlerFunctions('HelloWorldMessageHandler')]
    procedure TestHelloWorldMessage2()
    var
        CustList: TestPage "Customer List";
    begin
        CustList.OpenView();
        CustList.Close();
        if (not MessageDisplayed) then
            ERROR('Message was not displayed!');
    end;

    [MessageHandler]
    procedure HelloWorldMessageHandler(Message: Text[1024])
    begin
        MessageDisplayed := MessageDisplayed or (Message = 'App published: Hello Formula DevOps world 15.04.2025 app published both region after code analyse and unit tests passed  !!!!');
    end;

    var
        MessageDisplayed: Boolean;

}