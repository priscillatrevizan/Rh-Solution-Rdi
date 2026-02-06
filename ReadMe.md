# ANÁLISE DE REQUISITOS - SISTEMA DE RH - RDI

## REQUISITOS FUNCIONAIS: (mínimo 8 máximo 16 - devendo obrigatoriamente ter no mínimo 4 funcionalidades para cada integrante da dupla)

### Funcionalidades mínimas:

- **RF01.** O sistema deve permitir cadastrar, editar, listar e inativar funcionários, mantendo histórico das alterações de status.
- **RF02.** O sistema deve permitir cadastrar, editar, listar e inativar (ou impedir a exclusão de) departamentos quando houver funcionários vinculados.
- **RF03.** O sistema deve permitir cadastrar, editar, listar e inativar (ou impedir a exclusão de) cargos quando houver funcionários vinculados.
- **RF04.** O sistema deve permitir cadastrar, editar, listar e encerrar projetos, definindo data de início e término e impedindo a exclusão quando houver histórico de alocação.
- **RF05.** O sistema deve permitir listar funcionários por projeto, departamento ou cargo.
- **RF06.** O sistema deve permitir alocar e realocar funcionários em um departamento, cargo e/ou projeto, registrando essas alterações no histórico.
- **RF07.** O sistema deve permitir o desligamento de funcionários (inativação) e a desalocação de projetos, garantindo a integridade do histórico.
- **RF08.** O sistema deve permitir o cadastro de usuários de forma vinculada a funcionários ativos.
- **RF09.** O sistema deve impedir a criação ou reativação de usuários vinculados a funcionários inativos.
- **RF10.** O sistema deve manter a vinculação entre usuário e funcionário para fins de auditoria (registrando quem realizou cada ação importante).

### Regras de negócio:

- **RF11.** O sistema deve garantir que todo funcionário tenha exatamente um cargo e pertença a um departamento.
- **RF12.** O sistema deve garantir que todo funcionário com vínculo empregatício ativo esteja alocado em um projeto.
- **RF13.** O sistema deve garantir que cada projeto possua data de início e fim.
- **RF14.** Ao encerrar um projeto, o sistema deve obrigar que todos os funcionários alocados sejam realocados para outro projeto ou tenham seu vínculo empregatício encerrado (desligamento).
- **RF15.** O sistema deve registrar no histórico todas as alterações de cargo, departamento, projeto e status (ativo/inativo) do funcionário, incluindo data, tipo de evento e usuário responsável.
- **RF16.** O sistema deve gerenciar perfis de acesso (ADMIN, RH_OPERATOR, NONE) e aplicar as permissões de acordo com o perfil:

      - ADMIN: acesso total (criar, editar, listar, inativar, encerrar projetos).
      - RH_OPERATOR: leitura/escrita, sem permissão de exclusão definitiva.
      - NONE: sem acesso ao sistema (apenas funcionário cadastrado).


# MODELO DE DOMÍNIO E DADOS

## Entidades, Atributos e Regras ligadas às RF

### 1. Entidades

### 1.1. Funcionário (**Employee**) — RF01, RF05, RF06, RF07, RF08, RF09, RF11, RF12, RF14, RF16
Armazena os dados pessoais e profissionais básicos do colaborador, bem como seus vínculos com departamento, cargo e projeto.

- **Id** (id)  
  Tipo: UUID, PK, Identity.  
  Regra: Identificador único do funcionário.
- **Nome** (first_name)  
  Tipo: VARCHAR(100), NOT NULL.  
  Regra: Não pode ser vazio.
- **Sobrenome** (last_name)  
  Tipo: VARCHAR(100), NOT NULL.  
  Regra: Não pode ser vazio.
- **CPF** (cpf)  
  Tipo: CHAR(11), NOT NULL, UNIQUE.  
  Regra: Deve ser único no sistema.
- **E-mail** (email)  
  Tipo: VARCHAR(150), NOT NULL, UNIQUE.  
  Regra: Formato de e-mail válido; cada e-mail só pode estar vinculado a um funcionário.
- **Data de nascimento** (birth_date)  
  Tipo: DATE, NOT NULL.  
  Regra: Não pode ser futura.
- **Data de admissão** (hire_date)  
  Tipo: DATE, NOT NULL.  
  Regra: Não pode ser futura; usada para controle de vínculo (RF07).
- **Data de inativação** (inactive_date)  
  Tipo: DATE, NULL.  
  Regra: Preenchida quando o funcionário é desligado/inativado (RF07).
- **Ativo** (is_active)  
  Tipo: BOOLEAN, NOT NULL, DEFAULT true.  
  Regra: True para funcionário com vínculo ativo; False após desligamento (RF07).
- **Id do Departamento** (department_id)  
  Tipo: UUID, NOT NULL, FK → departments(id).  
  Regra: Obrigatório para garantir vínculo organizacional (RF08, RF11).
- **Id do Cargo** (position_id)  
  Tipo: UUID, NOT NULL, FK → positions(id).  
  Regra: Obrigatório para garantir que todo funcionário tenha um cargo (RF08, RF11).
- **Id do Projeto** (project_id)  
  Tipo: UUID, NOT NULL, FK → projects(id).  
  Regra: Obrigatório enquanto o funcionário estiver ativo (RF09, RF12).

---

### 1.2. Departamento (**Department**) — RF02, RF05, RF06, RF11
Define a unidade organizacional à qual o funcionário pertence.

- **Id** (id)  
  Tipo: UUID, PK, Identity.
- **Nome** (name)  
  Tipo: VARCHAR(100), NOT NULL, UNIQUE.  
  Regra: Não pode haver duplicidade de nomes.
- **Sigla** (acronym)  
  Tipo: VARCHAR(20), NOT NULL, UNIQUE.
- **Descrição** (description)  
  Tipo: VARCHAR(512), NULL.
- **Ativo** (is_active)  
  Tipo: BOOLEAN, NOT NULL, DEFAULT true.  
  Regra: Departamentos inativos não recebem novas alocações (RF02).
- **Data de criação** (created_at)  
  Tipo: TIMESTAMPTZ, NOT NULL, DEFAULT now().
- **Data de inativação** (inactive_date)  
  Tipo: DATE, NULL.

---

### 1.3. Cargo (**Position**) — RF03, RF05, RF06, RF11
Define a função e o nível hierárquico do funcionário.

- **Id** (id)  
  Tipo: UUID, PK, Identity.
- **Nome** (name)  
  Tipo: VARCHAR(100), NOT NULL, UNIQUE.
- **Sigla** (acronym)  
  Tipo: VARCHAR(20), NOT NULL, UNIQUE.
- **Nível** (level)  
  Tipo: INTEGER, NOT NULL.  
  Regra: Representa senioridade ou hierarquia.
- **Descrição** (description)  
  Tipo: VARCHAR(512), NULL.
- **Ativo** (is_active)  
  Tipo: BOOLEAN, NOT NULL, DEFAULT true.  
  Regra: Cargos inativos não podem ser atribuídos a funcionários (RF03).
- **Data de criação** (created_at)  
  Tipo: TIMESTAMPTZ, NOT NULL, DEFAULT now().
- **Data de inativação** (inactive_date)  
  Tipo: DATE, NULL.

---

### 1.4. Projeto (**Project**) — RF04, RF05, RF06, RF09, RF10, RF11
Iniciativas temporárias com datas de vigência.

- **Id** (id)  
  Tipo: UUID, PK, Identity.
- **Nome** (name)  
  Tipo: VARCHAR(100), NOT NULL, UNIQUE.
- **Sigla** (acronym)  
  Tipo: VARCHAR(20), NOT NULL, UNIQUE.
- **Descrição** (description)  
  Tipo: VARCHAR(255), NULL.
- **Data de início** (start_date)  
  Tipo: DATE, NOT NULL.
- **Data de fim** (end_date)  
  Tipo: DATE, NOT NULL.  
  Regra: Deve ser maior ou igual à data de início (RF10).
- **Ativo** (is_active)  
  Tipo: BOOLEAN, NOT NULL, DEFAULT true.

---

### 1.5. Usuário (**User**) — RF13, RF14, RF15, RF16
Credenciais de acesso vinculadas a um funcionário.

- **Id** (id)  
  Tipo: UUID, PK, Identity.
- **Email** (email)  
  Tipo: VARCHAR(150), NOT NULL, UNIQUE.
- **Senha hash** (password_hash)  
  Tipo: VARCHAR(255), NOT NULL.
- **Role** (role)  
  Tipo: VARCHAR(20), NOT NULL.  
  Regra: ADMIN, RH_OPERATOR ou NONE (RF15).
- **Id do Funcionário** (employee_id)  
  Tipo: UUID, NOT NULL, UNIQUE, FK → employees(id).  
  Regra: Um funcionário possui no máximo um usuário (RF13).
- **Ativo** (is_active)  
  Tipo: BOOLEAN, NOT NULL, DEFAULT true.
- **Data de criação** (created_at)  
  Tipo: TIMESTAMPTZ, NOT NULL, DEFAULT now().
- **Data de inativação** (inactive_date)  
  Tipo: DATE, NULL.

---

### 1.6. Histórico de Ações do Usuário (**UserLog**) — RF12, RF16
Snapshot das ações para auditoria.

- **Id** (id)  
  Tipo: UUID, PK, Identity.
- **Id do Usuário** (user_id)  
  Tipo: UUID, NOT NULL, FK → users(id).
- **Descrição da Ação** (action_description)  
  Tipo: VARCHAR(500), NOT NULL.
- **Snapshot de Dados** (action_snapshot)  
  Tipo: JSONB, NULL.  
  Regra: Armazena o estado dos dados no momento da ação para auditoria posterior.
- **Data e Hora da Ação** (action_date)  
  Tipo: TIMESTAMPTZ, NOT NULL, DEFAULT now().
- **Tipo de Ação** (action_type)  
  Tipo: VARCHAR(50), NOT NULL.  
  Regra: CREATE, UPDATE, DELETE, LOGIN, LOGOUT.

## 2. Métodos das Entidades (conceitual / OO) com referência às RF

### 2.1. Funcionário (**Employee**) — RF01, RF06, RF07, RF08, RF09, RF11, RF12

    - **Hire()**  
      Registra admissão do funcionário, define `IsActive = true`, `HireDate` e cria registro no histórico (RF01, RF07, RF12).

    - **Terminate()**  
      Encerra o vínculo empregatício, define `IsActive = false`, `TerminationDate` e registra evento no histórico (RF07, RF12).

    - **ChangeDepartment(departmentId)**  
      Altera o departamento do funcionário, garantindo vínculo com um departamento válido (RF08, RF11) e registra histórico (RF12).

    - **ChangePosition(positionId)**  
      Altera o cargo do funcionário, mantendo exatamente um cargo (RF08, RF11) e registrando histórico (RF12).

    - **ChangeProject(projectId)**  
      Altera o projeto atual do funcionário, garantindo que ativos estejam sempre alocados (RF06, RF09, RF11) e registra histórico (RF12).

    - **Deactivate()**  
      Marca o funcionário como inativo em cenários específicos de inativação (RF07).



### 2.2.Departamento (**Department**) — RF02, RF11

    - **Activate()**  
      Ativa o departamento, permitindo novos vínculos de funcionários (RF02).

    - **Deactivate()**  
      Inativa o departamento caso não existam funcionários ativos vinculados (RF02, RF11).

    - **CanBeDeactivated()**  
      Verifica se existe algum funcionário ativo vinculado ao departamento antes da inativação (RF02, RF11).



### 2.3. Cargo (**Position**) — RF03, RF11

    - **Activate()**  
      Ativa o cargo, permitindo novos vínculos (RF03).

    - **Deactivate()**  
      Inativa o cargo caso não existam funcionários ativos vinculados (RF03, RF11).

    - **CanBeDeactivated()**  
      Verifica se existe algum funcionário ativo vinculado ao cargo (RF03, RF11).



### 2.4. Projeto (**Project**) — RF04, RF06, RF09, RF10, RF11

    - **Start()**  
      Marca o início do projeto (pode ajustar `StartDate` ou `IsActive`) (RF04, RF10).

    - **Close()**  
      Encerra o projeto, define `EndDate`/`IsActive = false` e dispara lógica de realocação/desligamento via serviço (RF04, RF11).

    - **IsActive()**  
      Indica se o projeto está ativo com base em datas e/ou flag (RF04, RF09, RF10).

    - **CanBeDeleted()**  
      Verifica se não há histórico de alocação vinculado (regra para impedir exclusão quando há histórico) (RF04, RF12).


### 2.5. Usuário (**User**) — RF13, RF14, RF15, RF16

    - **Activate()**  
      Ativa o usuário se o funcionário vinculado estiver ativo (RF13, RF14).

    - **Deactivate()**  
      Inativa o usuário, preservando vínculo para auditoria (RF14, RF16).

    - **ChangePassword(newPassword)**  
      Atualiza a senha (hash) do usuário (RF13).

    - **AssignRole(role)**  
      Define/atualiza o perfil de acesso (ADMIN, RH_OPERATOR, NONE), aplicando as regras de permissão (RF15).



### 2.6. Histórico de Ações do Usuário (**UserLog**)

    - **RegisterAction(userId, actionType, actionDescription, actionSnapshot)**  
      Cria um novo registro de histórico de ações do usuário, com data/hora, tipo de ação, descrição legível e snapshot opcional dos dados afetados (RF12, RF16).


___

## 3. Classes de Serviço (camada de aplicação) com referência às RF

### 3.1. EmployeeService — RF01, RF05, RF06, RF07, RF08, RF09, RF11, RF12, RF16
    Responsável pelas operações de alto nível relacionadas a funcionários, aplicando as regras de negócio definidas.

    - CreateEmployee(...)
      Cria um novo funcionário, vinculando a um cargo, departamento e projeto ativos (RF01, RF08, RF09, RF11).

    - TerminateEmployee(employeeId)
      Encerra o vínculo empregatício do funcionário, marcando-o como inativo e registrando o evento no histórico (RF07, RF12).

    - ChangeEmployeeDepartment(employeeId, departmentId)
      Altera o departamento do funcionário e registra a movimentação no histórico (RF06, RF08, RF11, RF12).

    - ChangeEmployeePosition(employeeId, positionId)
      Altera o cargo do funcionário e registra a movimentação no histórico (RF06, RF08, RF11, RF12).

    - ChangeEmployeeProject(employeeId, projectId)
      Realoca o funcionário para outro projeto e registra a movimentação no histórico (RF05, RF06, RF09, RF11, RF12).


### 3.2. DepartmentService — RF02, RF05, RF08, RF11
    Responsável pelas operações de alto nível relacionadas a departamentos.

    - CreateDepartment(name, acronym, description)
      Cria um novo departamento ativo (RF02).

    - DeactivateDepartment(departmentId)
      Inativa um departamento, caso não existam funcionários ativos vinculados (RF02, RF08, RF11).

    - CanDeactivateDepartment(departmentId)
      Verifica se o departamento pode ser inativado (sem funcionários ativos) (RF02, RF08, RF11).


### 3.3. PositionService — RF03, RF05, RF08, RF11
    Responsável pelas operações de alto nível relacionadas a cargos.

    - CreatePosition(name, acronym, level, description)
      Cria um novo cargo ativo (RF03).

    - DeactivatePosition(positionId)
      Inativa um cargo, caso não existam funcionários ativos vinculados (RF03, RF08, RF11).

    - CanDeactivatePosition(positionId)
      Verifica se o cargo pode ser inativado (sem funcionários ativos) (RF03, RF08, RF11).


### 3.4. ProjectService — RF04, RF05, RF06, RF09, RF10, RF11, RF14
    Responsável pelas operações de alto nível relacionadas a projetos.

    - CreateProject(name, acronym, description, startDate, endDate)
      Cria um novo projeto ativo com datas de início e fim (RF04, RF10).

    - CloseProject(projectId)
      Encerra o projeto, define a data de término e aplica a regra de realocar funcionários ou encerrar vínculo (desligamento) (RF04, RF09, RF11, RF14).

    - CanDeleteProject(projectId)
      Verifica se o projeto pode ser excluído, garantindo que não exista histórico de alocação vinculado (RF04, RF12).


### 3.5. UserService — RF13, RF14, RF15, RF16
    Responsável pelas operações de alto nível relacionadas a usuários do sistema.

    - CreateUser(email, password, employeeId, role)
      Cria um novo usuário vinculado a um funcionário ativo, armazenando a senha em formato hash (RF13, RF14, RF15).

    - DeactivateUser(userId)
      Inativa o usuário, mantendo o vínculo com o funcionário para fins de histórico e auditoria (RF14, RF16).

    - ChangeUserRole(userId, role)
      Altera o perfil de acesso (ADMIN, RH_OPERATOR, NONE) de acordo com as regras de permissão (RF15).

    - ChangeUserPassword(userId, newPassword)
      Atualiza a senha do usuário (hash), preservando a segurança das credenciais (RF15, RF16).

___

## 4. Interfaces de Repositório (camada de acesso a dados) e RFs relacionadas

### 4.1. IEmployeeRepository
    Responsável por acessar os dados de Funcionário no banco.
    Relacionada indiretamente a RF01, RF05, RF06, RF07, RF08, RF09, RF11, RF12, RF14, RF16.

    Métodos principais (conceitual):

    - GetById(id)
    - GetAll()
    - Add(employee)
    - Update(employee)
    - Delete(id)  // ou Inactivate, se não existir exclusão física
  

### 4.2. IDepartmentRepository
    Responsável por acessar os dados de Departamento.
    Relacionada a RF02, RF05, RF08, RF11.
    
    Métodos principais (conceitual):
    
    - GetById(id)
    - GetAll()
    - Add(department)
    - Update(department)
    

### 4.3. IPositionRepository
    Responsável por acessar os dados de Cargo.
    Relacionada a RF03, RF05, RF08, RF11.
    
    Métodos principais (conceitual):
    
    - GetById(id)
    - GetAll()
    - Add(position)
    - Update(position)
    

### 4.4. IProjectRepository
    Responsável por acessar os dados de Projeto.
    Relacionada a RF04, RF05, RF06, RF09, RF10, RF11, RF14.

    Métodos principais (conceitual):
    
    - GetById(id)
    - GetAll()
    - Add(project)
    - Update(project)
    

### 4.5. IUserLogRepository
    Responsável por acessar os dados de histórico de ações de usuário (UserLog).
    Relacionada a RF12, RF16.

    Métodos principais (conceitual):
    - GetById(id)
    - GetAllByUser(userId)
    - Add(UserLog)

