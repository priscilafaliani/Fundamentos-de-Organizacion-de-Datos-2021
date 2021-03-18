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

    readln;
end.