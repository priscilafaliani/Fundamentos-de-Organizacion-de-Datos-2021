unit phone;

interface

type 
    reg_phone = record
        code : integer;
        price : real;
        brand : string;
        name : string;
        
        current_stock : integer;
        min_stock : integer;
        description : string;
    end;

procedure read_phone(var p : reg_phone);

procedure write_phone(p : reg_phone);

implementation

procedure read_phone(var p : reg_phone);
begin
    with p do 
    begin
        write('code: ');
        readln(code);

        write('name: ');
        readln(name);

        write('brand: ');
        readln(brand);

        write('price: ');
        readln(price);

        write('min stock: ');
        readln(min_stock);

        write('current_stock: ');
        readln(current_stock);

        write('description: ');
        readln(description);
    end;
end;

procedure write_phone(p : reg_phone);
begin
    with p do 
    begin
        writeln('----- PHONE DETAILS -----');
        writeln;
        writeln('code: ', code);
        writeln('name: ', name);
        writeln('brand: ', brand);
        writeln('price: ', price);
        writeln('min stock: ', min_stock);
        writeln('current stock: ', current_stock);
        writeln('description: ', description);
        writeln;
        writeln('-------------------------');
    end;
end;


end.