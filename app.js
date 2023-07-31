const express = require('express')
const {spawn} = require('child_process');
const bodyParser = require('body-parser');
const path = require('path');
const app = express()
const port = 3000

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

const multer = require('multer');
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'image/')
    },
    filename: function (req, file, cb) {
        cb(null, 'scan_image'+ path.extname(file.originalname))
    }
});
const upload = multer({ storage: storage });

app.post('/upload',upload.single('fileUpload'), (req, res) => {

    let dataToSendToPythonScript =  'req.file';
    var detect;

    const python = spawn('python', ['scri.py' , dataToSendToPythonScript]);

    python.stdout.on('data', function (data) {
        console.log('Pipe data from python script ...');
        dataToSend = data.toString();
        let result = dataToSend.match(/\[\s*'([^']*)'\s*\]/)[1];
        detect = result
        console.log(result);
        console.log(result.length);

    });

    python.stderr.on('data', (data) => {
        console.error(`stderr: ${data}`);
    });

    python.on('close', (code) => {
        console.log(`child process close all stdio with code ${code , detect}`);
        const filePath = path.join(__dirname , 'save.png');
        res.setHeader('Content-Disposition', `${detect}`);
        res.sendFile(filePath)
    });
})

app.listen(port, () => console.log(`Example app listening on port ${port}!`))