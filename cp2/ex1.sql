CREATE OR REPLACE FUNCTION fnc_valor_total_pedidos_por_estado (
    p_uf IN VARCHAR2
) RETURN NUMBER IS
    v_total NUMBER := 0;
BEGIN
    SELECT
        SUM(hp.val_total_pedido)
    INTO v_total
    FROM
             historico_pedido hp
        JOIN endereco_cliente ec ON hp.cod_cliente = ec.cod_cliente
        JOIN cidade           c ON ec.cod_cidade = c.cod_cidade
        JOIN estado           e ON c.cod_estado = e.cod_estado
    WHERE
            e.cod_estado = p_uf
        AND hp.dat_entrega IS NOT NULL;

    RETURN v_total;
EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(-20404, 'Nenhum dado encontrado');
END;