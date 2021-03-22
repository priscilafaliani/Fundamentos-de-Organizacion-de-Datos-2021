unit menus;

interface

procedure show_initial_menu();

procedure show_add_phones_menu();

procedure show_modify_stock_menu();

implementation

procedure show_initial_menu();
begin

    writeln('----- CHOOSE AN OPTION -----');
    writeln;
    writeln('1. Create phones data file');
    writeln('2. Show phones where the current stock is less than the min stock');
    writeln('3. Search by description');
    writeln('4. Export');
    writeln('5. Add phones data');
    writeln('6. Modify stock from a given phone');
    writeln('7. Export phones without stock');
    writeln('Any other num to exit');
    writeln;
    writeln('----------------------------');
end;

procedure show_add_phones_menu();
begin
    writeln('----- CHOOSE AN OPTION -----');
    writeln;
    writeln('1. Add another phone');
    writeln('Any other key to exit');
    writeln;    
    writeln('----------------------------');
end;

procedure show_modify_stock_menu();
begin
    writeln('----- CHOOSE AN OPTION -----');
    writeln;
    writeln('1. Modify another phone stock');
    writeln('Any other num to exit');
    writeln;    
    writeln('----------------------------');
end;

end.