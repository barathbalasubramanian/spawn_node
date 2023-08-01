FROM node:18-alpine

WORKDIR /app

FROM python:3.8-slim-buster

RUN apk add  python3 py3-pip gcc g++ musl-dev python3-dev

RUN pip install --no-cache-dir torch>=1.7.0

COPY ["package.json", "package-lock.json*", "./"]
COPY requirements.txt requirements.txt

RUN npm install --production
RUN pip3 install -r requirements.txt

COPY . .

CMD ["node", "app.js"]
