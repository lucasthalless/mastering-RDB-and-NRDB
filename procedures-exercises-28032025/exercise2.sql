CREATE OR REPLACE PROCEDURE listaritenspedidos (
    p_cod_pedido NUMBER
) AS
BEGIN
    FOR x IN (
        SELECT
            a.cod_produto "Código do produto",
            b.nom_produto "Nome do produto",
            a.qtd_item    "Quantidade do item"
        FROM
                 item_pedido a
            INNER JOIN produto b ON a.cod_produto = b.cod_produto
        WHERE
            cod_pedido = p_cod_pedido
    ) LOOP
        dbms_output.put_line(x."Código do produto");
        dbms_output.put_line(x."Nome do produto");
        dbms_output.put_line(x."Quantidade do item");
        dbms_output.put_line('============//=============');
    END LOOP;
END listaritenspedidos;