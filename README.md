# Infraestrutura Kubernetes da Oficina FIAP

Este repositorio provisiona, com Terraform, uma instancia EC2 que executa um
cluster Kubernetes leve com k3s. Ele corresponde ao repositorio de
**Infraestrutura Kubernetes (Terraform)** exigido na atividade.

## Pipeline CI/CD

O workflow `.github/workflows/terraform.yml` executa:

- em Pull Requests para `main`: formatacao, inicializacao, validacao e plano;
- depois do merge na `main`: as mesmas validacoes e o `terraform apply`.

O estado do Terraform e armazenado em S3. Nenhuma credencial ou arquivo de
estado deve ser versionado.

## Configuracao do GitHub Actions

Crie as seguintes **Variables** em `Settings > Secrets and variables > Actions`:

| Nome | Exemplo |
| --- | --- |
| `AWS_REGION` | `us-east-1` |
| `TF_STATE_BUCKET` | `oficina-fiap-tfstate-<id-da-conta>` |

Crie os seguintes **Secrets**:

| Nome | Conteudo |
| --- | --- |
| `AWS_ACCESS_KEY_ID` | Access key temporaria do AWS Academy |
| `AWS_SECRET_ACCESS_KEY` | Secret key temporaria do AWS Academy |
| `AWS_SESSION_TOKEN` | Session token temporario do AWS Academy |
| `SSH_ALLOWED_CIDR` | IP publico autorizado no formato `x.x.x.x/32` |
| `SSH_PUBLIC_KEY` | Conteudo completo da chave publica SSH |

As credenciais do AWS Academy expiram quando a sessao do laboratório termina e
precisam ser atualizadas antes de um novo deploy.

## Execucao local

Depois de autenticar a AWS CLI:

```powershell
terraform init `
  -backend-config="bucket=SEU_BUCKET" `
  -backend-config="key=infra-k8s/terraform.tfstate" `
  -backend-config="region=us-east-1" `
  -backend-config="encrypt=true" `
  -backend-config="use_lockfile=true"

terraform fmt -check
terraform validate
terraform plan
```

Arquivos `*.tfstate`, `*.tfvars`, planos e o diretório `.terraform` são
ignorados pelo Git e não devem ser enviados ao repositório.
