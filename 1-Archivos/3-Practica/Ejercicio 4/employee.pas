unit employee;

interface

type

    reg_employee = record
        code : integer;
        lastname : string;
        firstname : string;
        age : integer;
        dni : string;
    end;

procedure read_employee(var e : reg_employee);

procedure write_employee(e : reg_employee);

implementation

procedure read_employee(var e : reg_employee);
begin
    with e do 
    begin
        write('lastname: ');
        readln(lastname);

        if (lastname <> 'fin') then 
        begin
            write('firstname: ');
            readln(firstname);
            write('employee code:');
            readln(code);
            write('age: ');
            readln(age);
            write('dni: ');
            readln(dni);
        end;
    end;
end;

procedure write_employee(e : reg_employee);
begin
    with e do 
    begin
        writeln('employee code: ', code);
        writeln('lastname: ', lastname);
        writeln('firstname: ', firstname);
        writeln('age: ', age);
        writeln('dni: ', dni);
    end;
end;


end.