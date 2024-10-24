const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const cors = require('cors');
const JsonDB = require('litejsondb');
const app = express();
const port = 4000;

const db = new JsonDB('database.json');

const JWT_SECRET = 'your_jwt_secret_key';
const saltRounds = 10;

app.use(express.json());
app.use(cors());

// Register Endpoint
app.post('/ussd/register', async (req, res) => {
     const { username, password, dob, address, email, confirmPassword, role } = req.body; // Ajout du rôle

     // Vérifier que le rôle est soit 'client' soit 'producteur'
     if (role !== 'client' && role !== 'producteur') {
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
     res.status(200).json({ message: 'User registered successfully', token});
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

app.listen(port, () => {
     console.log(`Ndugu App Backend running on http://localhost:${port}`);
});
