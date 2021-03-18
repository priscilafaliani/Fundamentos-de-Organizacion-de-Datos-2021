program file_handling;

uses sysUtils;

type

    { tipo de dato que contiene el archivo }
    reg_persona = record
        dni : string;
        apellido : string;
        nombre : string;
        direccion : string;
        genero : string;
        salario : real;
    end;

    { tipo 'file' que contiene registros persona }
    archivo_personas = file of reg_persona;

procedure leer_persona(var persona : reg_persona);
begin
    writeln('dni: ');
    readln(persona.dni);

    if (persona.dni <> '') then 
    begin
        
        writeln('apellido: ');
        readln(persona.apellido);
        
        writeln('nombre: ');
        readln(persona.nombre);
        
        writeln('direccion: ');
        readln(persona.direccion);
        
        writeln('genero: ');
        readln(persona.genero);
        
        writeln('salario: ');
        readln(persona.salario);

    end;
end;

procedure imprimir_registro_persona(persona : reg_persona);
begin
    with persona do begin
        writeln('dni: ', dni);
        writeln('apellido: ', apellido);
        writeln('nombre: ', nombre);
        writeln('direccion: ', direccion);
        writeln('genero: ', genero);
        writeln('salario: ', salario);
    end;
end;

procedure actualizar_salario(var personas : archivo_personas; incremento : real);
var 
    persona : reg_persona;
begin
    reset(personas);

    while(not eof(personas)) do
    begin
        read(personas, persona);
        persona.salario := persona.salario * incremento;
        
        { posiciona nuevamente el puntero }
        seek(personas, filepos(personas) - 1);
        write(personas, persona);
    end;

    close(personas);
end;

var
    personas : archivo_personas;
    filename : string;
    persona : reg_persona;
    cantidad : integer;

begin
    write('nombre del archivo: ');
    readln(filename);
    writeln('el archivo "', filename, '" se va a guardar en ' + GetCurrentDir);

    { creando archivo }
    assign(personas, filename);
    rewrite(personas);

    { --- lee y escribe personas en el archivo --- }
    leer_persona(persona);
    
    { variable solo para dar formato al código }
    cantidad := 0;
    while (persona.dni <> '') do 
    begin
        cantidad := cantidad + 1;
        writeln('Cargando datos de la persona nro ', cantidad, '...');
        write(personas, persona);
        leer_persona(persona);        
    end;

    { --- --- }

    { cierra y guarda el archivo }
    close(personas);
    writeln('el archivo fue creado exitosamente');

    writeln('realizando actualizacion de salarios');
    actualizar_salario(personas, 1.1);
    writeln('fin de actualizacion');

    readln;
end.