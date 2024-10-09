// // Importing necessary libraries
// const express = require('express');
// const mongoose = require('mongoose');
// const bodyParser = require('body-parser');
// const cors = require('cors');

// // Initialize express app
// const app = express();
// const PORT = process.env.PORT || 5000;

// // Middleware
// app.use(cors()); // Enable CORS
// app.use(bodyParser.json()); // Parse JSON bodies

// // MongoDB connection
// const mongoURI = 'mongodb://localhost:27017/TrainerDb'; // Change 'yourdbname' to your actual database name
// mongoose.connect(mongoURI, {
//     useNewUrlParser: true,
//     useUnifiedTopology: true,
// })
// .then(() => console.log('MongoDB connected'))
// .catch(err => console.log(err));

// // Mongoose Schema
// const recordSchema = new mongoose.Schema({
//     name: { type: String, required: true },
//     employeeType: { type: String, enum: ['Regular', 'Adhoc'], required: true },
//     gender: { type: String, enum: ['Male', 'Female', 'Other'], required: true },
//     contact: { type: String, required: true },
//     email: { type: String, required: true },
//     subjectData: {
//         Hindi: {
//             '0-40%': { type: String, default: '' },
//             '40-80%': { type: String, default: '' },
//             '80-100%': { type: String, default: '' },
//         },
//         English: {
//             '0-40%': { type: String, default: '' },
//             '40-80%': { type: String, default: '' },
//             '80-100%': { type: String, default: '' },
//         },
//         Math: {
//             '0-40%': { type: String, default: '' },
//             '40-80%': { type: String, default: '' },
//             '80-100%': { type: String, default: '' },
//         },
//         'Computer Science': {
//             '0-40%': { type: String, default: '' },
//             '40-80%': { type: String, default: '' },
//             '80-100%': { type: String, default: '' },
//         },
//     },
// });

// // Create Mongoose model
// const Record = mongoose.model('Record', recordSchema);

// // Controller functions
// const createRecord = async (req, res) => {
//     const record = new Record(req.body);
//     try {
//         await record.save();
//         res.status(201).json({ message: 'Record created successfully', record });
//     } catch (error) {
//         res.status(400).json({ error: error.message });
//     }
// };

// const getRecords = async (req, res) => {
//     try {
//         const records = await Record.find();
//         res.status(200).json(records);
//     } catch (error) {
//         res.status(400).json({ error: error.message });
//     }
// };

// // Routes
// app.post('/api/records', createRecord);
// app.get('/api/records', getRecords);

// // Error handling middleware
// app.use((err, req, res, next) => {
//     console.error(err.stack);
//     res.status(500).send('Something broke!');
// });

// // Start the server
// app.listen(PORT, () => {
//     console.log(Server is running on http://localhost:${PORT});
// });


// Importing necessary libraries
const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');

// Initialize express app
const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors()); // Enable CORS
app.use(bodyParser.json()); // Parse JSON bodies

// MongoDB connection
const mongoURI = 'mongodb://localhost:27017/TrainerDb'; // Change 'yourdbname' to your actual database name
mongoose.connect(mongoURI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
})
.then(() => console.log('MongoDB connected'))
.catch(err => console.log(err));

// Mongoose Schema
const recordSchema = new mongoose.Schema({
    name: { type: String, required: true },
    employeeType: { type: String, enum: ['Regular', 'Adhoc'], required: true },
    gender: { type: String, enum: ['Male', 'Female', 'Other'], required: true },
    contact: { type: String, required: true },
    email: { type: String, required: true },
    subjectData: {
        Hindi: {
            '0-40%': { type: String, default: '0' },
            '40-80%': { type: String, default: '0' },
            '80-100%': { type: String, default: '0' },
        },
        English: {
            '0-40%': { type: String, default: '0' },
            '40-80%': { type: String, default: '0' },
            '80-100%': { type: String, default: '0' },
        },
        Math: {
            '0-40%': { type: String, default: '0' },
            '40-80%': { type: String, default: '0' },
            '80-100%': { type: String, default: '0' },
        },
        'Computer Science': {
            '0-40%': { type: String, default: '0' },
            '40-80%': { type: String, default: '0' },
            '80-100%': { type: String, default: '0' },
        },
    },
});

// Custom validation to check that total students in each subject is <= 100
recordSchema.pre('save', function (next) {
    const subjectData = this.subjectData;

    // Helper function to calculate the total students for a subject
    const validateSubject = (subject) => {
        const totalStudents =
            parseInt(subject['0-40%']) +
            parseInt(subject['40-80%']) +
            parseInt(subject['80-100%']);

        return totalStudents <= 100;
    };

    // Validate each subject
    if (!validateSubject(subjectData.Hindi)) {
        return next(new Error('Total students for Hindi must not exceed 100.'));
    }
    if (!validateSubject(subjectData.English)) {
        return next(new Error('Total students for English must not exceed 100.'));
    }
    if (!validateSubject(subjectData.Math)) {
        return next(new Error('Total students for Math must not exceed 100.'));
    }
    if (!validateSubject(subjectData['Computer Science'])) {
        return next(new Error('Total students for Computer Science must not exceed 100.'));
    }

    next(); // Proceed if validation passes
});

// Create Mongoose model
const Record = mongoose.model('Record', recordSchema);

// Controller functions
const createRecord = async (req, res) => {
    const record = new Record(req.body);
    try {
        await record.save();
        res.status(201).json({ message: 'Record created successfully', record });
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

const getRecords = async (req, res) => {
    try {
        const records = await Record.find();
        res.status(200).json(records);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

// Routes
app.post('/api/records', createRecord);
app.get('/api/records', getRecords);

// Error handling middleware
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).send('Something broke!');
});

// Start the server
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});