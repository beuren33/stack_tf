# Infraestrutura AWS 3 Camadas com Terraform

Este projeto provisiona, com Terraform, uma infraestrutura completa de três camadas na AWS, o tipo de arquitetura clássica para hospedar uma aplicação web com banco de dados: uma rede isolada, um balanceador de carga público, um grupo de instâncias que escala sozinho conforme a demanda e um banco de dados que fica protegido, sem acesso direto da internet. O objetivo é ter uma base de infraestrutura reutilizável e modular, em vez de escrever um único arquivo gigante com tudo misturado.

## Como funciona

A infraestrutura é dividida em módulos independentes, cada um responsável por uma camada específica, e depois combinados dentro de um ambiente, no caso o ambiente de desenvolvimento (`dev`), que decide como esses módulos se conectam entre si.

O módulo de rede cria uma VPC própria, com sub redes públicas e duas camadas de sub redes privadas, uma para a aplicação e outra para o banco de dados, distribuídas entre diferentes zonas de disponibilidade. Essa separação é o que garante o isolamento: só a camada pública tem rota direta para a internet, o resto fica protegido atrás dela.

O módulo de segurança define os security groups que controlam o tráfego entre as camadas, liberando por exemplo a porta 80 para o balanceador de carga vindo de qualquer lugar, mas restringindo o acesso às instâncias e ao banco apenas ao que realmente precisa se comunicar com eles.

O módulo de computação cria um launch template para as instâncias EC2, já com um script de inicialização que instala e sobe o nginx automaticamente, e um Auto Scaling Group que mantém essas instâncias saudáveis e ajusta a quantidade conforme a carga. O módulo de balanceador de carga cria um Application Load Balancer que distribui as requisições entre as instâncias do Auto Scaling Group, com health check configurado para verificar se cada instância está respondendo corretamente.

Por fim, o módulo de banco de dados sobe uma instância RDS rodando Postgres, dentro da sub rede privada dedicada ao banco, sem acesso público, com o subnet group configurado para restringir onde essa instância pode viver dentro da rede.

## Estrutura do projeto

```
stack_tf/
├── bootstrap/              # infraestrutura inicial (estado remoto)
├── modules/
│   ├── networking/         # VPC e sub redes publicas e privadas
│   ├── security/           # security groups das camadas
│   ├── compute/            # launch template e auto scaling group
│   ├── loadbalancer/       # application load balancer
│   └── database/           # instancia RDS Postgres
└── environments/
    └── dev/                # composicao dos modulos para o ambiente dev
```

## Como rodar

É preciso ter o Terraform instalado e credenciais AWS configuradas. Dentro do ambiente desejado:

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

## Observações

Por enquanto só existe o ambiente `dev` montado, mas a estrutura em módulos já deixa o caminho pronto para replicar a mesma infraestrutura em outros ambientes, como staging ou produção, bastando criar uma nova pasta em `environments` que reutilize os mesmos módulos com variáveis diferentes. Um próximo passo natural é configurar o backend remoto de estado, hoje ainda vazio, para guardar o state do Terraform de forma centralizada e segura em vez de local.
