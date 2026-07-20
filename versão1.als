/*
  =============================================================================
  SISTEMA DE AGENDAMENTO DE ESCAPE ROOMS
  Especificação Formal e Validação de Regras
  =============================================================================
*/

/*
Um complexo de entretenimento gerencia reservas de Escape Rooms. 
Cada sala de fuga possui exatamente um nível de dificuldade associado que pode ser: Iniciante, Intermediário ou Especialista.
Os clientes do complexo formam equipes para jogar, sendo que um cliente só pode pertencer a, no máximo,
uma equipe por vez (clientes podem estar aguardando sem equipe).
Para garantir o fluxo do estabelecimento, uma equipe pode agendar no máximo uma sala por dia.
Cada sala tem uma restrição física, ela precisa de no mínimo 2 e no máximo 6 jogadores associados à equipe que a reservou.
Existe também uma regra de segurança do complexo, equipes que possuam qualquer jogador classificado como "menor de idade" estão
totalmente proibidas de agendar salas do nível Especialista, que possuem temas de terror intenso não recomendado para menores.
Nenhuma sala pode ser reservada por mais de uma equipe ao mesmo tempo, mas salas podem ficar sem reservas.
*/

abstract sig Boolean {}

one sig True, False extends Boolean {}

sig Jogador {
    ehMenorDeIdade: one Boolean
}

abstract sig Nivel {}

one sig Iniciante, Intermediario, Especialista extends Nivel {}

sig Sala {
    nivel: one Nivel
}

sig Equipe {
    jogadores: set Jogador
}

sig Dia {}

sig Reserva {
    dia: one Dia,
    equipe: one Equipe,
    sala: one Sala
}


fact {
	//para quaisquer duas equipes disjuntas e1 e e2 não devem compartilhar nenhum jogador
	all disj e1,e2: Equipe | no (e1.jogadores & e2.jogadores)

	// para quaisquer Reservas disjuntas r1 e r2, se forem reservadas pela mesma equipe então o dia desse ser diferente
	all disj r1,r2: Reserva | (r1.equipe = r2.equipe) implies (r1.dia != r2.dia)
	
	// toda equipe deve ter no minimo 2 e no máximo 6 jogadores
	all e: Equipe | TemNumeroDeJogadoresValido[e.jogadores]
	
	// Só é possivel reservar uma sala no nivel especialista se a equipe não possui nenhum jogador de menor
	all r: Reserva | (r.sala.nivel = Especialista) implies not TemJogadorDeMenor[r.equipe]

	// Nenhuma sala pode ser usada ao mesmo tempo por diferentes equipes
	all disj r1, r2: Reserva | (r1.sala = r2.sala) implies (r1.dia != r2.dia)

}

pred TemNumeroDeJogadoresValido[j: set Jogador] {
	#j >= 2 and #j <= 6
}

pred TemJogadorDeMenor[e: Equipe] {
	some j: e.jogadores | j.ehMenorDeIdade = True
}

// Testes de Sanidade

//Testa se o sistema aceita criar equipes dentro do intervalo exigido
pred CriarEquipeMedia {
	some r: Reserva | #r.equipe.jogadores = 4
}

//Testa se é possivel criar equipes com o valor minimo de integrantes
pred CriarEquipeLimiteInferir {
	some r: Reserva | #r.equipe.jogadores = 2
}

// Testa se é possivel criar equipes com valor maximo de integrantes
pred CriarEquipeLimiteSuperior {
	some r: Reserva | #r.equipe.jogadores = 6
}

// Testa se um time com um jogador menor de idade pode criar jogar em uma sala de nivel intermediario
pred EquipeComMenorDificuldadeIntermediaria {
	some r: Reserva | r.sala.nivel = Intermediario && TemJogadorDeMenor[r.equipe]
}

//Testa se uma equipe sem menores de idade pode jogar em salas especialista
pred EquipeEspecialistaValido{
	some r: Reserva| r.sala.nivel = Especialista && not TemJogadorDeMenor[r.equipe]
}

//Testa se o sistema aceita um jogador sem equipe
pred ClienteSemEquipe{
	some j: Jogador | no e: Equipe | j in e.jogadores
}

run CriarEquipeMedia for 5

run CriarEquipeLimiteInferir for 5

run CriarEquipeLimiteSuperior for 7

run EquipeComMenorDificuldadeIntermediaria for 5

run EquipeEspecialistaValido for 5

run ClienteSemEquipe for 5


// Testes de checagem:

// Teste para ver se nenhum cliente tá em duas equipes ao mesmo tempo
assert ClienteEmNoMaximoUmaEquipe {
    no j: Jogador | some disj e1, e2: Equipe | j in e1.jogadores and j in e2.jogadores
}

// Garante que a mesma equipe não marque duas salas diferentes na mesma data
assert MaximoUmaReservaEquipePorDia {
    no disj r1, r2: Reserva | r1.equipe = r2.equipe and r1.dia = r2.dia
}

// Checa se a equipe da reserva tem o tamanho certo (entre 2 e 6 pessoas)
assert RestricaoFisicaDeJogadores {
    all r: Reserva | #r.equipe.jogadores >= 2 and #r.equipe.jogadores <= 6
}

// Se a sala for Especialista (terror), não pode ter nenhum menor de idade na equipe
assert SegurancaMenoresDeIdade {
    no r: Reserva | (r.sala.nivel = Especialista) and (some j: r.equipe.jogadores | j.ehMenorDeIdade = True)
}

// Confere se duas equipes não alugaram a mesma sala no mesmo dia (evita choque de horário)
assert ExclusividadeDaSalaNoDia {
    no disj r1, r2: Reserva | r1.sala = r2.sala and r1.dia = r2.dia
}

check ClienteEmNoMaximoUmaEquipe for 10
check MaximoUmaReservaEquipePorDia for 10
check RestricaoFisicaDeJogadores for 10
check SegurancaMenoresDeIdade for 10
check ExclusividadeDaSalaNoDia for 10
