unit file_managment;

interface

uses employee;

type
    employees_file = file of reg_employee;

procedure create_employees_file(var employees : employees_file);

procedure show_all_employees(var employees : employees_file);

procedure search_by_name(var employees : employees_file; first_or_last_name : string);

procedure show_soon_to_be_retired(var employees : employees_file);

procedure add_employees_to_file(var employees : employees_file);

procedure write_employees(var employees : employees_file);

procedure export_all_employees(var employees : employees_file);

procedure export_missing_dni_employees(var employees : employees_file);

procedure read_employee_from_file(var employees : employees_file; var employee : reg_employee);

procedure modify_employee_age(var employees : employees_file; employee_code, new_age : integer);

implementation

procedure write_employees(var employees : employees_file);
var
    employee : reg_employee;
begin

    { read employees data & write it to the file }
    read_employee(employee);
    while (employee.lastname <> 'fin') do
    begin
        write(employees, employee);
        read_employee(employee);    
    end;
end;

procedure create_employees_file(var employees : employees_file);
begin
    rewrite(employees);
    write_employees(employees);
    close(employees);
end;

procedure show_all_employees(var employees : employees_file);
var
    employee : reg_employee;
begin
    reset(employees);

    { output all the employees }
    while (not eof(employees)) do
    begin
        read(employees, employee);
        writeln('--------------------');
        write_employee(employee);
    end;
    writeln('--------------------');

    close(employees);
end;

procedure search_by_name(var employees : employees_file; first_or_last_name : string);
var
    employee : reg_employee;
begin
    reset(employees);

    { output all the employees who match the name }
    while (not eof(employees)) do
    begin
        read(employees, employee);
        if ((employee.firstname = first_or_last_name) or (employee.lastname = first_or_last_name)) then 
        begin
            writeln('--------------------');
            write_employee(employee);
        end;
    end;
    writeln('--------------------');

    close(employees);
end;

procedure show_soon_to_be_retired(var employees : employees_file);
var
    employee : reg_employee;
begin
    reset(employees);

    { output all the employees older than 70 }
    while (not eof(employees)) do
    begin
        read(employees, employee);

        if (employee.age >= 70) then 
        begin
            writeln('--------------------');
            write_employee(employee);
        end;
    end;
    writeln('--------------------');

    close(employees);
end;

procedure add_employees_to_file(var employees : employees_file);
begin
    reset(employees);
        seek(employees, filesize(employees));
    write_employees(employees);
    close(employees);
end;

procedure export_all_employees(var employees : employees_file);
var
    export_file : text;
    employee : reg_employee;
begin
    reset(employees);

    assign(export_file, 'exported\employees.txt');
    rewrite(export_file);

    while (not eof(employees)) do
    begin
        read(employees, employee);
        writeln(export_file, employee.code, ' ', employee.firstname, ' ', employee.lastname, ' ', employee.age, ' ', employee.dni);
    end;

    close(employees);
    close(export_file);
end;

procedure export_missing_dni_employees(var employees : employees_file);
var
    export_file : text;
    employee : reg_employee;
begin
    reset(employees);

    assign(export_file, 'exported\missing_dni.txt');
    rewrite(export_file);

    while (not eof(employees)) do
    begin
        read(employees, employee);

        if (employee.dni = '00') then
            writeln(export_file, employee.code, ' ', employee.firstname, ' ', employee.lastname, ' ', employee.age, ' ', employee.dni);
    end;

    close(employees);
    close(export_file);
end;

procedure modify_employee_age(var employees : employees_file; employee_code, new_age : integer);
var
    employee : reg_employee;
begin
    reset(employees);

    read_employee_from_file(employees, employee);    

    while ((not eof(employees)) and (employee.code <> employee_code)) do 
        read_employee_from_file(employees, employee);       

    { if the employee was found in the file, update it }
    if (employee.age <> 32767) then
    begin
        writeln('updated');

        employee.age := new_age;
        seek(employees, filepos(employees) - 1);

        write(employees, employee);
    end
    else 
        writeln('employee not found');

    close(employees);
end;

procedure read_employee_from_file(var employees : employees_file; var employee : reg_employee);
begin
    if (not eof(employees)) then
        read(employees, employee)
    else
        employee.age := 32767;
end;

end.