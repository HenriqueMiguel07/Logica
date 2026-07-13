module projeto_escape_room


abstract sig Nivel {}
one sig Iniciante, Intermediario, Especialista extends Nivel {}

sig Cliente {
    menor_de_idade: one Bool 
}

abstract sig Bool {}
one sig Sim, Nao extends Bool {}

sig Equipe {
    jogadores: set Cliente 
}

sig Sala {
    nivel: one Nivel 
}

sig Data {}

sig Reserva {
    equipe: one Equipe,
    sala: one Sala,
    data: one Data
}

fact RegrasDoComplexo {

    all c: Cliente | lone e: Equipe | c in e.jogadores

    all e: Equipe | #e.jogadores >= 2 and #e.jogadores <= 6

    all e: Equipe, d: Data | lone r: Reserva | r.equipe = e and r.data = d

    all s: Sala, d: Data | lone r: Reserva | r.sala = s and r.data = d

    all r: Reserva | (some j: r.equipe.jogadores | j.menor_de_idade = Sim) implies r.sala.nivel != Especialista
}



assert SemChoqueDeReservas {
    no disj r1, r2: Reserva | r1.sala = r2.sala and r1.data = r2.data
}

assert SegurancaGarantida {
    no r: Reserva | (some j: r.equipe.jogadores | j.menor_de_idade = Sim) and r.sala.nivel = Especialista
}

assert ClienteFiel {
    no c: Cliente | some disj e1, e2: Equipe | c in e1.jogadores and c in e2.jogadores
}



pred show() {
    #Reserva >= 2
    #Equipe >= 2
    #Cliente >= 2
}


run show for 10

// Rodando os testes para provar a consistência do sistema:
check SemChoqueDeReservas for 6
check SegurancaGarantida for 6
check ClienteFiel for 6