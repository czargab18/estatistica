@echo off
:: Script CMD para ren::Determinar arquivo de saída
if "%OUTPUT_FILE%"=="" (
    for %%F in ("%INPUT_FILE%") do (
        set INPUT_DIR=%%~dpF
        set LOCAL_OUTPUT_DIR=!INPUT_DIR!output
        
        :: Verificar se existe pasta output local junto com o arquivo de entrada
        if exist "!LOCAL_OUTPUT_DIR!" (
            set OUTPUT_FILE=!LOCAL_OUTPUT_DIR!\%%~nF.html
            echo Usando diretorio de output local: !LOCAL_OUTPUT_DIR!
        ) else (
            set OUTPUT_FILE=%OUTPUT_DIR%\%%~nF.html
        )
    )
)ção de Markdown para HTML - Apple Newsroom
:: Versão: 1.0
:: Uso: render.cmd arquivo.md [arquivo_saida.html]

setlocal enabledelayedexpansion

:: Configurações
set SCRIPT_DIR=%~dp0
set TEMPLATE_FILE=%SCRIPT_DIR%modelos\template.html
set COMPONENTS_DIR=%SCRIPT_DIR%components
set OUTPUT_DIR=%SCRIPT_DIR%output

:: Verificar argumentos
if "%1"=="" (
    echo ERRO: Arquivo de entrada necessario
    echo Uso: render.cmd arquivo.md [arquivo_saida.html]
    echo.
    echo Exemplos:
    echo   render.cmd artigo.md
    echo   render.cmd artigo.md meu_artigo.html
    exit /b 1
)

set INPUT_FILE=%1
set OUTPUT_FILE=%2

:: Verificar se arquivo de entrada existe
if not exist "%INPUT_FILE%" (
    echo ERRO: Arquivo nao encontrado: %INPUT_FILE%
    exit /b 1
)

:: Determinar arquivo de saída
if "%OUTPUT_FILE%"=="" (
    for %%F in ("%INPUT_FILE%") do (
        :: Verificar se o arquivo de entrada é artigo.md e definir como index.html
        if /i "%%~nF"=="artigo" (
            set OUTPUT_FILE=%OUTPUT_DIR%\index.html
        ) else (
            set OUTPUT_FILE=%OUTPUT_DIR%\%%~nF.html
        )
    )
)

:: Verificar se template existe
if not exist "%TEMPLATE_FILE%" (
    echo ERRO: Template nao encontrado: %TEMPLATE_FILE%
    echo Certifique-se de que o template.html esta na pasta modelos/
    exit /b 1
)

:: Criar diretório de saída se não existir
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

:: Mostrar informações
echo ====================================================
echo RENDERIZACAO MARKDOWN - APPLE NEWSROOM (CMD)
echo ====================================================
echo Entrada: %INPUT_FILE%
echo Saida:   %OUTPUT_FILE%
echo Template: %TEMPLATE_FILE%
echo ====================================================

:: Executar Pandoc
echo Executando pandoc...
pandoc "%INPUT_FILE%" ^
    --output "%OUTPUT_FILE%" ^
    --template="%TEMPLATE_FILE%" ^
    --standalone ^
    --from=markdown+yaml_metadata_block ^
    --to=html5 ^
    --section-divs ^
    --wrap=none

:: Verificar resultado
if %ERRORLEVEL% neq 0 (
    echo ERRO: Falha na conversao pandoc
    exit /b %ERRORLEVEL%
)

:: Verificar se arquivo foi criado
if not exist "%OUTPUT_FILE%" (
    echo ERRO: Arquivo de saida nao foi criado
    exit /b 1
)

:: Sucesso
echo.
echo ====================================================
echo SUCESSO: Arquivo HTML gerado!
echo ====================================================
echo Arquivo: %OUTPUT_FILE%

:: Mostrar tamanho do arquivo
for %%F in ("%OUTPUT_FILE%") do (
    echo Tamanho: %%~zF bytes
)

echo.
echo Dica: Abra o arquivo em um navegador para visualizar
echo.

endlocal
