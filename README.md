# dotfiles for Claude Code (`~/.claude`)

Личная конфигурация [Claude Code](https://claude.com/claude-code): глобальные
инструкции, настройки и список плагинов. Всё остальное в `~/.claude`
(история диалогов, кэш, учётные данные, бэкапы) — локальное/приватное и
намеренно не отслеживается git'ом (см. `.gitignore`).

## Что внутри

- `CLAUDE.md` — глобальные инструкции для всех проектов (отвечать на русском).
- `settings.json` — тема, statusLine, включённые плагины и известные marketplace'ы.
- `statusline-command.sh` — скрипт статус-бара (модель | директория/ветка | токены).
- `skills/syntax-coach/` — скилл `/syntax-coach`: подсказки по синтаксису незнакомого
  языка (Kotlin и др.) через решение задачи-двойника, не раскрывая алгоритм.

## Установка на новой машине

1. Установите [Claude Code](https://claude.com/claude-code), если ещё не установлен.
2. Склонируйте репозиторий на место `~/.claude`:

   ```bash
   git clone <URL_ЭТОГО_РЕПО> ~/.claude
   ```

   Если `~/.claude` уже существует (например, после первого запуска Claude Code),
   сохраните из него `.credentials.json` (учётные данные входа) и склонируйте
   репозиторий отдельно, затем скопируйте файлы `CLAUDE.md`, `settings.json`,
   `statusline-command.sh` внутрь существующей папки, либо перенесите
   `.credentials.json` в свежесклонированный репозиторий.

3. Установите плагины, перечисленные в `settings.json` (`enabledPlugins`/
   `extraKnownMarketplaces`). Обычно Claude Code сам предложит их
   доустановить при следующем запуске, синхронизировавшись по `settings.json`.
   Если этого не произошло — сделайте вручную:

   ```
   /plugin marketplace add warpdotdev/claude-code-warp
   /plugin marketplace add anthropics/claude-plugins-official
   /plugin install warp@claude-code-warp
   /plugin install mattpocock-skills@claude-plugins-official
   ```

4. Готово — запустите `claude` и проверьте, что statusline и скиллы из
   `mattpocock-skills` (`/tdd`, `/code-review` и т.д.) доступны.
