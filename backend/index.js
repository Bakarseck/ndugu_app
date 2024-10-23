const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const JsonDB = require('litejsondb');
const app = express();
const port = 4000;

const db = new JsonDB('database.json');

const JWT_SECRET = 'your_jwt_secret_key';
const saltRounds = 10;

app.use(express.json());

// Register Endpoint
app.post('/ussd/register', async (req, res) => {
    const { username, password, dob, address, email, confirmPassword } = req.body;

    if (password !== confirmPassword) {
        return res.status(400).json({ message: 'Passwords do not match' });
    }

    const userExists = db.getData(`users/${username}`);
    if (userExists) {
        return res.status(400).json({ message: 'User already exists' });
    }

    const hashedPassword = await bcrypt.hash(password, saltRounds);
    const newUser = { username, password: hashedPassword, dob, address, email };

    db.setData(`users/${username}`, newUser); // Save user in the database

    res.status(200).json({ message: 'User registered successfully' });
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

app.listen(port, () => {
    console.log(`Ndugu App Backend running on http://localhost:${port}`);
});
