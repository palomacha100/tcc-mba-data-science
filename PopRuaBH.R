#--Panorama e tendência das pessoas em situação de rua em Belo Horizonte - MG--

##Trabalho de conclusão de curso do MBA em Data Science e Analytics USP/Esalq


#primeiro instala o pacote
install.packages("tidyverse")

#depois carrega o pacote
library(tidyverse)

#importar PopRua jan/2019
pop_rua_01_2019 <- read.csv("01_PopRua_01_2019.csv",
                       sep = ";")

#visualizar PopRua jan/2019
View(pop_rua_01_2019)

head(pop_rua_01_2019, n = 5)

names(pop_rua_01_2019)

nrow(pop_rua_01_2019)
ncol(pop_rua_01_2019)
dim(pop_rua_01_2019)
str(pop_rua_01_2019)
pop_rua_01_2019$TEMPO_VIVIE_NA_RUA

# Criar banco com as 2 variáveis estudadas
pop_rua_01_2019_2v <- pop_rua_01_2019[ , c("TEMPO_VIVIE_NA_RUA", "GRAU_INSTRUCAO")]

# Corrigir nome da variável TEMPO_VIVIE_NA_RUA
nomes <- c("tempo_vive_na_rua", "grau_instrucao")
names(pop_rua_01_2019_2v) <- nomes
