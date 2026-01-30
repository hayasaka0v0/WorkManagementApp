AGENT.md
Trang
/1

# Agent Context & Instructions

This file provides the context and rules for the AI agent working on this project.

## Project Scope
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

