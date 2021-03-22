unit file_managment;

interface

uses phone;

type 

    phones_file = file of reg_phone;

procedure read_phone_data(var phones : text; var phone : reg_phone);

procedure create_phones_file(var output : phones_file);

procedure list_phones_with_less_stock_than_min(var phones : phones_file);

procedure search_by_description(var phones : phones_file);

procedure export_to_text(var phones : phones_file);

procedure add_phone_to_file(var phones : phones_file);

procedure modify_phone_stock(var phones : phones_file);

procedure export_without_stock(var phones : phones_file);

implementation

procedure read_phone_data(var phones : text; var phone : reg_phone);
begin
    readln(phones, phone.code, phone.price, phone.current_stock, phone.min_stock);
    readln(phones, phone.brand);
    readln(phones, phone.name);
    readln(phones, phone.description);
end;

procedure create_phones_file(var output : phones_file);
var
    phone : reg_phone;
    input : text;
begin
    { open the input file }
    assign(input, 'celulares.txt');
    reset(input);

    { create the new file }
    rewrite(output);

    while (not eof(input)) do
    begin
        read_phone_data(input, phone);
        write(output, phone);
    end;

    writeln('file created');

    close(input);
    close(output);
end;

procedure list_phones_with_less_stock_than_min(var phones : phones_file);
var
    phone : reg_phone;
begin
    reset(phones);
    while (not eof(phones)) do
    begin
        read(phones, phone);
        if (phone.current_stock < phone.min_stock) then
            write_phone(phone);
    end;
    close(phones);
end;

procedure search_by_description(var phones : phones_file);
var
    phone : reg_phone;
    word : string;
begin
    reset(phones);

    write('Phrase to search: ');
    readln(word);

    while (not eof(phones)) do
    begin
        read(phones, phone);
        if (pos(word, phone.description) <> 0) then
            write_phone(phone);
    end;

    close(phones);
end;

procedure write_phone_data(var output : text; phone : reg_phone);
begin
    writeln(output, phone.code, ' ', phone.price, ' ', phone.current_stock, ' ',phone.min_stock);
    writeln(output, phone.brand);
    writeln(output, phone.name);
    writeln(output, phone.description);
end;

procedure export_to_text(var phones : phones_file);
var
    phone : reg_phone;
    output : text;
begin
    reset(phones);

    assign(output, 'phones.txt');
    rewrite(output);

    while (not eof(phones)) do 
    begin
        read(phones, phone);
        write_phone_data(output, phone);
    end;

    close(phones);
    close(output);
end;

procedure add_phone_to_file(var phones : phones_file);
var
    phone : reg_phone;
begin
    writeln('----- FILL PHONE DATA -----');
    read_phone(phone);
    reset(phones);
    seek(phones, filesize(phones));
    write(phones, phone);
    close(phones);
    writeln('added');
end;

procedure modify_phone_stock(var phones : phones_file);
var
    phone_name : string;
    new_stock : integer;
    phone : reg_phone;
begin
    write('name of the phone to be modified: ');
    readln(phone_name);

    reset(phones);

    if (not eof(phones)) then
        read(phones, phone);

    while ((not eof(phones)) and (phone.name <> phone_name)) do
        read(phones, phone);

    if (phone.name = phone_name) then
    begin
        write('new stock: ');
        readln(new_stock);
        phone.current_stock := new_stock;

        seek(phones, filepos(phones) - 1);
        write(phones, phone);
    end
    else writeln('phone not found');
    
    close(phones);
end;

procedure export_without_stock(var phones : phones_file);
var
    phone : reg_phone;
    output : text;
begin
    reset(phones);
    assign(output, 'no_stock.txt');
    rewrite(output);

    while (not eof(phones)) do
    begin
        read(phones, phone);
        if (phone.current_stock = 0) then
            write_phone_data(output, phone);
    end;

    close(phones);
    close(output);
end;

end.