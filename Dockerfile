# ---- Base Node ----
FROM node:18-buster AS base
WORKDIR /app
COPY ["package.json", "package-lock.json*", "./"]
RUN npm install --production

# installing pip
RUN apt-get update
RUN apt-get install sudo 
RUN sudo apt-get install python3 
# RUN sudo apt-get install python3-pip



# ---- Base Python ----
FROM python:3.11-buster AS python-base
WORKDIR /app

RUN pip install numpy==1.23.5
# RUN pip install torch==1.4.0
COPY ./requirements.txt req.txt

RUN pip3 install -r req.txt

# ---- Copy Files/Build ----
FROM base AS build
WORKDIR /app
COPY --from=python-base /app /app
COPY . .
CMD ["node", "app.js"]
