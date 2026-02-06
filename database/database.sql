/* PROJETO: RH Solution
   CONVENÇÃO: snake_case
   STACK: PostgreSQL + Node.js (TS) + Vue.js
   
   - CRIAR O ESQUEMA
   - PRIMEIRO RODAR AS TABELAS INDEPENDENTES
*/

create schema rh_solution;

--TABELAS INDEPENDENTES
CREATE TABLE departments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    acronym VARCHAR(20) NOT NULL UNIQUE,
    description VARCHAR(512),
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now(),
    inactive_date DATE NULL
);

CREATE TABLE positions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    acronym VARCHAR(20) NOT NULL UNIQUE,
    level INTEGER NOT NULL,
    description VARCHAR(512),
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now(),
    inactive_date DATE NULL
);

CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    acronym VARCHAR(20) NOT NULL UNIQUE,
    description VARCHAR(255),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now()
);


-- TABELA PRINCIPAL
CREATE TABLE employees (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    cpf CHAR(11) UNIQUE NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    birth_date DATE NOT NULL,
    hire_date DATE NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    inactive_date DATE NULL,
    
    -- Chaves Estrangeiras (UUID)
    department_id UUID NOT NULL,
    position_id UUID NOT NULL,
    project_id UUID NOT NULL,

    CONSTRAINT fk_department FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE RESTRICT,
    CONSTRAINT fk_position FOREIGN KEY (position_id) REFERENCES positions(id) ON DELETE RESTRICT,
    CONSTRAINT fk_project FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE RESTRICT
);

-- TABELA DE ACESSOS
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'NONE',
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now(),
    inactive_date DATE NULL,
    employee_id UUID NOT NULL UNIQUE,
    
    CONSTRAINT fk_employee_user FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE RESTRICT
);

-- TABELA DE AUDITORIA
CREATE TABLE user_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    action_description VARCHAR(500) NOT NULL,
    action_snapshot JSONB NULL, 
    action_date TIMESTAMPTZ NOT NULL DEFAULT now(),
    action_type VARCHAR(50) NOT NULL,
    
    CONSTRAINT fk_user_log FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT
);

--- TABELA ASSOCIATIVAS---
CREATE TABLE project_departments (
    project_id UUID NOT NULL,
    department_id UUID NOT NULL,
    start_date DATE NOT NULL,
    finish_date DATE NULL,
    
    PRIMARY KEY (project_id, department_id),
    
    CONSTRAINT fk_proj_dept_project 
        FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
        
    CONSTRAINT fk_proj_dept_department 
        FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE RESTRICT
); 
--Tabela 
CREATE TABLE rh_solution.position_departments (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    position_id uuid REFERENCES rh_solution.positions(id),
    department_id uuid REFERENCES rh_solution.departments(id),
    created_at timestamptz DEFAULT now()
);