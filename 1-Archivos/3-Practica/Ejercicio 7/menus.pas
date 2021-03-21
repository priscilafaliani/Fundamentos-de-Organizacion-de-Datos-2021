unit menus;

interface

procedure show_initial_menu();

implementation

procedure show_initial_menu();
begin

    writeln('----- CHOOSE AN OPTION -----');
    writeln;
    writeln('1. Add new novel to the file');
    writeln('2. Modify an existent novel');
    writeln;
    writeln('----------------------------');

end;

end.