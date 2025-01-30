#!/bin/bash

# Création du dossier du projet
mkdir -p test-anglais
cd test-anglais

# Création des fichiers
echo "Création des fichiers..."
cat > server.js <<EOL
const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = 8989;

const server = http.createServer((req, res) => {
    if (req.url === '/' || req.url === '/index.html') {
        fs.readFile(path.join(__dirname, 'index.html'), (err, data) => {
            if (err) {
                res.writeHead(500, { 'Content-Type': 'text/plain' });
                res.end('Erreur interne du serveur');
            } else {
                res.writeHead(200, { 'Content-Type': 'text/html' });
                res.end(data);
            }
        });
    } else {
        res.writeHead(404, { 'Content-Type': 'text/plain' });
        res.end('Page non trouvée');
    }
});

server.listen(PORT, () => {
    console.log(\`Serveur démarré sur http://localhost:\${PORT}\`);
});
EOL

cat > index.html <<EOL
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test d'Anglais</title>
</head>
<body>
    <h1>Test Rapide en Anglais</h1>
    <p>Quelle est la traduction correcte de : "I didn't find five people" ?</p>
    <form id="testForm">
        <label><input type="radio" name="answer" value="1"> Je ne trouve pas cinq personnes</label><br>
        <label><input type="radio" name="answer" value="2"> Mais je n’ai pas trouvé cinq personnes</label><br>
        <label><input type="radio" name="answer" value="3"> J’ai trouvé cinq personnes</label><br>
        <button type="submit">Valider</button>
    </form>

    <p id="result"></p>

    <script>
        document.getElementById("testForm").addEventListener("submit", function(event) {
            event.preventDefault();
            const answer = document.querySelector('input[name="answer"]:checked');
            if (answer) {
                if (answer.value === "2") {
                    document.getElementById("result").innerText = "✅ Bonne réponse !";
                } else {
                    document.getElementById("result").innerText = "❌ Mauvaise réponse, réessayez.";
                }
            } else {
                document.getElementById("result").innerText = "❌ Veuillez choisir une réponse.";
            }
        });
    </script>
</body>
</html>
EOL

# Installation de Node.js si ce n'est pas déjà fait
if ! command -v node &> /dev/null
then
    echo "Node.js n'est pas installé. Installez-le et relancez le script."
    exit 1
fi

# Lancement du serveur
echo "Démarrage du serveur..."
node server.js
