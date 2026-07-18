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

