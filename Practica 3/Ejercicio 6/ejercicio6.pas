program ejercicio6;

type
    reg_prenda = record
        cod : integer;
        desc : string;
        color : string;
        tipo : string;
        stock : integer;
        precio : real;
    end;

    archivo_prendas = file of reg_prenda;

    // arch de codigos
    archivo_obsoletos = file of integer;
