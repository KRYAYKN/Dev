permissionset 50100 "SG Formula Cust."
{
    Access = Internal;
    Assignable = true;
    Caption = 'SG Formula Customization', Locked = true;
    Permissions = tabledata "Agent List" = RIMD,
        table "Agent List" = X,
        report Provisionsabrechnung = X;
}