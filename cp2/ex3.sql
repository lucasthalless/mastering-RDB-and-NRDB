SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE prc_relatorio_pedidos_por_cliente IS
    empty_address EXCEPTION;
    empty_city EXCEPTION;
BEGIN
    FOR cliente_info IN (
        SELECT
            cl.nom_cliente                 AS nome_cliente,
            ci.nom_cidade                  AS nome_cidade,
            COUNT(hp.cod_pedido)           AS qtd_pedidos,
            SUM(hp.val_total_pedido)       AS total_comprado,
            COUNT(hp.dat_cancelamento)     AS qtd_pedidos_cancelados,
            COUNT(ec.seq_endereco_cliente) AS qtd_enderecos_cliente
        FROM
            cliente          cl
            LEFT JOIN endereco_cliente ec ON cl.cod_cliente = ec.cod_cliente
            LEFT JOIN cidade           ci ON ec.cod_cidade = ci.cod_cidade
            LEFT JOIN historico_pedido hp ON cl.cod_cliente = hp.cod_cliente
        GROUP BY
            cl.nom_cliente,
            ci.nom_cidade
        ORDER BY
            cl.nom_cliente
    ) LOOP
        IF cliente_info.nome_cidade IS NULL THEN
            RAISE empty_city;
        END IF;
        IF cliente_info.qtd_enderecos_cliente IS NULL THEN
            RAISE empty_address;
        END IF;
        dbms_output.put_line('Cliente: ' || cliente_info.nome_cliente);
        dbms_output.put_line('Cidade: ' || cliente_info.nome_cidade);
        dbms_output.put_line('Quantidade de Pedidos: ' || cliente_info.qtd_pedidos);
        dbms_output.put_line('Valor Total Comprado: ' || cliente_info.total_comprado);
        IF cliente_info.qtd_pedidos_cancelados > 0 THEN
            dbms_output.put_line('Houve Pedido(s) Cancelado(s)');
        END IF;
        dbms_output.put_line('----------------------------------------');
    END LOOP;
EXCEPTION
    WHEN empty_address THEN
        raise_application_error(-20404, 'Cliente sem endereço');
    WHEN empty_city THEN
        raise_application_error(-20405, 'Nome da cidade vazio');
END;