-----------------------------------------------------------
-- Avaliação de DWH - Big Data - 2024.1
-- Grupo Formato por:
-- Carlos Henrique Ferreira Brito Filho (DRE 120081409)
-- Bárbara Rodrigues dos Santos Cerqueira (DRE 117198425)
-- Ramon de Attayde Barros de Souza (DRE 122047728)
-- Barbara Varela Bonfim (DRE 120130698)
-----------------------------------------------------------

WITH Movimentacoes AS (
    SELECT 
        ID_PATIO_RETIRADA,
        ID_PATIO_DEVOLUCAO,
        COUNT(*) AS total_movimentacoes
    FROM 
        FatoAluguel
    GROUP BY 
        ID_PATIO_RETIRADA, ID_PATIO_DEVOLUCAO
),
TotalRetiradas AS (
    SELECT 
        ID_PATIO_RETIRADA,
        SUM(total_movimentacoes) AS total_retiradas
    FROM 
        Movimentacoes
    GROUP BY 
        ID_PATIO_RETIRADA
),
Percentuais AS (
    SELECT 
        m.ID_PATIO_RETIRADA,
        m.ID_PATIO_DEVOLUCAO,
        (m.total_movimentacoes * 1.0 / tr.total_retiradas) * 100 AS percentual_movimentacao
    FROM 
        Movimentacoes m
    JOIN 
        TotalRetiradas tr ON m.ID_PATIO_RETIRADA = tr.ID_PATIO_RETIRADA
)
SELECT 
    p.ID_PATIO_RETIRADA AS Patio_Retirada,
    p.ID_PATIO_DEVOLUCAO AS Patio_Devolucao,
    p.percentual_movimentacao AS Percentual_Movimentacao
FROM 
    Percentuais p
ORDER BY 
    p.ID_PATIO_RETIRADA, p.ID_PATIO_DEVOLUCAO;