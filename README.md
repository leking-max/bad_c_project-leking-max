# mathlib

Небольшая библиотека математических хелперов на C и консольная утилита к ней.

- сборка — CMake
- юнит-тесты — cmocka, запуск через ctest
- форматирование — clang-format, стиль WebKit (файл `.clang-format` в корне)
- CI — GitHub Actions, конфигурация в `.github/workflows/ci.yml`

---

## С чего начать

Три команды — и вы увидите ровно те же проблемы, что и в CI:

```bash
./scripts/install-deps.sh   # поставить зависимости (нужен sudo, спросит пароль)
./scripts/build.sh          # собрать проект
./scripts/run-tests.sh      # прогнать тесты
```

После этого откройте вкладку **Actions** в репозитории на GitHub: там есть
проверки, и некоторые из них красные. Разберитесь, почему, и почините — подробнее
в разделе [Задание](#задание).

Если что-то не работает — загляните в раздел
[Частые проблемы](#частые-проблемы).

---

## Что внутри

| Путь | Что это |
|---|---|
| `src/math_utils.h`, `src/math_utils.c` | сама библиотека: `add`, `subtract`, `multiply_by_two`, `is_even` |
| `src/main.c` | консольная утилита `math_cli` |
| `tests/test_math_utils.c` | юнит-тесты на cmocka |
| `CMakeLists.txt` | описание сборки, здесь же регистрируются тесты |
| `.clang-format` | стиль форматирования, на который ориентируется проверка |
| `scripts/` | скрипты: зависимости, сборка, тесты, форматирование |
| `.github/workflows/ci.yml` | три CI-проверки: `build`, `format-check`, `test` |
| `build/` | каталог, куда собирается проект |
| `docs/ARCHITECTURE.md` | старая заметка об архитектуре, к коду отношения не имеет |

`src/Calc.c`, `src/legacy_math.c` — остатки прошлых попыток, в сборку не
подключены. Их можно не читать.

## Требования

Ubuntu 20.04 или новее (подойдёт любой Debian-подобный дистрибутив). Нужны:

| Программа | Зачем | Как проверить |
|---|---|---|
| компилятор C (gcc или clang) | сборка | `gcc --version` |
| CMake 3.16+ | сборка | `cmake --version` |
| clang-format | проверка форматирования | `clang-format --version` |
| cmocka | юнит-тесты | `ls /usr/include/cmocka.h` |

Всё это ставится одной командой на следующем шаге.

---

## Шаг 1. Зависимости

```bash
./scripts/install-deps.sh
```

Скрипт делает `apt-get update` и ставит `build-essential`, `cmake`,
`clang-format`, `libcmocka-dev`, `git`. Если предпочитаете руками — то же самое:

```bash
sudo apt-get update
sudo apt-get install -y build-essential cmake clang-format libcmocka-dev
```

## Шаг 2. Сборка

```bash
./scripts/build.sh
```

Это `cmake -S . -B build` и `cmake --build build`. В `build/` появятся
`libmath_utils.a`, `math_cli` и `test_math_utils`. Успех выглядит так:

```
[100%] Built target test_math_utils
```

Полезно знать: если в `CMakeLists.txt` менялись зависимости или список тестов,
конфигурацию нужно перегенерировать — `build.sh` это делает каждый раз.

## Шаг 3. Тесты

```bash
./scripts/run-tests.sh
```

Это `ctest --test-dir build --output-on-failure`. Каждый юнит-тест зарегистрирован
в ctest отдельно, поэтому видно имена:

```
  Test #1: test_add_of_positive_numbers .............   Passed    0.00 sec
  Test #2: test_add_of_negative_numbers .............   Passed    0.00 sec
```

Полезные варианты:

```bash
ctest --test-dir build -N                          # просто список тестов, ничего не запускать
ctest --test-dir build -R is_even                  # только тесты, в имени которых есть подстрока
ctest --test-dir build --output-on-failure         # с полным выводом упавших тестов
```

Прогоняйте тесты локально: это быстрее, чем ждать CI, и вывод подробнее.

## Шаг 4. Форматирование

Проверить, что код соответствует стилю из `.clang-format` (ничего не меняет,
просто возвращает ненулевой код возврата при нарушениях):

```bash
./scripts/check-format.sh
```

Применить стиль ко всем `.c` и `.h`:

```bash
./scripts/format.sh
```

## Шаг 5. Смотреть CI

Три независимые проверки, каждая своей job — по красному крестику сразу видно,
что именно сломалось:

| Проверка | Что делает |
|---|---|
| `build` | конфигурирует и собирает проект |
| `format-check` | запускает `scripts/check-format.sh` |
| `test` | собирает и запускает `ctest` |

Проверки запускаются на каждом пуше и на каждом pull request. Логи: вкладка
**Actions** → нужный workflow → клик по красной job → раздел `Check formatting`
или `Run tests`.

---

## Задание

В репозитории красные CI-проверки. Ваша задача — разобраться, **почему** они
красные, и починить так, чтобы все три позеленели.

Подсказки, которые помогут начать:

1. Посмотрите, какие именно проверки красные, и откройте их логи.
2. Воспроизведите это локально: те же команды, что и в CI, ничего лишнего не
   придумывая.
3. Сравните вывод локального прогона с логом CI — они должны совпадать.
4. Почините и запушьте: убедитесь, что все три проверки зелёные.

Формат кода задаётся файлом `.clang-format` в корне — тот же файл использует и
локальный `check-format.sh`, и CI.

## Частые проблемы

**`cmocka not found. Install it: sudo apt-get install libcmocka-dev`**
Не установлена библиотека для тестов. Выполните шаг 1.

**`Permission denied` при запуске `./scripts/...`**
Потерялся исполняемый бит (например, после копирования через архив):

```bash
chmod +x scripts/*.sh
```

**`build/` не создаётся, а `cmake` ругается на старый кэш**
Удалите каталог сборки и соберите заново:

```bash
rm -rf build && ./scripts/build.sh
```

**Тесты собираются, но `ctest` не находит ни одного**
Конфигурация устарела — перезапустите `build.sh`, чтобы CMake перерегистрировал
тесты из `CMakeLists.txt`.

**`No tests were found!!!` после правки `CMakeLists.txt`**
Та же причина: нужен `cmake -S . -B build`, а не только `cmake --build build`.

**Правку внёс, а поведение не изменилось**
`test_math_utils` не пересобрался. Запустите `build.sh` заново — и потом
`run-tests.sh`.

## Шпаргалка

```bash
./scripts/setup.sh         # зависимости + сборка + форматирование + тесты

make build                 # то же, что build.sh
make test                  # то же, что run-tests.sh
make check-format          # то же, что check-format.sh
make format                # то же, что format.sh
make clean                 # удалить build/
```

## Если хочется контекста

`docs/ARCHITECTURE.md` и `CHANGELOG.md` — исторические заметки, они не описывают
текущее состояние проекта. `TODO.md` — черновой список автора.
