#!/bin/bash

# 🚀 Scripts de Execução - Time Management App

## Para executar o app sem problemas de CORS

echo "🚀 Time Management App - Launcher"
echo "=================================="
echo ""
echo "Escolha uma opção:"
echo "1. ⭐ Executar no Desktop Linux (RECOMENDADO - sem CORS)"
echo "2. 🌐 Executar no Chrome Web (pode ter CORS)"
echo "3. 📱 Verificar dispositivos disponíveis"
echo "4. 🔧 Chrome Web SEM CORS (desenvolvimento)"
echo "5. 🧪 Executar testes"
echo ""

read -p "Digite sua escolha (1-5): " choice

case $choice in
    1)
        echo "⭐ Executando no Desktop Linux..."
        echo "✅ Sem problemas de CORS!"
        flutter run -d linux
        ;;
    2)
        echo "🌐 Executando no Chrome Web..."
        echo "⚠️  ATENÇÃO: Pode ter problemas de CORS!"
        echo "💡 Se der erro, use opção 1 ou 4"
        flutter run -d chrome
        ;;
    3)
        echo "📱 Dispositivos disponíveis:"
        flutter devices
        ;;
    4)
        echo "🔧 Executando Chrome SEM CORS (desenvolvimento)..."
        echo "⚠️  APENAS PARA DESENVOLVIMENTO!"
        echo "🔄 Fechando Chrome existente..."
        pkill chrome 2>/dev/null || true
        pkill chromium 2>/dev/null || true
        sleep 2
        
        echo "🚀 Iniciando Chrome sem CORS..."
        # Tentar Google Chrome primeiro
        if command -v google-chrome &> /dev/null; then
            google-chrome --user-data-dir="/tmp/chrome_dev_test" --disable-web-security --disable-features=VizDisplayCompositor &
        elif command -v chromium &> /dev/null; then
            chromium --user-data-dir="/tmp/chrome_dev_test" --disable-web-security --disable-features=VizDisplayCompositor &
        elif command -v chromium-browser &> /dev/null; then
            chromium-browser --user-data-dir="/tmp/chrome_dev_test" --disable-web-security --disable-features=VizDisplayCompositor &
        else
            echo "❌ Chrome/Chromium não encontrado!"
            echo "💡 Instale com: sudo apt install chromium-browser"
            exit 1
        fi
        
        echo "⏳ Aguardando Chrome inicializar..."
        sleep 3
        
        echo "🚀 Executando Flutter Web..."
        flutter run -d chrome
        ;;
    5)
        echo "🧪 Executando testes..."
        flutter test
        ;;
    *)
        echo "❌ Opção inválida! Use 1-5"
        exit 1
        ;;
esac
