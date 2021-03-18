program creacion1;

uses sysUtils;

type 
    archivo_enteros = file of integer;

var
    enteros : archivo_enteros;
    filename : string;
    numero : integer;

begin

    write('nombre del archivo: ');
    readln(filename);
    writeln('el archivo "', filename, '" se va a guardar en ' + GetCurrentDir);

    { creando archivo }
    assign(enteros, filename);
    rewrite(enteros);

    { lee y escribe numeros en el archivo }
    write('numero: ');
    readln(numero);
    
    while (numero <> 0) do 
    begin
        write(enteros, numero);
        
        write('numero: ');
        readln(numero);
    end;

    { cierra y guarda el archivo }
    close(enteros);
    writeln('el archivo fue creado exitosamente');

    readln;
end.