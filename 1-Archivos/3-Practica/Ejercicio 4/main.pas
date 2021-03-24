program ejercicio3;

uses file_managment, menus;

type
    INITIAL_MENU_OPTIONS = (CREATE, OPEN);

    OPEN_FILE_MENU_OPTIONS = (SEARCH_BY, SHOW_ALL, TO_BE_RETIRED, ADD_EMPLOYEES, MODIFY_AGE, EXPORT_ALL, EXPORT_MISSING_DNI, END_SELECTION);

    { 
        UDPATE/FINISH, YES/NO 
        the second one doesn't need to be specified, is the default option 
    }
    AGE_UPDATE_MENU_OPTIONS = (UPDATE);

    ACCEPT_REJECT_MENU_OPTIONS = (YES);

{ GLOBAL variables used in the procedures }
var
    employees : employees_file;
    user_selection : integer;
    filepath : string;

function get_selection(): integer;
var selected_option : integer;
begin
    readln(selected_option);
    { the minus 1 is needed bc the user inputs > 1 values but OPTIONS starts at 0 }
    get_selection := selected_option - 1;
end;

procedure update_age_option();
var
    new_age, employee_code : integer;
begin
    write('employee code: ');
    readln(employee_code);
    write('new age: ');
    readln(new_age);

    show_update_warning_menu();
    user_selection := get_selection();
    writeln;

    case ACCEPT_REJECT_MENU_OPTIONS(user_selection) of
        YES: 
            modify_employee_age(employees, employee_code, new_age); 
        else 
            writeln('update canceled');
    end;            
end;

procedure modify_age_option();
begin
    show_modify_age_menu();

    user_selection := get_selection();
    writeln;

    case AGE_UPDATE_MENU_OPTIONS(user_selection) of
        UPDATE:
        begin
            update_age_option();

            { use recursion to keep prompting until exit }
            modify_age_option();
        end;

        else 
            writeln('returning to main menu');
    end;
end;

procedure search_by_name_option();
var
    searched_name : string;
begin
    write('first/last name to be searched: ');
    readln(searched_name);
    search_by_name(employees, searched_name);
end;

procedure open_file_option();
begin    
    write('filepath: ');
    readln(filepath);
    assign(employees, filepath);

    show_open_file_menu();

    user_selection := get_selection();
    writeln;

    case OPEN_FILE_MENU_OPTIONS(user_selection) of
        SEARCH_BY:
            search_by_name_option();

        SHOW_ALL:
            show_all_employees(employees);

        TO_BE_RETIRED:
            show_soon_to_be_retired(employees);

        ADD_EMPLOYEES:
            add_employees_to_file(employees);

        MODIFY_AGE:
            modify_age_option();

        EXPORT_ALL:
            export_all_employees(employees);

        EXPORT_MISSING_DNI:
            export_missing_dni_employees(employees);
        
        else 
            writeln('returning to main menu');
    end;
end;

function main(): integer;
begin
    show_initial_menu(); 
    user_selection := get_selection();
    writeln;


    case INITIAL_MENU_OPTIONS(user_selection) of
        CREATE:
            create_employees_file(employees);
        OPEN:
            open_file_option();
        else
        begin
            writeln('exiting');
            user_selection := ord(END_SELECTION);
        end;
    end;

    main := user_selection;
end;
    
begin

    while (main() <> ord(END_SELECTION)) do
        writeln;
    readln;
end.
