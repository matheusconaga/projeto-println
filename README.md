<h1 align="center">📲 PrintLn</h1>

<p align="center">
Rede social moderna com foco em experiência mobile, autenticação segura e integração com serviços em nuvem.
</p>

<p align="center">
  <img src="https://github.com/matheusconaga/projeto-println/blob/main/assets/feed_println.png?raw=true" width="250"/>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white"/>
  <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black"/>
  <img src="https://img.shields.io/badge/Cloudinary-3448C5?style=for-the-badge&logo=cloudinary&logoColor=white"/>
  <img src="https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white"/>

</p>

<p align="center">
  <a href="https://println-social.vercel.app/" target="_blank"><img src="https://img.shields.io/badge/🌐%20Live%20Demo-000000?style=for-the-badge"/></a>
  <a href="https://println-api.onrender.com/docs" target="_blank"><img src="https://img.shields.io/badge/⚙️%20Backend%20API-009688?style=for-the-badge"/></a>
</p>

## 📌 Sobre o Projeto

O **PrintLn** é uma rede social mobile desenvolvida para oferecer uma experiência fluida de compartilhamento de conteúdo, com foco em performance, simplicidade e integração com serviços modernos em nuvem.

O usuário pode criar posts com texto e imagem, interagir com suas próprias publicações e utilizar recursos nativos do dispositivo como **câmera e geolocalização**.

### Principais funcionalidades:

- 🔐 Cadastro e autenticação de usuários
- 📝 Criação, edição e exclusão de posts e comentários
- 📸 Upload de imagens com câmera ou galeria
- 📍 Integração com localização (cidade/estado)
- ❤️ Feed de publicações em tempo real
- 💾 Salvamento de posts
- 👤 Alteração de username e foto de perfil
- 🌙 Modo escuro integrado ao aplicativo
- 📱 Interface mobile responsiva

### 🧪 Acesso para Testes

Caso queira explorar rapidamente a aplicação sem criar uma conta, utilize o login de demonstração:

```text
E-mail: matheus@gmail.com
Senha: 123456
```

---

## 🧠 Diferenciais

- ⚡ Experiência mobile-first
- 🔄 Estado reativo com MobX
- 🌐 Arquitetura separada (Frontend + Backend API)
- 📍 Geolocalização híbrida (Web + Mobile)
- ☁️ Integração com serviços externos em nuvem
- 🧩 Escalável e modular
  
---

## 🛠️ Stack Tecnológica

### 📱 Frontend (Flutter)

<p>
  <img src="https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white"/>
  <img src="https://img.shields.io/badge/MobX-FF9955?style=flat"/>
  <img src="https://img.shields.io/badge/Dio-000000?style=flat"/>
  <img src="https://img.shields.io/badge/Geolocator-3DDC84?style=flat"/>
</p>

### ⚙️ Backend e Serviços

<p>
  <img src="https://img.shields.io/badge/FastAPI-009688?style=flat&logo=fastapi&logoColor=white"/>
  <img src="https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white"/>
  <img src="https://img.shields.io/badge/Firebase-FFCA28?style=flat&logo=firebase&logoColor=black"/>
  <img src="https://img.shields.io/badge/PostgreSQL-336791?style=flat&logo=postgresql&logoColor=white"/>
  <img src="https://img.shields.io/badge/Cloudinary-3448C5?style=flat&logo=cloudinary&logoColor=white"/>
</p>


### 🌐 Deploys

<p>
  <a href="https://println-social.vercel.app/" target="_blank"><img src="https://img.shields.io/badge/Vercel-000000?style=flat&logo=vercel&logoColor=white"/></a>
  <a href="https://println-api.onrender.com/docs" target="_blank"><img src="https://img.shields.io/badge/Render-46E3B7?style=flat&logo=render&logoColor=black"/></a>
</p>

---

## 🧱 Arquitetura do Sistema

```text
Flutter App (PrintLn)
      ↓
FastAPI (Backend REST)
      ↓
Firebase Auth → autenticação
Cloudinary → imagens
PostgreSQL → dados
```

---

## 💻 Como rodar o projeto localmente

### 📱 Frontend (Flutter)
Acesse a pasta do projeto 
```bash
cd println
```
Instale as dependências

```bash
flutter pub get
```
Rode o app
```bash
flutter run
```

### ⚙️ Backend (FastAPI)
Acesse a pasta do projeto 
```bash
cd api_println
```
Crie uma maquina virtual
```bash
python -m venv venv
```
Acesse a maquina virtual
```bash
.\venv/bin/activate
```
Baixe os requirements
```bash
pip install -r requirements.txt
```
Rode a api
```bash
uvicorn main:app --host 0.0.0.0 --port 8000
```
## ⚙️ Variáveis de Ambiente

Crie um arquivo `.env` na raiz do api_println com as seguintes configurações:

```env
# Cloudinary
CLOUDINARY_CLOUD_NAME
CLOUDINARY_API_KEY
CLOUDINARY_API_SECRET

# Neon
DATABASE_URL

# PyJWT
JWT_SECRET_KEY
JWT_ALGORITHM
JWT_EXPIRE_MINUTES

# Firebase
FIREBASE_API_KEY
FIREBASE_CREDENTIALS_JSON

```
---

## 📈 Possíveis Evoluções

- 🧪 Testes automatizados no backend e frontend
- 🔐 Recuperação de senha por e-mail
- 🔔 Push notifications em tempo real
- 👥 Sistema de amigos, seguidores e seguindo
- 📰 Feed personalizado de usuários seguidos
- 🔍 Filtros de usuários e publicações
- 📊 Dashboard de métricas do usuário

---

## 📄 Licença
<p>
Este projeto está disponível para fins de estudo, portfólio e aprendizado. 
Sinta-se à vontade para fazer um fork, evoluir a solução e criar novas melhorias a partir dele.
</p>

---

## 👨‍💻 Autor

<p align="center">
  <img src="https://avatars.githubusercontent.com/matheusconaga" width="110px;" style="border-radius:50%;" />
</p>

<h3 align="center">Matheus Lula</h3>

<p align="center">
Desenvolvedor Fullstack • React • Flutter • FastAPI • IA
</p>

<div align="center">
<a href="mailto:matheusphillip170@gmail.com"><img src="https://img.shields.io/badge/Gmail-FF0000?style=for-the-badge&logo=gmail&logoColor=white"/></a>
<a href="https://www.linkedin.com/in/matheusconaga/"><img src="https://img.shields.io/badge/💼%20LinkedIn-0e76a8?style=for-the-badge&logo=linkedin"/></a>
<a href="https://portifoliomatheuslula.onrender.com/"><img src="https://img.shields.io/badge/Portfólio-000000?style=for-the-badge&logo=render&logoColor=white"/></a>
</div>
