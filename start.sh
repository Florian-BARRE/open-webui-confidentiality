#!/bin/bash

# Démarrer le serveur frontend
npm run dev &

# Naviguer vers le répertoire backend et démarrer le serveur backend
cd backend
sh dev.sh
