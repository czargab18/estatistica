class Empregado():
    def __init__ (self, nome, sexo, salario):
        self.nome = nome
        self.sexo = sexo
        self.salario = salario

Fulano = Empregado("Fulano de Tal", "m", 2500.00)
print(Fulano.nome[0:6], Fulano.salario)
