CREATE OR REPLACE PROCEDURE prc_valida_total_pedido (
    order_code NUMBER
) IS

    items_value NUMBER;
    CURSOR cur_get_order IS
    SELECT
        *
    FROM
        pedido
    WHERE
        cod_pedido = order_code;

    CURSOR get_order_items (
        item_order_number pedido.cod_pedido%TYPE
    ) IS
    SELECT
        *
    FROM
        item_pedido
    WHERE
        cod_pedido = item_order_number;

BEGIN
    FOR o IN cur_get_order LOOP
        items_value := 0;
        FOR item IN get_order_items(o.cod_pedido) LOOP
            items_value := items_value + ( ( item.qtd_item * item.val_unitario_item ) - item.val_desconto_item );
        END LOOP;

        IF items_value = o.val_total_pedido THEN
            dbms_output.put_line('pedido ok');
        ELSE
            dbms_output.put_line('total dos itens não coincide com valor total do pedido');
        END IF;

    END LOOP;
END;
