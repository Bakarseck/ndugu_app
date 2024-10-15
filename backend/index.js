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
    console.log(`Ndugu App Backend running on http://localhost:${port}`);
});
