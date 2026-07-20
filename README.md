# Simulador Tático de Redes e Coloração de Grafos

## 👤 Identificação do Aluno
* **Nome Completo:** João Pedro Ruidivalle Medeiros de Amorim
* **Instituição:** Instituto Federal de Educação, Ciência e Tecnologia do Piauí (IFPI) - Campus Picos
* **Disciplina:** Tópicos Especiais em Computação (2026.1) — Otimização Combinatória
* **Docente:** Prof. João Paulo

---

## 📌 Introdução

Este projeto consiste em um jogo de simulação tática casual desenvolvido com foco no ensino e exploração prática de **Otimização Combinatória** e **Teoria dos Grafos**. A aplicação simula uma sala de situação tática (*war room*) onde o usuário assume o papel de um comandante militar encarregado de implantar bases e estabelecer rotas logísticas seguras entre elas.

### Contexto e Problema Escolhido
O projeto aborda formalmente o problema clássico de **Coloração de Vértices de Grafos**. Na simulação:
* **Vértices ($V$):** Representam as bases militares implantadas no mapa.
* **Arestas ($E$):** Representam as estradas e rotas de suprimento conectando bases adjacentes.
* **Cores (Especializações):** Representam os 4 tipos de funções táticas das bases (Comando, Armamento, Combustível e Suporte Médico).

**Restrição Principal:** Duas bases diretamente conectadas por uma estrada não podem compartilhar a mesma especialização (cor). Isso garante o fluxo equilibrado de recursos e evita redundâncias ou vulnerabilidades no sistema de distribuição.

### Estratégia Algorítmica e Complexidade
* **Classificação do Problema:** O problema de decisão da $k$-coloração de grafos para $k \\ge 3$ cores pertence à classe dos problemas **NP-Completos**. Encontrar o Número Cromático $\\chi(G)$ (menor número absoluto de cores necessário) via métodos exatos exige tempo computacional exponencial, tornando-se inviável para redes dinâmicas em tempo real.
* **Estratégia Adotada:** Para contornar a limitação de tempo de processamento, adotou-se uma **Heurística Gulosa (Greedy Algorithm)**.
* **Funcionamento da Heurística:** O algoritmo varre sequencialmente cada nó do grafo, analisa as cores já atribuídas aos seus vizinhos diretos e atribui a primeira cor disponível que não gere conflitos. Essa abordagem garante uma complexidade temporal de ordem polinomial $O(V^2)$, permitindo o recálculo instantâneo da rede a cada interação do usuário.

---

## 🛠️ Desenvolvimento e Lógica da Aplicação

### Formulário Teórico do Problema
* **Função Objetivo:** Minimizar a ocorrência de conflitos de adjacência (atribuir tipos válidos a $100\\%$ dos vértices da rede).
* **Variáveis de Decisão:** $x_{i} \\in \\{\\text{Comando}, \\text{Armamento}, \\text{Combustível}, \\text{Médico}\\}$, representando a especialização atribuída a cada nó $i \\in V$.
* **Restrições:**
  1. $\\forall (i, j) \\in E \\implies x_i \\neq x_j$ (vértices adjacentes não podem ter a mesma cor).
  2. $\\text{Grau}(i) \\le \\text{Limite Máximo de Conexões}$ (restrição tática configurável via UI).
  3. $\\text{Distância}(i, j) \\le \\text{Alcance Máximo da Aresta}$ (restrição de visibilidade e conexão do terreno).

### Stack Tecnológica e Bibliotecas
* **Engine de Desenvolvimento:** Godot Engine 4+
* **Linguagem de Programação:** GDScript / C#
* **Arquitetura de Software:** 
  * *Pattern Singleton:* Implementado em `AudioManager.gd` para gerenciamento global de áudio e efeitos sonoros (*Game Juice*).
  * *Filtragem de Entrada (`_unhandled_input`):* Desacoplamento entre os eventos de clique no mundo do jogo e interações na interface (`CanvasLayer`).

### Estrutura e Lógica dos Scripts
1. **`GraphCalculator.gd`:** Módulo puramente algorítmico responsável por receber a Lista de Adjacência e executar o algoritmo guloso de coloração em tempo real.
2. **`World.gd`:** Gerenciador do mundo que controla o ciclo de vida dos nós (criação via botão esquerdo, deleção via botão direito), cálculo dinâmico de distâncias para geração de arestas e envio de sinalizações para a UI.

---

## 📦 Como Baixar, Executar e Jogar

### 💾 Baixando Executáveis Prontos (Windows & Linux)
Não é necessário compilar o projeto para jogar! Você pode baixar a versão final compilada diretamente na seção de **Releases** do repositório:
1. Acesse a aba **[Releases](../../releases)** na barra lateral do repositório.
2. Baixe o arquivo comprimido referente ao seu sistema operacional:
   * **`Windows`:** Baixe o arquivo `*.zip` da versão Windows e execute o arquivo `.exe`.
   * **`Linux`:** Baixe o arquivo `*.zip` da versão Linux (x86_64) e execute o arquivo binário.
3. Extraia o conteúdo da pasta `.zip` e execute a aplicação diretamente.

### 💻 Executando a Partir do Código Fonte
1. Clone este repositório:
   ```bash
   git clone https://github.com/Juawo/graph-coloring-tactical-map.git
```

2. Abra a **Godot Engine 4+**.
	
3. Importe o arquivo `project.godot`.
	
4. Pressione **F5** para executar o projeto.
	
```

### 🎮 Controles da Aplicação


| Entrada de Controle        | Ação no Simulador                                            |
| -------------------------- | ------------------------------------------------------------ |
| **Clique Esquerdo**            | Instanciar uma nova base no mapa / Interagir com a UI        |
| **Clique Direito**             | Deletar uma base existente ao clicar sobre ela               |
| **Scroll do Mouse**            | Zoom in/out na câmera do mapa                                |
| **Arrasto na UI**              | Ajustar os limites de nós, raio de aresta e conexões máximas |
| **Espaço com clique esquerdo** | Arrastar a câmera pelo mapa                                  |


## 📊 Conclusão

O projeto demonstrou com sucesso a aplicação de algoritmos de **Otimização Combinatória** aplicados ao design de sistemas interativos. A utilização da heurística gulosa provou ser a escolha ideal para o cenário de tempo real, mantendo a responsividade do jogo mesmo durante alterações drásticas na topologia do grafo.

As principais dificuldades encontradas envolveram a sincronização entre a camada de física/renderização da Godot e a estrutura de dados abstrata do grafo (lista de adjacência), além do isolamento correto de inputs da UI para evitar comandos acidentais no mapa.

## 📚 Referências

- **Wikipedia.** _Graph coloring_. Disponível em: [https://en.wikipedia.org/wiki/Graph_coloring](https://en.wikipedia.org/wiki/Graph_coloring).
	
- **IME-USP.** _Vertex coloring of graphs_ (Prof. Paulo Feofiloff). Disponível em: [https://www.ime.usp.br/~pf/algoritmos_para_grafos/aulas/vertex-coloring.html](https://www.ime.usp.br/~pf/algoritmos_para_grafos/aulas/vertex-coloring.html).
	
- **Godot Engine Documentation.** _Input events and Node2D rendering_. Disponível em: [https://docs.godotengine.org/](https://docs.godotengine.org/).
	