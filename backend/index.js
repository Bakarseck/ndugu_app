const express = require('express');
// const Web3 = require('web3');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const app = express();
const port = 4000;

const users = []; // In-memory array to store users for simplicity (use a database in production)

const JWT_SECRET = 'your_jwt_secret_key'; // Change this to something more secure
const saltRounds = 10;

// // Web3 Configuration (same as before)
// const web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:7545"));
// const contractABI = [/* ABI here */];
// const contractAddress = 'Contract_address_here';
// const traceabilityContract = new web3.eth.Contract(contractABI, contractAddress);

app.use(express.json());

// Register Endpoint
app.post('/ussd/register', async (req, res) => {
    const { username, password, dob, address, email, confirmPassword } = req.body;

    if (password !== confirmPassword) {
        return res.status(400).json({ message: 'Passwords do not match' });
    }

    const userExists = users.find(user => user.username === username || user.email === email);
    if (userExists) {
        return res.status(400).json({ message: 'User already exists' });
    }

    const hashedPassword = await bcrypt.hash(password, saltRounds);
    const newUser = { username, password: hashedPassword, dob, address, email };
    users.push(newUser);

    res.status(200).json({ message: 'User registered successfully' });
});

// Login Endpoint
app.post('/ussd/login', async (req, res) => {
    const { username, password } = req.body;

    const user = users.find(user => user.username === username);
    if (!user) {
        return res.status(400).json({ message: 'User not found' });
    }

    const passwordMatch = await bcrypt.compare(password, user.password);
    if (!passwordMatch) {
        return res.status(400).json({ message: 'Invalid password' });
    }

    const token = jwt.sign({ username: user.username }, JWT_SECRET, { expiresIn: '1h' });
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

// // Your existing product-related routes remain the same
// app.post('/api/products', async (req, res) => {
//     const { id, name, origin, status } = req.body;
//     const accounts = await web3.eth.getAccounts();
//     await traceabilityContract.methods.addProduct(id, name, origin, status).send({ from: accounts[0] });
//     res.send('Product added successfully');
// });

// app.get('/api/products/:id', async (req, res) => {
//     const product = await traceabilityContract.methods.getProduct(req.params.id).call();
//     res.send(product);
// });

app.listen(port, () => {
    console.log(`Ndugu App Backend running on http://localhost:${port}`);
});
