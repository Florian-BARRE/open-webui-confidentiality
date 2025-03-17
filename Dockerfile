# Étape 1 : Utiliser une image Node.js officielle avec la version recommandée
FROM node:20.18.1-bullseye-slim AS base

# Installer Conda
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && curl -sSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -b -p /opt/conda \
    && rm /tmp/miniconda.sh \
    && echo "export PATH=/opt/conda/bin:$PATH" >> ~/.bashrc

# Définir le répertoire de travail
WORKDIR /app

# Cloner le dépôt
RUN git clone https://github.com/Florian-BARRE/open-webui-confidentiality.git /app

# Étape 2 : Configuration du frontend
WORKDIR /app/

# Copier le fichier .env.example et renommer en .env
RUN cp -RPp .env.example .env

# Installer les dépendances du frontend
RUN npm install

# Étape 3 : Configuration du backend
WORKDIR /app/backend

# Créer et activer l'environnement Conda pour le backend
RUN /opt/conda/bin/conda create --name open-webui python=3.11 -y \
    && echo "conda activate open-webui" >> ~/.bashrc

# Installer les dépendances du backend
RUN /opt/conda/envs/open-webui/bin/pip install -r requirements.txt -U

# Étape 4 : Exposer les ports nécessaires
EXPOSE 5173 8080

WORKDIR /app/

# Étape 5 : Commande pour démarrer le frontend et le backend
CMD ["/app/start.sh"]