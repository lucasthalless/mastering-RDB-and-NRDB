CREATE OR REPLACE PROCEDURE prc_valida_total_pedido (
    order_code NUMBER
) IS

    CURSOR cur_get_order IS
    SELECT
        *
    FROM
        pedido p
    WHERE
        cod_pedido = order_code;

    CURSOR get_order_items IS
    SELECT
        *
    FROM
        item_pedido ip
    WHERE
        ip.cod_pedido = order_code;

BEGIN
    FOR x IN cur_emp LOOP
        dmbs_output.put_line(x.cod_pedido);
    END LOOP;
END;
