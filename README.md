# POC API - TaskMan

Uma ferramente de gerenciamento de tarefas, similar à board do MeisterTask.

# Entidades, Atributos e Regras de Negócio
## Usuário
- Quem terá acesso a plataforma e poderá usufruir de suas funcionalidades;

## Projeto
- Um projeto só pode ter um owner;
- Deve existir uma categoria padrão que não pode ser apagada, mas pode ser editada;

## Tarefa
- Status: pending, done, expired;
- Deve pertencer a uma categoria;
- Se tiver um assign, o usuário assigned não poderá estar com outra tarefa pending agendada para o mesmo período de tempo (Se tiver done, pode existir sobreposição de agendamentos. Se tiver pending, não pode existir sobreposição. Se tiver expired, o usuário não pode ter nenhum assign pro futuro até que esteja done);

## Categoria

## Usuário/Projeto
- Roles: owner, maintainer e colaborator;
- Para adicionar ou remover participante, a role do participante em questão deve ser inferior a quem está realizando a ação;

# Funcionalidades
## Usuário
- Login/Logout (todos);
- Pedir esquecimento (apagar tudo do usuário: projetos, tasks, etc.);

## Projeto
- Criar um projeto (todos);
- Listar projetos (todos - aparecem apenas os seus);
- Deletar um projeto (owners);
- Editar um projeto (owners, maintainers);
- Visualizar um projeto (usuários relacionados ao projeto);

### Usuário/Projeto
- Adicionar participantes (owners, maintainers); 
- Remover participantes (owners, maintainers);

## Tarefa
- Criar uma tarefa (owners, maintainers);
- Dar assign numa tarefa (Pode dar assign pra outro tenha role inferior naquele projeto OU para si caso esteja sem assign);
- Marcar uma tarefa como concluída (Owner, maintainar ou assigned);
- Mudar categoria da tarefa (Owner, maintainar ou assigned);
- Mudar data de início e fim de uma tarefa (Owner ou maintainar);
- Deletar (Owner ou maintainar);
- Visualizar (usuários relacionados ao projeto);
- Usuário consegue buscar tarefas, através de um termo, pelo nome;

## Categoria
- Criar e editar categorias (owners, maintainers);
- Apagar categorias. Ao apagar, mover tarefas para a categoria padrão. (owners, maintainers);

# Especificações técnicas
## Gems
1. Devise (Autenticação e fluxo de cadastro);
2. Devise Token Auth (Autenticação via tokens);
3. Pundit (Políticas de acesso);
4. JSON:API Serialization Library (views/jsons);

## Atributos e Regras de negócio
### Usuário
- Name (Nome do usuário, string);
- Password (Senha do usuário, string);
- Email (Email do usuário, string, será uma chave única de identificação de usuário);

### Projeto (Pode possuir N usuários associados, tendo obrigatoriamente um usuário Owner)
- Name (Nome do projeto, string);
- Tem exatamente 1 owner;

### Categoria (Deve pertencer a um projeto)
- Name (Nome da categoria, string);
- Slug (Nome da categoria parametrizado, string, única por projeto);
- ProjectID (ID do projeto a qual a categoria deve pertencer, integer);

### Tarefa (Deve pertencer a uma categoria e pode ser designada a um usuário)
- Name (Nome da tarefa, string);
- Description (Descrição da tarefa, text);
- StartDate (Data em que a tarefa deve ser iniciada, Datetime);
- DueDate (Data em que a tarefa deve ser finalizada, Datetime);
- Status (Status atual da realização da tarefa, enum: pending, done, expired);
- CategoryID (ID da categoria a qual a tarefa deve pertencer, integer);

### Tabela ponte Project x User
- ProjectID (ID do projeto que será associado ao usuário, integer);
- UserID (ID do usuário que será associado ao projeto, integer);
- Role (Função de um usuário dentro do projeto, enum: owner, maintainer, developer)
