import os
import shutil
import glob
import re
import json
import random
import string

#### AUTOMACAO PERGUNTAS: ( VERIFICAR & TENTAR ) NOVAMENTE

def perguntas(opcao:str, pergunta:str, resposta:str):
    """
     * Automatizar perguntas e verificação:
     * - (1) 'Pergunta qualquer'
     * - (2) 'Pergunta: Tentar Novamente'
    """
    def verificar_resposta(resposta):
        if resposta in ["sim", "s", "yes", "y"]:
            return True
        elif resposta in ["não", "nao", "n"]:
            return False
    def verificar_pergunta(pergunta):
        if pergunta is None:
            return True
        else:
            return False
    
        
    if opcao in ["p", "pergunta"]:
        resposta = input(f'{pergunta}? (s/n): ').lower().strip()
        return verificar_resposta(resposta)
    elif opcao in ["t","tentar"]:
        resposta = input(f'{pergunta}? (s/n): ').lower().strip()
        return verificar_resposta(resposta)
    else:
        return None