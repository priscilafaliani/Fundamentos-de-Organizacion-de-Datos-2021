program modificar_archivos;

type
    employee_reg = record
        name : string[20];
        address : string[20];
        salary : real;
    end;

    employees_file = file of employee_reg;

procedure read_employee(var employee : employee_reg);
begin
    write('employee name: ');
    readln(employee.name);

    write('employee address: ');
    readln(employee.address);

    writeln('employee salary: ');
    readln(employee.salary);
end;

procedure writeEmployees(var employees : employees_file);
var
    employee : employee_reg;
begin
    { open the file }
    reset(employees);

    read_employee(employee);
    while (employee.salary <> 0) do 
    begin
        write(employees, employee);
        read_employee(employee);
    end;

    { close the file }
    close(employees);
end;

procedure increment_salary(var employees : employees_file; increment : real);
var
    employee : employee_reg;
begin
    reset(employees);

    while (not eof(employees)) do
    begin
        { lee un registro del archivo }
        read(employees, employee);
        { actualiza }
        employee.salary := employee.salary * increment;
        { lo guarda }
        seek(employees, filepos(employees) - 1);
        write(employees, employee);
    end;

    close(employees);
end;

procedure read_employees_data(employees : employees_file);
begin
    rewrite(employees);



    close(employees);
end;

var
    employees_data : employees_file;

begin
    { create employees data file }
    assign(employees_data, 'employees.dat');
    rewrite(employees_data);
    writeln('employees data file created...');

    { add data to the file }
    writeEmployees(employees_data);
    writeln('employees data uploaded...');

    { update all employees salary }
    increment_salary(employees_data, 1.1);
    writeln('employees salary updated');
end.