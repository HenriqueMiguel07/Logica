/*
  =============================================================================
  SISTEMA DE AGENDAMENTO DE ESCAPE ROOMS
  Especificação Formal e Validação de Regras
  =============================================================================
*/

// --- 1. SIGNATURAS E ESTRUTURAS DE DADOS ---

// Níveis de dificuldade possíveis para as salas
abstract sig Dificuldade {}
one sig Iniciante, Intermediario, Especialista extends Dificuldade {}

// Entidade representando os Clientes do complexo
sig Cliente {}

// Subconjunto de clientes especificamente identificados como menores de idade
sig MenorDeIdade in Cliente {}

// As equipes que os clientes formam para jogar
sig Equipe {
    membros: set Cliente
}

// Cada sala de fuga do complexo
sig Sala {
    dificuldade: one Dificuldade
}

// Representação abstrata do Tempo/Dias de funcionamento do complexo
sig Dia {}

// Representação de um Agendamento/Reserva realizado
sig Reserva {
    equipe: one Equipe,
    sala: one Sala,
    dia: one Dia
}

// --- 2. FATOS (RESTRIÇÕES E REGRAS DE NEGÓCIO ESTRITAS) ---

fact RegrasDoComplexo {
    
    // REGRA 1: Um cliente só pode pertencer a, no máximo, uma equipe por vez.
    // Clientes que não estão em nenhuma equipe ficam com o conjunto vazio (aguardando).
    all c: Cliente | lone e: Equipe | c in e.membros

    // REGRA 2: Uma equipe pode agendar no máximo uma sala por dia.
    // Garante que para qualquer par (Equipe, Dia), exista no máximo 1 átomo de Reserva.
    all e: Equipe, d: Dia | lone r: Reserva | r.equipe = e and r.dia = d

    // REGRA 3: Nenhuma sala pode ser reservada por mais de uma equipe ao mesmo tempo (no mesmo dia).
    // Garante unicidade de uso da sala por data.
    all s: Sala, d: Dia | lone r: Reserva | r.sala = s and r.dia = d

    // REGRAS ESPECÍFICAS APLICADAS A CADA RESERVA EFETUADA:
    all r: Reserva {
        
        // REGRA 4: Restrição física de ocupação da sala.
        // A equipe associada à reserva precisa ter entre 2 e 6 membros.
        #r.equipe.membros >= 2
        #r.equipe.membros <= 6

        // REGRA 5: Restrição de segurança para proteção de menores.
        // Se a dificuldade da sala reservada for 'Especialista', a interseção 
        // entre os membros da equipe e o grupo de menores de idade deve ser VAZIA (no).
        r.sala.dificuldade = Especialista => no (r.equipe.membros & MenorDeIdade)
    }
}

// --- 3. VALIDAÇÃO E CHECAGEM DO MODELO ---

// Asserção para provar matematicamente que menores NUNCA entram em salas Especialistas
assert GarantiaDeSeguranca {
    all r: Reserva | r.sala.dificuldade = Especialista => no (r.equipe.membros & MenorDeIdade)
}
// O comando 'check' tenta encontrar falhas na nossa lógica procurando contraexemplos
check GarantiaDeSeguranca for 5

// Predicado para gerar cenários visuais válidos no Alloy Analyzer
pred MostrarCenario {
    some Reserva                     // Força o sistema a mostrar agendamentos acontecendo
    some s: Sala | no r: Reserva | r.sala = s // Garante a exibição de salas sem reserva (comportamento permitido)
}
run MostrarCenario for 5