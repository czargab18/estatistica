import os
import re
import json
import string
import random
from bs4 import BeautifulSoup, Comment
import shutil
import requests
from datetime import datetime

# Função final do resultado da junção da função abaixo:
def verificacao(pergunta:str):
  # PERGUNTA
  resposta = input(f'{pergunta}? (s/n): ').lower().strip()
  # VERIFICAR RESPOSTA DA PERGUNTA
  if resposta in ["sim", "s", "yes", "y"]:
        return True
  elif resposta in ["não", "nao", "n", "no", "ñ"]:
      return False
  else:
      return None

#_____ TESTE DA FUNÇÃO _____#
print(verificacao(pergunta="Você está bem?")) ###__ FUNCIONA __###