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
	some j: Jogador | all e: Equipe | j not in e.jogadores
}

// Testa se o sistema aceita uma sala sem reserva
pred SalaSemReserva {
	some s: Sala | all r: Reserva | r.sala != s
}

//Testa se uma sala pode ser reservada em 2 dias diferentes
pred SalaReservadaEmDiasDiferentes{
	some disj r1, r2: Reserva | r1.sala = r2.sala && r1.dia != r2.dia
}

run CriarEquipeMedia for 5

run CriarEquipeLimiteInferir for 5

run CriarEquipeLimiteSuperior for 7

run EquipeComMenorDificuldadeIntermediaria for 5

run EquipeEspecialistaValido for 5

run ClienteSemEquipe for 5

run SalaSemReserva for 5

run SalaReservadaEmDiasDiferentes for 7

// Testes de checagem:

// Teste para ver se nenhum cliente tá em duas equipes ao mesmo tempo
assert ClienteEmNoMaximoUmaEquipe {
    no c: Cliente | some disj e1, e2: Equipe | c in e1.jogadores and c in e2.jogadores
}

// Garante que a mesma equipe não marque duas salas diferentes na mesma data
assert MaximoUmaReservaEquipePorDia {
    no disj r1, r2: Reserva | r1.equipe = r2.equipe and r1.data = r2.data
}

// Checa se a equipe da reserva tem o tamanho certo (entre 2 e 6 pessoas)
assert RestricaoFisicaDeJogadores {
    all r: Reserva | #r.equipe.jogadores >= 2 and #r.equipe.jogadores <= 6
}

// Se a sala for Especialista (terror), não pode ter nenhum menor de idade na equipe
assert SegurancaMenoresDeIdade {
    no r: Reserva | (r.sala.nivel = Especialista) and (some j: r.equipe.jogadores | j.menor_de_idade = Sim)
}

// Confere se duas equipes não alugaram a mesma sala no mesmo dia (evita choque de horário)
assert ExclusividadeDaSalaNoDia {
    no disj r1, r2: Reserva | r1.sala = r2.sala and r1.data = r2.data
}

check ClienteEmNoMaximoUmaEquipe for 10
check MaximoUmaReservaEquipePorDia for 10
check RestricaoFisicaDeJogadores for 10
check SegurancaMenoresDeIdade for 10
check ExclusividadeDaSalaNoDia for 10
