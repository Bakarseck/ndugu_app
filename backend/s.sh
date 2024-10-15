# Installation de Web3.js
echo "Installation de Web3.js..."
npm install web3

echo "## Étape 2 : Création et configuration du contrat Traceability.sol ##"

# Création du smart contract Traceability.sol
mkdir -p contracts
cat <<EOL > contracts/Traceability.sol
pragma solidity ^0.8.0;

contract Traceability {
    struct Product {
        uint id;
        string name;
        string origin;
        string status;
        uint timestamp;
    }

    mapping(uint => Product) public products;

    function addProduct(uint _id, string memory _name, string memory _origin, string memory _status) public {
        products[_id] = Product(_id, _name, _origin, _status, block.timestamp);
    }

    function getProduct(uint _id) public view returns (string memory, string memory, string memory, uint) {
        Product memory product = products[_id];
        return (product.name, product.origin, product.status, product.timestamp);
    }
}
EOL

# Compilation du contrat
echo "Compilation du contrat Traceability.sol..."
truffle compile

echo "## Étape 3 : Configuration et déploiement du contrat ##"

# Création du fichier de migration pour le déploiement du contrat
mkdir -p migrations
cat <<EOL > migrations/2_deploy_contracts.js
const Traceability = artifacts.require("Traceability");

module.exports = function(deployer) {
    deployer.deploy(Traceability);
};
EOL

# Déploiement du contrat sur Ganache
echo "Déploiement du contrat sur le réseau Ganache..."
truffle migrate --network development

echo "## Étape 4 : Création de l'API Node.js ##"

# Initialisation du projet Node.js avec Express et création du fichier index.js
npm init -y
npm install express body-parser web3

# Création de l'API de base dans index.js
cat <<EOL > index.js
const express = require('express');
const Web3 = require('web3');
const app = express();
const port = 3000;

// Connexion à Ganache
const web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:7545"));

// ABI et adresse du contrat (à mettre à jour après le déploiement)
const contractABI = [/* Copiez ici l'ABI générée après la compilation du contrat */];
const contractAddress = 'Adresse_du_contrat';

const traceabilityContract = new web3.eth.Contract(contractABI, contractAddress);

app.use(express.json());

// Endpoint pour ajouter un produit
app.post('/api/products', async (req, res) => {
    const { id, name, origin, status } = req.body;
    const accounts = await web3.eth.getAccounts();
    await traceabilityContract.methods.addProduct(id, name, origin, status).send({ from: accounts[0] });
    res.send('Produit ajouté avec succès');
});

// Endpoint pour récupérer un produit
app.get('/api/products/:id', async (req, res) => {
    const product = await traceabilityContract.methods.getProduct(req.params.id).call();
    res.send(product);
});

app.listen(port, () => {
    console.log(\`Ndugu App Backend running on http://localhost:\${port}\`);
});
EOL

echo "## Installation et configuration terminées ! ##"
echo "Lancez le serveur Node.js avec la commande suivante :"
echo "node index.js"
