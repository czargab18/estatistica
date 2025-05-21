# Prova do Limite do Produto Vetorial

Sejam **r**(t) e **v**(t) funções vetoriais definidas por:

$$
\mathbf{r}(t) = \langle r_1(t), r_2(t), r_3(t) \rangle, \quad \mathbf{v}(t) = \langle v_1(t), v_2(t), v_3(t) \rangle
$$

com limites existentes quando \( t \to a \):

$$
\lim_{t \to a} \mathbf{r}(t) = \mathbf{L} = \langle L_1, L_2, L_3 \rangle, \quad \lim_{t \to a} \mathbf{v}(t) = \mathbf{M} = \langle M_1, M_2, M_3 \rangle.
$$

## Passo 1: Desenvolvimento do Produto Vetorial

O produto vetorial em componentes é:

$$
\mathbf{r}(t) \times \mathbf{v}(t) = \langle r_2(t)v_3(t) - r_3(t)v_2(t),\; r_3(t)v_1(t) - r_1(t)v_3(t),\; r_1(t)v_2(t) - r_2(t)v_1(t) \rangle
$$

## Passo 2: Aplicação do Limite

Aplicando o limite a cada componente:

$$
\begin{aligned}
\lim_{t \to a} (\mathbf{r}(t) \times \mathbf{v}(t)) &= \langle \lim_{t \to a}(r_2 v_3 - r_3 v_2), \lim_{t \to a}(r_3 v_1 - r_1 v_3), \lim_{t \to a}(r_1 v_2 - r_2 v_1) \rangle \\
&= \langle L_2 M_3 - L_3 M_2, L_3 M_1 - L_1 M_3, L_1 M_2 - L_2 M_1 \rangle
\end{aligned}
$$

## Passo 3: Identificação do Produto Vetorial dos Limites

O resultado é exatamente o produto vetorial dos limites:

$$
\mathbf{L} \times \mathbf{M} = \langle L_2 M_3 - L_3 M_2, L_3 M_1 - L_1 M_3, L_1 M_2 - L_2 M_1 \rangle
$$

## Teorema Final

Portanto, temos:

$$
\boxed{
\lim_{t \to a} \left( \mathbf{r}(t) \times \mathbf{v}(t) \right) = \left( \lim_{t \to a} \mathbf{r}(t) \right) \times \left( \lim_{t \to a} \mathbf{v}(t) \right)
}
$$

**Condição:** Os limites \(\mathbf{L}\) e \(\mathbf{M}\) devem existir.
