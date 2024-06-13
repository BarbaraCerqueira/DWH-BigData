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
    COUNT(*) AS QUANTIDADE
FROM 
    DimVeiculo V
JOIN 
    FatoAluguel A ON V.ID_VEICULO = A.ID_VEICULO
WHERE 
    A.STATUS = 0 -- Supondo que 0 significa 'no pátio'
GROUP BY 
    V.CATEGORIA, V.MODELO, V.MECANIZACAO
ORDER BY 
    V.CATEGORIA, V.MODELO, V.MECANIZACAO;