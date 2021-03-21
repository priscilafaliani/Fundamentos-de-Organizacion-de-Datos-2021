unit novel;

interface

type 
    reg_novel = record
        code : integer;
        price : real;
        genre : string;

        name : string;
    end;

procedure read_novel(var novel : reg_novel);

procedure write_novel(novel : reg_novel);

implementation 

procedure read_novel(var novel : reg_novel);
begin
    writeln('----- FILL NOVEL DATA -----');
    writeln;
    with novel do
    begin
        write('code: ');
        readln(code);

        write('name: ');
        readln(name);

        write('price: ');
        readln(price);

        write('genre: ');
        readln(genre);
    end;
    writeln;
    writeln('ADDING TO FILE...');
end;

procedure write_novel(novel : reg_novel);
begin
    with novel do 
    begin
        writeln('----- NOVEL INFO -----');
        writeln;
        writeln('code: ', code);
        writeln('name: ', name);
        writeln('price: $', price:1:2);
        writeln('genre: ', genre);    
        writeln;
        writeln('----------------------');
    end;
end;

end.