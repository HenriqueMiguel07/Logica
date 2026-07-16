// Sistema de Agendamento de Escape Rooms


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
	
	// toda equipe que reserva uma sala deve ter no minimo 2 e no máximo 6 jogadores
	all r: Reserva | TemNumeroDeJogadoresValido[r.equipe]
	
	// Só é possivel reservar uma sala no nivel especialista se a equipe não possui nenhum jogador de menor
	all r: Reserva | (r.sala.nivel = Especialista) implies not TemJogadorDeMenor[r.equipe]

	// Nenhuma sala pode ser usada ao mesmo tempo por diferentes equipes
	all disj r1, r2: Reserva | (r1.sala = r2.sala) implies (r1.dia != r2.dia)

}

pred TemNumeroDeJogadoresValido[e: Equipe] {
	#e.jogadores >= 2 and #e.jogadores <= 6
}

pred TemJogadorDeMenor[e: Equipe] {
	some j: e.jogadores | j.ehMenorDeIdade = True
}


