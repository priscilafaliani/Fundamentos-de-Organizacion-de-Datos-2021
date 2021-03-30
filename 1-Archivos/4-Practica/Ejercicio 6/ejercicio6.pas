program ejercicio6;

const
    CODIGO_SALIDA = -1;

type
    reg_cliente = record
        codigo : integer;
        nombre : string;
        apellido : string;
    end;

    reg_fecha = record 
        anio : integer;
        mes : integer;
        dia : integer;
    end;

    reg_venta = record
        cliente : reg_cliente;
        monto : real;
        fecha : reg_fecha;
    end;


    archivo_ventas = file of reg_venta;


procedure escribir_cliente(cliente : reg_cliente);
begin
    with cliente do
    begin
        writeln('codigo: ', codigo);
        writeln('nombre: ', nombre);
        writeln('apellido: ', apellido);
    end;
end;

procedure escribir_fecha(fecha : reg_fecha);
begin
    with fecha do
    begin
        writeln(fecha.año, ' ', fecha.mes, ' ', fecha.dia);
    end;
end;


procedure escribir_venta(venta : reg_venta);
begin
    with venta do
    begin
        writeln('cliente...');
        escribir_cliente(venta.cliente);
        writeln('monto: ', venta.monto);
        escribir_fecha(venta.fecha);
    end;
end;


procedure leer_venta_bin(var archivo : archivo_ventas; var registro : reg_venta);
begin
    if not eof(archivo) then
        read(archivo, registro)
    else
        registro.monto := -1;
end;


procedure realizar_reporte();
var
    ventas : archivo_ventas;
    aux, actual : reg_venta;
    total_mensual, total_anual : real;
begin

    assign(ventas, 'ventas');
    reset(ventas);

    leer_venta_bin(ventas, aux);
    while(aux.monto <> CODIGO_SALIDA) do
    begin

        actual := aux;
        escribir_datos(actual);
        while (aux.monto <> CODIGO_SALIDA) and (aux.cliente.codigo = actual.cliente.codigo) do
        begin
            actual.fecha.anio := aux.fecha.anio;
            total_anual := 0;
            while (aux.monto <> CODIGO_SALIDA) and 
            (aux.cliente.codigo = actual.cliente.codigo) and 
            (aux.cliente.anio = actual.fecha.anio) do
            begin
                actual.fecha.mes := aux.fecha.mes;
                total_mensual := 0;
                while (aux.monto <> CODIGO_SALIDA) and 
                (aux.cliente.codigo = actual.cliente.codigo) and 
                (aux.fecha.anio = actual.fecha.anio) and 
                (aux.fecha.mes = actual.fecha.mes) do
                begin
                    total_mensual := total_mensual + aux.monto;
                    leer_venta_bin(ventas, aux);
                end;

                writeln('total del mes ', actual.fecha.mes, ': ', total_mensual);
                total_anual := total_anual + total_mensual;
            end;

            writeln('total del anio ', actual.fecha.anio, ': ', total_anual);
        end;

    end;

    close(ventas);    
end;