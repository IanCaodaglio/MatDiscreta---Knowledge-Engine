import csv
import re



def normalizar(texto):
    """Converte string para formato Prolog: minúsculo, sem espaços/acentos."""
    texto = texto.lower()
    
    substituicoes = {
        'á':'a','à':'a','ã':'a','â':'a','ä':'a',
        'é':'e','è':'e','ê':'e','ë':'e',
        'í':'i','ì':'i','î':'i','ï':'i',
        'ó':'o','ò':'o','õ':'o','ô':'o','ö':'o',
        'ú':'u','ù':'u','û':'u','ü':'u',
        'ç':'c','ñ':'n',
    }
    for orig, dest in substituicoes.items():
        texto = texto.replace(orig, dest)
    
    texto = re.sub(r'[^a-z0-9]+', '_', texto)
    texto = texto.strip('_')
    return texto



with open('drivers.csv') as f:
    drivers = {r['driverId']: r['driverRef'] for r in csv.DictReader(f)}

with open('constructors.csv') as f:
    constructors = {r['constructorId']: r['constructorRef'] for r in csv.DictReader(f)}

with open('races.csv') as f:
    races = {r['raceId']: r for r in csv.DictReader(f) if r['year'] == '2024'}



predicados = []

with open('results.csv') as f:
    for r in csv.DictReader(f):
        if r['raceId'] not in races:
            continue

        
        posicao_txt = r['positionText']
        if not posicao_txt.lstrip('-').isdigit():
            posicao_txt = 'dnf'  

        piloto  = normalizar(drivers[r['driverId']])
        equipe  = normalizar(constructors[r['constructorId']])
        corrida = normalizar(races[r['raceId']]['name'])
        ano     = races[r['raceId']]['year']
        grid    = r['grid']
        posicao = posicao_txt
        pontos  = r['points']
        voltas  = r['laps']

        pred = (
            f"resultado({piloto}, {equipe}, {corrida}, "
            f"{ano}, {grid}, {posicao}, {pontos}, {voltas})."
        )
        predicados.append(pred)



with open('f1_2024.pl', 'w') as f:
    f.write("% Base de conhecimento - Formula 1 2024\n")
    f.write("% resultado(piloto, equipe, corrida, ano, grid, posicao, pontos, voltas).\n\n")
    for p in predicados:
        f.write(p + '\n')

print(f"Gerados {len(predicados)} predicados em f1_2024.pl")
