# Exercícios de Limites em Várias Variáveis via Definição ε-δ

## Problema 1 (Limite existente)
Calcule usando a definição ε-δ:

$$
\lim_{(x,y)\to(0,0)} \frac{x^3 + y^3}{x^2 + y^2}
$$

**Dica:** Comece limitando a expressão usando coordenadas polares ou a desigualdade $|x^3| \leq x^2\sqrt{x^2 + y^2}$.

---

## Problema 2 (Limite em ponto arbitrário)
Demonstre via definição formal:

$$
\lim_{(x,y)\to(1,2)} (x^2y - 2xy + 3) = 3
$$

**Dica:** Reescreva como $f(1+h,2+k)-3$ e desenvolva a expressão.

---

## Problema 3 (Limite que não existe)
Prove que o seguinte limite não existe:

$$
\lim_{(x,y)\to(0,0)} \frac{x^2y}{x^4 + y^2}
$$

**Sugestão:** Considere os caminhos $y = kx^2$ para diferentes valores de $k$.

---

## Problema 4 (Caso tridimensional)
Calcule usando definição ε-δ:

$$
\lim_{(x,y,z)\to(0,0,0)} \frac{xyz}{x^2 + y^2 + z^2}
$$

**Técnica útil:** Use $|xyz| \leq \frac{(x^2 + y^2 + z^2)^{3/2}}{3\sqrt{3}}$.

---

## Problema 5 (Função trigonométrica)
Demonstre que:

$$
\lim_{(x,y)\to(0,0)} \frac{\sin(x^2 + y^2)}{x^2 + y^2} = 1
$$

**Dica:** Use o limite fundamental $\lim_{t\to 0} \frac{\sin t}{t} = 1$.

---

## Problema 6 (Caso desafiador)
Investigue a existência do limite:

$$
\lim_{(x,y)\to(0,0)} \frac{x^4 + y^4}{(x^2 + y^2)^2}
$$

**Análise:** Considere diferentes caminhos de aproximação e tente encontrar uma majoração.

---

## Problema 7 (Função racional)
Prove usando ε-δ:

$$
\lim_{(x,y)\to(0,0)} \frac{xy^2}{x^2 + y^2} = 0
$$

**Sugestão:** Use $|xy^2| \leq \frac{(x^2 + y^2)^{3/2}}{2}$.

---

## Problema 8 (Caso com valor não-nulo)
Demonstre que:

$$
\lim_{(x,y)\to(2,-1)} (3x - 2y + 1) = 9
$$

**Abordagem:** Aplique a definição diretamente para função linear.

---

## Problema 9 (Limite direcional)
Investigue:

$$
\lim_{(x,y)\to(0,0)} \frac{x^2 - y^2}{\sqrt{x^2 + y^2}}
$$

**Dica:** Analise primeiro em coordenadas polares.

---

## Problema 10 (Caso patológico)
Prove que não existe:

$$
\lim_{(x,y)\to(0,0)} \frac{xy}{x^2 + y^2}
$$

**Método:** Mostre que os limites direcionais diferem.
