program ejercicio5;

const
    DELEGACIONES = 50;

type

    reg_direccion = record
        calle : integer;
        numero : integer;
        piso : integer;
        departamento : string;
        ciudad : string;
    end;

    reg_persona = record
        nombre : string;
        apellido : string;
        dni : string;
    end;

    reg_nacimiento = record
        num_partida_nacimiento : integer;
        nombre : string;
        apellido : string;
        direccion : reg_direccion;
        matricula_medico : string;
        madre : reg_persona;
        padre : reg_persona;
    end;
    
    arr_reg_nacimiento = array[1..DELEGACIONES] of reg_nacimiento;

    archivo_nacimiento = file of reg_nacimiento;

    arr_archivo_nacimiento = array[1..DELEGACIONES] of archivo_nacimiento;

    reg_fallecimiento = record
        num_partida_nacimiento : integer;
        datos : reg_persona;
        matricula_medico : string;
        fecha_y_hora : string;
        lugar : string;
    end;

    arr_reg_fallecimiento = array[1..DELEGACIONES] of reg_fallecimiento;

    archivo_fallecimiento = file of reg_fallecimiento;

    arr_archivo_fallecimiento = array[1..DELEGACIONES] of archivo_fallecimiento;
