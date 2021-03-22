program ejemplo2;

const
    VALOR_CORTE = '9999';

type
    reg_producto = record
        codigo : string;
        nombre : string;
        cantidad : integer;
    end;

    file_productos = file of reg_producto;



procedure leer(var archivo : archivo_productos; var dato : reg_producto);
begin
    if (not eof(archivo)) then
        readln(archivo, dato)
    else
        dato.codigo = VALOR_CORTE;
end;

var
    min, reg_detalle1, reg_detalle2, reg_detalle3 : reg_producto;
    detalle1, detalle2, detalle3, merged_file : archivo_productos;

procedure minimo();
begin
    if ((reg_detalle1.codigo <= reg_detalle2.codigo) and (reg_detalle1.codigo <= reg_detalle3.codigo)) then
    begin
        min := reg_detalle1;
        leer(detalle1, reg_detalle1);
    end
    else if (reg_detalle2.codigo <= reg_detalle3.codigo) then
    begin
        min := reg_detalle2;
        leer(detalle2, reg_detalle2);
    end
    else 
    begin
        min := reg_detalle3;
        leer(detalle3, reg_detalle3);    
    end;
        
end;

var
    codigo_actual : integer;
    cantidad : integer;
begin
    assign(merged_file, 'maestro');
    assign(detalle1, 'detalle1');
    assign(detalle2, 'detalle2');
    assign(detalle3, 'detalle3');

    rewrite(merged_file);
    reset(detalle1);
    reset(detalle2);
    reset(detalle3);

    leer(detalle1);
    leer(detalle2);
    leer(detalle3);

    while (min.codigo <> VALOR_CORTE) do
    begin
        codigo_actual := min.codigo;
        while (min.codigo <> codigo_actual) do 
        begin
            cantidad := min.cantidad + cantidad;
            minimo();
        end;

        write(merged_file, min);
        minimo();
    end;

    close(merged_file);
    close(detalle1);
    close(detalle2);
    close(detalle3);
end.