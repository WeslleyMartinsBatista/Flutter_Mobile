#!/bin/bash

# Baixa o Flutter
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:`pwd`/flutter/bin"

# Habilita suporte web e baixa dependências
flutter config --enable-web
flutter pub get

# Gera a versão Web em modo release
flutter build web --release