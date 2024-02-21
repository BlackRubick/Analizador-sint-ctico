// Requerir el módulo express para la creación de un servidor web
const express = require('express');

// Requerir el módulo body-parser para analizar los cuerpos de las solicitudes HTTP
const bodyParser = require('body-parser');

// Requerir el módulo pegjs para generar un parser a partir de una gramática PEG
const peg = require('pegjs');

// Requerir el módulo fs para trabajar con el sistema de archivos
const fs = require('fs');

// Crear una instancia de la aplicación express
const app = express();

// Servir archivos estáticos desde el directorio 'public'
app.use(express.static('public'));

// Analizar el cuerpo de las solicitudes entrantes como JSON
app.use(bodyParser.json());

// aqui lee la gramatica desde el archivo tokens.pegjs xd
const grammar = fs.readFileSync('tokens.pegjs', 'utf8');

// Generar un parser a partir de la gramática
const parser = peg.generate(grammar);

// Definir una ruta para manejar las solicitudes POST en '/parse'
app.post('/parse', (req, res) => {
  // Extraer los datos del cuerpo de la solicitud
  let input = req.body.data;

  // aqui se eliminan los saltos de linea xd
  input = input.replace(/\n/g, '');

  // Imprimir la entrada recibida en la consola del servidor
  console.log('Entrada: ' + JSON.stringify(req.body));
  console.log('Entrada sin saltos de línea: ' + input);

  try {
    // Intentar analizar la entrada utilizando el parser generado
    const result = parser.parse(input);
    // Enviar el resultado como respuesta
    res.json(result);
  } catch (error) {
    // En caso de error, enviar una respuesta de error con un mensaje apropiado
    res.status(400).json({ error: 'Error de sintaxis: ' + error.message });
  }
});

// Configurar el servidor para escuchar en el puerto 3000
app.listen(3000, () => {
  console.log('Servidor escuchando en el puerto 3000');
});
