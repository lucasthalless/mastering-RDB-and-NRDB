CREATE OR REPLACE PROCEDURE prc_analise_vendas_por_vendedor (
    p_cod_vendedor NUMBER
) IS
    empty_customer_name EXCEPTION;
    empty_product_name EXCEPTION;
BEGIN
    FOR cliente_info IN (
        SELECT
            c.nom_cliente    AS nome_cliente,
            p.nom_produto    AS nome_produto,
            SUM(ip.qtd_item) AS qtd_total
        FROM
            vendedor    v
            LEFT JOIN pedido      pd ON v.cod_vendedor = pd.cod_vendedor
            LEFT JOIN item_pedido ip ON pd.cod_pedido = ip.cod_pedido
            LEFT JOIN produto     p ON ip.cod_produto = p.cod_produto
            LEFT JOIN cliente     c ON pd.cod_cliente = c.cod_cliente
        WHERE
            v.cod_vendedor = p_cod_vendedor
        GROUP BY
            c.nom_cliente,
            p.nom_produto
        ORDER BY
            c.nom_cliente,
            p.nom_produto
    ) LOOP
        IF cliente_info.nome_cliente IS NULL THEN
                RAISE empty_customer_name;
        END IF;
        dbms_output.put_line('Cliente: ' || cliente_info.nome_cliente);
            IF cliente_info.nome_produto IS NULL THEN
                RAISE empty_product_name;
            ELSE
                dbms_output.put_line('  Produto: ' || cliente_info.nome_produto);
                IF cliente_info.qtd_total = 0 THEN
                    dbms_output.put_line('  Perfil: NENHUMA COMPRA REGISTRADA');
                ELSE
                dbms_output.put_line('  Quantidade Total: ' || cliente_info.qtd_total);
                IF cliente_info.qtd_total > 50 THEN
                    dbms_output.put_line('  Perfil: CLIENTE FIEL');
                ELSIF cliente_info.qtd_total BETWEEN 11 AND 50 THEN
                    dbms_output.put_line('  Perfil: CLIENTE RECORRENTE');
                ELSE
                    dbms_output.put_line('  Perfil: CLIENTE OCASIONAL');
                END IF;

            END IF;
        END IF;

        dbms_output.put_line('----------------------------------------');
    END LOOP;
EXCEPTION
    WHEN empty_customer_name THEN
        raise_application_error(-20404, 'Nome do cliente vazio');
    WHEN empty_product_name THEN
        raise_application_error(-20405, 'Nome do produto vazio');
    WHEN no_data_found THEN
        raise_application_error(-20406, 'Nenhum dado encontrado');
END;