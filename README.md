# PrintLn

> Rede social mobile com foco em experiência de uso, integração com serviços em nuvem e gerenciamento reativo de estado.

<p align="center">
  <img src="println/assets/logo.png" alt="PrintLn Logo" width="140" />
</p>

---

## 📌 Visão Geral

O **PrintLn** é um aplicativo mobile que permite aos usuários:

- Criar conta e autenticar com segurança;
- Postar textos e imagens com recursos nativos de câmera e localização;
- Editar ou deletar postagens próprias;
- Visualizar detalhes completos de cada post;
- Salvar publicações para acesso posterior;
- Navegar em um feed com experiência fluida e intuitiva.

O projeto foi pensado para dispositivos Android, testado em **Galaxy A56 com Android 16**.

---

## 🧱 Stack Utilizada

### Frontend
- **Flutter 3**
- **MobX** para gerenciamento de estado
- **Dio** para comunicação com a API
- Recursos nativos: **câmera** e **localização**
- Ambiente de teste: **Android**
- NDK: `29.0.14206865`

### Backend
- **FastAPI**
- **Firebase Authentication** para login e sessão
- **Cloudinary** para hospedagem de imagens
- **Neon (PostgreSQL)** para persistência de dados

---

## ⚡ Funcionalidades Principais

- Cadastro e login de usuários
- Criação e edição de posts
- Exclusão de posts pelo autor
- Feed principal de publicações
- Detalhes do post
- Posts salvos
- Gerenciamento reativo de estado com MobX
- Consumo da API com Dio
- Uso de recursos nativos do dispositivo (câmera e localização)

---

## 🧭 Experiência de Uso

- Interface limpa, responsiva e fácil de navegar;
- Botões de ação claros (editar, deletar, salvar post);
- Feedback visual em carregamentos e autenticação;
- Layout adaptado para dispositivos móveis Android.

---

## 🛠️ Como executar o Backend

1. Coloque os arquivos:
.env (raiz)
app/core/firebase_service_account.json

2. Baixe a maquina virtual python
python -m venv venv

3. Instale as dependências na maquina virtual
pip install -r requirements.txt

4. Execute a API geral
uvicorn main:app --host 0.0.0.0 --port 8000

## 🛠️ Como executar o Frontend

1. Coloque o arquivo do Firebase:

2. Ajuste a URL do backend no serviço correspondente.

3. Instale as dependências:
    flutter pub get
   
5. Execute o app

## 🔐 Serviços Externos

1. Firebase Auth → autenticação de usuários

2. Cloudinary → hospedagem de imagens

3. Neon PostgreSQL → banco de dados da aplicação

## 📂 Estrutura do Projeto
### Frontend

lib/core/ — temas, validações, utilitários e serviços

lib/view_models/ — MobX stores

lib/views/ — telas do app

lib/widgets/ — componentes reutilizáveis

assets/ — imagens e ícones

### Backend

app/routers/ — rotas da API

app/services/ — regras de negócio e integrações

app/core/ — arquivos centrais

.env — variáveis sensíveis

📦 Arquivos Confidenciais para enviar por e-mail

| Arquivo                               | Pasta                | Descrição                             |
| ------------------------------------- | -------------------- | ------------------------------------- |
| `google-services.json`                | `android/app/`       | Configuração Firebase Android         |
| Arquivo de configuração da URL da API | `lib/core/services/` | Ajuste da URL local/produção          |
| `.env`                                | raiz do backend      | Variáveis de ambiente (banco, tokens) |
| `firebase_service_account.json`       | `app/core/`          | Credenciais de serviço Firebase       |
| Imagens e recursos visuais            | `assets/`            | Recursos usados no app                |
