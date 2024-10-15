# Ndugu App - Backend avec Node.js et Ethereum

## Pré-requis
1. **Installer Node.js et npm** : [Télécharger ici](https://nodejs.org/)
2. **Installer Truffle** (framework de développement Ethereum pour les smart contracts).
3. **Installer Ganache** (simulateur de blockchain pour tester localement).
4. **Installer Web3.js** (librairie pour interagir avec Ethereum dans Node.js).
5. **Configurer Metamask** (pour interagir avec Ganache et gérer les comptes Ethereum).

## Étapes de Développement

### Étape 1 : Installer les outils nécessaires
   - [ ] Télécharger et installer **Node.js** et **npm**.
   - [ ] Ouvrir un terminal et vérifier l’installation :
     ```bash
     node -v
     npm -v
     ```
   - [ ] Installer **Truffle** en global :
     ```bash
     npm install -g truffle
     ```
   - [ ] Télécharger et installer **Ganache** : [Télécharger ici](https://trufflesuite.com/ganache/).

### Étape 2 : Créer un Projet Truffle
   - [ ] Ouvrir un terminal dans le répertoire de travail et exécuter :
     ```bash
     mkdir ndugu-app-backend
     cd ndugu-app-backend
     truffle init
     ```
   - [ ] Installer **Web3.js** pour interagir avec Ethereum :
     ```bash
     npm install web3
     ```

### Étape 3 : Configurer Ganache
   - [ ] Lancer Ganache et créer un nouveau réseau de développement.
   - [ ] Noter l’URL RPC locale (souvent `http://127.0.0.1:7545`) pour l’utiliser dans Truffle.

### Étape 4 : Écrire le Smart Contract
   - [ ] Dans le dossier `contracts/` de ton projet, créer un fichier `Traceability.sol` :
     ```solidity
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
     ```
   - [ ] Enregistrer le fichier et le compiler avec Truffle :
     ```bash
     truffle compile
     ```

### Étape 5 : Configurer le Déploiement du Smart Contract
   - [ ] Dans le dossier `migrations/`, modifier `2_deploy_contracts.js` :
     ```javascript
     const Traceability = artifacts.require("Traceability");

     module.exports = function(deployer) {
         deployer.deploy(Traceability);
     };
     ```
   - [ ] Déployer le contrat sur Ganache :
     ```bash
     truffle migrate --network development
     ```

### Étape 6 : Créer une API avec Node.js pour Interagir avec le Smart Contract
   - [ ] Dans le projet, initialiser un projet **Express** :
     ```bash
     npm init -y
     npm install express body-parser
     ```
   - [ ] Créer un fichier `index.js` et ajouter la configuration de base du serveur :
     ```javascript
     const express = require('express');
     const app = express();
     const port = 3000;

     app.use(express.json());
     app.listen(port, () => {
         console.log(`Ndugu App Backend running on http://localhost:${port}`);
     });
     ```
   - [ ] Installer **Web3** pour interagir avec Ethereum depuis Node.js :
     ```bash
     npm install web3
     ```

### Étape 7 : Connecter l’API à Ethereum
   - [ ] Dans `index.js`, connecter Web3 à Ganache :
     ```javascript
     const Web3 = require('web3');
     const contractABI = [/* Copie l'ABI du contrat ici après la compilation */];
     const contractAddress = 'Adresse du contrat déployé';

     const web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:7545"));
     const traceabilityContract = new web3.eth.Contract(contractABI, contractAddress);
     ```

### Étape 8 : Ajouter les Endpoints pour Interagir avec le Contrat
   - [ ] Ajouter un endpoint pour ajouter un produit :
     ```javascript
     app.post('/api/products', async (req, res) => {
         const { id, name, origin, status } = req.body;
         const accounts = await web3.eth.getAccounts();
         await traceabilityContract.methods.addProduct(id, name, origin, status).send({ from: accounts[0] });
         res.send('Produit ajouté avec succès');
     });
     ```
   - [ ] Ajouter un endpoint pour récupérer un produit :
     ```javascript
     app.get('/api/products/:id', async (req, res) => {
         const product = await traceabilityContract.methods.getProduct(req.params.id).call();
         res.send(product);
     });
     ```

### Étape 9 : Tester l’API et le Contrat
   - [ ] Lancer le serveur :
     ```bash
     node index.js
     ```
   - [ ] Utiliser **Postman** ou **curl** pour tester les endpoints `POST /api/products` et `GET /api/products/:id`.

## Étapes Suivantes
1. **Sécuriser l'API** avec des jetons JWT pour l'authentification.
2. **Déployer le Contrat** sur le réseau de test Ropsten si tu es prêt pour le test sur Ethereum.
3. **Intégrer le Frontend** Flutter pour interagir avec l’API.
