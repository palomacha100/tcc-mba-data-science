# Resultados Preliminares

Antes de iniciar a análise dos dados foi necessário prepará-los para afastar inconsistências que impactam os resultados. 

Os 48 arquivos compreendendo o período entre os meses de janeiro do ano de 2019 e dezembro de 2022 foram combinados em Excel, dando origem a um único banco de dados com 435.603 linhas intitulado “PopRuaBH_2019_2022.csv”. Em seguida, no ambiente de desenvolvimento R, o arquivo CSV foi lido e importado por meio da função read.csv() que recebeu dois argumentos: o nome do arquivo “PopRuaBH_2019_2022.csv” e o argumento sep = ";" uma vez que o banco de dados utilizou o ponto e vírgula para separar os valores nele contido. Isso assegurou que a função fizesse a interpretação correta da estrutura do arquivo e separasse os valores em colunas. Os dados armazenados no arquivo foram atribuídos à variável “pop_rua_bh”.

Foi criado o vetor de caracteres "nomes" com os novos nomes das categorias, que incluem "tempo_vive_na_rua", "contato_parente_fora_ruas", "data_nascimento", "idade", "sexo", "auxilio_brasil", "pop_rua", "grau_instrucao", "cor_raca", "faixa_renda_familiar_per_capita", "val_remuneracao_mes_passado", "cras", "regional", "faixa_desatualizacao_cadastral" e "referencia". A seguir, a função "names()" foi utilizada para atribuir esses novos nomes às variáveis no conjunto de dados "pop_rua_bh". O objetivo foi tornar os nomes das variáveis mais descritivos, aprimorando a análise e interpretação dos dados.

Foram selecionadas as variáveis "tempo_vive_na_rua" e "grau_instrucao" do banco de dados "pop_rua_bh" para formar um novo conjunto de dados denominado "pop_rua_bh_2v". A variável "tempo_vive_na_rua" descreve o período em que os indivíduos se encontram em situação de rua, enquanto "grau_instrucao" representa o nível de escolaridade. Ambas as variáveis são categorizadas como dados de tipo texto. Essa seleção foca nas informações pertinentes ao objetivo dessa pesquisa.

Através da função "grepl()", a filtragem dos dados foi realizada em duas etapas. Inicialmente, procurou-se valores na variável "grau_instrução" que continham o termo "Informado", incluindo variações com a palavra "não" acentuada ou não, como "Não Informado" e “Nao Informado”. Registros nessa condição foram excluídos. Em seguida, a mesma função foi usada com uma expressão regular que abrangia categorias específicas de grau de instrução. Isso resultou na retenção dos registros com graus de instrução definidos, enquanto os demais, possivelmente campos nulos ou vazios, foram removidos. O objetivo principal foi eliminar dados ausentes ou inconsistentes, contribuindo para a qualidade dos dados analisados.

Deu-se início à fase de processamento. Com a função “table()” uma tabela de contingência com frequências absolutas observadas foi criada. Essa tabela relacionou as variáveis "tempo_vive_na_rua" e "grau_instrucao" do conjunto de dados "pop_rua_bh_2v", evidenciando a associação entre o tempo vivido em situação de rua e o grau de instrução. As frequências variam em diferentes graus de instrução e faixas de tempo em situação de rua. O ensino fundamental incompleto e completo são mais frequentes na faixa de tempo de “até seis meses”. As categorias “sem instrução” e “ensino superior ou mais” são menos frequentes, mas são muito significativas em certos períodos de tempo.


Tabela 1. Tabela de contingência entre tempo nas ruas e grau de instrução da população em situação de rua
	Sem instrução	Ensino fundamental incompleto	Ensino fundamental completo	Ensino médio incompleto	Ensino médio completo	Ensino superior ou mais
Até 6 meses	7156	60606	19755	16997	25290	2078
Entre 6 meses e 1 ano	3771	28346	8981	6296	9278	561
Entre 1 e 2 anos	3229	27447	7425	5439	7449	384
Entre 2 e 5 anos	6077	44311	12235	7514	9278	457
Entre 5 e 10 anos	4684	30365	7723	4011	5904	439
Mais de 10 anos	7705	36215	7008	3298	4553	198
Fonte: Resultados originais da pesquisa

A partir dessa tabela, introduziu-se a análise do teste qui-quadrado [χ²], realizado com a função chisq.test(). O teste qui-quadrado evidenciou uma significativa associação entre o tempo de permanência nas ruas e o grau de escolaridade das pessoas nessa condição. O valor do χ² de 15007 e os graus de liberdade totalizando 25 indicam uma discrepância extremamente alta entre as frequências observadas e esperadas na tabela de contingência e ajudam a entender a complexidade da relação entre o tempo passado nas ruas e o nível de escolaridade. Isso confirma que essa diferença é significativa e que a associação não acontece por acaso. Adicionalmente, o valor-p muito baixo (< 2.2e-16) ressaltou que essa associação não é aleatória, mas possui uma significância substancial.

A partir dos valores oriundos do teste χ², foi possível explorar as relações entre o tempo nas ruas e nível de instrução de pessoas nesse contexto específico. Os resíduos padronizados, obtidos através da expressão qui2$residuals no ambiente R mostraram a diferença entre as frequências observadas e as esperadas na tabela de contingência. Os resíduos padronizados ajustados (qui2$stdres), calculados de maneira ponderada, levaram em consideração tanto o que revelou os resíduos ponderados quanto as frequências totais esperadas em cada célula da tabela. Através dessa ponderação, tornou-se possível conduzir uma análise mais sensível e precisa das associações entre as variáveis, com destaque para as categorias que exercem um papel mais proeminente nas discrepâncias.

Para melhor compreensão dos resíduos padronizados ajustados, foi criado um mapa de calor, com a biblioteca ggplot2 no ambiente de desenvolvimento R. Os resíduos padronizados ajustados foram estruturados em um data frame e as variáveis foram renomeadas para maior clareza. Através da função “mutate”, as categorias das variáveis foram ordenadas para garantir uma representação visual coerente. As categorias de "tempo_vive_na_rua" estão no eixo x, as categorias de "grau_instrucao" estão no eixo y. Os valores dos resíduos são exibidos dentro das células do mapa de calor.

Cada célula do mapa representou uma combinação única de categorias. A cores variaram em uma escala de cinza e as mais intensas indicam discrepâncias maiores entre as frequências observadas e esperadas. Maiores valores de resíduos indicam associações mais fortes entre as categorias das variáveis representadas nos eixos horizontal e vertical do gráfico. 

O mapa de calor, visto na Figura 1, considerou os resíduos padronizados ajustados maiores que 1,96. O valor de referência 1,96 foi utilizado com respaldo na literatura dos autores Fávero e Belfiore (2017), no livro "Manual de Análise de Dados". Esse valor foi indicado como um ponto de corte para estabelecer o intervalo e confiança. Essa referência é amplamente reconhecida na área estatística como uma abordagem comum para calcular intervalos de confiança quando se considera uma distribuição normal padrão. 

Identificou-se a forte associação entre a categoria de tempo “Mais de dez anos” e as categorias de grau de instrução “Sem instrução” e “Ensino fundamental incompleto”. A medida em que o tempo em que essa população está na rua diminui, o mapa de calor mostrou acentuada associação entre os graus de instrução Ensino médio incompleto, Ensino médio completo e Ensino superior incompleto ou mais” com tempo de permanência na rua de até 6 meses.

Tempo que vive na rua	Mais de dez anos	55,147	47,751	-19,545	-38,501	-50,867	-19,005	
	Entre cinco e dez anos	12,271	24,046	0,129	
-20,217
	-24,262	-6,284	
	Entre dois e cinco anos	-0,645	12,952	4,308	-8,514	-10,130	-16,211	
	Entre um e dois anos	-11,153	5,569	-0,449	4,583	-0,652	-7,997	
	Entre seis meses e um ano	-8,906	-14,120	8,551	8,409	11,749	-2,756	
	Até seis meses	-34,843	-57,148	4,827	40,855	55,520	39,989	
		Sem instrução	Ensino
fundamental incompleto	Ensino fundamental completo	Ensino médio incompleto	Ensino médio completo	Ensino superior incompleto ou mais	
	Grau de instrução	
Figura 1. Mapa de calor dos resíduos padronizados ajustados
Fonte: Resultados originais da pesquisa

No contexto analítico desta pesquisa, além da elaboração do mapa de calor, também se percorreu uma série de etapas interdependentes e sequenciais que desempenharam um papel essencial na obtenção de um mapa perceptual. Será demonstrada em detalhes essa sequência.

O primeiro passo consistiu em calcular a matriz A, na qual os resíduos padronizados foram divididos pela raiz quadrada do tamanho da amostra. Isso resultou na normalização das diferenças entre os resíduos padronizados. Em seguida, prosseguiu-se com o cálculo da matriz W por meio da multiplicação da matriz A transposta pela matriz A e assim obteve-se uma melhor representação das associações de forma a condensar a informação contida na matriz A.

Com base na matriz W, avançou-se para determinar o número de dimensões que serão incluídas na análise, visto que nem todas são igualmente relevantes para o prosseguimento da pesquisa. Esse cálculo foi realizado considerando o menor valor entre o número de linhas e o número de colunas da matriz W, e então subtraindo 1 de cada um desses valores, focando nas dimensões mais significativas para a análise.

A partir desse ponto, a função "svd" foi empregada para obter os valores singulares da matriz A. Esses valores indicam quais dimensões são mais relevantes para a análise, fornecendo informações sobre onde ocorre a maior parte da variação dos dados. Em seguida, foram selecionados os valores singulares de acordo com a quantidade de dimensões previamente determinada. Esses valores ressaltam quais dimensões são mais importantes para a compreensão dos dados.

A próxima fase foi a obtenção dos autovalores onde quantifica-se a relevância de cada dimensão em nosso contexto analítico. Esse processo envolveu elevar ao quadrado os valores singulares anteriormente calculados.

Avançou-se para uma medida adicional. Ao dividir o valor estatístico do teste do qui-quadrado pelo total das frequências presentes na tabela de contingência, foi possível chegar à inércia principal total. Essa medida ofereceu uma compreensão da proporção de variação que cada dimensão é capaz de capturar.

Prosseguindo, calculou-se a variância explicada em cada dimensão para entender o quanto cada uma contribuiu para a variação global nos dados. Esse cálculo envolveu a divisão dos autovalores pela inércia total previamente obtida.

A Tabela 2 apresenta um conjunto de informações resultantes dos cálculos realizados. Cada linha representa uma dimensão da análise e as colunas fornecem medidas para avaliar a relevância e contribuição de cada dimensão.

A Dimensão 1 possui um valor singular de 0.1796767, indicando sua significância na análise. A inércia principal e parcial associada a essa dimensão é de 0.0322837, demonstrando que essa dimensão captura uma parcela substancial da variação nos dados. O percentual da inércia principal total é notavelmente alto, representando cerca de 93.54% da variação total. Isso reflete o fato de que a Dimensão 1 sozinha consegue explicar uma proporção substancial da variação total dos dados.

Ao observar a Dimensão 2, seu valor singular é 0.0424553, sugerindo relevância, porém menor que na Dimensão 1. O percentual da inércia principal total dessa dimensão contribui com aproximadamente 5.22% na variação total. A percentual da inércia principal acumulada atingiu quase 98.76% com as duas primeiras dimensões.

Na Dimensão 3, o percentual da inércia principal total diminui consideravelmente para cerca de 0.73%, indicando uma contribuição menor para a variação total.

Já Dimensão 4 revela um percentual da inércia principal total de aproximadamente 0.50%, significando uma contribuição ainda menor para a variação total. A Dimensão 5 possui o menor valor singular, 0.0020512, e a inércia principal e parcial mais baixa, 0.0000042. O percentual da inércia principal total é de apenas 0.01%, evidenciando uma contribuição mínima para a variação total. O percentual da inércia principal acumulada atinge 100.00%, indicando que com todas as cinco dimensões, abrangeu-se a totalidade da variação.

A análise desses números destaca a importância das duas primeiras dimensões na explicação da variação dos dados. As dimensões subsequentes contribuem de forma decrescente. Essa avaliação auxilia na determinação do número de dimensões relevantes para construir um mapa perceptual eficaz.

Tabela 2. Dimensões e proporção da inércia na análise de correspondência
Dimensão	Valor singular	Inércia principal e parcial	χ²	Percentual da inércia principal total	Percentual da inércia principal acumulada
Dimensão 1	0.1796767	0.0322837	3.2283726	93.5353619	93.53536
Dimensão 2	0.0424553	0.0018025	0.1802452	5.2222296	98.75759
Dimensão 3	0.0159039	0.0002529	0.0252935	0.7328253	99.49042
Dimensão 4	0.0131025	0.0001717	0.0171675	0.4973930	99.98781
Dimensão 5	0.0020512	0.0000042	0.0004207	0.0121903	100.00000
Fonte: Resultados originais da pesquisa

Partiu-se para o cálculo das massas das colunas e das linhas. Primeiro foram feitas as somas das colunas da tabela de contingência usando a função "apply". O resultado foi um vetor que representa a soma total de cada categoria em todas as colunas, mostrando a frequência total de cada uma ao longo das dimensões. Para obter as massas das colunas, o vetor das somas das colunas foi divido pelo número total de observações, fornecendo as proporções das massas de cada categoria em relação ao total de observações.

Em sequência, realizou-se o cálculo das somas das linhas da tabela de contingência. Também com a função "apply" foi feita a soma dos valores em cada coluna ao longo das linhas, resultando em um vetor que reflete a soma total de cada categoria em todas as linhas. 

Da mesma forma que com as massas das colunas, o vetor das somas das linhas foi divido pelo número total de observações para obter as massas das linhas normalizadas, representando a proporção de cada categoria em relação ao total de observações, mas agora considerando as dimensões de linhas.

Após o cálculo das massas, ficou evidente que, na variável de tempo nas ruas, a categoria “Até seis meses” teve maior peso, sendo 0.3047. Na análise de correspondência, ela é a que apresentou maior importância relativa entre as categorias dessa variável. Já para a variável grau de instrução, a categoria “Ensino fundamental incompleto”, com peso 0.5227, mostrou ter maior influência para compor a estrutura dos dados.

Todos esses resultados foram de fundamental importância para a construção do mapa perceptual e na determinação das coordenadas das categorias nesse mapa, levando em consideração as duas dimensões que são as principais fontes de variação do estudo.

As coordenadas das categorias da variável "tempo_vive_na_rua" ao longo do eixo horizontal (abcissas) são calculadas utilizando informações como os valores singulares, as massas das colunas e os autovetores correspondentes à primeira dimensão. Essa etapa permite posicionar as categorias no mapa de acordo com sua relação específica com essa dimensão.

De forma similar, as coordenadas das categorias da variável "tempo_vive_na_rua" também são determinadas, mas desta vez ao longo do eixo vertical (ordenadas) do mapa perceptual. Novamente, os cálculos envolvem os valores singulares, massas das colunas e autovetores associados à segunda dimensão. Essa abordagem contribui para a representação espacial das relações entre as categorias e a segunda dimensão.

Essas duas etapas também são realizadas para a variável "grau_instrucao", considerando as posições das categorias em relação a ambas as dimensões calculadas.

Para criação do gráfico, as coordenadas das categorias das variáveis de tempo e grau de instrução resultantes foram combinadas em um único dataframe, mostrando a posição dessas categorias nas duas dimensões principais da análise. Em seguida, o dataframe foi reorganizado em um formato "tidy" no ambiente R, onde cada linha indicou uma categoria e cada coluna, uma variável.

A etapa de plotagem começou utilizando a biblioteca ggplot2. Primeiro, pontos são criados para representar as categorias da variável "tempo_vive_na_rua" nas dimensões 1 e 2. Esses pontos são representados por losangos. Rótulos de texto foram adicionados usando geom_text_repel para evitar sobreposição.

A plotagem prosseguiu com a criação de pontos para representar as categorias da variável "grau_instrucao" nas mesmas dimensões 1 e 2. Esses pontos possuem o formato de um quadrado. Linhas verticais e horizontais de referência foram adicionadas nos valores zero das dimensões 1 e 2. As legendas dos eixos x e y foram configuradas com base nos valores explicados das duas dimensões, contribuindo para a compreensão da variação dos dados.

Como resultado final, foi produzido um mapa perceptual que ilustra as posições das categorias das variáveis "tempo_vive_na_rua" e "grau_instrucao" e pode ser visualizado na Figura 2.

 
Figura 2. Mapa perceptual do perfil da população em situação de rua de Belo Horizonte em relação ao tempo em que vive na rua e seu grau de instrução
Fonte: Resultados originais da pesquisa

A análise do mapa de calor revelou padrões significativos na relação entre o tempo que as pessoas vivem na rua e o nível de educação. Essas descobertas estão alinhadas com os perfis identificados no mapa perceptual, que categorizou os indivíduos em quatro grupos com base na proximidade de suas características. No primeiro perfil, notou-se que o grau de instrução "Ensino médio incompleto", "Ensino médio completo" e "Ensino superior incompleto ou mais" estava associado ao período de até seis meses vivendo nas ruas. O segundo perfil agrupou aqueles com "ensino fundamental completo" com um tempo na rua entre seis meses e dois anos. O terceiro perfil abrangia pessoas desabrigadas entre dois e dez anos com ensino fundamental incompleto, enquanto no Perfil 4 se destacou a relação entre pessoas sem instrução que estavam em situação de rua há mais de dez anos.

Esses perfis encontrados no mapa perceptual são corroborados pelos dados do recenseamento da população em condição de rua conduzido pela Faculdade de Medicina da Universidade Federal de Minas Gerais, a pedido da Prefeitura de Belo Horizonte (2023), nos dias 19, 20 e 21 de outubro de 2022. As proporções das categorias observadas no censo refletem diretamente os perfis identificados no mapa perceptual.

O censo revela que 91,4% dos entrevistados aspiram a sair das ruas, muitos mencionaram a educação/formação profissional (17%) e o trabalho assalariado (55%) como meios para deixar essa situação. A correspondência entre o perfil associando indivíduos de maior nível educacional a um tempo mais curto nas ruas e o desejo de sair dessa condição evidencia o papel crucial da educação e qualificação na reintegração social e prevenção da situação de rua. Pessoas com maior nível educacional têm menor probabilidade de entrar nessa situação vulnerável, possivelmente devido a maiores oportunidades de emprego, e mais opções ou oportunidades de lidar com os desafios econômicos. Assim, a educação não apenas contribui para a reintegração social daqueles já estão em situação de rua, mas também desempenha um papel preventivo, reduzindo as chances de pessoas com maior nível educacional chegarem a essa condição. Isso reforça a importância da abordagem educacional como um fator-chave na prevenção e enfrentamento da situação de rua, permitindo que indivíduos alcancem maior estabilidade e participação na sociedade.

Isso ressalta também a importância de ações de inclusão produtiva mencionadas no programa "Estamos Juntos", para qualificação profissional, divulgado pela Prefeitura de Belo Horizonte (2023) com base nos dados do censo de 2022. O programa visa o fomento e a garantia da integração da população em situação de rua no ambiente laboral. Especificamente, para aquelas pessoas que estão em situação de rua há muito tempo e possuem baixa ou nenhuma escolaridade, essa iniciativa se torna ainda mais relevante.

Em comparação com o censo anterior (2014), realizado em 2013, a população triplicou em Belo Horizonte, chegando ao número de 5.300 pessoas, e o tempo médio de permanência da população desabrigada cresceu de 7,4 para 11 anos. Esse aumento do tempo médio confirma empiricamente a realidade refletida nos perfis delineados no mapa perceptual pois reforça a existência de grupos claramente diferenciados de pessoas que realmente enfrentam períodos mais prolongados de vida nas ruas. Esse crescimento pode ser interpretado como um reflexo das dificuldades enfrentadas por pessoas com menos oportunidades educacionais para superar suas circunstâncias e encontrar saídas viáveis.

Os dados de escolaridade do censo acrescentam profundidade à interpretação dos perfis. A concentração significativa de pessoas com "anos finais do ensino fundamental incompleto" (21,4%) e "anos iniciais do ensino fundamental incompleto" (19,4%) em um perfil associado a um tempo de vida mais prolongado nas ruas demonstra de maneira concreta a influência crucial da educação na definição das trajetórias das pessoas em situação de rua. Além disso, a notável predominância ressalta a predisposição desse grupo a enfrentar um período mais longo de vida nas ruas, possivelmente devido a barreiras educacionais e de emprego que dificultam a transição para uma situação mais estável. 

Ao observar os dados sobre trabalho no censo, nota-se categorias específicas, como "Profissional do sexo" e "Chapa de caminhão", que estão associadas a diferentes formas de emprego. Muitas vezes, esses empregos são informais e precários. A presença dessas categorias é importante, pois traz à tona considerações relevantes para entender os perfis identificados no mapa perceptual. Ao reconhecer que essas categorias frequentemente refletem ocupações pouco convencionais, pode-se entender como as circunstâncias socioeconômicas dessas pessoas influenciam suas opções de emprego.

A informalidade dessas ocupações pode estar relacionada à falta de acesso a oportunidades de emprego formal, à falta de qualificação educacional ou à dificuldade de entrar no mercado de trabalho tradicional. Isso, por sua vez, pode se alinhar aos perfis identificados no mapa perceptual, destacando conexões potenciais entre níveis de educação, experiência de vida na rua e tipos de trabalho. Muitas vezes, pessoas desabrigadas recorrem a trabalhos como "Profissional do sexo" ou "Chapa de caminhão" devido à falta de alternativas, podendo ser uma resposta à falta de apoio social, educação e oportunidades.

A constatação de que 18% das pessoas em situação de rua atribuem seu estado à falta de emprego, de acordo com o censo, também valida os perfis identificados no mapa perceptual. Essa correlação destaca que a busca por oportunidades de trabalho é um fator chave que explica a relação entre nível educacional, tempo nas ruas e permanência nessa condição. A consistência entre os dados do censo e o mapa perceptual reforça a importância das associações delineadas nos perfis. 

Ademais, o censo revela que 13,3% das pessoas em situação de rua estão nessa condição devido à renda insuficiente, e 6,2% foram despejadas por falta de pagamento. Essas porcentagens reforçam as considerações do mapa perceptual e do mapa de calor. As categorias de trabalho no censo, como "Profissional do sexo", "Chapa de caminhão", "Faz faxina", "Construção Civil" e outras, frequentemente associadas a baixos rendimentos, estão em sintonia com os perfis identificados. Essa relação reforça a ligação entre tipos de trabalho precários e renda insuficiente, contribuindo para a compreensão das razões pelas quais determinados grupos são mais propensos a permanecer em situação de rua.

Em resumo, os resultados do mapa perceptual, juntamente com os dados do censo, estabelecem relações coerentes e relevantes entre as categorias de tempo vivendo na rua, grau de instrução e aspirações da população em situação de rua. A consistência entre os perfis e os dados do censo valida a importância desses resultados e fornece um embasamento sólido para ações e políticas voltadas para essa população.
