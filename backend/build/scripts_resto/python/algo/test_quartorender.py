from core import *
import os
import sys
import unittest

# Adiciona o diretório raiz ao sys.path
sys.path.append(os.path.abspath(
    os.path.join(os.path.dirname(__file__), "../..")))


class TestBooksguide(unittest.TestCase):

    def setUp(self):
        """
        Configuração inicial para os testes.
        Cria um arquivo temporário para ser usado nos testes.
        """
        self.test_file = "test_file.txt"
        self.test_content = "Conteúdo de teste"
        with open(self.test_file, "w", encoding="utf-8") as file:
            file.write(self.test_content)

    def tearDown(self):
        """
        Limpeza após os testes.
        Remove o arquivo temporário criado.
        """
        if os.path.exists(self.test_file):
            os.remove(self.test_file)

    def test_ler(self):
        """
        Testa a função 'ler' para verificar se ela lê corretamente o conteúdo de um arquivo.
        """
        content = ler(self.test_file)
        self.assertEqual(content, self.test_content)

    def test_escrever(self):
        """
        Testa a função 'escrever' para verificar se ela escreve corretamente o conteúdo em um arquivo.
        """
        new_content = "Novo conteúdo de teste"
        escrever(self.test_file, new_content)
        with open(self.test_file, "r", encoding="utf-8") as file:
            content = file.read()
        self.assertEqual(content, new_content)


if __name__ == "__main__":
    unittest.main()
