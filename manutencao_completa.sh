#!/bin/bash

# Dando permissão de execução ao próprio arquivo
chmod +x "$0"

echo "Iniciando manutenção completa do sistema..."

# ========================
# 1. Limpeza de Arquivos Temporários
# ========================
echo "1. Limpando arquivos temporários do sistema..."
sudo rm -rf /var/tmp/*
sudo rm -rf /tmp/*
sudo apt-get clean

# ========================
# 2. Limpeza de Dados de Navegadores
# ========================
echo "2. Limpando dados de navegadores..."

# Para Chromium
if [ -d "/home/pi/.config/chromium" ]; then
  echo "Limpando dados do Chromium..."
  rm -rf /home/pi/.config/chromium/Default/* 2> /dev/null
  rm -rf /home/pi/.config/chromium/Default/Local\ Storage 2> /dev/null
fi

# Para Firefox (se estiver instalado)
if [ -d "/home/pi/.mozilla/firefox" ]; then
  echo "Limpando dados do Firefox..."
  rm -rf /home/pi/.mozilla/firefox/*.default-release/{cache2,storage,safebrowsing,crashes,updates} 2> /dev/null
  rm -rf /home/pi/.mozilla/firefox/*.default-release/{cookies.sqlite,webappsstore.sqlite,signons.sqlite,places.sqlite} 2> /dev/null
fi

# ========================
# 3. Remoção de Pacotes Desnecessários
# ========================
echo "3. Removendo pacotes desnecessários..."
sudo apt-get autoremove --purge -y
sudo apt-get autoclean -y

# ========================
# 4. Desfragmentação do Sistema de Arquivos (se aplicável)
# ========================
if command -v e4defrag &> /dev/null; then
  echo "4. Desfragmentando o sistema de arquivos..."
  sudo e4defrag /
else
  echo "O comando e4defrag não está disponível. Pular desfragmentação."
fi

# ========================
# 5. Exclusão de Arquivos Baixados Recentemente
# ========================
echo "5. Excluindo arquivos baixados recentemente..."
rm -rf /home/pi/Downloads/*
rm -rf /home/pi/Pictures/*

# ========================
# 6. Esvaziar a Lixeira
# ========================
echo "6. Esvaziando a lixeira..."
rm -rf /home/pi/.local/share/Trash/*

# ========================
# 7. Excluir Todos os Arquivos em /home/pi (Exceto Pastas)
# ========================
echo "7. Excluindo todos os arquivos em /home/pi (exceto pastas)..."
find /home/pi -maxdepth 1 -type f -exec rm -f {} \;

# ========================
# 8. Histórico de Comandos 'apt-get install'
# ========================
echo "8. Mostrando histórico de comandos apt-get install usados:"
history | grep "apt-get install"


echo "Manutenção completa do sistema concluída!"

