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
    COUNT(A.ID_ALUGUEL) AS QUANTIDADE_ALUGUEIS,
    E.CIDADE AS CIDADE_ORIGEM_CLIENTE
FROM 
    DimVeiculo V
JOIN 
    FatoAluguel A ON V.ID_VEICULO = A.ID_VEICULO
JOIN 
    DimCliente C ON A.ID_CLIENTE = C.ID_CLIENTE
JOIN 
    DimEndereco E ON C.ID_ENDERECO = E.ID_ENDERECO
WHERE 
    A.STATUS = 1 -- Supondo que 1 significa 'alugado'
GROUP BY 
    V.CATEGORIA, V.MODELO, E.CIDADE
ORDER BY 
    QUANTIDADE_ALUGUEIS DESC;