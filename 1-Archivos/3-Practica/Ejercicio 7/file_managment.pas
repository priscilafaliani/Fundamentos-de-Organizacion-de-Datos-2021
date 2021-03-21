unit file_managment;

interface

uses novel;

type
    novel_file = file of reg_novel;

procedure read_novel_from_text_file(var novels : text; var novel : reg_novel);

procedure create_novel_file(var input : text; var output : novel_file);

procedure add_novel(var novels : novel_file);

procedure find_novel(var novels : novel_file; var novel : reg_novel; novel_code : integer);

procedure modify_novel(var novels : novel_file);

procedure print_novel_file(var novels : novel_file);

implementation

procedure read_novel_from_text_file(var novels : text; var novel : reg_novel);
begin
    readln(novels, novel.code, novel.price, novel.genre);
    readln(novels, novel.name);
end;

procedure create_novel_file(var input : text; var output : novel_file);
var 
    novel : reg_novel;
begin
    reset(input);
    rewrite(output);

    while (not eof(input)) do
    begin
        read_novel_from_text_file(input, novel);
        write(output, novel);
    end;

    close(input);
    close(output);
end;

procedure add_novel(var novels : novel_file);
var
    novel : reg_novel;
begin
    reset(novels);
    read_novel(novel);
    seek(novels, filesize(novels));
    write(novels, novel);
    close(novels);
end;

procedure find_novel(var novels : novel_file; var novel : reg_novel; novel_code : integer);
begin
    if (not eof(novels)) then
        read(novels, novel);

    while ((not eof(novels)) and (not novel.code = novel_code)) do
        read(novels, novel);

    if (novel.code <> novel_code) then
        novel.genre := 'none';
end;

procedure modify_novel(var novels : novel_file);
var 
    novel_code : integer;
    novel : reg_novel;
begin
    writeln('code of the novel to modify: ');
    readln(novel_code);

    reset(novels);
    find_novel(novels, novel, novel_code);

    if (novel.genre <> 'none') then 
    begin
        read_novel(novel);
        seek(novels, filepos(novels) - 1);
        write(novels, novel);
    end 
    else 
        writeln('novel not found');    
    close(novels);
end;

procedure print_novel_file(var novels : novel_file);
var novel : reg_novel;
begin
    reset(novels);
    while (not eof(novels)) do 
    begin
        read(novels, novel);
        write_novel(novel);
    end;
    close(novels);
end;

end.