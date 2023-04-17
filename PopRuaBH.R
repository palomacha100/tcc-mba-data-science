#--Panorama e tendência das pessoas em situação de rua em Belo Horizonte - MG--

##Trabalho de conclusão de curso do MBA em Data Science e Analytics USP/Esalq


# Instalação e carregamento dos pacotes utilizados
pacotes <- c("plotly", #plataforma gráfica
             "tidyverse", #carregar outros pacotes do R
             "ggrepel", #geoms de texto e rótulo para 'ggplot2' que ajudam a evitar sobreposição de textos
             "knitr", "kableExtra", #formatação de tabelas
             "sjPlot", #elaboração de tabelas de contingência
             "FactoMineR", #função 'CA' para elaboração direta da Anacor
             "amap", #funções 'matlogic' e 'burt' para matrizes binária e de Burt
             "ade4") #função 'dudi.acm' para elaboração da ACM

if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for(i in 1:length(instalador)) {
    install.packages(instalador, dependencies = T)
    break()}
  sapply(pacotes, require, character = T) 
} else {
  sapply(pacotes, require, character = T) 
}

# importar banco de dados
pop_rua_bh <- read.csv("PopRuaBH_2019_2022.csv",
                       sep = ";")

# alterar nomes das categorias
nomes <- c("tempo_vive_na_rua", "contato_parente_fora_ruas", "data_nascimento",
           "idade", "sexo", "auxilio_brasil", "pop_rua", "grau_instrucao", 
           "cor_raca", "faixa_renda_familiar_per_capita", "val_remuneracao_mes_passado",
           "cras", "regional", "faixa_desatualizacao_cadastral", "mes_ano_referencia")

names(pop_rua_bh) <- nomes

# Criar banco com as 3 variáveis a serem estudadas
pop_rua_bh_3v <- pop_rua_bh[ , c("tempo_vive_na_rua", "grau_instrucao", "mes_ano_referencia")]

# Remover linhas com campo "Não informado"
pop_rua_bh_3v <- pop_rua_bh_3v[-grep("Não Informado", pop_rua_bh_3v$grau_instrucao), ]

# Visualizar banco de dados 
View(pop_rua_bh_3v)
  

# Tabelas de frequência das variáveis
summary(pop_rua_bh_3v)



## 1ª Parte: Análise da associação por meio de tabelas

# Tabela de contingência com frequências absolutas observadas
tabela_contingencia <- table(pop_rua_01_2019_2v$tempo_vive_na_rua,
                             pop_rua_01_2019_2v$grau_instrucao)
tabela_contingencia

# Definição da quantidade de observações na tabela de contingência
n <- sum(tabela_contingencia)
n

# Estatística qui-quadrado e teste
qui2 <- chisq.test(x = tabela_contingencia)
qui2

# Tabela de contingência com frequências absolutas observadas
qui2$observed

# Tabela de contingência com frequências absolutas esperadas
qui2$expected

# Tabela de contingência com frequências absolutas observadas e esperadas
sjt.xtab(var.row = pop_rua_01_2019_2v$tempo_vive_na_rua,
         var.col = pop_rua_01_2019_2v$grau_instrucao,
         show.exp = TRUE)

# Resíduos – diferenças entre frequências absolutas observadas e esperadas
qui2$observed - qui2$expected

# Valores de qui-quadrado por célula
((qui2$observed - qui2$expected)^2)/qui2$expected

# Resíduos padronizados
qui2$residuals

# Resíduos padronizados ajustados
qui2$stdres

# Mapa de calor dos resíduos padronizados ajustados
data.frame(qui2$stdres) %>%
  rename(tempo_vive_na_rua = 1,
         grau_instrucao = 2) %>% 
  ggplot(aes(x = fct_rev(tempo_vive_na_rua), y = grau_instrucao,
             fill = Freq, label = round(Freq, 3))) +
  geom_tile() +
  geom_text(size = 5) +
  scale_fill_gradient2(low = "white", 
                       mid = "white", 
                       high = "purple",
                       midpoint = 1.96) +
  labs(x = 'Tempo vive na rua', y = 'Grau instrução', fill = "Res. Pad. Ajustados") +
  coord_flip() +
  theme_bw()

## 2ª Parte: Análise da associação por meio do mapa perceptual

# Definição da matriz A
# Resíduos padronizados (qui2$residuals) divididos pela raiz quadrada do tamanho da amostra (n)
matrizA <- qui2$residuals/sqrt(n)
matrizA

# Definição da matriz W
# Multiplicação da matriz A transposta pela matriz A
matrizW <- t(matrizA) %*% matrizA
matrizW

# Definição da quantidade de dimensões
qtde_dimensoes <- min(nrow(matrizW) - 1, ncol(matrizW) - 1)
qtde_dimensoes

# Definição dos valores singulares
VS_AV <- svd(matrizA, nu = qtde_dimensoes, nv = qtde_dimensoes)

# Valores singulares de cada dimensão
valores_singulares <- VS_AV$d[1:qtde_dimensoes]
valores_singulares

# Autovalores (eigenvalues) de cada dimensão
eigenvalues <- (valores_singulares)^2
eigenvalues

# Cálculo da inércia principal total (a partir do qui-quadrado)
inercia_total <- as.numeric(qui2$statistic/sum(tabela_contingencia))
inercia_total

# Cálculo da variância explicada em cada dimensão
variancia_explicada <- eigenvalues / inercia_total
variancia_explicada

# Cálculo das massas das colunas (column profiles)
soma_colunas <- apply(tabela_contingencia, MARGIN = 1, FUN = sum)
soma_colunas

# Massas das colunas (column profiles)
massa_colunas <- soma_colunas / n
massa_colunas

# Cálculo das massas das linhas (row profiles)
soma_linhas <- apply(tabela_contingencia, MARGIN = 2, FUN = sum)
soma_linhas

# Massas das linhas (row profiles)
massa_linhas <- soma_linhas / n
massa_linhas

# Autovetores v das dimensões
autovetor_v <-VS_AV$v
autovetor_v

# Autovetores u das dimensões
autovetor_u <-VS_AV$u
autovetor_u

# Resumindo as informações até aqui
data.frame(Dimensão = paste("Dimensão", 1:qtde_dimensoes),
           `Valor Singular` = valores_singulares,
           `Inércia Principal Parcial eigenvalues` = eigenvalues) %>%
  mutate(`Percentual da Inércia Principal Total` = (`Inércia.Principal.Parcial.eigenvalues`/inercia_total) * 100,
         `Percentual da Inércia Principal Total Acumulada` = cumsum(`Percentual da Inércia Principal Total`),
         Qui2 = qui2$statistic[[1]] * `Percentual da Inércia Principal Total` / n,
         `Valor Singular` = `Valor.Singular`,
         `Inércia Principal Parcial eigenvalues` = Inércia.Principal.Parcial.eigenvalues) %>%
  select(Dimensão, `Valor Singular`, `Inércia Principal Parcial eigenvalues`,
         Qui2, `Percentual da Inércia Principal Total`,
         `Percentual da Inércia Principal Total Acumulada`) %>%
  kable() %>%
  kable_styling(bootstrap_options = "striped", 
                full_width = FALSE, 
                font_size = 17)

# Calculando as coordenadas para plotar as categorias no mapa perceptual

# Variável em linha na tabela de contingência ('perfil')
# Coordenadas das abcissas
coord_abcissas_tempo_vive_na_rua <- sqrt(valores_singulares[1]) * (massa_colunas^-0.5) * autovetor_u[,1]
coord_abcissas_tempo_vive_na_rua

# Coordenadas das ordenadas
coord_ordenadas_tempo_vive_na_rua <- sqrt(valores_singulares[2]) * (massa_colunas^-0.5) * autovetor_u[,2]
coord_ordenadas_tempo_vive_na_rua

# Variável em coluna na tabela de contingência ('aplicacao')
# Coordenadas das abcissas
coord_abcissas_grau_instrucao <- sqrt(valores_singulares[1]) * (massa_linhas^-0.5) * autovetor_v[,1]
coord_abcissas_grau_instrucao

# Coordenadas das ordenadas
coord_ordenadas_grau_instrucao <- sqrt(valores_singulares[2]) * (massa_linhas^-0.5) * autovetor_v[,2]
coord_ordenadas_grau_instrucao

# Mapa perceptual
# O resultado pode ser obtido por meio da função 'CA' do pacote 'FactoMineR'
anacor <- CA(tabela_contingencia, graph = TRUE)


