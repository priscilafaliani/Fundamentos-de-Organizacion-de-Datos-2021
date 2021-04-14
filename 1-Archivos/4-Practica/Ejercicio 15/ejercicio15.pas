program ejercicio15;

type
    reg_maestro = record
        dni_alumno : integer;
        codigo_carrera : integer;
        monto_pagado : real;
    end;

    archivo_maestro = file of reg_maestro;

    reg_detalle = record
        