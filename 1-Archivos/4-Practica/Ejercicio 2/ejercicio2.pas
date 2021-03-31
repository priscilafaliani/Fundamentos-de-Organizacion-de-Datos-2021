program ejercicio2;

const
    CODIGO_FIN = -1;

type
    reg_alumno = record
        codigo_alumno : itneger;
        apellido : string;
        nombre : string;
        materias_cursadas : integer;
        materias_aprobadas : integer;
    end;

    archivo_maestro = file of reg_alumno;

    reg_estado_materia = record
        codigo_alumno : integer;
        estado : string; // 'cursada' o 'aprobada'
    end;
        
    archivo_detalle = file of reg_estado_materia;


procedure leer_alumno_txt(var archivo : text; var alumno : reg_alumno);
begin
    if not eof(archivo) then
    begin
        with alumno do begin
            read(archivo, codigo_alumno, materias_cursadas, materias_aprobadas,.apellido);
            read(archivo, nombre);
        end;
    end
    else
        alumno.codigo_alumno := CODIGO_FIN;
end;

procedure crear_archivo_maestro();
var
    arch_maestro : archivo_maestro;
    alumnos : text;
    alumno : reg_alumno;
begin
    assign(arch_maestro, 'maestro');
    assign(alumnos, 'alumnos.txt');

    rewrite(arch_maestro);
    reset(alumnos);

    leer_alumno_txt(alumnos, alumno);
    while (alumno.codigo_alumno <> CODIGO_FIN) do
    begin
        write(arch_maestro, alumnos);
        leer_alumno_txt(alumnos, alumno);
    end;


    close(arch_maestro);
    close(alumnos);
end;


procedure leer_estado_materia_txt(var archivo : text; var estado_materia : reg_estado_materia);
begin
    if not eof(archivo) then
    begin
        with estado_materia do
        begin
            read(archivo, codigo_alumno, estado);
        end;
    end;
end;


procedure crear_archivo_detalle();
var
    arch_detalle : archivo_detalle;
    detalle : text;
    estado_materia : reg_estado_materia;
begin
    assign(arch_detalle, 'detalle');
    assign(detalle, 'detalle.txt');

    rewrite(arch_detalle);
    reset(detalle);

    leer_estado_materia_txt(detalle, estado_materia);
    while (estado_materia.codigo_alumno <> CODIGO_FIN) do
    begin
        write(arch_detalle, estado_materia);
        leer_estado_materia_txt(detalle,estado_materia);
    end;

    close(arch_detalle);
    close(detalle);
end;


procedure leer_alumno_bin(var archivo : archivo_maestro; var alumno : reg_alumno);
begin
    if not eof(archivo) then
        read(archivo, alumno)
    else
        alumno.codigo_alumno := CODIGO_FIN;
end;


procedure escribir_alumno_txt(var archivo : text; alumno : reg_alumno);
begin
    with alumno do begin
        writeln(archivo, codigo_alumno, ' ', materias_cursadas, ' ', materias_aprobadas, ' ', apellido);
        write(archivo, nombre);
    end;
end;


procedure exportar_txt_maestro();
var
    arch_maestro : archivo_maestro;
    reporte_alumnos : text;
    alumno : reg_alumno;
begin
    assign(arch_maestro, 'maestro');
    assign(reporte_alumnos, 'reporteAlumnos.txt');

    reset(arch_maestro);
    rewrite(reporte_alumnos);

    leer_alumno_bin(arch_maestro, alumno);
    while (alumno.codigo_alumno <> CODIGO_FIN) do
    begin
        escribir_alumno_txt(reporte_alumnos, alumno);
        leer_alumno_bin(arch_maestro, alumno);
    end;

    close(arch_maestro);
    close(reporte_alumnos);
end;


procedure leer_estado_materia_bin(var archivo : archivo_detalle; var estado_materia : reg_estado_materia);
begin
    if not eof(archivo) then
        read(archivo, estado_materia)
    else
        estado_materia.codigo_alumno := CODIGO_FIN;
end;


procedure escribir_estado_materia_txt(var archivo : text; estado_materia : reg_estado_materia);
begin
    with estado_materia do
    begin
        writeln(archivo, codigo_alumno, ' ', estado);
    end;
end;


procedure exportar_txt_detalle();
var
    arch_detalle : archivo_detalle;
    reporte_detalle : text;
    estado_materia : reg_estado_materia;
begin
    assign(arch_detalle, 'detalle');
    assign(reporte_detalle, 'reporteDetalle.txt');

    reset(arch_detalle);
    rewrite(reporte_detalle);


    leer_estado_materia_bin(arch_detalle, estado_materia);
    while (estado_materia.codigo_alumno <> CODIGO_FIN) do
    begin
        escribir_estado_materia_txt(reporte_detalle, estado_materia);
        leer_estado_materia_bin(arch_detalle, estado_materia);
    end;


    close(arch_detalle);
    close(reporte_detalle);
end;


procedure actualizar_maestro();
var
    arch_maestro : archivo_maestro;
    arch_detalle : archivo_detalle;
    estado_materia : reg_estado_materia;
    alumno : reg_alumno;
begin
    assign(arch_maestro, 'maestro');
    assign(arch_detalle, 'detalle');

    reset(arch_maestro);
    reset(arch_detalle);

    leer_estado_materia_bin(arch_detalle, estado_materia);
    while (estado_materia.codigo_alumno <> CODIGO_FIN) do
    begin
        leer_alumno_bin(arch_maestro, alumno);
        while (alumno.codigo_alumno <> aux.codigo_alumno) do
            leer_alumno_bin(arch_maestro, alumno);        
        
        while (estado_materia.codigo_alumno = alumno.codigo_alumno) do
        begin
            // se asume que estado solo puede tomar los valores 'aprobada' o 'cursada'
            if (estado_materia.estado = 'aprobada') then
                alumno.materias_aprobadas := alumno.materias_aprobadas + 1
            else
                alumno.materias_cursadas := alumno.materias_cursadas + 1;    

            leer_estado_materia_bin(arch_detalle, estado_materia);
        end;

        seek(arch_maestro, filepos(arch_maestro) - 1);
        write(arch_maestro, alumno);
    end;

    close(arch_maestro);
    close(arch_detalle);
end;


procedure listar_malos_alumnos();
var
    arch_maestro : archivo_maestro;
    malos_alumnos : text;
    alumno : reg_alumno;
begin
    assign(arch_maestro, 'maestro');
    assign(malos_alumnos, 'malosAlumnos.txt');

    reset(arch_maestro);
    rewrite(malos_alumnos);

    leer_alumno_bin(arch_maestro, alumno);
    while (alumno.codigo_alumno <> CODIGO_FIN) do
    begin
        if (alumno.materias_cursadas > 4) and (alumno.materias_aprobadas < alumno.materias_cursadas) then
            escribir_alumno_txt(malos_alumnos, alumno);
        leer_alumno_bin(arch_maestro, alumno);
    end;

    close(arch_maestro);
    close(malos_alumnos);
end;


procedure menu();
begin
    writeln('-----------------------------------');
    writeln('1. crear archivo maestro');
    writeln('2. crear archivo detalle');
    writeln('3. exportar archivo maestro a txt');
    writeln('4. exportar archivo detalle a txt');
    writeln('5. actualizar archivo maestro');
    writeln('6. listar malos alumnos');
    writeln('-----------------------------------');
end;


procedure main();
var
    eleccion : integer;
begin
    readln(eleccion);
    while (eleccion > 0) and (eleccion < 7) do 
    begin
        case eleccion of
            1: crear_archivo_maestro();
            2: crear_archivo_detalle();
            3: exportar_txt_maestro();
            4: exportar_txt_detalle();
            5: actualizar_maestro();
            6: listar_malos_alumnos();
        end;
        readln(eleccion);
    end;    
end;


begin
    main();
end.