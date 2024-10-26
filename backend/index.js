const express = require('express');
const bcrypt = require('bcrypt');
const { ethers } = require('ethers');
const jwt = require('jsonwebtoken');
const cors = require('cors');
const JsonDB = require('litejsondb');
const app = express();
const port = 4000;

const db = new JsonDB('database.json');

const contractABI = [
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "string",
				"name": "lotNumber",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "productName",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "address",
				"name": "producer",
				"type": "address"
			}
		],
		"name": "ProductRegistered",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_lotNumber",
				"type": "string"
			}
		],
		"name": "getProduct",
		"outputs": [
			{
				"components": [
					{
						"internalType": "string",
						"name": "productName",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "harvestDate",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "productionLocation",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "cultivationMethod",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "quantity",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "lotNumber",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "certifications",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "additionalInfo",
						"type": "string"
					},
					{
						"internalType": "address",
						"name": "producer",
						"type": "address"
					}
				],
				"internalType": "struct ProductTraceability.Product",
				"name": "",
				"type": "tuple"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"name": "products",
		"outputs": [
			{
				"internalType": "string",
				"name": "productName",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "harvestDate",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "productionLocation",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "cultivationMethod",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "quantity",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "lotNumber",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "certifications",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "additionalInfo",
				"type": "string"
			},
			{
				"internalType": "address",
				"name": "producer",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_productName",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_harvestDate",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_productionLocation",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_cultivationMethod",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "_quantity",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "_lotNumber",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_certifications",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_additionalInfo",
				"type": "string"
			}
		],
		"name": "registerProduct",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	}
];

const contractAddress = '0xd9145CCE52D386f254917e481eB44e9943F39138';
const provider = new ethers.JsonRpcProvider('https://sepolia.infura.io/v3/2b37d059ff3942f984b89d8ea597d0e7');
const privateKey = '0xb3d7d6f4300b41dc3b3de933e00dabc427557f87a5ee992bfa250f8fcaebd81f';
const wallet = new ethers.Wallet(privateKey, provider);
const contract = new ethers.Contract(contractAddress, contractABI, wallet);

const JWT_SECRET = 'your_jwt_secret_key';
const saltRounds = 10;

app.use(express.json());
app.use(cors());

// Register Endpoint
app.post('/ussd/register', async (req, res) => {
	const { username, password, dob, address, email, confirmPassword, role } = req.body; // Ajout du rôle

	// Vérifier que le rôle est soit 'client' soit 'producteur'
	if (role !== 'Client' && role !== 'Producteur') {
		return res.status(400).json({ message: 'Invalid role. Must be either client or producteur' });
	}

	if (password !== confirmPassword) {
		return res.status(400).json({ message: 'Passwords do not match' });
	}

	const userExists = db.getData(`users/${username}`);
	if (userExists) {
		return res.status(400).json({ message: 'User already exists' });
	}

	const hashedPassword = await bcrypt.hash(password, saltRounds);
	const newUser = { username, password: hashedPassword, dob, address, email, role };

	db.setData(`users/${username}`, newUser);

	const token = jwt.sign({ username: username, role: role }, JWT_SECRET);
	res.status(200).json({ message: 'User registered successfully', token });
});


// Login Endpoint
app.post('/ussd/login', async (req, res) => {
	const { username, password } = req.body;

	const user = db.getData(`users/${username}`);
	if (!user) {
		return res.status(400).json({ message: 'User not found' });
	}

	const passwordMatch = await bcrypt.compare(password, user.password);
	if (!passwordMatch) {
		return res.status(400).json({ message: 'Invalid password' });
	}

	// Insertion du rôle dans le JWT
	const token = jwt.sign({ username: user.username, role: user.role }, JWT_SECRET);
	res.status(200).json({ message: 'Login successful', token });
});


// Example protected route
app.get('/ussd/protected', (req, res) => {
	const token = req.headers['authorization'];

	if (!token) {
		return res.status(403).json({ message: 'No token provided' });
	}

	try {
		const decoded = jwt.verify(token, JWT_SECRET);
		res.status(200).json({ message: `Welcome ${decoded.username}` });
	} catch (err) {
		res.status(401).json({ message: 'Invalid token' });
	}
});

// Endpoint pour enregistrer un produit (réservé aux producteurs)
app.post('/ussd/product', async (req, res) => {
	const token = req.headers['authorization'];

	if (!token) {
		return res.status(403).json({ message: 'No token provided' });
	}

	try {
		const decoded = jwt.verify(token, JWT_SECRET);
		if (decoded.role !== 'Producteur') {
			return res.status(403).json({ message: 'Access denied. Only producteurs can register products.' });
		}

		const { productName, harvestDate, productionLocation, cultivationMethod, quantity, lotNumber, certifications, additionalInfo } = req.body;

		// Appel au smart contract pour enregistrer le produit
		const tx = await contract.registerProduct(productName, harvestDate, productionLocation, cultivationMethod, quantity, lotNumber, certifications, additionalInfo);
		await tx.wait();  // Attendre que la transaction soit confirmée

		res.status(200).json({ message: 'Produit enregistré avec succès dans la blockchain', transactionHash: tx.hash });
	} catch (err) {
		res.status(500).json({ message: 'Erreur lors de l\'enregistrement du produit', error: err.message });
	}
});

app.listen(port, () => {
	console.log(`Ndugu App Backend running on http://localhost:${port}`);
});
