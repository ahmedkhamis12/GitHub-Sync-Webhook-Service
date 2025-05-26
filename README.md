
# GitHub Sync Webhook

This project is a lightweight Python-based webhook server using Flask that listens for GitHub push events and automatically pulls the latest code and restarts Docker containers based on labels. It supports multiple repositories with individual configuration.

## Features

- Supports multiple private/public GitHub repositories
- Auto clone/pull repositories to local directories
- Restarts Docker containers based on custom labels
- Configurable via `.env` file
- Uses Docker and Docker Compose for easy deployment

---

## Getting Started

### 1. Clone This Repository

```bash
git clone https://github.com/your-username/github-sync.git
cd github-sync
```

### 2. Set Up Your `.env` File

Create a `.env` file in the root directory and define your repositories and configurations:

```env
REPOS=odoo-project,another-repo

REPO_URL_odoo-project=git@github.com:youruser/odoo-project.git
CONTAINER_LABEL_odoo-project=restart_group=odoo_group

REPO_URL_another-repo=git@github.com:youruser/another-repo.git
CONTAINER_LABEL_another-repo=restart_group=another_group

REPOS_BASE_DIR=/repos
```

> ℹ️ Make sure your SSH key has access to the private repositories and `~/.ssh` is mounted.

---

## 3. Build and Run the Project

Using Docker Compose:

```bash
docker-compose up --build -d
```

---

## 4. GitHub Webhook Setup

Go to your repository settings on GitHub:

- Navigate to **Settings > Webhooks > Add webhook**
- **Payload URL**: `http://<YOUR_SERVER_IP>:8000/webhook`
- **Content Type**: `application/json`
- Select **Just the push event**
- Click **Add Webhook**

---

## Folder Structure

```
.
├── Dockerfile
├── docker-compose.yml
├── sync.py
├── .env
├── repos/              # Contains pulled repositories
└── requirements.txt
```

---

## Dockerfile Overview

- Based on `python:3.11-slim`
- Installs `git`, `curl`, and sets up SSH
- Installs Python dependencies
- Runs `sync.py` with Flask

---

## Environment Variables

| Variable                 | Description                             |
|--------------------------|-----------------------------------------|
| `REPOS`                  | Comma-separated list of repo keys       |
| `REPO_URL_<key>`         | Git URL for each repo                   |
| `CONTAINER_LABEL_<key>`  | Label to identify containers to restart |
| `REPOS_BASE_DIR`         | Base directory to clone repos into      |

---

## Example Webhook Payload

The server expects the standard GitHub push event. The repository name is extracted from:

```json
{
  "repository": {
    "name": "odoo-project"
  }
}
```

---

## Logging & Debugging

Logs are printed directly in the container logs. You can view them using:

```bash
docker logs github-sync
```

---

## License

This project is licensed under the MIT License.

