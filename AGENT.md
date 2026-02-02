AGENT.md
Trang
/1

# Agent Context & Instructions

This file provides the context and rules for the AI agent working on this project.

## Project Scope
**IMPORTANT**: This project is a Flutter application that uses Supabase for the backend. The application is built using Clean Architecture with Feature-based separation bloc pattern.
- **Focus Directories**: `lib/`
- **Allowed Config Files**: `.env`, `pubspec.yaml`
- **Ignored Directories**: Do NOT read, explore, or modify `android/`, `ios/`, `build/`, `linux/`, `macos/`, `web/`, `windows/` or any other directory not explicitly listed.

## Interaction Rules (Strict Adherence Required)
1.  **Autonomy & Efficiency**:
    - **No Confirmation**: Do NOT ask the user for confirmation before making changes. Assume authorization for all tasks within the scope.
    - **No Redundant Questions**: Do NOT ask for more context if it can be inferred from the existing codebase (especially the file tree below and file contents).
    - **Remmember the context** : Must remmeber the context of this session.
    
2.  **Output Format**:
    - **List Changes**: You MUST list every single file you modify at the end of your response.
    - **In-depth Explanation**: For every change made, provided a detailed, educational explanation of *why* the change was made and *how* it works. The user intends to learn from these explanations.
    
3.  **File System**:
    - Strict absolute path usage for tool calls.
    - Only modify files within the allowed scope (`lib/` + config files).

## Project Structure (lib/)
The following is the current structure of the `lib/` directory. Use this to understand the project architecture (Clean Architecture with Feature-based separation).


## Supabase SQL:
-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

-- Enum cho TaskStatus
CREATE TYPE public.task_status_enum AS ENUM (
    'pending', 
    'inProgress', 
    'completed', 
    'cancelled'
);

-- Enum cho TaskPriority (nếu chưa có thì tạo mới, thay thế check constraint cũ)
CREATE TYPE public.task_priority_enum AS ENUM (
    'low', 
    'medium', 
    'high', 
    'urgent'
);

-- Enum cho TaskVisibility
CREATE TYPE public.task_visibility_enum AS ENUM (
    'public', 
    'private', 
    'teamOnly'
);

CREATE TABLE public.attachments (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  message_id uuid NOT NULL,
  file_url text NOT NULL,
  file_name character varying,
  file_type character varying,
  file_size_bytes bigint,
  CONSTRAINT attachments_pkey PRIMARY KEY (id),
  CONSTRAINT attachments_message_id_fkey FOREIGN KEY (message_id) REFERENCES public.messages(id)
);
CREATE TABLE public.chat_rooms (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL,
  room_name character varying,
  is_group boolean DEFAULT false,
  CONSTRAINT chat_rooms_pkey PRIMARY KEY (id),
  CONSTRAINT chat_rooms_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id)
);
CREATE TABLE public.companies (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  company_name character varying NOT NULL,
  invite_code character varying NOT NULL UNIQUE,
  created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT companies_pkey PRIMARY KEY (id)
);
CREATE TABLE public.events (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL,
  title character varying NOT NULL,
  description text,
  location text,
  start_time timestamp with time zone NOT NULL,
  end_time timestamp with time zone NOT NULL,
  creator_id uuid,
  created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT events_pkey PRIMARY KEY (id),
  CONSTRAINT events_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id),
  CONSTRAINT events_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.users(id)
);
CREATE TABLE public.messages (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  room_id uuid NOT NULL,
  sender_id uuid NOT NULL,
  content text,
  created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT messages_pkey PRIMARY KEY (id),
  CONSTRAINT messages_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.chat_rooms(id),
  CONSTRAINT messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(id)
);
CREATE TABLE public.tasks (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  company_id uuid NOT NULL,
  creator_id uuid NOT NULL,
  assignee_id uuid,
  title character varying NOT NULL,
  description text,
  priority USER-DEFINED DEFAULT 'medium'::task_priority_enum,
  due_date timestamp with time zone NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp with time zone NOT NULL,
  user_id uuid DEFAULT auth.uid(),
  status USER-DEFINED NOT NULL DEFAULT 'pending'::task_status_enum,
  visibility USER-DEFINED NOT NULL DEFAULT 'public'::task_visibility_enum,
  CONSTRAINT tasks_pkey PRIMARY KEY (id),
  CONSTRAINT tasks_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id),
  CONSTRAINT tasks_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id),
  CONSTRAINT tasks_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.users(id),
  CONSTRAINT tasks_assignee_id_fkey FOREIGN KEY (assignee_id) REFERENCES public.users(id)
);
CREATE TABLE public.users (
  id uuid NOT NULL,
  email character varying NOT NULL UNIQUE,
  full_name character varying,
  company_id uuid,
  role character varying CHECK (role::text = ANY (ARRAY['boss'::character varying, 'manager'::character varying, 'employee'::character varying]::text[])),
  job_title character varying,
  avatar_url text,
  created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
  phone_number character varying,
  CONSTRAINT users_pkey PRIMARY KEY (id),
  CONSTRAINT users_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id),
  CONSTRAINT users_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id)
);


CREATE TABLE public.chat_participants (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  room_id uuid NOT NULL,
  user_id uuid NOT NULL,
  joined_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT chat_participants_pkey PRIMARY KEY (id),
  CONSTRAINT chat_participants_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.chat_rooms(id) ON DELETE CASCADE,
  CONSTRAINT chat_participants_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE,
  UNIQUE(room_id, user_id)
);
```text
lib
lib/core
lib/core/di
lib/core/di/injection_container.dart
lib/core/error
lib/core/error/failures.dart
lib/core/network
lib/core/network/supabase_client.dart
lib/core/theme
lib/core/theme/app_pallete.dart
lib/core/theme/theme.dart
lib/core/usecase
lib/core/usecase/usecase.dart
lib/features
lib/features/account
lib/features/account/presentation
lib/features/account/presentation/pages
lib/features/account/presentation/pages/account_page.dart
lib/features/auth
lib/features/auth/data
lib/features/auth/data/datasources
lib/features/auth/data/datasources/auth_remote_data_source.dart
lib/features/auth/data/models
lib/features/auth/data/models/auth_user_model.dart
lib/features/auth/data/repositories
lib/features/auth/data/repositories/auth_repository_impl.dart
lib/features/auth/domain
lib/features/auth/domain/entities
lib/features/auth/domain/entities/auth_user.dart
lib/features/auth/domain/repositories
lib/features/auth/domain/repositories/auth_repository.dart
lib/features/auth/domain/repository
lib/features/auth/domain/repository/auth_repository.dart
lib/features/auth/domain/usecases
lib/features/auth/domain/usecases/get_current_user.dart
lib/features/auth/domain/usecases/login.dart
lib/features/auth/domain/usecases/logout.dart
lib/features/auth/domain/usecases/signup.dart
lib/features/auth/presentation
lib/features/auth/presentation/bloc
lib/features/auth/presentation/bloc/auth_bloc.dart
lib/features/auth/presentation/bloc/auth_event.dart
lib/features/auth/presentation/bloc/auth_state.dart
lib/features/auth/presentation/pages
lib/features/auth/presentation/pages/login_page.dart
lib/features/auth/presentation/pages/signup_page.dart
lib/features/auth/presentation/widgets
lib/features/auth/presentation/widgets/auth_button.dart
lib/features/auth/presentation/widgets/auth_field.dart
lib/features/calendar
lib/features/calendar/presentation
lib/features/calendar/presentation/pages
lib/features/calendar/presentation/pages/calendar_page.dart
lib/features/chat
lib/features/chat/presentation
lib/features/chat/presentation/pages
lib/features/chat/presentation/pages/chat_new_chat.dart
lib/features/chat/presentation/pages/chat_new_group_chat.dart
lib/features/chat/presentation/pages/chat_page.dart
lib/features/chat/presentation/widgets
lib/features/chat/presentation/widgets/chat_item_tile.dart
lib/features/chat/presentation/widgets/search_box.dart
lib/features/home
lib/features/home/presentation
lib/features/home/presentation/pages
lib/features/home/presentation/pages/home_page.dart
lib/features/task
lib/features/task/data
lib/features/task/data/datasources
lib/features/task/data/datasources/task_remote_data_source.dart
lib/features/task/data/models
lib/features/task/data/models/task_model.dart
lib/features/task/data/repositories
lib/features/task/data/repositories/task_repository_impl.dart
lib/features/task/domain
lib/features/task/domain/entities
lib/features/task/domain/entities/task.dart
lib/features/task/domain/repositories
lib/features/task/domain/repositories/task_repository.dart
lib/features/task/domain/usecases
lib/features/task/domain/usecases/create_task.dart
lib/features/task/domain/usecases/delete_task.dart
lib/features/task/domain/usecases/get_tasks.dart
lib/features/task/domain/usecases/update_task.dart
lib/features/task/presentation
lib/features/task/presentation/bloc
lib/features/task/presentation/bloc/task_bloc.dart
lib/features/task/presentation/bloc/task_event.dart
lib/features/task/presentation/bloc/task_state.dart
lib/features/task/presentation/pages
lib/features/task/presentation/pages/task_form_page.dart
lib/features/task/presentation/pages/task_list_page.dart
lib/features/task/presentation/widgets
lib/features/task/presentation/widgets/empty_tasks_widget.dart
lib/features/task/presentation/widgets/task_card.dart
lib/main.dart
```

HG6M9BWV