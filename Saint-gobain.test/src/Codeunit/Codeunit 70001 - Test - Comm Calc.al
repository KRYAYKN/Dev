codeunit 70001 "Test - Comm Calc"
{
    Description = 'Test - Comm Calc';
    Subtype = Test;
    TestPermissions = Disabled;


    var
        LibraryLowerPermissions: Codeunit "Library - Lower Permissions";
        LibraryRandom: Codeunit "Library - Random";
        Assert: Codeunit "Library Assert";


    [Test]
    procedure TestItemCardPalletField()
    var
        Item: Record Item;
        NewPalletValue: Boolean;
        ItemCard: TestPage "Item Card";
    begin
        // GIVEN
        // Test için gerekli verileri hazırlama


        // Yeni bir öğe oluştur
        CreateItem(Item);
        NewPalletValue := true;

        // WHEN
        // Item Card sayfasını aç ve öğeyi seç
        ItemCard.OpenEdit();
        ItemCard.FILTER.SetFilter("No.", Item."No.");

        // THEN
        // Pallet alanının görünürlüğünü kontrol et
        Assert.IsTrue(ItemCard.Pallet.Visible(), 'Pallet alanı görünür olmalıdır');

        // Değeri değiştirip kaydedebilme testi
        ItemCard.Pallet.SetValue(NewPalletValue);
        ItemCard.OK().Invoke();


        // Değişikliğin kaydedilip kaydedilmediğini kontrol et
        Item.Get(Item."No.");
        Assert.AreEqual(NewPalletValue, Item.Pallet, 'Pallet değeri veritabanında güncellenmelidir');
    end;

    [Test]
    procedure TestItemListPalletField()
    var
        Item: Record Item;
        NewPalletValue: Boolean;
        ItemList: TestPage "Item List";
    begin
        // GIVEN
        // Test için gerekli verileri hazırlama
        LibraryLowerPermissions.SetO365BusFull();

        // Yeni bir öğe oluştur
        CreateItem(Item);
        NewPalletValue := true;

        // WHEN
        // Item List sayfasını aç ve öğeyi seç
        ItemList.OpenEdit();
        ItemList.FILTER.SetFilter("No.", Item."No.");

        // THEN
        // Pallet alanının görünürlüğünü kontrol et
        Assert.IsTrue(ItemList.Pallet.Visible(), 'Pallet alanı görünür olmalıdır');

        // Alanın salt okunur olduğunu kontrol et (değiştirilememeli)
        Assert.IsFalse(ItemList.Pallet.Editable(), 'Pallet alanı Item List sayfasında düzenlenebilir olmamalıdır');


        // Değeri değiştirmeye çalış ve kaydet (bu değişiklik uygulanmamalı)
        ItemList.Pallet.SetValue(NewPalletValue);
        ItemList.OK().Invoke();

        // Değişikliğin veritabanında yapılmadığını doğrula
        Item.Get(Item."No.");
        Assert.AreEqual(NewPalletValue, Item.Pallet, 'Pallet değeri Item List sayfasından değiştirilememelidir');
    end;

    [Test]
    procedure TestSalesPricePage()
    var
        PriceListHeader: Record "Price List Header";
        PriceListLine: Record "Price List Line";
        PriceListCode: Code[20];
        PriceListLines: TestPage "Price List Lines";
    begin
        // GIVEN
        // Test için gerekli verileri hazırlama

        // Yeni bir fiyat listesi oluştur
        CreatePriceList(PriceListHeader);
        PriceListCode := PriceListHeader.Code;

        // Fiyat listesine bir satır ekle
        CreatePriceListLine(PriceListLine, PriceListCode);

        // WHEN
        // Price List Lines sayfasını aç ve satırı seç
        PriceListLines.OpenEdit();
        PriceListLines.FILTER.SetFilter("Price List Code", PriceListCode);

        // THEN
        // Agent1 komisyon alanlarının görünürlüğünü kontrol et
        Assert.IsTrue(PriceListLines."Agent1 Commission 1(Percentage".Visible(), 'Agent1 Commission 1 field should be visible');
        Assert.IsTrue(PriceListLines."Agent1 Commission 2(Percentage".Visible(), 'Agent1 Commission 2 field should be visible');
        Assert.IsTrue(PriceListLines."Agent1 Amount Euro per ton".Visible(), 'Agent1 Amount Euro field should be visible');

        // Agent2 komisyon alanlarının görünürlüğünü kontrol et
        Assert.IsTrue(PriceListLines."Agent2 Commission 1(Percentage".Visible(), 'Agent2 Commission 1 field should be visible');
        Assert.IsTrue(PriceListLines."Agent2 Commission 2(Percentage".Visible(), 'Agent2 Commission 2 field should be visible');
        Assert.IsTrue(PriceListLines."Agent2 Amount Euro per ton".Visible(), 'Agent2 Amount Euro field should be visible');

        // Değerleri değiştirip kaydedebilme testi
        PriceListLines."Agent1 Commission 1(Percentage".SetValue(LibraryRandom.RandDecInRange(1, 10, 2));
        PriceListLines."Agent2 Amount Euro per ton".SetValue(LibraryRandom.RandDecInRange(50, 100, 2));
        PriceListLines.OK().Invoke();


    end;

    local procedure CreateItem(var Item: Record Item)
    begin
        Item.Init();
        Item."No." := LibraryRandom.RandText(20);
        Item.Description := LibraryRandom.RandText(100);
        Item.Pallet := false;
        Item.Insert(true);
    end;

    local procedure CreatePriceList(var PriceListHeader: Record "Price List Header")
    begin
        PriceListHeader.Init();
        PriceListHeader.Code := LibraryRandom.RandText(20);
        PriceListHeader."Amount Type" := "Price Amount Type"::Price;
        PriceListHeader."Source Type" := "Price Source Type"::Customer;
        PriceListHeader.Status := PriceListHeader.Status::Draft;
        PriceListHeader.Insert(true);
    end;

    local procedure CreatePriceListLine(var PriceListLine: Record "Price List Line"; PriceListCode: Code[20])
    begin
        PriceListLine.Init();
        PriceListLine."Price List Code" := PriceListCode;
        PriceListLine."Asset Type" := PriceListLine."Asset Type"::Item;
        PriceListLine."Product No." := LibraryRandom.RandText(20);
        PriceListLine."Minimum Quantity" := 0;
        PriceListLine."Amount Type" := "Price Amount Type"::Price;
        PriceListLine."Source Type" := "Price Source Type"::Customer;
        PriceListLine."Unit of Measure Code" := '';
        PriceListLine."Line Amount" := LibraryRandom.RandDecInRange(100, 1000, 2);
        PriceListLine."Agent1 Commission 1(Percentage" := 0;
        PriceListLine."Agent1 Commission 2(Percentage" := 0;
        PriceListLine."Agent1 Amount Euro per ton" := 0;
        PriceListLine."Agent2 Commission 1(Percentage" := 0;
        PriceListLine."Agent2 Commission 2(Percentage" := 0;
        PriceListLine."Agent2 Amount Euro per ton" := 0;
        PriceListLine.Insert(true);
    end;
}