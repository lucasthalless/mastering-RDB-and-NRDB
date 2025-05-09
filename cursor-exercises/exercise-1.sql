-- bloco anonimo com cursor que realiza uma consulta na tabela de clientes e retorna o codigo e o nome do cliente

DECLARE
    CURSOR c_consulta_clientes IS
    SELECT
        cod_cliente,
        nom_cliente
    FROM
        cliente;

BEGIN
    FOR x IN c_consulta_clientes LOOP
        dbms_output.put_line('cliente: '
                    || x.cod_cliente
                    || ' nome: '
                    || x.nom_cliente);
    END LOOP;
END;
