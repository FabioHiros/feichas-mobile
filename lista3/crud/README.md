# Lista de Compras — CRUD

Aplicativo Flutter de lista de compras com backend Python (FastAPI) e banco de dados SQLite.

## Pré-requisitos

- Python 3.8+
- Flutter SDK
- Linux, macOS ou Windows

## Como executar

### 1. Backend (API Python)

Abra um terminal e execute:

```bash
cd backend
python3 -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate
pip install -r requirements.txt
uvicorn main:app --reload --port 8000
```

A API estará disponível em `http://localhost:8000`.
Acesse `http://localhost:8000/docs` para ver a documentação interativa.

### 2. Aplicativo Flutter

Abra outro terminal e execute:

```bash
flutter run         # ou -d chrome, -d android, etc.
```

> O backend precisa estar rodando antes de iniciar o aplicativo.

## Funcionalidades

- Listar itens da lista de compras
- Adicionar novo item (nome, quantidade, unidade, categoria)
- Editar item existente (toque no item)
- Marcar item como comprado (checkbox)
- Remover item (ícone de lixeira)

## Estrutura do projeto

```
crud/
├── lib/
│   ├── main.dart
│   ├── models/grocery_item.dart
│   ├── services/api_service.dart
│   └── screens/
│       ├── item_list_screen.dart
│       └── item_form_screen.dart
└── backend/
    ├── main.py
    ├── database.py
    └── requirements.txt
```
