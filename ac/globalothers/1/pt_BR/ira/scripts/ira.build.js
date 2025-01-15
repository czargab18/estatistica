let periodoCount = 0;
let disciplinaCount = {};
const maxDisciplinas = 8;
const maxPeriodos = 20;

function criaPeriodo() {
  if (periodoCount >= maxPeriodos) {
    alert(`Você só pode adicionar até ${maxPeriodos} períodos.`);
    return;
  }

  periodoCount++;
  disciplinaCount[periodoCount] = 0;

  const container = document.getElementById("container-periodos");

  const periodoDiv = document.createElement("div");
  periodoDiv.id = `periodo${periodoCount}`;
  periodoDiv.innerHTML = `
    <div class="periodo-title">
      <h3>${periodoCount}º Período</h3>
      <div class="periodo-title-btns">
      <button
          class="btn btn-danger remove-periodo"
          onclick="removerPeriodo(${periodoCount})"
        >
          Remover Período
        </button>
        <button
          class="btn btn-primary"
          onclick="adicionarDisciplina(${periodoCount})"
        >
          Adicionar Disciplina
        </button>
      </div>
    </div>
    <div id="periodo${periodoCount}-disciplinas"></div>
  `;

  container.appendChild(periodoDiv);

  adicionarDisciplina(periodoCount);
}

function removerPeriodo(periodoId) {
  const periodoDiv = document.getElementById(`periodo${periodoId}`);
  if (periodoDiv) {
    periodoDiv.remove();
    delete disciplinaCount[periodoId];
    periodoCount--;
  }
}

function adicionarDisciplina(periodoId) {
  if (disciplinaCount[periodoId] >= maxDisciplinas) {
    alert(`Você atingiu o limite máximo de ${maxDisciplinas} disciplinas para este período.`);
    return;
  }
  disciplinaCount[periodoId]++;
  const disciplinaId = disciplinaCount[periodoId];
  const disciplinasDiv = document.getElementById(
    `periodo${periodoId}-disciplinas`
  );

  const disciplinaDiv = document.createElement("div");
  disciplinaDiv.id = `periodo${periodoId}-disciplina${disciplinaId}-preencher`;
  disciplinaDiv.className = `preencher-linha`;
  disciplinaDiv.innerHTML = `
    <div id = "periodo${periodoId}-disciplina${disciplinaId}-lista" class="left">
    <div id="col-item-discip-${disciplinaId}" class="col-items">
      <input
        type="text"
        id="periodo${periodoId}-disciplina${disciplinaId}-codigo"
        class="form-control"
        placeholder="Código da Disciplina"
        pattern="[A-Z]{3}[0-9]{4}"
        title="O código será automaticamente formatado para 3 letras maiúsculas e 4 números (ex.: ABC1234)."
        oninput="formatarCodigo(this)"
        maxlength="7"
      />
    </div>
    <div id="col-item-discip-${disciplinaId}"" class="col-items">
      <select
        id="periodo${periodoId}-disciplina${disciplinaId}-creditos"
        class="form-control"
      >
        <option value="" selected disabled>Selecione os Créditos</option>
        <option value="2">2 Créditos</option>
        <option value="3">3 Créditos</option>
        <option value="4">4 Créditos</option>
        <option value="6">6 Créditos</option>
        <option value="8">8 Créditos</option>
        <option value="10">10 Créditos</option>
        <option value="12">12 Créditos</option>
        <option value="16">16 Créditos</option>
        <option value="22">22 Créditos</option>
        <option value="40">40 Créditos</option>
        <option value="52">52 Créditos</option>
        <option value="64">64 Créditos</option>
      </select>
    </div>
    <div id="col-item-discip-${disciplinaId}" class="col-items">
      <select
        id="periodo${periodoId}-disciplina${disciplinaId}-mencao"
        class="form-control"
        onchange="atualizarStatus(${periodoId}, ${disciplinaId})"
      >
        <option value="" selected disabled>Menção</option>
        <option value="SR">SR</option>
        <option value="II">II</option>
        <option value="MI">MI</option>
        <option value="MM">MM</option>
        <option value="MS">MS</option>
        <option value="SS">SS</option>
      </select>
    </div>
    </div>
    <div id="periodo${periodoId}-disciplina${disciplinaId}-status-removeDiscp" class="rigth">
    <div id="col-item-status-discip-${disciplinaId}" class="col-items">
      <span id="status-${periodoId}-${disciplinaId}">Status</span>
    </div>
    <div id="col-item-discip-${disciplinaId}">
      <button class="btn btn-danger" onclick="removerDisciplina(${periodoId}, ${disciplinaId})">Remover Disciplina</button>
    </div>
    </div>
  `;

  disciplinasDiv.appendChild(disciplinaDiv);

  adicionarEventosParaMonitoramento(periodoId, disciplinaId);
}

function removerDisciplina(periodoId, disciplinaId) {
  const disciplinaDiv = document.getElementById(`periodo${periodoId}-disciplina${disciplinaId}-preencher`);
  if (disciplinaDiv) {
    disciplinaDiv.remove();
    disciplinaCount[periodoId]--;
  }
}

function determinarStatus(mencao) {
  const aprovadas = ["MM", "MS", "SS"];
  return aprovadas.includes(mencao) ? "Aprovado" : "Reprovado";
}
function atualizarStatus(periodoId, disciplinaId) {
  const mencao = document.getElementById(
    `periodo${periodoId}-disciplina${disciplinaId}-mencao`
  ).value;

  const statusSpan = document.getElementById(
    `status-${periodoId}-${disciplinaId}`
  );
  if (!mencao) {
    statusSpan.textContent = "Incompleto";
    return;
  }

  const status = determinarStatus(mencao);
  statusSpan.textContent = status;
  atualizarIRA();
}
function calcularIRA() {
  const dados = coletaDados();
  let numeradorIra = 0;
  let denominadorIra = 0;
  const valoresMencao = {
    SR: 0,
    II: 1,
    MI: 2,
    MM: 3,
    MS: 4,
    SS: 5,
  };
  for (const periodo in dados) {
    const disciplinas = dados[periodo];
    const semestre = Math.max(6 - parseInt(periodo.split(" ")[1]) + 1, 1);
    for (const disciplina of disciplinas) {
      const {
        creditos,
        mencao
      } = disciplina;
      if (!valoresMencao[mencao] || creditos <= 0) continue;
      const valorMencao = valoresMencao[mencao];
      numeradorIra += valorMencao * creditos * semestre;
      denominadorIra += creditos * semestre;
    }
  }
  const ira = denominadorIra > 0 ? numeradorIra / denominadorIra : 0;
  const iraDisplay = document.getElementById("ira-mp");
  if (iraDisplay) {
    iraDisplay.textContent = `IRA: ${ira.toFixed(2)}`;
  }
  console.log(`IRA calculado: ${ira.toFixed(2)}`);
  return ira;
}
function coletaDados() {
  const dados = {};
  for (let p = 1; p <= periodoCount; p++) {
    const periodoDiv = document.getElementById(`periodo${p}`);
    if (!periodoDiv) continue;
    dados[`Periodo ${p}`] = [];
    for (let d = 1; d <= (disciplinaCount[p] || 0); d++) {
      const codigo = document.getElementById(
        `periodo${p}-disciplina${d}-codigo`
      )?.value || "";
      const creditos = parseInt(
        document.getElementById(`periodo${p}-disciplina${d}-creditos`)?.value || 0
      );
      const mencao = document.getElementById(
        `periodo${p}-disciplina${d}-mencao`
      )?.value || "";
      const status = document.getElementById(
        `status-${p}-${d}`
      )?.textContent || "Incompleto";
      if (codigo && creditos > 0 && mencao) {
        dados[`Periodo ${p}`].push({
          codigo: codigo,
          mencao: mencao,
          creditos: creditos,
          status: status
        });
      }
    }
  }

  console.log(dados);
  return dados;
}
function atualizarIRA() {
  let totalCreditos = 0;
  let creditosAprovados = 0;
  for (let p = 1; p <= periodoCount; p++) {
    for (let d = 1; d <= (disciplinaCount[p] || 0); d++) {
      const mencao = document.getElementById(
        `periodo${p}-disciplina${d}-mencao`
      )?.value;
      const creditos = parseInt(
        document.getElementById(`periodo${p}-disciplina${d}-creditos`)?.value || 0
      );
      if (mencao && creditos) {
        totalCreditos += creditos;
        if (determinarStatus(mencao) === "Aprovado") {
          creditosAprovados += creditos;
        }
      }
    }
  }
  const mp = totalCreditos > 0 ? creditosAprovados : 0;
  const iraDisplay = document.getElementById("ira-mp");
  iraDisplay.textContent = `MP: ${mp} Créditos`;
}
function adicionarEventosParaMonitoramento(periodo, disciplina) {
  const codigo = document.getElementById(`periodo${periodo}-disciplina${disciplina}-codigo`);
  const creditos = document.getElementById(`periodo${periodo}-disciplina${disciplina}-creditos`);
  const mencao = document.getElementById(`periodo${periodo}-disciplina${disciplina}-mencao`);

  codigo.addEventListener("input", () => {
    coletaDados();
    calcularIRA();
  });
  creditos.addEventListener("change", () => {
    coletaDados();
    calcularIRA();
  });
  mencao.addEventListener("change", () => {
    coletaDados();
    calcularIRA();
  });
}

function formatarCodigo(input) {
  let valor = input.value.replace(/[^A-Za-z0-9]/g, '');
  if (valor.length > 3) {
    valor = valor.slice(0, 3).toUpperCase() + valor.slice(3, 7).replace(/[^0-9]/g, '');
  } else {
    valor = valor.toUpperCase();
  }
  input.value = valor.slice(0, 7);
}

function coletaDados() {
  const dados = {};
  for (let p = 1; p <= periodoCount; p++) {
    const periodoDiv = document.getElementById(`periodo${p}`);
    if (!periodoDiv) continue;
    dados[`Periodo ${p}`] = [];
    for (let d = 1; d <= (disciplinaCount[p] || 0); d++) {
      const codigo = document.getElementById(`periodo${p}-disciplina${d}-codigo`)?.value || "";
      const creditos = parseInt(document.getElementById(`periodo${p}-disciplina${d}-creditos`)?.value || 0);
      const mencao = document.getElementById(`periodo${p}-disciplina${d}-mencao`)?.value || "";

      if (codigo && creditos > 0 && mencao) {
        dados[`Periodo ${p}`].push({
          codigo: codigo,
          mencao: mencao,
          creditos: creditos,
        });
      }
    }
  }
  return dados;
}

function verificarPreenchimento() {
  const dados = coletaDados();
  const botaoBaixar = document.getElementById("botao-baixar");
  let preenchido = Object.values(dados).some(periodo => periodo.length > 0);
  botaoBaixar.style.display = preenchido ? "block" : "none";
}

function baixarDados() {
  const dados = coletaDados();
  const json = JSON.stringify(dados, null, 2);
  const blob = new Blob([json], { type: "application/json" });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = "dados.json";
  a.click();
}

document.addEventListener("DOMContentLoaded", () => {
  const footer = document.querySelector("footer");
  if (footer) {
    let avisosDiv = footer.querySelector(".avisos");
    if (!avisosDiv) {
      avisosDiv = document.createElement("div");
      avisosDiv.className = "avisos";
      footer.appendChild(avisosDiv);
    }

    const paragrafo = footer.querySelector("p");

    const botaoBaixar = document.createElement("button");
    botaoBaixar.id = "botao-baixar";
    botaoBaixar.className = "btn btn-success";
    botaoBaixar.style.display = "none";
    botaoBaixar.textContent = "Baixar Dados";
    botaoBaixar.onclick = baixarDados;

    avisosDiv.appendChild(botaoBaixar);
    if (paragrafo) {
      avisosDiv.appendChild(paragrafo);
    }
  }

  const linhaSuperior = document.getElementById('linhaSuperior');
  if (linhaSuperior) {
    const botaoNovoPeriodo = linhaSuperior.querySelector('#novoPeriodo');
    if (botaoNovoPeriodo) {
      const botaoBaixar = document.createElement("button");
      botaoBaixar.id = "botao-baixar";
      botaoBaixar.className = "btn btn-success";
      botaoBaixar.style.display = "none";
      botaoBaixar.textContent = "Baixar Dados";
      botaoBaixar.onclick = baixarDados;

      linhaSuperior.insertBefore(botaoBaixar, botaoNovoPeriodo);
    }
  }

  const container = document.getElementById('container');
  if (container) {
    container.addEventListener('input', verificarPreenchimento);
    container.addEventListener('change', verificarPreenchimento);
  }
});

function verificarPreenchimento() {
  const dados = coletaDados();
  const botoesBaixar = document.querySelectorAll("#botao-baixar");
  let preenchido = Object.values(dados).some(periodo => periodo.length > 0);
  botoesBaixar.forEach(botao => {
    botao.style.display = preenchido ? "block" : "none";
  });
}

function applyStyles() {
    // Referência: https://codepen.io/wheresdara/pen/wvXBpwa
 
    // Estilos para o body
    document.body.style.backgroundColor = '#000';

    // Cria um elemento style
    const style = document.createElement('style');
    style.textContent = `
        .main {
            position: fixed;
            top: 50%;
            left: 50%;
            height: 1px;
            width: 1px;
            background-color: #fff;
            border-radius: 50%;
            box-shadow: -42vw -4vh 0px 0px #fff,25vw -41vh 0px 0px #fff,-20vw 49vh 0px 1px #fff,5vw 40vh 1px 1px #fff,29vw 19vh 1px 0px #fff,-44vw -13vh 0px 0px #fff,46vw 41vh 0px 1px #fff,-3vw -45vh 0px 1px #fff,47vw 35vh 1px 0px #fff,12vw -8vh 1px 0px #fff,-34vw 48vh 1px 1px #fff,32vw 26vh 1px 1px #fff,32vw -41vh 1px 1px #fff,0vw 37vh 1px 1px #fff,34vw -26vh 1px 0px #fff,-14vw -49vh 1px 0px #fff,-12vw 45vh 0px 1px #fff,-44vw -33vh 0px 1px #fff,-13vw 41vh 0px 0px #fff,-36vw -11vh 0px 1px #fff,-23vw -24vh 1px 0px #fff,-38vw -27vh 0px 1px #fff,16vw -19vh 0px 0px #fff,28vw 33vh 1px 0px #fff,-49vw -4vh 0px 0px #fff,16vw 32vh 0px 1px #fff,36vw -18vh 1px 0px #fff,-25vw -30vh 1px 0px #fff,-23vw 24vh 0px 1px #fff,-2vw -35vh 1px 1px #fff,-25vw 9vh 0px 0px #fff,-15vw -34vh 0px 0px #fff,-8vw -19vh 1px 0px #fff,-20vw -20vh 1px 1px #fff,42vw 50vh 0px 1px #fff,-32vw 10vh 1px 0px #fff,-23vw -17vh 0px 0px #fff,44vw 15vh 1px 0px #fff,-40vw 33vh 1px 1px #fff,-43vw 8vh 0px 0px #fff,-48vw -15vh 1px 1px #fff,-24vw 17vh 0px 0px #fff,-31vw 50vh 1px 0px #fff,36vw -38vh 0px 1px #fff,-7vw 48vh 0px 0px #fff,15vw -32vh 0px 0px #fff,29vw -41vh 0px 0px #fff,2vw 37vh 1px 0px #fff,7vw -40vh 1px 1px #fff,15vw 18vh 0px 0px #fff,25vw -13vh 1px 1px #fff,-46vw -12vh 1px 1px #fff,-18vw 22vh 0px 0px #fff,23vw -9vh 1px 0px #fff,50vw 12vh 0px 1px #fff,45vw 2vh 0px 0px #fff,14vw -48vh 1px 0px #fff,23vw 43vh 0px 1px #fff,-40vw 16vh 1px 1px #fff,20vw -31vh 0px 1px #fff,-17vw 44vh 1px 1px #fff,18vw -45vh 0px 0px #fff,33vw -6vh 0px 0px #fff,0vw 7vh 0px 1px #fff,-10vw -18vh 0px 1px #fff,-19vw 5vh 1px 0px #fff,1vw 42vh 0px 0px #fff,22vw 48vh 0px 1px #fff,39vw -8vh 1px 1px #fff,-6vw -42vh 1px 0px #fff,-47vw 34vh 0px 0px #fff,-46vw 19vh 0px 1px #fff,-12vw -32vh 0px 0px #fff,-45vw -38vh 0px 1px #fff,-28vw 18vh 1px 0px #fff,-38vw -46vh 1px 1px #fff,49vw -6vh 1px 1px #fff,-28vw 18vh 1px 1px #fff,10vw -24vh 0px 1px #fff,-5vw -11vh 1px 1px #fff,33vw -8vh 1px 0px #fff,-16vw 17vh 0px 0px #fff,18vw 27vh 0px 1px #fff,-8vw -10vh 1px 1px #fff;
            animation: zoom 16s alternate infinite;
        }

        @keyframes zoom {
            0% {
                transform: scale(1);
            }
            100% {
                transform: scale(1.5);
            }
        }
    `;
    document.head.appendChild(style);
}

// Chama a função para aplicar os estilos
applyStyles();
