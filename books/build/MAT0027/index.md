resumindo limite pela definição:
caso queira comer tua mãe com força sem quebrar o quadril dela, basta saber a força para botar de tal modo que eu consiga não quebrar o quadril dela.

De forma mais delicada: dado uma margem de erro epsilon na imagen, devo saber qual o valor de um delta no domínio que me permita sempre estar dentro da margem epsilon.

# Cálculo do Limite $\lim_{(x,y) \to (0,0)} \frac{xy}{\sqrt{x^2 + y^2}}$

## Solução via Definição $\epsilon$-$\delta$

### Passo 1: Manipulação da Expressão

Queremos limitar $\left| \frac{xy}{\sqrt{x^2 + y^2}} \right|$. Partimos da desigualdade:

$$
(|x| - |y|)^2 \geq 0 \implies x^2 + y^2 \geq 2|xy| \implies |xy| \leq \frac{x^2 + y^2}{2}
$$

Substituindo na função original:

$$
\left| \frac{xy}{\sqrt{x^2 + y^2}} \right| \leq \frac{\frac{x^2 + y^2}{2}}{\sqrt{x^2 + y^2}} = \frac{\sqrt{x^2 + y^2}}{2}
$$

### Passo 2: Escolha de $\delta$

Para garantir $\left| f(x,y) \right| < \epsilon$, basta:

$$
\frac{\sqrt{x^2 + y^2}}{2} < \epsilon \implies \sqrt{x^2 + y^2} < 2\epsilon
$$

Portanto, escolhemos **$\delta = 2\epsilon$**.

### Passo 3: Verificação Formal

Dado $\epsilon > 0$, tome $\delta = 2\epsilon$. Se $0 < \sqrt{x^2 + y^2} < \delta$, então:

$$
\left| \frac{xy}{\sqrt{x^2 + y^2}} \right| \leq \frac{\delta}{2} = \epsilon
$$

### Passo 4: Conclusão

$$
\boxed{\lim_{(x,y) \to (0,0)} \frac{xy}{\sqrt{x^2 + y^2}} = 0}
$$

## Confirmação via Coordenadas Polares

Seja:
- $x = r\cos\theta$
- $y = r\sin\theta$
- $r = \sqrt{x^2 + y^2} \to 0$

Substituindo:

$$
\frac{xy}{\sqrt{x^2 + y^2}} = \frac{r^2 \cos\theta \sin\theta}{r} = r \cos\theta \sin\theta
$$

Como $|\cos\theta \sin\theta| \leq \frac{1}{2}$ para todo $\theta$:

$$
|r \cos\theta \sin\theta| \leq \frac{r}{2} \to 0 \quad \text{quando} \quad r \to 0
$$

## Resumo da Prova

1. **Limitante Superior**:
   $$\left| \frac{xy}{\sqrt{x^2 + y^2}} \right| \leq \frac{r}{2}$$

2. **Escolha de $\delta$**:
   $$\delta = 2\epsilon$$

3. **Verificação**:
   $$0 < r < \delta \implies |f(x,y)| < \epsilon$$

4. **Convergência Uniforme**:
   O limite vale para qualquer caminho de aproximação à origem.
