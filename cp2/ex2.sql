CREATE OR REPLACE FUNCTION fnc_qtd_itens_em_pedidos_por_produto (
    p_cod_produto IN NUMBER
) RETURN NUMBER IS
    v_total_qtd NUMBER := 0;
BEGIN
    SELECT
        SUM(ip.qtd_item)
    INTO v_total_qtd
    FROM
             item_pedido ip
        JOIN pedido  p ON ip.cod_pedido = p.cod_pedido
        JOIN produto pr ON ip.cod_produto = pr.cod_produto
    WHERE
        pr.cod_produto = p_cod_produto;

    RETURN v_total_qtd;
EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(-20404, 'Nenhum dado encontrado');
END;