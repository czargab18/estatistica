import express, { request } from "express";
const app = express();

// criando rota teste
app.get("/teste/putaVagabunda", (req, res) => {
  res.send(
    '<p> O objetivo de oferecer aos estudantes de estatística e áreas afins um espaço de aprendizagem, troca e atualização sobre os principais conceitos,  métodos e aplicações da ciência dos dados </p>'
  );
});

export default app;
