# Modelagem das Entidades e Estados
&emsp;Dificuldade (Iniciante, Intermediario, Especialista): Definidos utilizando abstract sig e herança direta por objetos do tipo one sig. Isso garante que existam exatamente esses três níveis de dificuldade no universo do programa, nem mais, nem menos.

&emsp;Sala: Possui a propriedade dificuldade: one Dificuldade. O quantificador one obriga que toda e qualquer sala instanciada possua exatamente um nível de dificuldade atrelado a ela, cumprindo a primeira exigência.

&emsp;MenorDeIdade in Cliente: Em vez de criar um tipo de dado separado, usamos a palavra-chave in para criar um subconjunto de Cliente. Isso significa que todo menor de idade é um cliente, mas nem todo cliente é menor de idade.

&emsp;Dia e Reserva: Para simular o conceito de "ao mesmo tempo" e "por dia", criamos uma entidade de tempo (Dia) e uma entidade pivot (Reserva). A Reserva amarra graficamente os três pontos cruciais do problema: quem vai jogar (Equipe), onde vai jogar (Sala) e quando vai jogar (Dia).

# Comportamento das Regras Lógicas (fact)
&emsp;lone e: Equipe | c in e.membros: A palavra-chave lone significa zero ou um. Ao aplicar isso a todos os clientes (all c: Cliente), o Alloy permite perfeitamente que existam clientes "soltos" no sistema esperando por um grupo, mas proíbe estritamente que um cliente esteja cadastrado em duas equipes simultâneas.

&emsp;lone r: Reserva | r.equipe = e and r.dia = d: Essa restrição impede que a mesma equipe consiga criar mais de um registro de reserva na mesma data, blindando o fluxo de agendamentos diários do estabelecimento.

&emsp;lone r: Reserva | r.sala = s and r.dia = d: Funciona de forma análoga à regra anterior, mas foca na infraestrutura da sala. Se a Sala X já possui um agendamento associado ao Dia Y, o motor do Alloy impede que qualquer outra equipe tente alocar essa mesma sala nessa mesma data. O fato de mapearmos apenas as salas ativas dentro de Reserva automaticamente permite que salas fiquem totalmente ociosas (sem reservas) se não houver demanda.

&emsp;Contagem de Membros (#r.equipe.membros): O operador # retorna a cardinalidade (quantidade) do conjunto de clientes da equipe. O modelo rejeita qualquer agendamento cuja equipe possua apenas 1 jogador ou mais do que 6 jogadores.

&emsp;O Operador de Interseção (&): Para a regra de segurança, usamos r.equipe.membros & MenorDeIdade. Isso extrai apenas os membros daquela equipe específica que também pertencem ao subconjunto de menores. Ao adicionar o prefixo no, determinamos que esse cruzamento deve ser vazio sempre que a sala for do tipo terror intenso (Especialista).