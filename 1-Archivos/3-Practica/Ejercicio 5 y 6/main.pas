program ejercicio5;

uses menus, file_managment, sysutils;

const
    END_PROG = 32767;

var
    user_selection : integer;
    phones : phones_file;

type

    INITIAL_MENU_OPTIONS = (CREATE, SHOW_LESS_STOCK, SEARCH_BY_DESC, EXPORT_ALL, ADD_PHONE, MODIFY_STOCK, EXPORT_NO_STOCK);
    REPEAT_ACTION_OPTION = (REPEAT_ACTION);

procedure get_user_selection();
begin
    readln(user_selection);
    writeln;
    { the user inputs values from 1 but the enum starts at 0 }
    user_selection := user_selection - 1;
end;

procedure create_file_option();
var 
    filename : string;
begin
    writeln('filename: ');
    readln(filename);
    assign(phones, filename);
    create_phones_file(phones);
end;

procedure add_phones_option(var phones : phones_file);
begin
    add_phone_to_file(phones);

    show_add_phones_menu();
    get_user_selection();


    case REPEAT_ACTION_OPTION(user_selection) of
        REPEAT_ACTION:
            add_phones_option(phones);
    end;
end;

procedure modify_stock_option(var phones : phones_file);
begin
    modify_phone_stock(phones);

    show_modify_stock_menu();
    get_user_selection();

    case REPEAT_ACTION_OPTION(user_selection) of
        REPEAT_ACTION:
            modify_phone_stock(phones);
    end;
end;

function main(): integer;
begin
    assign(phones, 'phones');
    show_initial_menu();
    get_user_selection();

    case INITIAL_MENU_OPTIONS(user_selection) of
        CREATE:
            create_phones_file(phones);

        SHOW_LESS_STOCK:
            list_phones_with_less_stock_than_min(phones);
        
        SEARCH_BY_DESC:
            search_by_description(phones);

        EXPORT_ALL:
            export_to_text(phones);

        ADD_PHONE:
            add_phones_option(phones);

        MODIFY_STOCK:
            modify_stock_option(phones);

        EXPORT_NO_STOCK:
            export_without_stock(phones);

        else begin
            writeln('Goodbye');
            user_selection := END_PROG;
        end;
    end;

    main := user_selection;
end;

begin
    while (main() <> END_PROG) do;
    readln;
end.