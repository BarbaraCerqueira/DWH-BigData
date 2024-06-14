-----------------------------------------------------------
-- Avaliação de DWH - Big Data - 2024.1
-- Grupo Formato por:
-- Carlos Henrique Ferreira Brito Filho (DRE 120081409)
-- Bárbara Rodrigues dos Santos Cerqueira (DRE 117198425)
-- Ramon de Attayde Barros de Souza (DRE 122047728)
-- Barbara Varela Bonfim (DRE 120130698)
-----------------------------------------------------------

SELECT 
    V.CATEGORIA AS Tipo_Veiculo,
    P.NOME_PATIO AS Patio,
    E.CIDADE AS Cidade_Cliente,
    CASE
        WHEN T.DATA BETWEEN CURDATE() AND CURDATE() + INTERVAL 1 WEEK THEN 'Semana que vem'
        WHEN T.DATA BETWEEN CURDATE() AND CURDATE() + INTERVAL 1 MONTH THEN 'Mês que vem'
        ELSE 'Futuro'
    END AS Periodo_Futuro,
    COUNT(*) AS Quantidade_Reservas
FROM 
    DimReserva R
JOIN 
    DimTempo T ON R.ID_TEMPO_INICIO = T.ID_TEMPO
JOIN 
    DimCliente C ON R.ID_CLIENTE = C.ID_CLIENTE
JOIN 
    DimEndereco E ON C.ID_ENDERECO = E.ID_ENDERECO
JOIN 
    DimVeiculo V ON R.ID_VEICULO = V.ID_VEICULO
JOIN 
    DimPatio P ON R.ID_PATIO = P.ID_PATIO
WHERE 
    R.STATUS = 'Ativa'
    AND T.DATA >= CURDATE() -- Considera apenas reservas futuras
GROUP BY 
    V.CATEGORIA, 
    P.NOME_PATIO, 
    E.CIDADE,
    CASE
        WHEN T.DATA BETWEEN CURDATE() AND CURDATE() + INTERVAL 1 WEEK THEN 'Semana que vem'
        WHEN T.DATA BETWEEN CURDATE() AND CURDATE() + INTERVAL 1 MONTH THEN 'Mês que vem'
        ELSE 'Futuro'
    END
ORDER BY 
    V.CATEGORIA, 
    P.NOME_PATIO, 
    E.CIDADE, 
    Periodo_Futuro;