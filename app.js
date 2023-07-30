const express = require('express');
const fs = require('fs');
const path = require('path');
const app = express();
const port = 3000;

// Middleware para lidar com o corpo das requisições
app.use(express.json());

// Rota para obter todos os ícones
app.get('/api/icons', (req, res) => {
  const iconsPath = path.join(__dirname, 'ac', 'assets', 'icons', 'icons.json');

  fs.readFile(iconsPath, 'utf8', (err, data) => {
    if (err) {
      return res.status(500).json({ error: 'Erro ao ler o arquivo de ícones.' });
    }

    const icons = JSON.parse(data);
    res.json(icons);
  });
});

// Rota para salvar um novo ícone
app.post('/api/icons', (req, res) => {
  const iconsPath = path.join(__dirname, 'ac', 'assets', 'icons', 'icons.json');

  fs.readFile(iconsPath, 'utf8', (err, data) => {
    if (err) {
      return res.status(500).json({ error: 'Erro ao ler o arquivo de ícones.' });
    }

    const icons = JSON.parse(data);
    icons.icons.push(req.body);
    
    fs.writeFile(iconsPath, JSON.stringify(icons), (err) => {
      if (err) {
        return res.status(500).json({ error: 'Erro ao salvar o ícone.' });
      }

      res.json({ message: 'Ícone salvo com sucesso.' });
    });
  });
});

// Inicie o servidor
app.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
});
