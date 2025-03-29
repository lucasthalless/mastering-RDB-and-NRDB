CREATE OR REPLACE PROCEDURE ListarPedidosCliente (
    p_cod_cliente NUMBER
) AS
BEGIN
    FOR x IN(
        SELECT 
            cod_cliente, 
            val_total_pedido,
            dat_pedido
        FROM PEDIDO WHERE cod_cliente = p_cod_cliente
    ) LOOP
        dbms_output.put_line(x.cod_cliente);
    END LOOP;    
    
END ListarPedidosCliente;