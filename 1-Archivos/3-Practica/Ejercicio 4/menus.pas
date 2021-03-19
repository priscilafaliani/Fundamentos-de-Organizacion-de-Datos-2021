unit menus;

interface

procedure show_initial_menu();

procedure show_open_file_menu();

procedure show_modify_age_menu();

procedure show_update_warning_menu();

implementation

procedure show_initial_menu();
begin
    writeln('---------- Choose an option ----------');
    writeln('1. Create new employees file');
    writeln('2. Open employees file');
    writeln('3. Exit');
    writeln('--------------------------------------');
end;

procedure show_open_file_menu();
begin
    writeln('---------- Choose an option ----------');
    writeln('1. Search employees by first/last name');
    writeln('2. Show all employees');
    writeln('3. Show soon to be retired employees');
    writeln('4. Add more employees to the file ');
    writeln('5. Modify ages');
    writeln('6. Export');
    writeln('7. Export only employees with DNI missing');
    writeln('--------------------------------------');
end;

procedure show_modify_age_menu();
begin
    writeln('---------- Choose an option ----------');
    writeln('1. Modify an employee age');
    writeln('2. Done');
    writeln('--------------------------------------');
end;

procedure show_update_warning_menu();
begin
    writeln('----------  Are you sure you wanna update the record?  ----------');
    writeln('1. Yes');
    writeln('2. No');
    writeln('-----------------------------------------------------------------');
end;

end.