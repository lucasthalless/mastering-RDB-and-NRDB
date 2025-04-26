CREATE OR REPLACE PROCEDURE prc_movimentacao_produto_por_vendedor IS
BEGIN
    FOR vendedor_info IN (
        SELECT
            v.cod_vendedor,
            v.nom_vendedor           AS nome_vendedor,
            p.cod_produto,
            p.nom_produto            AS nome_produto,
            COUNT(hp.cod_pedido)     AS qtd_pedidos,
            SUM(hp.val_total_pedido) AS valor_total
        FROM
            vendedor         v
            RIGHT JOIN historico_pedido hp ON v.cod_vendedor = hp.cod_vendedor
            LEFT JOIN item_pedido      ip ON hp.cod_pedido = ip.cod_pedido
            LEFT JOIN produto          p ON p.cod_produto = ip.cod_produto
        GROUP BY
            v.cod_vendedor,
            v.nom_vendedor,
            p.cod_produto,
            p.nom_produto
        ORDER BY
            v.nom_vendedor,
            p.nom_produto
    ) LOOP
        dbms_output.put_line('Vendedor: ' || vendedor_info.nome_vendedor);
        IF vendedor_info.cod_produto IS NULL THEN
            dbms_output.put_line('Sem vendas registradas');
        ELSE
            dbms_output.put_line('Produto: ' || vendedor_info.nome_produto);
            dbms_output.put_line('Quantidade Total: ' || vendedor_info.qtd_pedidos);
            dbms_output.put_line('Valor Total: ' || vendedor_info.valor_total);
        END IF;

        dbms_output.put_line('----------------------------------------');
    END LOOP;
END;