program ejercicio7;

uses file_managment, menus;

type

    OPTIONS = (ADD, MODIFY);

function get_user_selection(): integer;
var
    user_selection : integer;
begin
    readln(user_selection);
    get_user_selection := user_selection - 1;
end;

var 
    input_novels : text;
    output_novels : novel_file;
    user_selection : integer;
begin
    assign(input_novels, 'novels.txt');
    assign(output_novels, 'novels.data');

    create_novel_file(input_novels, output_novels);

    show_initial_menu();
    user_selection := get_user_selection();

    case OPTIONS(user_selection) of
        ADD:
            add_novel(output_novels);
        MODIFY:
            modify_novel(output_novels);
    end;

    print_novel_file(output_novels);

    readln;
end.