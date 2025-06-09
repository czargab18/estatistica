// Nova estrutura de código para o cálculo do IRA
// 1. Ao invés injetar html com JaVascript, os elemtos HTML
//    estarão na página mas ocultos par ao usuário.
// 2. O javascrit apenas ira desocultar os elementos e adicionar
//    os eventos necessários para o funcionamento do IRA.


let periodoCount = 0;
let disciplinaCount = {};
const maxDisciplinas = 8;
const maxPeriodos = 20;

document.addEventListener("DOMContentLoaded", () => {
  // Adicionar evento ao botão "Novo Período"
  const botaoNovoPeriodo = document.getElementById("novoPeriodo");
  if (botaoNovoPeriodo) {
    botaoNovoPeriodo.addEventListener("click", criaPeriodo);
  }
});

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
        <button class="btn btn-danger remove-periodo">Remover Período</button>
        <button class="btn btn-primary adicionar-disciplina">Adicionar Disciplina</button>
      </div>
    </div>
    <div id="periodo${periodoCount}-disciplinas"></div>
  `;

  container.appendChild(periodoDiv);

  // Adicionar eventos aos botões recém-criados
  const botaoRemoverPeriodo = periodoDiv.querySelector(".remove-periodo");
  const botaoAdicionarDisciplina = periodoDiv.querySelector(".adicionar-disciplina");

  botaoRemoverPeriodo.addEventListener("click", () => removerPeriodo(periodoCount));
  botaoAdicionarDisciplina.addEventListener("click", () => adicionarDisciplina(periodoCount));

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
  const disciplinasDiv = document.getElementById(`periodo${periodoId}-disciplinas`);

  const disciplinaDiv = document.createElement("div");
  disciplinaDiv.id = `periodo${periodoId}-disciplina${disciplinaId}-preencher`;
  disciplinaDiv.className = `preencher-linha`;
  disciplinaDiv.innerHTML = `
    <div id="periodo${periodoId}-disciplina${disciplinaId}-lista" class="left">
      <div class="col-items">
        <input
          type="text"
          id="periodo${periodoId}-disciplina${disciplinaId}-codigo"
          class="form-control"
          placeholder="Código da Disciplina"
          pattern="[A-Z]{3}[0-9]{4}"
          title="O código será automaticamente formatado para 3 letras maiúsculas e 4 números (ex.: ABC1234)."
          maxlength="7"
        />
      </div>
      <div class="col-items">
        <select id="periodo${periodoId}-disciplina${disciplinaId}-creditos" class="form-control">
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
      <div class="col-items">
        <select id="periodo${periodoId}-disciplina${disciplinaId}-mencao" class="form-control">
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
      <div class="col-items">
        <span id="status-${periodoId}-${disciplinaId}">Status</span>
      </div>
      <div class="col-items">
        <button class="btn btn-danger remover-disciplina">Remover Disciplina</button>
      </div>
    </div>
  `;

  disciplinasDiv.appendChild(disciplinaDiv);

  // Adicionar eventos aos elementos recém-criados
  const inputCodigo = disciplinaDiv.querySelector(`#periodo${periodoId}-disciplina${disciplinaId}-codigo`);
  const selectCreditos = disciplinaDiv.querySelector(`#periodo${periodoId}-disciplina${disciplinaId}-creditos`);
  const selectMencao = disciplinaDiv.querySelector(`#periodo${periodoId}-disciplina${disciplinaId}-mencao`);
  const botaoRemoverDisciplina = disciplinaDiv.querySelector(".remover-disciplina");

  inputCodigo.addEventListener("input", () => formatarCodigo(inputCodigo));
  selectMencao.addEventListener("change", () => atualizarStatus(periodoId, disciplinaId));
  botaoRemoverDisciplina.addEventListener("click", () => removerDisciplina(periodoId, disciplinaId));

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
  const mencao = document.getElementById(`periodo${periodoId}-disciplina${disciplinaId}-mencao`).value;
  const statusSpan = document.getElementById(`status-${periodoId}-${disciplinaId}`);

  if (!mencao) {
    statusSpan.textContent = "Incompleto";
    return;
  }

  const status = determinarStatus(mencao);
  statusSpan.textContent = status;
  atualizarIRA();
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