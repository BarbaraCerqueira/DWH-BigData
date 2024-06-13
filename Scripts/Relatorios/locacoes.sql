-----------------------------------------------------------
-- Avaliação de DWH - Big Data - 2024.1
-- Grupo Formato por:
-- Carlos Henrique Ferreira Brito Filho (DRE 120081409)
-- Bárbara Rodrigues dos Santos Cerqueira (DRE 117198425)
-- Ramon de Attayde Barros de Souza (DRE 122047728)
-- Barbara Varela Bonfim (DRE 120130698)
-----------------------------------------------------------


SELECT 
    V.CATEGORIA,
    V.MODELO,
    V.MECANIZACAO,
    A.ID_ALUGUEL,
    T_RETIRADA.DATA AS DATA_RETIRADA,
    T_DEVOLUCAO_PREVISTA.DATA AS DATA_DEVOLUCAO_PREVISTA,
    DATEDIFF(T_DEVOLUCAO_PREVISTA.DATA, CURDATE()) AS TEMPO_RESTANTE_DIAS
FROM 
    DimVeiculo V
JOIN 
    FatoAluguel A ON V.ID_VEICULO = A.ID_VEICULO
JOIN 
    DimTempo T_RETIRADA ON A.ID_TEMPO_RETIRADA = T_RETIRADA.ID_TEMPO
JOIN 
    DimTempo T_DEVOLUCAO_PREVISTA ON A.ID_TEMPO_DEVOLUCAO_PREVISTA = T_DEVOLUCAO_PREVISTA.ID_TEMPO
WHERE 
    A.STATUS = 1 -- Supondo que 1 significa 'alugado'
ORDER BY 
    V.CATEGORIA, V.MODELO, V.MECANIZACAO;