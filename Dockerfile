# ---- Base Node ----
FROM node:18-buster AS base
WORKDIR /app
COPY ["package.json", "package-lock.json*", "./"]
RUN npm install --production

# ---- Base Python ----
FROM python:3.11-buster AS python-base
WORKDIR /pyapp

# RUN pip install torch==1.4.0

COPY ./requirements.txt requirements.txt
RUN pip install -r requirements.txt

# ---- Copy Files/Build ----
FROM base AS build
WORKDIR /app
COPY --from=python-base /pyapp /pyapp
COPY . .
CMD ["node", "app.js"]
