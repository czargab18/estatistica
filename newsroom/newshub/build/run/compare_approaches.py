#!/usr/bin/env python3
"""
Script de Comparação: PowerShell vs Python/pypandoc
Análise comparativa para sistema Apple Newsroom
"""

import os
import time
import subprocess
import sys
from pathlib import Path
import psutil
import json

class PerformanceComparator:
    def __init__(self):
        self.base_dir = Path(__file__).parent
        self.results = {}
    
    def measure_powershell_approach(self, input_file):
        """Mede desempenho da abordagem PowerShell"""
        print("🔄 Testando abordagem PowerShell...")
        
        powershell_script = self.base_dir / "process-md-newsroom.ps1"
        
        # Medir tempo e recursos
        start_time = time.time()
        start_memory = psutil.Process().memory_info().rss / 1024 / 1024  # MB
        
        try:
            # Executar script PowerShell
            result = subprocess.run([
                "powershell.exe", 
                "-ExecutionPolicy", "Bypass",
                "-File", str(powershell_script),
                input_file
            ], capture_output=True, text=True, timeout=60)
            
            end_time = time.time()
            end_memory = psutil.Process().memory_info().rss / 1024 / 1024  # MB
            
            execution_time = end_time - start_time
            memory_used = end_memory - start_memory
            
            success = result.returncode == 0
            
            return {
                'approach': 'PowerShell',
                'success': success,
                'execution_time': execution_time,
                'memory_used': memory_used,
                'stdout': result.stdout,
                'stderr': result.stderr,
                'return_code': result.returncode
            }
            
        except subprocess.TimeoutExpired:
            return {
                'approach': 'PowerShell',
                'success': False,
                'execution_time': 60,
                'memory_used': 0,
                'error': 'Timeout após 60 segundos'
            }
        except Exception as e:
            return {
                'approach': 'PowerShell',
                'success': False,
                'execution_time': 0,
                'memory_used': 0,
                'error': str(e)
            }
    
    def measure_python_approach(self, input_file):
        """Mede desempenho da abordagem Python"""
        print("🐍 Testando abordagem Python...")
        
        python_script = self.base_dir / "process_md_newsroom.py"
        
        # Medir tempo e recursos
        start_time = time.time()
        start_memory = psutil.Process().memory_info().rss / 1024 / 1024  # MB
        
        try:
            # Executar script Python
            result = subprocess.run([
                "python", 
                str(python_script),
                input_file
            ], capture_output=True, text=True, timeout=60, cwd=str(self.base_dir))
            
            end_time = time.time()
            end_memory = psutil.Process().memory_info().rss / 1024 / 1024  # MB
            
            execution_time = end_time - start_time
            memory_used = end_memory - start_memory
            
            success = result.returncode == 0
            
            return {
                'approach': 'Python',
                'success': success,
                'execution_time': execution_time,
                'memory_used': memory_used,
                'stdout': result.stdout,
                'stderr': result.stderr,
                'return_code': result.returncode
            }
            
        except subprocess.TimeoutExpired:
            return {
                'approach': 'Python',
                'success': False,
                'execution_time': 60,
                'memory_used': 0,
                'error': 'Timeout após 60 segundos'
            }
        except Exception as e:
            return {
                'approach': 'Python',
                'success': False,
                'execution_time': 0,
                'memory_used': 0,
                'error': str(e)
            }
    
    def compare_approaches(self, input_file, iterations=3):
        """Compara ambas abordagens com múltiplas execuções"""
        print(f"📊 Comparando abordagens com {iterations} iterações...")
        print(f"📄 Arquivo de teste: {input_file}")
        print("=" * 80)
        
        powershell_results = []
        python_results = []
        
        # Executar múltiplas iterações para cada abordagem
        for i in range(iterations):
            print(f"\n🔄 Iteração {i+1}/{iterations}")
            
            # Testar PowerShell
            ps_result = self.measure_powershell_approach(input_file)
            powershell_results.append(ps_result)
            
            # Testar Python
            py_result = self.measure_python_approach(input_file)
            python_results.append(py_result)
            
            # Pausa entre iterações
            time.sleep(1)
        
        # Calcular estatísticas
        ps_times = [r['execution_time'] for r in powershell_results if r['success']]
        py_times = [r['execution_time'] for r in python_results if r['success']]
        
        ps_memory = [r['memory_used'] for r in powershell_results if r['success']]
        py_memory = [r['memory_used'] for r in python_results if r['success']]
        
        # Resultados consolidados
        comparison_results = {
            'powershell': {
                'success_rate': sum(1 for r in powershell_results if r['success']) / iterations * 100,
                'avg_time': sum(ps_times) / len(ps_times) if ps_times else 0,
                'min_time': min(ps_times) if ps_times else 0,
                'max_time': max(ps_times) if ps_times else 0,
                'avg_memory': sum(ps_memory) / len(ps_memory) if ps_memory else 0,
                'raw_results': powershell_results
            },
            'python': {
                'success_rate': sum(1 for r in python_results if r['success']) / iterations * 100,
                'avg_time': sum(py_times) / len(py_times) if py_times else 0,
                'min_time': min(py_times) if py_times else 0,
                'max_time': max(py_times) if py_times else 0,
                'avg_memory': sum(py_memory) / len(py_memory) if py_memory else 0,
                'raw_results': python_results
            }
        }
        
        return comparison_results
    
    def generate_report(self, results, input_file):
        """Gera relatório detalhado da comparação"""
        print("\n" + "="*80)
        print("📈 RELATÓRIO COMPARATIVO: PowerShell vs Python/pypandoc")
        print("="*80)
        
        print(f"📄 Arquivo testado: {input_file}")
        print(f"🕒 Data/Hora: {time.strftime('%Y-%m-%d %H:%M:%S')}")
        
        # Resultados PowerShell
        ps = results['powershell']
        print(f"\n🔷 POWERSHELL:")
        print(f"   ✅ Taxa de sucesso: {ps['success_rate']:.1f}%")
        print(f"   ⏱️  Tempo médio: {ps['avg_time']:.3f}s")
        print(f"   ⚡ Tempo mínimo: {ps['min_time']:.3f}s")
        print(f"   🐌 Tempo máximo: {ps['max_time']:.3f}s")
        print(f"   🧠 Memória média: {ps['avg_memory']:.1f} MB")
        
        # Resultados Python
        py = results['python']
        print(f"\n🐍 PYTHON:")
        print(f"   ✅ Taxa de sucesso: {py['success_rate']:.1f}%")
        print(f"   ⏱️  Tempo médio: {py['avg_time']:.3f}s")
        print(f"   ⚡ Tempo mínimo: {py['min_time']:.3f}s")
        print(f"   🐌 Tempo máximo: {py['max_time']:.3f}s")
        print(f"   🧠 Memória média: {py['avg_memory']:.1f} MB")
        
        # Comparação direta
        print(f"\n🏆 VENCEDOR:")
        if py['avg_time'] < ps['avg_time'] and py['success_rate'] >= ps['success_rate']:
            speed_improvement = ((ps['avg_time'] - py['avg_time']) / ps['avg_time']) * 100
            print(f"   🐍 Python é {speed_improvement:.1f}% mais rápido")
        elif ps['avg_time'] < py['avg_time'] and ps['success_rate'] >= py['success_rate']:
            speed_improvement = ((py['avg_time'] - ps['avg_time']) / py['avg_time']) * 100
            print(f"   🔷 PowerShell é {speed_improvement:.1f}% mais rápido")
        else:
            print(f"   🤝 Desempenho similar (diferença < 5%)")
        
        # Vantagens e desvantagens
        print(f"\n📋 ANÁLISE QUALITATIVA:")
        
        print(f"\n🔷 PowerShell - Vantagens:")
        print("   • Nativo no Windows")
        print("   • Sem dependências Python")
        print("   • Integração direta com sistema")
        print("   • Controle fino sobre processos")
        
        print(f"\n🔷 PowerShell - Desvantagens:")
        print("   • Sintaxe mais verbosa")
        print("   • Tratamento de erro manual")
        print("   • Menos portabilidade")
        print("   • Parsing YAML manual")
        
        print(f"\n🐍 Python - Vantagens:")
        print("   • Código mais limpo e legível")
        print("   • Bibliotecas especializadas (pypandoc, PyYAML)")
        print("   • Melhor estruturação OOP")
        print("   • Tratamento de erro mais robusto")
        print("   • Mais portável (Linux/Mac)")
        
        print(f"\n🐍 Python - Desvantagens:")
        print("   • Requer instalação de dependências")
        print("   • Overhead da VM Python")
        print("   • Possível problema com PATH/ambiente")
        
        # Recomendação
        print(f"\n🎯 RECOMENDAÇÃO:")
        if py['avg_time'] < ps['avg_time'] * 0.95 and py['success_rate'] >= 90:
            print("   🐍 Usar Python/pypandoc para:")
            print("     - Projetos que requerem portabilidade")
            print("     - Equipes familiarizadas com Python")
            print("     - Necessidade de extensibilidade futura")
            print("     - Processamento em lote frequente")
        elif ps['success_rate'] >= 90:
            print("   🔷 Usar PowerShell para:")
            print("     - Ambientes 100% Windows")
            print("     - Scripts simples e pontuais")
            print("     - Evitar dependências externas")
            print("     - Integração com scripts Windows existentes")
        else:
            print("   ⚠️  Ambas abordagens precisam de ajustes")
        
        print("\n" + "="*80)
        
        # Salvar relatório JSON
        report_file = self.base_dir / f"performance_report_{int(time.time())}.json"
        with open(report_file, 'w', encoding='utf-8') as f:
            json.dump(results, f, indent=2, ensure_ascii=False)
        
        print(f"💾 Relatório detalhado salvo em: {report_file}")

def main():
    if len(sys.argv) != 2:
        print("Uso: python compare_approaches.py <arquivo.md>")
        sys.exit(1)
    
    input_file = sys.argv[1]
    if not Path(input_file).exists():
        print(f"❌ Arquivo não encontrado: {input_file}")
        sys.exit(1)
    
    comparator = PerformanceComparator()
    results = comparator.compare_approaches(input_file, iterations=3)
    comparator.generate_report(results, input_file)

if __name__ == "__main__":
    main()
