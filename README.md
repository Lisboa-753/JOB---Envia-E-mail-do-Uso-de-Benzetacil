# Procedure de Envio de E-mail - Solicitações de Penicilina Benzatina (Benzetacil) no PA.
Este projeto contém uma procedure (função no banco de dados Oracle) que envia um e-mail com informações Solicitações de Penicilina Benzatina (Benzetacil) no pronto atendimento.

## Objetivo

O objetivo principal desta procedure é enviar ** Solicitações de Penicilina Benzatina (Benzetacil) no pronto atendimento no dia anterior** com dados como:

- Atendimento do paciente que contém a solicitação do médico via prescrição médica,
- Nome do paciente,
- Descrição do medicamento.

Essas informações são mostradas em um modelo de e-mail em HTML, pronto para ser enviado.

## Como funciona

A JOB do banco de dados chama a procedure todo dia as 06:00h, onde é verificado se houve alguma prescrição com benzetacil no dia anterior.

1. Busca dados do atendimento, paciente e medicamento
2. Monta o conteúdo do e-mail com HTML

Tudo isso é feito de forma automática, sem precisar escrever o e-mail manualmente.

## Tecnologias utilizadas

- Oracle PL/SQL
- Banco de dados relacional
- HTML para formatar o e-mail

## Uso

Esta procedure pode ser útil para sistemas que:

- Setores que fazem o controle de medicamentos
- Precisam enviar relatórios por e-mail
- Querem automatizar esse processo e ganhar tempo

---

> ⚠️ Atenção: este código é genérico e não utiliza dados reais de atendimentos, paciente e medicamentos. Foi adaptado para fins de exemplo.

## Autor

Desenvolvido por Gabriel Lisboa Alves👨‍💻
