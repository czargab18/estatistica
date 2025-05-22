import bibtexparser
from pybtex.database import parse_file

# Caminho ajustado para o arquivo .bib
file_path = '/newsroom/newshub/build/conteudo/references.bib'
bib_data = parse_file(file_path)
for cite_key, entry in bib_data.entries.items():
    print(f"Cite Key: {cite_key}")
    print("Fields:")
    for field, value in entry.fields.items():
        print(f"  {field}: {value}")
    print("Persons:")
    for role, persons in entry.persons.items():
        for person in persons:
            print(f"  {role}: {person}")
