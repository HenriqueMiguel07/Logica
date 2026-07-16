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



